package Game

// For game save, serialize scene tree + asset tree. To serialize scene tree, serialize thing (World/Root) and all child things. Asset tree also serialize the root and childs.
// For Object save, serialize objects root parent + all children. This could be two systems. For scene tree you say which thing you want to serialize + if all child nodes.
// Then you get a plan asset which you can save. Also deserialize is the same system but a flag. And also asset tree the same. Wait, maybe this can be one system and you give in
// a pointer to the array and depending on if its scene tree or asset tree it does diff stuff but the main system is the same maybe??

Serializer :: struct
{
	dataVersion: u32,
	// add memory chunk pointer for the result. You have to write to file yourself. Maybe slice to buffer? We can have one global(inmain) buffer which is as large as thing array maybe?
	isWriting: bool,
}

serialize :: proc{serializeThing, serializeU8, serializeU32, serializeI32}

serializeThing :: proc(serializer: Serializer, Thing: ThingRef, includeChildren: bool, gameState: ^GameState)
{

}

serializeU8 :: proc(serializer: Serializer, datum: ^u8) {}

serializeU16 :: proc(serializer: Serializer, datum: ^u16) {}

serializeU32 :: proc(serializer: Serializer, datum: ^u32) {}

serializeU64 :: proc(serializer: Serializer, datum: ^u64) {}

serializeI32 :: proc(serializer: Serializer, datum: ^i32) {}
