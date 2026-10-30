package Game

Thing :: struct
{
	kind: ThingKind,

	name: [32]rune,
	icon: AssetRef,

	sceneTree: Tree,

	data: ThingData,
}


ThingRef :: struct
{
	idx: Idx,
	gen: u32,
}

NIL_THING_REF :: ThingRef{}

resetThings :: proc(gameState: ^GameState)
{
	gameState.things = {}
	for i in 1 ..< MAX_THINGS - 1
	{
		gameState.thingsNextFree[i] = Idx(i + 1)
	}
	gameState.thingsFirstFree = 1
	gameState.thingsLastFree = MAX_THINGS - 1
}

addThing :: proc(kind: ThingKind, gameState: ^GameState) -> ThingRef
{
	slot := gameState.thingsFirstFree
	if slot == NIL
	{
		return NIL_THING_REF
	}

	gameState.thingsFirstFree = gameState.thingsNextFree[slot]
	if gameState.thingsFirstFree == NIL
	{
		gameState.thingsLastFree = NIL
	}

	gameState.thingsNextFree[slot] = NIL

	gameState.things[slot] = {}
	gameState.things[slot].kind = kind
	gameState.thingsUsed[slot] = true
	gameState.thingsGeneration[slot] += 1

	return ThingRef{idx = slot, gen = gameState.thingsGeneration[slot]}
}

derefThing :: proc(ref: ThingRef, gameState: GameState) -> Idx
{
	if ref.idx > NIL && ref.idx < MAX_THINGS && gameState.thingsUsed[ref.idx] && ref.gen == gameState.thingsGeneration[ref.idx]
	{
		return ref.idx
	}
	return NIL
}

getThing :: proc(ref: ThingRef, gameState: ^GameState) -> ^Thing
{
	return &gameState.things[derefThing(ref, gameState^)]
}

isValidThing :: proc(ref: ThingRef, gameState: ^GameState) -> bool
{
	return derefThing(ref, gameState^) != NIL
}

removeThing :: proc(ref: ThingRef, gameState: ^GameState)
{
	slot := derefThing(ref, gameState^)
	if slot == NIL do return

	gameState.thingsUsed[slot] = false
	gameState.thingsNextFree[slot] = NIL

	if gameState.thingsLastFree != NIL
	{
		gameState.thingsNextFree[gameState.thingsLastFree] = slot
	}
	else
	{
		gameState.thingsFirstFree = slot
	}
	gameState.thingsLastFree = slot
}

ThingData :: union
{
	WorldData,
	PlayerData,
	SculptureRecipeData,
	NodeData,
}


ThingKind :: enum u16
{
	NIL,
	World,
	Group,
	Model,
	SculptureRecipe,
	Player,
	Chip,
	NoteChunk,
	Node,
}
