// todo:
// get imgui working DONE (good enough for now ig)
// thing system + imgui editor
// asset system
// naive voxel engine

// NEXT: Make thing system and asset system tree working. + imgui editor

package Game

import "core:fmt"

// hash stuff

import rl "vendor:raylib"

// ImGui from https://github.com/fredtheking/Odin-Raylib-ImGui-Template (seems to be good for now!)
import rlimgui "../libs/imgui_impl_raylib"
import imgui "../libs/odin-imgui"

WINDOW_TITLE :: "Game"
WINDOW_W :: 1280
WINDOW_H :: 720

GAME_TICK_RATE :: 60
AUDIO_SAMPLE_RATE :: 44100

Idx :: distinct u32
NIL :: Idx(0)

Vec2 :: rl.Vector2
Vec3 :: rl.Vector3

// LIMITS
MAX_THINGS :: 8192

main :: proc()
{
	rl.InitWindow(WINDOW_W, WINDOW_H, WINDOW_TITLE)
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	// Setup ImGui context
    imgui.CreateContext(nil); defer imgui.DestroyContext(nil)

    // Init ImGui for Raylib
    rlimgui.init(); defer rlimgui.shutdown()

	camera := rl.Camera3D{position = Vec3{0, 10, 10}, target = Vec3{0, 0, 0}, up = Vec3{0, 1, 0}, fovy = 45, projection = .PERSPECTIVE}

	fmt.println("GameState size:", size_of(GameState) / 1024, "kb!\n")
	fmt.println("Thing size:", size_of(Thing), "bytes!\n")

	thing: Thing
	thing.data = PlayerData{}
	//thing.data.pos = Vec3{3, 3,3}

	for !rl.WindowShouldClose()
	{
		// hacky camera movement
		rl.UpdateCamera(&camera, .FIRST_PERSON)

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)

		// ImGui begin (must be called each frame BEFORE using ImGui)
        rlimgui.begin()

		rl.BeginMode3D(camera);

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

		//imgui.ShowDemoWindow(nil)

		imgui.Begin("Menu of Menus")
		imgui.End()

		rlimgui.end()

		rl.EndDrawing()
	}
}

GameState :: struct
{
	things: [MAX_THINGS] Thing,
	thingsUsed: [MAX_THINGS]bool,
	thingsGeneration: [MAX_THINGS]u32,

	thingsNextFree: [MAX_THINGS]Idx,
	thingsFirstFree: Idx,
	thingsLastFree: Idx,

	drawList: [dynamic]DrawCommand // make this use the temp alloc?
}

Thing :: struct
{
	kind: ThingKind,

	name: [32]rune,
	icon: AssetRef,

	using sceneTree: Tree,

	data: ThingData,
}

ThingRef :: struct
{
	idx: Idx,
	gen: u32,
}

ThingKind :: enum u16
{
	NIL,
	World,
	Group,
	SculptureRecipe,
	Player,
	Chip,
	NoteChunk,
}

Transform :: struct
{
	pos: Vec3,
	rot: Vec3,
}

ThingData :: union
{
	WorldData,
	PlayerData,
	SculptureRecipeData,
}

PlayerData :: struct
{
	using _: Transform
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
NoteChunkData :: struct
{
	notes: [8]Note // Grow size with union!
}

PatternData :: struct
{
	tempo: f32
	// Note chunks will be children.
}

// Asset System
Asset :: struct
{
	name: string,
	icon: AssetRef,
	using _: Tree,
	state: AssetState,
	data: ^u32, // no clue what type yet maybe slice?
	size: u32,
	type: AssetType,
	hash: [32]u8, // idk make this how long the hash is
}

AssetType :: enum u8
{
	FOLDER,
	PLAN,
	SPRITE,
	SAMPLE,
}

AssetState :: enum u8
{
	UNLOADED,
	LOADED,
}

AssetRef :: struct{}
