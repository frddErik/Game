package Game

import "core:fmt"
import rl "vendor:raylib"

WINDOW_TITLE :: "Game"
WINDOW_W :: 1280
WINDOW_H :: 720

ThingIdx :: distinct u32

Vec2 :: rl.Vector2
Vec3 :: rl.Vector3

// LIMITS
MAX_THINGS :: 4096

main :: proc()
{
	rl.InitWindow(WINDOW_W, WINDOW_H, WINDOW_TITLE)
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

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

		rl.EndDrawing()
	}
}

GameState :: struct
{
	things: [MAX_THINGS] Thing,

	drawList: [dynamic]DrawCommand
}

Thing :: struct
{
	kind: ThingKind,

	name: [24]rune,
	pos: Vec3,
	health: u8,

	using sceneTree: Tree,

	data: ThingData,
}

ThingKind :: enum u16
{
	NIL,
	World,
	Group,
	SculptureRecipe,
	Chip,
	Player,
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
	pos: Vec3,
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
