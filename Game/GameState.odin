package Game

import rl "vendor:raylib"

GameState :: struct
{
	// Things
	things: [MAX_THINGS] Thing,
	thingsUsed: [MAX_THINGS]bool,
	thingsGeneration: [MAX_THINGS]u32,

	thingsNextFree: [MAX_THINGS]Idx,
	thingsFirstFree: Idx,
	thingsLastFree: Idx,

	// Assets
	assets: [MAX_ASSETS]Asset,
	assetsUsed: [MAX_ASSETS]bool,
	assetsGeneration : [MAX_ASSETS]u32,

	assetsNextFree: [MAX_ASSETS]Idx,
	assetsFirstFree: Idx,
	assetsLastFree: Idx,

	camera: rl.Camera3D,

	drawList: [dynamic]DrawCommand // make this use the temp alloc?
}
