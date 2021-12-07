# Knit Framework Public Test Project

*"Knit is a lightweight framework for Roblox that simplifies communication between core parts of your game and seamlessly bridges the gap between the server and the client."* 

  -Stephen (sleitnick)

The purpose of this project is to test and learn the [knit framework](https://sleitnick.github.io/Knit/) in a simple **Avoid the falling kill bricks type of game** and a number of [Knit utilities](https://sleitnick.github.io/RbxUtil/), specially the [Knit component utility](https://sleitnick.github.io/RbxUtil/api/Component/).

## Brick Fall

Kill bricks are raining from the sky! Quick, stay alive to earn points and buy pets. 

The "game" includes:

- Event based round system life cycle:
  - Intermission
  - Waiting for enough players (min one player 1)
  - In Match
  - After match

- Player Points stats to keep track of current points
- Point counting, you will get 10 points every second and loose 50 when you die
- Shop where you can buy pets (Note: pets not yet implemented)
- TONS Kill brick component
- HUD that shows Current points, players, and game status
- Shop menu with functional buttons

<br>

If you have any sugestion or want to reach out, feel free to dm me on discord:
CluelessDev(Quique)#5459

## Conclusion
Knit has made communication between server and client and vice versa a borderline trivial thing, it allowed me to make services api for both a server and client consumer in an idiomatic, and more importantly CLEAN way that I struggled with before using thi framework. 

I really recommend it!

Furthermore the Component utility allows for some really interesting data oriented behavior that makes mantaining code an easier task in my honest opinion, if you have used to some degree [collection service](https://developer.roblox.com/en-us/api-reference/class/CollectionService) you will love this! (I am a sucker for tags, and this makes them 10x better)


## Demo
  
![](Images/Brick%20Fall%20gif.gif)
<br>


TODO: 

- Make it so you actually get a pet when you buy it
- Use Enums for round state?
- Add pet service
- Clean up shop gui
- Add better comments