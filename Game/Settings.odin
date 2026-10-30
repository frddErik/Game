package Game

import rl "vendor:raylib"

SKY_COLOR_B := [4]f32{142.0/255, 142.0/255, 1, 1}
SKY_COLOR := [4]f32{255.0/255, 166.0/255, 88.0/255, 1}

// IMGUI
imguiScale: f32 = 2
imguiFontPath :: "Assets/Fonts/NotoSans-Light.ttf"

// Colors
SILVER :: rl.Color{192, 192, 192, 255}
ALARMING_RED :: rl.Color{255, 15, 15, 255}
AQUA_BLUE :: rl.Color{15, 212, 203, 255}
