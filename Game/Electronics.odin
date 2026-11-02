package Game

Wire :: struct
{
	sourceThing: ThingRef,
	sourcePort: u8,
	destinationThing: ThingRef,
	destinationPort: u8,
}

// Wire: 1 Game-Rate Signal
// Wire Bundle: Several Game-Rate Signals
// Cable: 1 Audio-Rate Signal
// Cable Bundle: Several Audio-Rate Signals
// Mixed Bundle: Mix

// Keyframe is invisible wire/cable.
// how do we do ports?

// FFT
