"""Unlock KeePassXC from an already unlocked, encrypted GNOME login keyring."""

import getpass
import os
from pathlib import Path
import resource
import stat
import subprocess
import sys
import time

HOME = Path.home()
DATABASE = HOME / "Passwords.kdbx"
KEYRING = HOME / ".local/share/keyrings/login.keyring"
ATTRIBUTES = ["application", "keepassxc-login-unlock", "database", str(DATABASE)]


def command(name, *args, **kwargs):
    return subprocess.run(
        [name, *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        timeout=15,
        **kwargs,
    )


def active_unlocked_session():
    display = command("loginctl", "show-user", str(os.getuid()), "-p", "Display", "--value")
    session = display.stdout.decode().strip()
    if display.returncode or not session:
        return False
    result = command("loginctl", "show-session", session, "-p", "Active", "-p", "LockedHint")
    properties = dict(line.split("=", 1) for line in result.stdout.decode().splitlines() if "=" in line)
    return result.returncode == 0 and properties.get("Active") == "yes" and properties.get("LockedHint") == "no"


def encrypted_login_keyring():
    if KEYRING.is_symlink():
        return False
    info = KEYRING.stat()
    if info.st_uid != os.getuid() or stat.S_IMODE(info.st_mode) & 0o077:
        return False
    with KEYRING.open("rb") as keyring:
        return keyring.read(16).startswith(b"GnomeKeyring\n\r\0\n")


def keyring_unlocked():
    result = command(
        "busctl", "--user", "get-property", "org.freedesktop.secrets",
        "/org/freedesktop/secrets/collection/login",
        "org.freedesktop.Secret.Collection", "Locked",
    )
    return result.returncode == 0 and result.stdout.strip() == b"b false"


def check_database():
    if DATABASE.is_symlink() or not DATABASE.is_file():
        raise RuntimeError("The enrolled database path must be a regular file, not a symlink.")
    info = DATABASE.stat()
    if info.st_uid != os.getuid():
        raise RuntimeError("The database must belong to your user.")


def enroll():
    if not sys.stdin.isatty():
        raise RuntimeError("Run setup in your own terminal; the password must be entered locally without echo.")
    check_database()
    if not encrypted_login_keyring() or not active_unlocked_session() or not keyring_unlocked():
        raise RuntimeError("Log in normally and unlock your encrypted GNOME login keyring before enrolling.")
    print("Enroll automatic unlock for ~/Passwords.kdbx.")
    print("Your password is entered only in this terminal and stored in the encrypted login keyring.")
    password = getpass.getpass("KeePassXC database master password: ")
    secret = password.encode("utf-8")
    del password
    if not secret or b"\n" in secret or b"\r" in secret or b"\0" in secret:
        raise RuntimeError("A nonempty, single-line database password is required.")
    validation = command("keepassxc-cli", "db-info", str(DATABASE), input=secret + b"\n")
    if validation.returncode:
        raise RuntimeError("The database did not unlock with that password. Nothing was enrolled.")
    if not active_unlocked_session() or not keyring_unlocked():
        raise RuntimeError("The desktop or keyring locked during enrollment. Nothing was enrolled.")
    stored = command("secret-tool", "store", "--collection=/org/freedesktop/secrets/collection/login", "--label=KeePassXC login unlock (Passwords.kdbx)", *ATTRIBUTES, input=secret)
    del secret
    if stored.returncode:
        raise RuntimeError("The password could not be stored in the GNOME login keyring.")
    unlock()
    print("Enrolled ~/Passwords.kdbx for login and screen unlock.")


def enrolled_password():
    check_database()
    if not encrypted_login_keyring():
        raise RuntimeError("Automatic unlock requires an encrypted, private GNOME login keyring.")
    for attempt in range(20):
        if active_unlocked_session() and keyring_unlocked():
            break
        if attempt == 19:
            raise RuntimeError("Desktop or login keyring is locked; leaving KeePassXC locked.")
        time.sleep(0.5)
    result = command("secret-tool", "lookup", *ATTRIBUTES)
    if result.returncode or not result.stdout:
        raise RuntimeError("No enrolled password was found; run keepassxc-keyring-setup locally.")
    secret = result.stdout
    del result
    if any(character in secret for character in (b"\n", b"\r", b"\0")):
        raise RuntimeError("The saved keyring entry is invalid; run setup again.")
    # Check again after retrieval; screen/keyring locking must never trigger an unlock.
    if not active_unlocked_session() or not keyring_unlocked():
        raise RuntimeError("Desktop or login keyring locked; leaving KeePassXC locked.")
    return secret


def launch():
    secret = enrolled_password()
    child = subprocess.Popen(["keepassxc", "--minimized", "--pw-stdin", str(DATABASE)], stdin=subprocess.PIPE)
    try:
        child.stdin.write(secret + b"\n")
        child.stdin.close()
    except BrokenPipeError:
        pass
    finally:
        del secret
    return child.wait()


def unlock():
    import dbus

    name = "org.keepassxc.KeePassXC.MainWindow"
    bus = dbus.SessionBus()
    if not bus.name_has_owner(name):
        # Let the login unit own the GUI process, including its session lifetime.
        result = command("systemctl", "--user", "start", "keepassxc-login.service")
        if result.returncode:
            raise RuntimeError("Could not start the KeePassXC login service.")
        return 0

    # Address this specific connection even if KeePassXC exits during keyring lookup.
    owner = bus.get_name_owner(name)
    window = bus.get_object(owner, "/keepassxc", introspect=False)
    secret = enrolled_password()
    try:
        window.openDatabase(str(DATABASE), secret.decode("utf-8"), dbus_interface=name,
                            signature="ss", timeout=30)
    except dbus.DBusException:
        raise RuntimeError("KeePassXC did not accept the unlock request.") from None
    finally:
        del secret
    # A relock can arrive while KeePassXC is deriving the database key.
    if not active_unlocked_session():
        window.lockAllDatabases(dbus_interface=name)
    return 0


def main():
    os.umask(0o077)
    resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
    if sys.argv[1:] == ["setup"]:
        enroll()
        return 0
    if sys.argv[1:] == ["launch"]:
        return launch()
    if sys.argv[1:] == ["unlock"]:
        return unlock()
    raise RuntimeError("Use setup, launch, or unlock.")


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (RuntimeError, OSError, subprocess.TimeoutExpired) as error:
        # Never include subprocess output or password-bearing input in errors.
        message = str(error) if isinstance(error, RuntimeError) else "Required desktop service or file is unavailable."
        print("KeePassXC login unlock: " + message, file=sys.stderr)
        sys.exit(1)
