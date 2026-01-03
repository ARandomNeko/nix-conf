{pkgs, ...}: {
  # PipeWire audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Audio tools
  environment.systemPackages = with pkgs; [
    pavucontrol
    pwvucontrol
    pamixer
    cava
  ];
}


