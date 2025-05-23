# Little Town Remake

## :pushpin: About
GameMaker Tutorial remade in Godot to understand the differences between the two game engines and improve my understanding of Godot.  
Original Tutorial: https://gamemaker.io/de/tutorials/little-town-gamemaker-tutorial

**Status**: WIP  
**Genre:** top town 2D, adventure, non pixel art  
**Engine**: Godot 4.4  
**Language**: GDScript  
**Project Documentaion**: [Wiki](https://github.com/SuperEugen/little-town-remake/wiki)  
**Project Management**: [Kanban Board](https://github.com/users/SuperEugen/projects/1)  

![Screenshot Godot 4.4](https://i.imgur.com/G9iwKYq.png)

## :video_game: How to Play
- Use WASD or arrow keys to walk around
- Use Shift to run
- Use Space to pick-up or put-down an item or to talk to an NPC
- Finish the game by finding and giving the correct items to the NPCs

## :mag: Implementation Details
- Player with sprite animation
- 4 way movement of player
- 3 NPCs with animations
- World with tiles and additional decorations
- 6 items to interact with
- 3 quests
- Start screen and Game Over screen
- Music, ambience SFX, 2D audio, SFX

## :electric_plug: Plug-ins
- TODO Manager (Godot 4) from the [AssetLib](https://godotengine.org/asset-library/asset/1327)

## :factory: Additional Software
- **Sound recording**: iPhone with EZAudioCut  
- **Music**: GarageBand with AppleLoops, converted to OGG with VLC  
- **Sprites, Animations and Tiles**: Moho Pro 14.3, PNGs cropped with Mac Preview  
- **Project management and documentation**: GitHub with Project and Wiki  

## :framed_picture: Assets
- **SFX**: SuperEugen  
- **Music**: SuperEugen  
- **Sprites**: SuperEugen  
- **Characters**: YoYo Games  
- **Tiles**: SuperEugen
- **Game Idea**: [YoYo Games](https://gamemaker.io/) and  [Benjamin Rivers](https://www.bancy.co)  

## :man_teacher: Learning Ressources
- Official Godot tutorial: [Your first 2D Game](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html)
- GDScript Reference [Godot Docs](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)
- GameMaker Tutorial: [Make Your Adventure Game](https://gamemaker.io/de/tutorials/little-town-gamemaker-tutorial)
- GameDev.tv course: [Complete Godot 4 2D: Code Your Own 2D Games In Godot 4!](https://www.gamedev.tv/courses/godot-complete-2d)

## :trophy: Take Away
- GameMaker understands animated GIFs, in Godot these have to be converted to image sequences.
- Y-sorting can be automated in Godot.
- User interface in Godot is classic editor with properties pane, in GameMaker editor windowas are laid out on an endless canvas which is more difficult to navigate.
- GameMaker is easier to start with but Godot offers more posibilities with extra layers of complexity.
- GameMaker sequences translate to Godot AnimationPlayer animations. To see them on top of the screen one has to use Control nodes and CanvasLayer nodes.
