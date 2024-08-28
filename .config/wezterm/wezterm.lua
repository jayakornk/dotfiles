local wezterm = require("wezterm")

return {
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 16.0,
	font = wezterm.font("GeistMono Nerd Font"),
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	macos_window_background_blur = 5,
	window_background_opacity = 0.90,
	window_decorations = "RESIZE",
}
