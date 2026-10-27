package Game

import "core:os"
import "core:fmt"
import "core:encoding/hex"

Asset :: struct
{
	name: [32]rune,
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
	TEXTURE,
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


loadAsset :: proc(ref: AssetRef, gameState: ^GameState) -> bool
{
	// get pointer to asset from AssetRef (by proc get?)
	asset := getAsset(ref, &gameState^)
	// Load the asset (get hash, search hash in fs, load, store slice)
	hash := asset.hash
	hex_str_upper, err_upper := hex.encode_upper(hash[:])
	if err_upper == nil
	{
		defer delete(hex_str_upper)
		path := string(hex_str_upper)
		if data, data_err := os.read_entire_file(path, context.allocator); data_err == nil
		{
			// Set asset to loaded in gamestate and set data pointer to slice
			asset.state = .LOADED
			asset.data = data
			fmt.println("LOADED!")
		}
		else
		{
			fmt.println(data_err)
		}
	}
	// return true if successfull
	return false
}

unloadAsset :: proc(ref: AssetRef, gameState: ^GameState)
{
	// get pointer to asset from AssetRef (by proc get?)
	asset := getAsset(ref, &gameState^)
	delete(asset.data, context.allocator)
}

derefAsset :: proc(ref: AssetRef) -> Idx
{
	return ref.idx
}

getAsset :: proc(ref: AssetRef, gameState: ^GameState) -> ^Asset
{
	return &gameState.assets[derefAsset(ref)]
}

// TEST STUFF
MAX_ASSETS :: 256

testAssetSystem :: proc(gameState: ^GameState)
{
	gameState.assets[0].hash = [16]u8{0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef, 0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x10}
	ref := AssetRef{idx = 0}
	loadAsset(ref, gameState)
	fmt.printfln("%02X", gameState.assets[0].data[:16])
}
