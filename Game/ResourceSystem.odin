package Game

import "core:image/qoi"

// In the future, I want some sort of VCS. Does the resource system have to take care of this? Or the fs? Idk, look into it in the future.

// WE NEED A GUID AND HASH FOR PERSISTENT ASSET REF!!!!!!!!!!!!!

// placeholder for other code
GUID :: u64

ResourceType :: enum
{
	PLAN,
	TEXTURE,
	AUDIO,
	MESH,
}

// maybe do an ResourceHeader per type?
// ofr example
AudioResourceHeader :: struct
{
	lossless: bool,
}

TextureCompression :: enum
{
	QOI,
	QOI_ZSTD,
}

// QOI + zstd for textures
// okay so I did some testing and its generally better than png ig but sometimes raw + zstd is better
// but for now just always use qoi + zstd its fine BUT make the resource system be able to store different
// compression methods etc! Also different image formats whend decoded.
// yk what fuh it just always use qoi + zstd for now who cares if it works!!
//
// Flac for lossless audio
// Opus for lossy audio
