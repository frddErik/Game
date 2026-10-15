// todo:
// get imgui working DONE (good enough for now ig)
// thing system + imgui editor
// asset system
// naive voxel engine

package Game

import "core:fmt"

import rl "vendor:raylib"

// ImGui from https://github.com/fredtheking/Odin-Raylib-ImGui-Template (seems to be good for now!)
import rlimgui "../libs/imgui_impl_raylib"
import imgui "../libs/odin-imgui"

WINDOW_TITLE :: "Game"
WINDOW_W :: 1280
WINDOW_H :: 720

GAME_TICK_RATE :: 60
AUDIO_SAMPLE_RATE :: 44100

ThingIdx :: distinct u32
NIL :: ThingIdx(0)

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

		imgui.ShowDemoWindow(nil)

		rlimgui.end()

		rl.EndDrawing()
	}
}

GameState :: struct
{
	things: [MAX_THINGS] Thing,
	thingsUsed: [MAX_THINGS]bool,
	thingsGeneration: [MAX_THINGS]u32,

	thingsNextFree: [MAX_THINGS]ThingIdx,
	thingsFirstFree: ThingIdx,
	thingsLastFree: ThingIdx,

	drawList: [dynamic]DrawCommand // make this use the temp alloc?
}

Thing :: struct
{
	kind: ThingKind,

	name: [32]rune,
	icon: u32, // Make this some sort of static resource hash/id?
	position: Vec3,
	rotation: Vec3,
	health: u8,

	using sceneTree: Tree,

	data: ThingData,
}

ThingRef :: struct
{
	idx: ThingIdx,
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

ThingData :: union
{
	WorldData,
	PlayerData,
	SculptureRecipeData,
}

PlayerData :: struct
{
	pos: Vec3,
}

Tree :: struct // types change to u32 to have a more generic tree?
{
	parent: ThingIdx,
	firstChild: ThingIdx,
	nextSibling: ThingIdx,
	prevSibling: ThingIdx,
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
