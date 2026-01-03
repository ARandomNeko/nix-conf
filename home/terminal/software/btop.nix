{pkgs, ...}: {
  users.users.ritu.packages = [pkgs.btop];

  # Btop config via xdg.configFile
  xdg.configFile."btop/btop.conf" = {
    force = true;
    text = ''
      vim_keys = True
      theme_background = False
      truecolor = True
      show_gpu_info = True
      presets = "cpu:1:default,proc:0:default gpu0:0:default"
      graph_symbol = "braille"
      gpu_mirror_graph = True
      check_temp = True
      show_coretemp = True
      cpu_sensor = "Auto"
      temp_scale = "celsius"
      update_ms = 2000
      proc_update_mult = 2
      show_battery = True
      selected_battery = "Auto"
      show_uptime = True
      show_cpu_freq = True
      mem_graphs = True
      show_disks = True
      show_io_stat = True
      proc_sorting = "cpu lazy"
      proc_colors = True
      proc_gradient = True
      proc_mem_bytes = True
      proc_cpu_graphs = True
      net_download = " ↓"
      net_upload = " ↑"
      net_auto = True
      log_level = "WARNING"
    '';
  };
}
