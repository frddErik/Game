package Game

import "core:os"

// In the future, I want some sort of VCS. Does the resource system have to take care of this? Or the fs? Idk, look into it in the future.

// .barc - blob archive
// .bmap - fs blob map
// .farc - blarc + farc in one file

BARC_REVISION :: 0
BMAP_REVISION :: 0
FARC_REVISION :: 0

// BARC - Blob Archive
Blob :: struct
{
	data: []byte,
	indexEntry: IndexEntry,
}

IndexEntry :: struct #packed
{
	hash: [16]byte,
	offset: u64,
	size: u32,
}

BarcFooter :: struct #packed
{
	revision: u8,
	elementCount: u32,
	magic: [4]byte,
}

writeBarc :: proc(file: os.File, blobs: ^[]Blob)
{
	blobCount := u32(len(blobs^))
	barcFooter := BarcFooter{BARC_REVISION, blobCount, "BARC"}

	// count the data size of all blobs (loop trough blobs and += size)
	// make data buffer with the size
	// iterate trough blobs again
	// for each blob, append data to data buffer

	// Then, make buffer for idk how to call it but like the metadata stuff
	// just use blob count * size of each entry (whole Blob struct - data slice size) for size
	// and iterate trough array. Actully do it all in one so only go trough array once and append data and metadata.

	// Finally, write data buffer, then metadata buffer, then footer. Barc done :)
}


// Hmm idk about ts how does it connect to assets?
//
// So i think well store the fs in the map not as a path per map element but also as intrusive.
// This way when we load a bmap we can load the whole fs structure and present in tree view. Thats what we want.
// Like we load all MapElements of Bmap into Assets array intrusive. We have one global World current loaded assets fs.
// But then we can also do several fs's like one fs (aka intrusive array of Asset structs) per Palettes etc. For easier access you
// can like make a palette (aka folder but it only references the assets) for easier access. This is very confusing ik, we'll see!
MapElement :: struct
{
	hash: [16]byte,
	guid: u32,

	pathLength: u16,
	path: string,
}
