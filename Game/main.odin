package Game

VERSION :: "0.0"
REVISION :: 0

import "core:fmt"

main :: proc()
{
	blob := [2]byte{0xAA, 0xBB}

	fmt.println(hashBlob(blob[:]))
}
