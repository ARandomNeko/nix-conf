{
  codexbar,
  fetchurl,
  makeWrapper,
}:

# nixpkgs currently packages only the macOS app. Upstream also ships an
# official, static Linux CLI with the same `codexbar` command.
codexbar.overrideAttrs (
  finalAttrs: previousAttrs: {
    version = "0.56.3";

    src = fetchurl {
      url = "https://github.com/steipete/CodexBar/releases/download/v${finalAttrs.version}/CodexBarCLI-v${finalAttrs.version}-linux-musl-x86_64.tar.gz";
      hash = "sha256-YTYjbw8f8HJYuNTIyWTwr4uFSv+W1nCtCT6eL8c6q6M=";
    };

    sourceRoot = ".";
    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/libexec/codexbar
      install -Dm755 CodexBarCLI $out/libexec/codexbar/CodexBarCLI
      install -Dm644 VERSION $out/libexec/codexbar/VERSION
      cp -r CodexBar_CodexBarCore.bundle $out/libexec/codexbar/

      makeWrapper $out/libexec/codexbar/CodexBarCLI $out/bin/CodexBarCLI
      ln -s CodexBarCLI $out/bin/codexbar

      runHook postInstall
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      test "$($out/bin/codexbar --version)" = "CodexBar ${finalAttrs.version}"
    '';

    meta = previousAttrs.meta // {
      platforms = [ "x86_64-linux" ];
    };
  }
)
