# Cupid-s-Courier
Final Project for AME 435 (Mobile Development) - made a game using Xcode + Swift

Cupid's Courier is a game where player A (you) selects an item of choice to gift to player B. 
- 3 characters to choose from for both Player A and Player B (6 characters total). 
- 3 items to choose from - cookies, flowers, or money.
- Select the level of difficulty -  as the level of difficulty increases, the rate at which the items fall increases and the time between the items falling decreases.

How to Play:
- When the Play button is clicked, the user will see the main game screen where the Player A avatar they chose has to collect the item of choice that's falling from the top.  
- Whenever an item is collected, the score increases by 10 points, which is seen on the top right corner of the screen. 
- The items are collected by simple game mechanics - just moving left and right, i.e., tap the bottom left and right corners of the screen near the character in order to move left and right.
- When the item hits the ground the game is over. 

When the game is over, you will see a screen that congratulates Player A (you) for collecting n number of items (n is your final score) to gift Player B and tells you that Player B is happy! 
It displays the Player A, Player B, and item of choice sprites. It also has 3 buttons:
- Play Again, which enables you to play the game again with the same character and the same item that you chose.
- Start Over, which takes you back to the screen where you can select a different character and a different item if you desire.
- Exit Game, which takes you back to the initial screen where the name of the game and the Start button is displayed.

Code overview:
WelcomeScene - displays the name “Cupid's Courier” and the Start button
UserScene - prompts you to select the character you want to play with and the character you want to gift
SelectionScene - prompts you to choose the item you want to gift : flowers,  cookies, or money, as well as lets you select the level of difficulty 
ResetScene - displays the Player A, Player B, and item of choice sprites, and the final score message; it also has 3 buttons - Play Again, Start Over, and Exit Game
Background - helper file that has code to create backgrounds easier across different screens
BGM - AVAudioPlayer code
ContentView - code to manage scenes + play background music throughout
PlayerA / PlayerB - SKSpriteNode classes to handle features for the character sprites
Gift - SKSpriteNode class to handle features for the items to choose from
Game - the main logic for the game
