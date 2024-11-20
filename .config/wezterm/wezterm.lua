local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.colors = {

   -- Custom colors, taken from ~/.Xdefaults
   ansi = {
      '#252525', -- Black
      '#cc4949', -- Red
      '#49cc49', -- Green
      '#cccc49', -- Yellow
      '#5c5cff', -- Blue
      '#cc49cc', -- Magenta
      '#49cccc', -- Cyan
      '#e5e5e5', -- Light gray
   },
   brights = {
      '#7f7f7f', -- Dark gray
      '#ff5c5c', -- Light red
      '#5cff5c', -- Light green
      '#ffff5c', -- Light yellow
      '#7d7dff', -- Light blue
      '#ff5cff', -- Light magenta
      '#5cffff', -- Light cyan
      'white',   -- White? Doesn't seem to change anything.
   },
}

return config
