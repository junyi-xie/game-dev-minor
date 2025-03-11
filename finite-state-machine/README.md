# Implementing a State Machine in Godot - Game Programming | Gold 1

Simple Finite State Machine implementation in Godot 4.4.

## Preview

<img src="https://github.com/junyi-xie/game-dev-minor/blob/main/finite-state-machine/preview.png" />

## Controls

The player can be moved using the following controls:

- **WASD** or **Arrow keys** to move
- **Space** to jump
- **Space (while ascending mid-air)** to double jump (_only accessible from the Jump state_)

## Requirements

- Simple 2D/3D level.
  - The character can move through a level that supports/facilitates the movement states. 
- Player can be controlled.
  - The player object can be moved with WASD or arrow-keys. 
- Conatains at least 4 different states.
  - For example idle, walk, run, jump.
- At least 1 state relies on another state.
  - For example jump can only be entered from run.
- Different states should be observable.
  - The state changes and current active state are easily determined by use of colour, sprites, or text.
- State machine implementation uses class-hierarchy.
  - No giant is-else, enums or booleans (for state management) used.
- Player movement is framerate independent.
- Player is kept in frame.
  - Use a follow camera of some kind.

## Tutorial

For this achievement, I followed the following tutorials:

- [Finite State Machines in Godot 4 in Under 10 Minutes ](https://www.youtube.com/watch?v=ow_Lum-Agbs)
- [Start Your Game Creation Journey Today! (Godot beginner tutorial)](https://www.youtube.com/watch?v=5V9f3MT86M8)
- [Starter state machines in Godot 4 ](https://www.youtube.com/watch?v=oqFbZoA2lnU)

## Credits

Tileset: https://kenney.nl/assets/pixel-platformer

Character: https://pixelfrog-assets.itch.io/pixel-adventure-1
