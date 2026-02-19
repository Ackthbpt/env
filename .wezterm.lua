local wezterm = require "wezterm"
local config = wezterm.config_builder()
local action = wezterm.action

-- Font
config.font = wezterm.font('MesloLGL Nerd Font Mono')
config.font_size = 12.0
--config.freetype_load_target = "Normal"
--config.font = wezterm.font {
  --family = 'JetBrains Mono',
  --weight = 'Medium',
  --harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },  disable ligatures
--}
--config.line_height = 1.0

-- Window appearance
--config.window_padding = { left = '0.5cell', right = '0.5cell', top = '0.5cell', bottom = '0.5cell' }
config.default_cursor_style = 'SteadyBlock'
--config.default_cursor_style = 'BlinkingBlock'
config.window_background_opacity = 0.9
config.macos_window_background_blur = 5
--config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'NeverPrompt'
config.scrollback_lines = 350000

-- Colors
config.colors = {
  background = 'rgb(20,25,30)',
  foreground = 'rgb(219,219,219)'
}
--config.color_scheme = '3024 (dark) (terminal.sexy)'
--config.color_scheme = '3024 Night'
--config.color_scheme = 'iTerm2 Default'
--config.color_scheme = 'Tokyo Night'

-- Terminal
config.term = "xterm-256color"
--config.enable_kitty_keyboard = false
--config.enable_csi_u_key_encoding = false

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_max_width = 100
--config.window_frame = {
  --font_size = 12,
--}
---- Sets the font for the window frame (tab bar)
config.window_frame = {
  -- Berkeley Mono for me again, though an idea could be to try a
  -- serif font here instead of monospace for a nicer look?
  font = wezterm.font({ family = 'Berkeley Mono', weight = 'Bold' }),
  font_size = 14,
}

-- Tab title arrows
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- Returns the title to display for a tab.
-- For SSH sessions: uses the pane title set by the remote shell (includes hostname)
-- For vim/vi: uses the pane title (includes filename)
-- For everything else: shows the current working directory
function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  local pane = tab_info.active_pane
  local process = pane.foreground_process_name or ""
  process = process:match("([^/]+)$") or process

  if process == "ssh" then
    return tostring(pane.title)
  elseif process == "vim" or process == "vi" then
    return pane.title or "vim"
  else
    local uri = pane.current_working_dir
    if uri then
      local cwd = uri.file_path or tostring(uri)
      local home = os.getenv("HOME") or ""
      cwd = cwd:gsub("^" .. home, "~")
      return cwd
    end
  end
  return process ~= "" and process or "zsh"
end

-- Tab styling with color coding:
--   Default (local):  purple
--   SSH:              dark blue
--   Root:             dark red
wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local background = '#1b1032'
    local foreground = '#808080'

    -- Detect SSH and root sessions
    local pane = tab.active_pane
    local process = (pane.foreground_process_name or ""):match("([^/]+)$") or ""
    local title_text = pane.title or ""
    local is_ssh = process == "ssh"
    local is_root = title_text:match("root@") ~= nil

    if tab.is_active then
      if is_root then
        background = '#4a1a1a'   -- dark red for root
        foreground = '#ff9090'
      elseif is_ssh then
        background = '#1a3a4a'   -- dark blue for SSH
        foreground = '#90c0ff'
      else
        background = '#2b2042'
        foreground = '#c0c0c0'
      end
    elseif hover then
      if is_root then
        background = '#5a2a2a'
        foreground = '#ff9090'
      elseif is_ssh then
        background = '#2a4a5a'
        foreground = '#90c0ff'
      else
        background = '#3b3052'
        foreground = '#909090'
      end
    else
      if is_root then
        background = '#3a0a0a'
        foreground = '#cc7070'
      elseif is_ssh then
        background = '#0a2a3a'
        foreground = '#7090aa'
      end
    end

    local edge_foreground = background
    local title = tab_title(tab)
    --title = "SSH:" .. tostring(is_ssh) .. " ROOT:" .. tostring(is_root) .. " " .. title
    --title = "SSH:" .. tostring(is_ssh) .. " ROOT:" .. tostring(is_root) .. " " .. title
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

---- Alternative tab styling (color-coded active/last-active)
--wezterm.on(
  --'format-tab-title',
  --function(tab, tabs, panes, config, hover, max_width)
    --local title = tab_title(tab)
    --if tab.is_active then
      --return {
        --{ Background = { Color = 'blue' } },
        --{ Text = ' ' .. title .. ' ' },
      --}
    --end
    --if tab.is_last_active then
      --return {
        --{ Background = { Color = 'green' } },
        --{ Text = ' ' .. title .. '*' },
      --}
    --end
    --return title
  --end
--)

return config
