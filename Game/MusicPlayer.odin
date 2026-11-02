package Game

// Audio goes into Master Mixer slot. This is not ingame music player but menu based.

// Jukebox mode: play game ost OR sounds/music aka audio from ur profile. The other mode is "mp3 player" like, so stream from os folder whatever the user wants.
// On consoles, obviously only jukebox mode. But since you can download/import audio into ur profile obviously, shouldnt be a prob.
// Sequenced songs have to be listened to in world, gotta record it to listen to it in this music player.

// Make ingame jukeboxes (out of electronics and model so ingame plan) too! This is seperate though!

// Playlists
// Liked songs is one default playlist everyone has.
// Audio visualizer is there too in the menu.
// Queue too


// FILE mode is only available on PC.

mpSource :: enum
{
	MP_SOURCE_OST,
	MP_SOURCE_PROFILE,
	MP_SOURCE_FILE
}

MP_SOURCE_OST :: struct
{
	ref: AssetRef
}

MP_SOURCE_PROFILE :: struct
{
	ref: AssetRef
}

MP_SOURCE_FILE :: struct
{
	path: string
}

mpTrack :: struct
{
	id: GUID,
	source: mpSource,
	title: string,
	artist: string,
	album: string,
	cover: AssetRef,
	duration: f32, // secs
	missing: bool, // greyed out if source is missing
	playCount: u16,
}
