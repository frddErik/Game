// todo:
// get imgui working DONE (good enough for now ig)
// thing system + imgui editor
// asset system
// naive voxel engine

// NEXT: Make thing system and asset system tree working. + imgui editor


// keyframes will be just invisible wires.

package Game

import "core:thread"
import "core:fmt"

import "core:crypto/blake2b"

import rl "vendor:raylib"

// ImGui from https://github.com/fredtheking/Odin-Raylib-ImGui-Template (seems to be good for now!)
import rlimgui "../libs/imgui_impl_raylib"
import imgui "../libs/odin-imgui"

WINDOW_TITLE :: "Game"
WINDOW_W :: 1920
WINDOW_H :: 1080

GAME_TICK_RATE :: 60
AUDIO_SAMPLE_RATE :: 44100

Idx :: distinct u32
NIL :: Idx(0)

Vec2 :: rl.Vector2
Vec3 :: rl.Vector3

// LIMITS
MAX_THINGS :: 128

font: rl.Font

debugState := DebugState{showDebugMenu = true}

main :: proc()
{
	rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(WINDOW_W, WINDOW_H, WINDOW_TITLE)
	defer rl.CloseWindow()

	windowIcon := rl.LoadImage("Assets/Textures/UI/squares-unite.png")
	rl.SetWindowIcon(windowIcon)

	rl.SetTargetFPS(120)

	font = rl.LoadFontEx(imguiFontPath, 512, nil, 0)

	// Setup ImGui context
    imgui.CreateContext(nil); defer imgui.DestroyContext(nil)

    // Init ImGui for Raylib
    rlimgui.init(); defer rlimgui.shutdown()

    styleImgui(imguiScale)

    gameState: GameState
    resetThings(&gameState)


	gameState.camera = rl.Camera3D{position = Vec3{0, 10, 10}, target = Vec3{0, 0, 0}, up = Vec3{0, 1, 0}, fovy = 45, projection = .PERSPECTIVE}

	fmt.println("GameState size:", size_of(GameState) / 1024, "kb!\n")
	fmt.println("Thing size:", size_of(Thing), "bytes!\n")

	player := addThing(.Player, &gameState)
	fmt.println(isValidThing(player, &gameState))
	removeThing(player, &gameState)
	fmt.println(isValidThing(player, &gameState))

	testAssetSystem(&gameState)

	// IMGUI CONFIG

	for !rl.WindowShouldClose()
	{
		// hacky camera movement
		rl.UpdateCamera(&gameState.camera, .FIRST_PERSON)

		// toggle debug menu
		if rl.IsKeyPressed(.I)
		{
			debugState.showDebugMenu = !debugState.showDebugMenu
		}

		if rl.IsKeyPressed(.M)
		{
			rl.TakeScreenshot("screenshotnotolight.png")
		}


		Render(&gameState, &debugState)
	}
}

Render :: proc(gameState: ^GameState, debugState: ^DebugState)
{
	rl.BeginDrawing()
	rl.ClearBackground(rl.Color{u8(clamp(SKY_COLOR.r*256, 0, 255)), u8(clamp(SKY_COLOR.g*256, 0, 255)), u8(clamp(SKY_COLOR.b*256, 0, 255)), u8(clamp(SKY_COLOR.a*256, 0, 255))})

	/*
	rl.BeginMode3D(gameState.camera);

	rl.DrawGrid(16, 1)

	for x in 0..<32
	{
		for z in 0..<32
		{
			//rl.DrawCube(Vec3{f32(x), 0, f32(z)}, 1, 1, 1, rl.RED)
			rl.DrawCubeWires(Vec3{f32(x), 0, f32(z)}, 1, 1, 1, rl.WHITE)
		}
	}

	rl.DrawSphere(Vec3{0,0,0},.5,rl.WHITE)

	rl.EndMode3D()
	*/

	node := addThing(.Node, &gameState^)

	rawnode := getThing(node, gameState)

	rl.DrawTextEx(font, "Hello!",Vec2{100, 100}, 100,0, rl.WHITE)

	//rl.DrawRectangle(rawnode.pos)

	//imgui.ShowDemoWindow(nil)
	if debugState.showDebugMenu
	{
		// ImGui begin (must be called each frame BEFORE using ImGui)
    	rlimgui.begin()

     	if imgui.Begin("Menu of Menus")
      	{
       		if imgui.Button("Show General")
	        {
		        debugState.showGeneral = !debugState.showGeneral
	        }

			if imgui.Button("Show World Management")
	        {
		        debugState.showWorldManagement = !debugState.showWorldManagement
	        }

			if imgui.Button("Show Asset Management")
	        {
		        debugState.showAssetManagement = !debugState.showAssetManagement
	        }

			if imgui.Button("Show Settings")
	        {
		        debugState.drawSettings = !debugState.drawSettings
	        }
       	}
        imgui.End()

        if debugState.showWorldManagement
        {
        	if imgui.Begin("World Management")
	        {
				if imgui.TreeNode("Scene Tree")
				{
					if imgui.TreeNode("World")
					{
						if imgui.TreeNode("Player")
						{
							imgui.TreePop()
						}
						imgui.TreePop()
					}
					imgui.TreePop()
				}
	        }
         	imgui.End()
        }

        if debugState.showAssetManagement
        {
        	if imgui.Begin("Asset Management")
	        {

	        }
         	imgui.End()
        }

        drawDebugUi()

        if debugState.showAbout
        {
        	if imgui.Begin("About", &debugState.showAbout)
	        {
		        imgui.Text("Game")
				imgui.Separator()
				imgui.Text("Prototype v0.0 (r0)")
	        }
			imgui.End()
        }

        drawDebugMenuBar()

		rlimgui.end()
	}

	rl.EndDrawing()
}

DebugState :: struct
{
	showDebugMenu: bool,
	showGeneral: bool,
	showWorldManagement: bool,
	showAssetManagement: bool,
	drawSettings: bool,
	showAbout: bool,
}




Transform :: struct
{
	pos: Vec3,
	rot: Vec3,
}

PlayerData :: struct
{
	using _: Transform
}
// node is just for editor, the underlying data is in scene tree. wait or make chip.
// just make a chip is WRONG cuz chips are for realtime data manipulation stuff and recipes are well recipes...
// so seperate it!
NodeData :: struct
{
	using _: Transform,
	name: string,
}

Tree :: struct
{
	parent: Idx,
	firstChild: Idx,
	nextSibling: Idx,
	prevSibling: Idx,
}

DrawCommand :: union
{
	DrawCommandCircle,
	DrawCommandRect,
	DrawCommandText,

	DrawCommandSprite,
}
// DrawList

DrawCommandSprite :: struct
{
	pos: Vec2,
	size: Vec2,
	// spriteId
}

DrawCommandCircle :: struct
{
	pos: Vec2,
	radius: f32,
	color: rl.Color
}

DrawCommandRect :: struct{}
DrawCommandText :: struct{}

SculptRecipeKind :: enum
{
	OpUnion,
	opSubtraction,
	opIntersection,
	opXor,
	PrimSphere,
	primBox,
}

SculptureRecipeData :: struct
{
	kind: SculptRecipeKind,

	// Operations
	smoothBlendAmount: f32,

	// Primitives
	pos: Vec3, // THIS IS ALR IN THING, rotation also for boxes n stuff
	radius: f32,
}

WorldData :: struct{}

ChipKind :: enum
{
	Value,

	Toggle,

	GateAND,
	GateNOT,
	GateOR,
}

ChipData :: struct
{
	outputInverted: bool,
}

Note :: struct{} // also pan like in fl!

// Because everything is stored in things, we store notes in chunks (they will be as big as the union allows)
// without inflating it more. This way a pattern only needs a few child things and not hundreds.

// LOWK DONT POLLUTE THE SCENE TREE WITH NOTE DATA, LETS JUST MAKE AN ARRAY WITH NOTE CHUNKS! MAYBE
NoteChunkData :: struct
{
	notes: [8]Note // Grow size with union!
}

PatternData :: struct
{
	tempo: f32
	// Note chunks will be children.
}



// Compiler: Code into Plan!
// this is not efficient at all but for our minimal engine it is enough. We want to have a minimal but functional engine.
