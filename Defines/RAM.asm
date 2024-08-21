;RAM Map

;all entity tables are 16 bytes long for a max of 16 entities (anything that use sprites is an entity)
Entity_ID = $00                                             ;if 0, the slot isn't used
Entity_GFXFrame = $10                                       ;animation stuff
;Entity_MovementType = $20                                  ;actually, this has differing uses for different entities...
Entity_Player_RotationTimer = $20                           ;uesd for death sequence
Entity_Ghost_Character = $30                                ;used exclusively by ghosts, this determines what character this ghost is supposed to be
Entity_Direction = $40                                      ;facing direction. 0 - right, 1 - up, 2 - left, 3 - down

Entity_XPos = $50                                           ;\note that these are relative to the camera. if you want entity's true position, see Entity_CurrentTileSubXPosition and beyond
Entity_YPos = $60                                           ;/these are mainly messed with in the cutscenes

Entity_GFXProperties = $70                                  ;mainly flips

UsedOAMSlotsValue = $80                                     ;keeps track of how many sprite tiles have been drawn
CameraBottomBoundary = $81                                  ;how low the camera can go, depends on the size of the maze

CurrentMazeSize = $82                                       ;0 - mini, 1 - medium, 2 - big

;$83 - ???

FrameCounter = $86                                          ;16-bit
FrameFlag = $88

TEMP_RAM = $89                                              ;10 bytes of temporary RAM for various purposes

RNG_Value = $9B
TileBuffer_Pointer = $9C                                    ;16-bit, indirect access to the buffer
TileBuffer_Pointer2 = $9E                                   ;16-bit, similar to above, mainly used in conjunction with the "sequence" flag to record until which address from the buffer it should apply changes
TileBuffer_SequenceFlag = $A0                               ;if set to 1, the tile buffer will "record" all changes that'll be applied once this flag is set to 0. if it's 0 as-is, the changes will be immediate

Player1Inputs = $A1                                         ;inputs for current frame
Player2Inputs = $A2

Player1Inputs_LastFrame = $A3                               ;inputs from the last frame
Player2Inputs_LastFrame = $A4

Player1Inputs_Press = $A5                                   ;newly pressed inputs (ones that weren't pressed last frame)
Player2Inputs_Press = $A6

Player1DirectionalInput = $A7                               ;only d-pad directions are stored here
Player2DirectionalInput = $A8

PlayersInputs = $A9                                         ;combined inputs for both players. in practice, these aren't used anywhere
PlayersInputs_Press = $AA                                   ;

DemoMovementIndex = $AB                                     ;basically acts as a demo mode flag and movement index, which movement and timing should be used
DemoMovementTiming = $AC                                    ;how long the input is held for

CameraPositionX = $AD                                       ;X-position value of VRAMRenderAreaReg (first write)
;$AE - unused
CameraPositionY = $AF                                       ;Y-position value of VRAMRenderAreaReg (second write)

;This offsets camera position to one of the four screens in the nametable (via Control register). If set, will add +240 to camera Y-position (effectively acting as a high byte)
CameraBasePositionOffset = $B0

CameraPositionY_BeforePause = $B1                           ;this is used to remember where the camera was (so we can move the camera up and down during pause safely)

ControlMirror = $B2                                         ;mirror of ControlBits
RenderMirror = $B3                                          ;mirror of RenderBits

Options_CursorPosition = $B4
Options_MaxOptions = $B5                                    ;ensures that the cursor can wrap around properly
Options_DefaultVRAMPos = $B6                                ;16-bit, cursor's base position from which it moves around and defaults to when it wraps around

LevelBeatenFlag = $B8

Player_WhoDied = $B9                                        ;0 - no one is dead, 1 - player 1 died, 2 - player 2 died.
Player1EntitySlot = $BA                                     ;used during simultaneous play, to remove player 1 (???)
Player2EntitySlot = $BB

CurrentEntitySpeed = $BC                                    ;used to determine the movement speed of any given entity (varies per entity)

FreezeTimer = $BD                                           ;decrements once a frame
GhostScatterTime = $BE                                      ;16-bit, when the timer reaches 0, the ghosts will begin their normal chasing procedure, otherwise they'll target whatever tile they please
;$C0-$C3 - ?

PowerPelletTimer = $C4                                      ;16-bit

;$C6 - unused

CurrentPlayerConfiguration = $C7                            ;0 - player 1 playing, 1 - player 2 playing, 2 - player 1 and 2 are playing simultaneously
ScoreCounterPointer = $C8                                   ;16-bit, used for updating score and displaying it on screen
CurrentMazeLayout = $CA                                     ;

PacJuniorCount = $CB                                        ;how many pac-man juniors can spawn when two players collide with each other in the tunnel

;$CC-$CD - some timer increased by the bouncing item...
;$CE-$CF - X/Y tile position the bouncing item should reach?

Score_CurrentPlayer = $D0                                   ;24-bit. in most cases, this is player 1's score, except for alternating 2P type
;$D3 - but stored to an equally unused $03A3 (2 player alternating)

CurrentPlayerLives = $D4
CurrentLevel = $D5                                          ;usually acts as the current players' level (1 player or simultaneous)
OneUpScoreTargetIndex = $D6                                 ;used for awarding 1-up based on score

BouncingItemState = $D7                                     ;0 - can spawn item 1, 1 - the item has been spawned, 2 - can spawn the second, 3 - the item has been spawned again

Score_HighScore = $0100                                     ;24-bit, for 1 player and 2 player alternating
;$0103 - unused
Score_Player2 = $0104                                       ;24-bit, used for 2 player simultanious types (alternating mode uses Score_CurrentPlayer and OtherPlayerScore)
;$0107 - unused

Player2Lives = $0108                                        ;is this right?
Player2_OneUpScoreTargetIndex = $0109                       ;2P competitive only

Score_RewardedPlayer = $010A                                ;used for adding score for respective player/score counter
Score_Total = $010B                                         ;24-bit, only used for 2 player cooperative, total score of both players
;$010E - unused
SoftResetIndicator = $010F                                  ;8 bytes, when the game is booted up, some specific values are stored to check for a soft reset

TrueFrameCounter = $0117                                    ;8-bit. while the standard FrameCounter has many uses and is altered whenever, this one consistently ticks one per frame (it's also unaffected by lag because it ticks during NMI)
PauseCounter = $0118                                        ;increments each time the pause button is hit, caps at 255, after which you won't be able to pause anymore (mentioned in the manual)
CurrentActCutscene = $0119                                  ;which act cutscene we're playing right now

Act2Cutscene_CharacterAppearancePhase = $011A               ;\used exclusively in act 2 cutscene and nowhere else
Act2Cutscene_CharacterAppearanceTimer = $011B               ;/

Options_OptionMaxChoices = $011C                            ;5 bytes, reserved for each option, used as a way to tell how many choices each option has.

LevelSelect_MaxLevel = $0120                                ;stores the maximum level you can select (if level select cheat is enabled, you can go up to 99)
LevelSelectInputCounter = $0121                             ;used to get the next input required to trigger the level select cheat
ContinuesRemaining = $0122

Options_Type = $0123
Options_PacBooster = $0124
Options_GameDifficulty = $0125
Options_MazeSelection = $0126
Options_StartingLevel = $0127

;these position addresses are used during mazes for true position.
;note that these are within the maze itself
Entity_CurrentTileSubXPosition = $0200                      ;dictates entity's sub position within the 8x8 tile it's currently on, horizontally. every 32 units = 1 pixel
Entity_CurrentTileXPosition = $0210                         ;used to determine which tile on the x-axis the entity is aligning with
Entity_CurrentTileSubYPosition = $0220                      ;dictates entity's sub position within the 8x8 tile it's currently on, vertically. every 32 units = 1 pixel
Entity_CurrentTileYPosition = $0230                         ;used to determine which tile on the y-axis the entity is aligning with

Entity_DrawingPriority = $0240                              ;determines the order in which entity sprite tiles are drawn, entities with higher values take lower OAM slots and lower priority ones take later ones. Set to 0 when graphic flickering enabled, in which case frame counter decides the order of OAM tiles (to create flicker).

Entity_XSpeed = $0250
Entity_YSpeed = $0260
Entity_PlayerCharacter = $0270                              ;for players determines which player is which character (0 - ms. pac-man, 1 - pac-man). for other entities, determines which character interacted with it if it has collision detection (same values)
;$0280 - for players, decides if the player is sad (set to FF). also set to $01 occasionally, idk what that's for)
;for ghost eyes, this is used as a counter for breaking out of endlessly looping by setting its target location to something random
Entity_TargetTileXPosition = $0290                          ;used to tell some entities like ghosts where it should attempt to reach horizontally
Entity_TargetTileYPosition = $02A0                          ;used to tell some entities like ghosts where it should attempt to reach vertically
Entity_PlayerPacBoosterState = $02B0                        ;exclusive to player entities, determies if the pac-booster is toggled on or off for current player entity (0 - off, FF - on)

;contains all background and sprite palettes that are uploaded to PPU at run time. Can be used to modify palettes on the fly (e.g. ghost palettes after consuming a power pellet)
PaletteStorage = $02C0

MazeLayoutMirrorBuffer = $02E0                              ;14 bytes, used for drawing the right side of the maze, which is mirrored (hold one line at a time)
EatenDotStateBits = $02EE                                   ;148 bytes, reserved to indicate which spaces have dots and which don't have dots (so that ms. pac-man can eat them), in bitwise format, so one byte corresponds to 8 dots
                                                            ;since each line of maze is 28 tiles wide, 4 bytes are used for each

CurrentDotsRemaining = $0383                                ;16-bit, both big and small

;$0385-$0386 - something tile related
PowerPelletsRemaining = $0387
PowerPelletsVRAMPosLow = $0388                              ;6 bytes each (for a max of 6 big dots). if FF, the pellet has been consumed
PowerPelletsVRAMPosHigh = $038E
PowerPelletsTileXPos = $0394                                ;which tile it's on horizontally
PowerPelletsTileYPos = $039A                                ;which tile its on vertically (within the maze)

;these variables are used for switching between players in 2P alternating mode
OtherPlayerScore = $03A0                                    ;stores score for the other player while Score_CurrentPlayer has current player's score (2P alternating only)
;$03A3 - same as $D3, technically unused
OtherPlayerLives = $03A4
OtherPlayerLevel = $03A5
OtherPlayerOneUpScoreTargetIndex = $03A6
OtherPlayerBouncingItemCount = $03A7

OtherPlayerDotStateBits = $03A8

MazeSolidTileBits = $045A                                   ;148 bytes, reserved to indicate which tiles can be traversed through and which tiles are impassable. just like with EatenDotStateBits, each row reserves 4 bytes

;$04EF-$04F6 - unused

Player1ReverseControlFlag = $04F7
Player2ReverseControlFlag = $04F8

;$04F9 - unused
LastOAMByteToUpdate = $04FA                                 ;holds the target value of OAM byte writes to perform (tile*4)
;$04FB and $04FC - ???

EatenGhostCombo = $04FD                                     ;increases for every ghost eaten during power pellet timer, zeroes out when power pellet timer ends/a new power pellet is consumed.
EntityVisualYOffset = $04FE                                 ;used for e.g. bouncing item to simulate bouncing movement by offsetting its y-position

;these store to respective channel registers (e.g. $4000-$4003 for square 1)
;each address is 6 bytes long, meaning 6 sound slots. Various sound effects are assigned to specific slots.
Sound_ChannelVariable1 = $04FF
Sound_ChannelVariable2 = $0505
Sound_ChannelVariable3 = $050B
Sound_ChannelVariable4 = $0511
Sound_NoteLength = $0517                                    ;how long the note will be held for
Sound_DataPointerLow = $051D
Sound_DataPointerHigh = $0523
Sound_CurrentNoteParameters = $0529                         ;first 5 bits determine the sound's frequency, last 3 bits determine the note's length (via a special table)
Sound_AssignedChannel = $052F                               ;which channel is used by this sound slot?
Sound_ChannelEnabledFlag = $0535                            ;see if respective channel is playing some kind of sound
Sound_PriorityLevel = $053B                                 ;Indicates the priority value of the sound that's being played, the higher it is, the more important it is

;$541-$5FF - unused

TileBuffer = $0600                                          ;255 bytes of buffer, the game keeps looping through it contineously

;OAM base ram addresses
;generally at $0200, but in this game it's at $0700-$07FF
OAM_Y = $0700
OAM_Tile = $0701
OAM_Prop = $0702
OAM_X = $0703

;the OAM is dynamic and there's no hardcoded uses for it