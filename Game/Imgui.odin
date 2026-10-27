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

    if imgui.BeginMenu("General")
    {
    	if imgui.MenuItem("Open File")
	    {
	    }

    	if imgui.MenuItem("About")
	    {
	    }

		imgui.PushStyleColorImVec4(imgui.Col.Text, colorToImVec4(ALARMING_RED))
	   	if imgui.MenuItem("Exit")
	    {
	        os.exit(0)
	    }
		imgui.PopStyleColor()

		imgui.EndMenu()
    }

    if imgui.BeginMenu("Colors!")
    {
    	imgui.PushStyleColorImVec4(imgui.Col.Text, colorToImVec4(AQUA_BLUE))
   		if imgui.MenuItem("Beautiful")
	    {
	    }
		imgui.PopStyleColor()

		if imgui.MenuItem("White again...")
		{
		}

		imgui.EndMenu()
    }

    imgui.PushStyleColorImVec4(imgui.Col.Text, colorToImVec4(SILVER))
    if imgui.BeginMenu("Settings")
    {
   		if imgui.MenuItem("Open")
	    {
			imgui.Button("SIZE")
	    }

		imgui.EndMenu()
    }
    imgui.PopStyleColor()

    imgui.EndMainMenuBar()
}

drawSettings :: proc(){}
