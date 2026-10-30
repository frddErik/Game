package Game

import "core:os"
import "core:fmt"

import rl "vendor:raylib"

import rlimgui "../libs/imgui_impl_raylib"
import imgui "../libs/odin-imgui"

colorToImVec4 :: proc(color: rl.Color) -> imgui.Vec4
{
	return imgui.Vec4{f32(color.r) / 255, f32(color.g) / 255, f32(color.b) / 255, f32(color.a) / 255}
}

styleImgui :: proc(scale: f32)
{
	imgui.StyleColorsDark(nil)

	io := imgui.GetIO()

	if os.exists(imguiFontPath)
	{
		imgui.FontAtlas_Clear(io.Fonts)
		imgui.FontAtlas_AddFontFromFileTTF(io.Fonts, imguiFontPath, 16 * scale, nil, nil)
	}
	else
	{
		// LOG WARNING: unable to load font.
		io.FontGlobalScale = scale
	}
	imgui.Style_ScaleAllSizes(imgui.GetStyle(), scale)

	rlimgui.build_font_atlas()
}

drawDebugMenuBar :: proc()
{
	if !imgui.BeginMainMenuBar()
    {
        return
    }

    if imgui.BeginMenu("Game")
    {
    	if imgui.MenuItem("About")
	    {
			debugState.showAbout = !debugState.showAbout
	    }

		imgui.PushStyleColorImVec4(imgui.Col.Text, colorToImVec4(ALARMING_RED))
	   	if imgui.MenuItem("Exit")
	    {
	        os.exit(0)
	    }
		imgui.PopStyleColor()

		imgui.EndMenu()
    }

    if imgui.BeginMenu("View")
    {
    	if imgui.MenuItem("X")
     	{
      	}

     	imgui.EndMenu()
    }

    //imgui.PushStyleColorImVec4(imgui.Col.Text, colorToImVec4(SILVER))
    if imgui.BeginMenu("Settings")
    {
   		if imgui.MenuItem("Open")
	    {
			debugState.drawSettings = !debugState.drawSettings
	    }

		imgui.EndMenu()
    }
    //imgui.PopStyleColor()

    imgui.EndMainMenuBar()
}

drawSettings :: proc()
{
	if debugState.drawSettings
    {
        if imgui.Begin("Settings", &debugState.drawSettings)
        {
       		imgui.ColorPicker4("Sky Color", &SKY_COLOR)
        }
    imgui.End()
    }
}


drawDebugUi :: proc()
{
	drawSettings()
}
