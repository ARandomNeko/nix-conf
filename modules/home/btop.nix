{ ... }:

{
  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
      theme_background = false;
      truecolor = true;
      
      # Enable GPU monitoring
      show_gpu_info = true;
      presets = "cpu:1:default,proc:0:default gpu0:0:default";
      
      # Graph settings
      graph_symbol = "braille";
      gpu_mirror_graph = true;
      
      # Temperature monitoring
      check_temp = true;
      show_coretemp = true;
      cpu_sensor = "Auto";
      temp_scale = "celsius";
      
      # Update intervals
      update_ms = 2000;
      proc_update_mult = 2;
      
      # Display settings
      show_battery = true;
      selected_battery = "Auto";
      show_uptime = true;
      show_cpu_freq = true;
      mem_graphs = true;
      show_disks = true;
      show_io_stat = true;
      
      # Process settings
      proc_sorting = "cpu lazy";
      proc_colors = true;
      proc_gradient = true;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      
      # Network settings
      net_download = " ↓";
      net_upload = " ↑";
      net_auto = true;
      
      log_level = "WARNING";
    };
  };
}
