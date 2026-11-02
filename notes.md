which hashing algo for assets?

Atomic Resource Types
- Audio
- Texture
- Mesh

- need to have a good wire implementation. Keyframes can be just invisible wires. We store an array of properties and they can be connected via an wire to the modulated value.

blarc - blob archive
blmap - blob map
farc - file archive. map + blarc

Each model either has a mesh or something for volumetric. The recipes are stored in a linked recipenode array NOT the main scene tree as things! For recipes
we will need an different editor then tho but thats no prob prolly even better than having it pollute the scene tree!


ASSETS ARE RUNTIME AND RESOURCES ARE ON FILE!!!!!!

maybe unify resourcesystem.odin and filearchive.odin?

What will we use for textures? QOI??

Audio:
Opus for lossy.
For lossless???  FLAC, wavpack...?
