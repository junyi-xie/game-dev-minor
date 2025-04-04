# Stacking Boxes - Game Programming | Gold 2

3D physiced-based stacking game made in Godot 4.4.

## Preview

![Demonstration of gameplay](https://github.com/junyi-xie/game-dev-minor/blob/main/stacking-boxes/gameplay.gif)

## Controls

The player can interact using the following controls:

- **Mouse Movement** to position the box
- **Left Click** to drop the box

## Requirements

- Scene with table/floor. 
  - Boxes on the table stay there, and can fall of to the floor on the sides.
- Random boxes. 
  - The player gets a random shaped box every time. Have at least 4 different shapes.
- Physics based collisions. 
  - Use RigidBodies (faked physics) and collision detection for falling boxes.
- Dropped box ends game. 
  - If a box falls off the table, the game is over.
- Players can move the box. 
  - Player must be able to control where the box is dropped.
- Camera responds to stacked boxes. 
  - As the stack gets higher, your game should handle the camera position and spawn location so the game can still continue.

## Tutorial

- [3D Ray-Casting Basics in Godot - Godot 4 Tutorial](https://www.youtube.com/watch?v=HqnXLalw7Kw)
- [Godot Engine 4.4 documentation in English - Smoothing Motion](https://docs.godotengine.org/en/stable/tutorials/math/interpolation.html#smoothing-motion)

## Credits

Super Peace: https://www.dafont.com/super-peace.font

3D Baked Goods Kit: https://tinytreats.itch.io/baked-goods
