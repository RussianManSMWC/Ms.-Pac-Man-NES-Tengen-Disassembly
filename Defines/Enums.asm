;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Constants but they're enumerations

;Entity IDs
.enum
  Entity_ID_None
  Entity_ID_Player                                          ;pac-man or ms. pac-man
  Entity_ID_Ghost
  Entity_ID_VulnerableGhost                                 ;ghosts turn into this after consuming a power pellet
  Entity_ID_BouncingItem
  Entity_ID_GhostScore                                      ;score display left by the ghost after eating them with a power pellet
  Entity_ID_ItemScore                                       ;score display left by the bouncing item when collected
  Entity_ID_GhostEyes                                       ;what's left of the ghost after being eaten with power pellet, retreats into the center of the maze
  Entity_ID_GAME_OVERString                                 ;a scrolling game over text that uses sprite tiles
  Entity_ID_READYString                                     ;when starting a stage or after dying
  Entity_ID_PacJunior                                       ;the maze roaming Pac-Man Junior (easter egg and Act 4)
  Entity_ID_ClapperPart                                     ;a portion of the ACT clapper that is made out of sprite tiles
  Entity_ID_Stork                                           ;found in ACT 3
  Entity_ID_CutscenePacJunior                               ;ACT 3
  Entity_ID_Heart                                           ;appears in ACT 1
  Entity_ID_CutscenePlayer
  Entity_ID_CutsceneGhost
.endenum

;entity directions
.enum
  Entity_Direction_Right
  Entity_Direction_Up
  Entity_Direction_Left
  Entity_Direction_Down
.endenum

;ghost characters
.enum
  Entity_Ghost_Character_Blinky
  Entity_Ghost_Character_Sue
  Entity_Ghost_Character_Inky
  Entity_Ghost_Character_Pinky
.endenum

;score rewards (aligned with ScoreAwardData_FBE2)
.enum
  ScoreReward_10Pts
  ScoreReward_50Pts
  ScoreReward_100Pts
  ScoreReward_200Pts
  ScoreReward_400Pts
  ScoreReward_500Pts
  ScoreReward_700Pts
  ScoreReward_800Pts
  ScoreReward_1000Pts
  ScoreReward_2000Pts
  ScoreReward_5000Pts
  ScoreReward_3000Pts
  ScoreReward_4000Pts
  ScoreReward_6000Pts
  ScoreReward_7000Pts
  ScoreReward_8000Pts
  ScoreReward_9000Pts
  ScoreReward_Ten000Pts
.endenum

;Tile stripe/strings enum
.enum
  TileStripeID_TitleScreen
  TileStripeID_HighScore
  TileStripeID_MazePlayer1
  TileStripeID_MazePlayer2
  TileStripeID_UnusedLevelXX
  TileStripeID_MazePlayerXEmpty
  TileStripeID_1UP
  TileStripeID_1UPEmpty
  TileStripeID_GameOver
  TileStripeID_UnusedLevelXXEmpty
  TileStripeID_OptionsText
  TileStripeID_Pause
  TileStripeID_Option_Type_2PAlternating
  TileStripeID_Option_Type_2PCompetitive
  TileStripeID_Option_Type_2Cooperative
  TileStripeID_Option_PacBooster_Off
  TileStripeID_Option_PacBooster_UseAorB
  TileStripeID_Option_PacBooster_AlwaysOn
  TileStripeID_Option_MazeSelection_Arcade
  TileStripeID_Option_MazeSelection_Mini
  TileStripeID_MazePlayers
  TileStripeID_Option_Type_1P
  TileStripeID_2UP
  TileStripeID_2UPEmpty
  TileStripeID_Total
  TileStripeID_UnusedMazePlayers
  TileStripeID_Leader
  TileStripeID_LeadingPlayer1DUPLICATE
  TileStripeID_LeadingPlayer1
  TileStripeID_LeadingPlayer2
  TileStripeID_Tied
  TileStripeID_PauseEmpry
  TileStripeID_Option_MazeSelection_Big
  TileStripeID_Option_MazeSelection_Strange
  TileStripeID_Option_Difficulty_Normal
  TileStripeID_Option_Difficulty_Easy
  TileStripeID_Option_Difficulty_Hard
  TileStripeID_Option_Difficulty_Crazy
  TileStripeID_ActName_TheyMeet
  TileStripeID_ActName_TheChase
  TileStripeID_ActName_Junior
  TileStripeID_ActNameEmpty
  TileStripeID_RemoveClapper
  TileStripeID_CharacterCast_GameTitle
  TileStripeID_CharacterCast_StarringMsPacMan
  TileStripeID_CharacterCast_With
  TileStripeID_CharacterCast_Blinky
  TileStripeID_CharacterCast_Inky
  TileStripeID_CharacterCast_Pinky
  TileStripeID_CharacterCast_Sue
  TileStripeID_CharacterCast_WithEmpty
  TileStripeID_CharacterCast_CharNameEmpty
  TileStripeID_ActName_TheEnd
  TileStripeID_CharacterCast_PacMan
  TileStripeID_Continues
  TileStripeID_CreditsText
  TileStripeID_TengenPresents
.endenum
  
;Sound related shenanigans
.enum
  Sound_GameStartPart1                                      ;square 1
  Sound_DotEaten
  Sound_OptionCursorMove
  Sound_GameStartPart2                                      ;square 2
  Sound_Ghost                                               ;what plays during mazes normally
  Sound_GhostFaster                                         ;few dots remain
  Sound_Death
  Sound_Bounce
  Sound_ExtraLife
  Sound_ItemCollected
  Sound_PowerPellet                                         ;repeating loop that gets higher pitch overtime (until power pellet runs out, it can technically overflow into low pitch, but that shouldn't happen)
  Sound_Act1Part1                                           ;square 1
  Sound_Act1Part2                                           ;square 2
  Sound_Act2Part1
  Sound_Act2Part2
  Sound_Act3Part1
  Sound_Act3Part2
  Sound_GhostEaten ;$11
  Sound_GhostRetreat
  Sound_PlayersCollide
  Sound_OptionChange
  Sound_PacJrAppear1Part1
  Sound_PacJrAppear1Part2
  Sound_Act4Part1
  Sound_Act4Part2
  Sound_PacJrAppear2Part1
  Sound_PacJrAppear2Part2
.endenum

;option stuff
;"Type"
.enum
  Options_Type_1Player
  Options_Type_2PlayerAlternating
  Options_Type_2PlayerCompetitive
  Options_Type_2PlayerCooperative
.endenum

;"Pac Booster"
.enum
  Options_PacBooster_Off
  Options_PacBooster_UseAOrB
  Options_PacBooster_AlwaysOn
.endenum

;"Game Difficulty"
.enum
  Options_GameDifficulty_Normal
  Options_GameDifficulty_Easy
  Options_GameDifficulty_Hard
  Options_GameDifficulty_Crazy
.endenum

;"Maze Selection"
.enum
  Options_MazeSelection_Arcade
  Options_MazeSelection_Mini
  Options_MazeSelection_Big
  Options_MazeSelection_Strange
.endenum

;other stuff
.enum
  CurrentPlayerConfiguration_Player1
  CurrentPlayerConfiguration_Player2
  CurrentPlayerConfiguration_BothPlayers
.endenum