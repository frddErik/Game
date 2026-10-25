package Game

Asset :: struct
{
	name: [48]rune,
	type: AssetType,
	hash: [16]u8,
	icon: AssetRef,
	using sceneTree: Tree,
	state: AssetState,
	data: []byte,
}

AssetType :: enum u8
{
	PLAN,
	FOLDER,
	SPRITE,
	AUDIO_SAMPLE,
}

AssetState :: enum u8
{
	UNLOADED,
	LOADED,
}

AssetRef :: struct
{
	idx : Idx,
	gen: u32,
}

derefAsset :: proc(ref: AssetRef){}

loadAsset :: proc(ref: AssetRef) -> bool
{
	// get pointer to asset from AssetRef (by proc get?)
	// Load the asset (get hash, search hash in fs, load, store slice)
	// Set asset to loaded in gamestate and set data to slice
	// return true if successfull
	return false
}
