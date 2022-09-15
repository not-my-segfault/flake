local wezterm = require 'wezterm'
return {
--Font
  font = wezterm.font_with_fallback {
    {
      family = 'Hasklug Nerd Font Mono',
      weight = 'Medium',
    },
    'Monospace'
  },
  font_size = 10,
  
--Appearance
  color_scheme = "Circus (base16)",
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  enable_scroll_bar = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  colors = {
    selection_fg = 'black',
    scrollbar_thumb = '#262626',
  },
  
--Shell
  default_prog = { '/home/michal/.nix-profile/bin/nu', '-l' },
  
--Misc
  scrollback_lines = 9999,
}
