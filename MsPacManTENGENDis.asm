;Ms. Pac-Man (NES) by Tengen
;Disassembly by RussianManSMWC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.include "Defines/RAM.asm"                                  ;load all defines for RAM addresses
.include "Defines/Registers.asm"                            ;hardware registers
.include "Defines/Constants.asm"                            ;constants
.include "Defines/Enums.asm"                                ;more constants
.include "Macros.asm"                                       ;useful macros

.segment "HEADER"
.include "iNES_Header.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.segment "TILES"
.incbin "MsPacManGFX.bin"                                   ;graphics

.segment "CODE"
.include "CharacterSet.asm"
.feature force_range                                        ;allows -$xx expressions (for negative values)

InitTengenPresentsScreen_8000:
JSR CheckSoftReset_FD91                                     ;check if we have specific valeus set indicating a soft reset
JSR InitRAMAndRegs_FF77                                     ;
JSR ResetBufferVariables_9AC1                               ;the routine below the below one also does this...
JSR RemoveAllEntities_89DC                                  ;the routine below this one also does this, so it's kind of pointless
JSR DefaultVisuals_F91D                                     ;initialize all sorts of variables related to screen shenanigans

LDA #$10                                                    ;load attributes
STA $8B                                                     ;
JSR SetPPUAttributesForSpecialscreen_FB34                   ;prepare attributes for tengen presents screen

JSR StoreToControlAndRenderRegs_9A70                        ;enable NMI, I think

LDA #$04                                                    ;yep, the "maze layout" is used for palette (this is temporary, naturally)
STA CurrentMazeLayout                                       ;
JSR LoadDefaultPalettes_88D1                                ;

LDA #$28                                                    ;yellow color (MS. PAC-MAN title)
STA PaletteStorage+(Palette_Background0 + 1)                ;

LDA #$25                                                    ;pink color (copyright text at the bottom)
STA PaletteStorage+(Palette_Background3 + 3)                ;

LDA #TileStripeID_TengenPresents                            ;draw the flashing "TENGEN PRESENTS" string
JSR DrawTileStripes_9B80                                    ;

LDA #$00                                                    ;reset frame counter
STA FrameCounter                                            ;

LDA #$20                                                    ;default camera Y-pos
STA CameraPositionY                                         ;

LDA #$01                                                    ;high byte
STA CameraBasePositionOffset                                ;

LOOP_803B:
LDA HardwareStatus                                          ;wait a frame...
BPL LOOP_803B                                               ;

LOOP_8040:
LDA HardwareStatus                                          ;wait a frame...
BPL LOOP_8040                                               ;

JSR EnableRender_9A41                                       ;show visuals

;TENGEN PRESENTS screen (game boot)
ExecuteTengenPresentsScreen_8048:
JSR WaitAFrame_FFAC                                         ;sync
JSR HandleEntities_8A8C                                     ;
JSR HandleEntityGraphics_8A12                               ;
JSR AnimateTengenPresentsAndPressStartText_F5D9             ;animate text with pretty colors

LDA CameraPositionY                                         ;check if the text is high enough
CMP #$C0                                                    ;
BCS CODE_805F                                               ;
CLC                                                         ;move the camera to give an illusion of moving text
ADC #$04                                                    ;
STA CameraPositionY                                         ;

CODE_805F:
LDA FrameCounter                                            ;check the frame counter
CMP #176                                                    ;
BCC CODE_806C                                               ;if 176 frames haven't passed, nothing happens

LDA CameraPositionY                                         ;move the text away
SEC                                                         ;
SBC #$10                                                    ;this will overpower the addition we did before
STA CameraPositionY                                         ;move camera up -> text scrolls down

CODE_806C:
LDA FrameCounter                                            ;Blinky will appear at a certain time
CMP #96                                                     ;at 96th frame
BNE CODE_808B                                               ;

LDA #Entity_ID_CutsceneGhost                                ;spawn a Cutscene Ghost
JSR SpawnEntity_8A61                                        ;

LDA #$F8                                                    ;init x-pos
STA Entity_XPos,X                                           ;

LDA #$B0                                                    ;init y-pos
STA Entity_YPos,X                                           ;

LDA #$05                                                    ;movement type? (really fast horizontal movement)
STA $20,X                                                   ;

LDA #Entity_Ghost_Character_Blinky                          ;blinky
STA Entity_Ghost_Character,X                                ;

LDA #Entity_Direction_Left                                  ;movement direction = left
STA Entity_Direction,X                                      ;

CODE_808B:
LDA FrameCounter                                            ;
CMP #188                                                    ;transition at 188th frame
BCC ExecuteTengenPresentsScreen_8048                        ;

LDA #$04                                                    ;
STA ContinuesRemaining                                      ;default amount of continues

JSR InitOptions_F544                                        ;

SoftReset_8099:
LDX #$FF                                                    ;
TXS                                                         ;
JSR CheckSoftReset_FD91                                     ;yes, there's apparently a check for soft reset during a soft reset
JSR InitRAMAndRegs_FF77                                     ;

GoToTitleScreen_80A2:
LDX #$FF                                                    ;stack stuff again (unless you get here from somewhere else)
TXS                                                         ;
JSR InitTitleScreenAndCredits_80AB                          ;
JMP LoadTitleScreen_F626                                    ;

;specifically for title screen and credits
InitTitleScreenAndCredits_80AB:
JSR DisableRender_9A4B                                      ;disable render for real...
JSR DisableNMI_9A55                                         ;don't generate NMI for now

LDA #$00                                                    ;
STA Options_CursorPosition                                  ;
STA CameraPositionY                                         ;
STA CameraBasePositionOffset                                ;
STA CurrentLevel                                            ;
STA DemoMovementIndex                                       ;

LDA DemoMovementData_A25B+1                                 ;??? (can be replaced with a constant)
STA DemoMovementTiming                                      ;

JSR ResetBufferVariables_9AC1                               ;
JSR RemoveAllEntities_89DC                                  ;
JSR StoreToControlAndRenderRegs_9A70                        ;
RTS                                                         ;

;LoadGameplay_80CC:
CODE_80CC:
JSR InitializeGameplayVariables_86B1
JSR CODE_86F1
JSR CODE_868C
JSR InitializeGameplayVariables_86B1                        ;twice???

CODE_80D8:
JSR CODE_86F1
JSR CODE_E4F3

CODE_80DE:
LDA DemoMovementIndex
BNE CODE_80F9

LDA CurrentPlayerConfiguration                              ;check if not player 1
BNE CODE_80EB

LDA #TileStripeID_MazePlayer1                               ;will display player 1 string
CLV                                                         ;yeah, this game frequently uses this CLV : BVC setup as an unconditional branch
BVC CODE_80F6                                               ;I don't see any benefits of using this, it's slower than using a JMP by 1 cycle. Toobin' for NES also uses these, Krazy Kreatures does not.

CODE_80EB:
CMP #CurrentPlayerConfiguration_Player2                     ;check if player 2 is playing
BNE CODE_80F4                                               ;

LDA #TileStripeID_MazePlayer2                               ;display player 2 string
CLV
BVC CODE_80F6

CODE_80F4:
LDA #TileStripeID_MazePlayers                               ;display players string because there are two of them

CODE_80F6:
JSR DrawTileStripes_9B80                                    ;

CODE_80F9:
JSR RemoveAllEntities_89DC                                  ;
JSR LoadPlayers_8557                                        ;load player entities

LDA DemoMovementIndex                                       ;if in demo...
BNE CODE_8106                                               ;do not show ready string

JSR SpawnReadyStringEntity_9677                             ;spawn READY!

CODE_8106:
JSR DisableSounds_F3A3                                      ;

LDA Score_CurrentPlayer                                     ;check if player has any score
ORA Score_CurrentPlayer+1                                   ;
ORA Score_CurrentPlayer+2                                   ;
BNE CODE_811B                                               ;if so, they haven't started the game, they're onto the next stage. don't play game start sound

LDA #Sound_GameStartPart1                                   ;level start sound byte
JSR PlaySound_F2FF                                          ;

LDA #Sound_GameStartPart2                                   ;second part of it on a different channel
JSR PlaySound_F2FF                                          ;

CODE_811B:
LDA #$00                                                    ;
STA Player_WhoDied                                          ;no one's dead
STA PowerPelletTimer                                        ;no one's powered-up
STA PowerPelletTimer+1                                      ;

LDA #$40
STA FreezeTimer                                             ;wait for 40 frames to pass

CODE_8127:
JSR WaitAFrame_FFAC
JSR HandleControllerInputs_A10A
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12
JSR HandleGameplayTileAnimations_94EB

LDA FreezeTimer                                             ;check if reached 1
CMP #$01
BNE CODE_8127

LDA #$00                                                    ;
STA Player_WhoDied                                          ;still umm achsually no one's dead.
STA PowerPelletTimer                                        ;
STA PowerPelletTimer+1                                      ;
STA FrameCounter                                            ;
STA FrameCounter+1                                          ;
STA GhostScatterTimer

LDA #$02                                                    ;scatter for 512 frames
STA GhostScatterTimer+1                                      ;(approximately 8.5 seconds)

LDA #TileStripeID_MazePlayerXEmpty                          ;remove player-related string within the maze
JSR DrawTileStripes_9B80                                    ;

JSR PlaceGhostsInMaze_85F6                                  ;spooky ghosts appear!

LDA CameraBottomBoundary                                    ;
SBC CameraPositionY                                         ;the taller the level is, the longer this timer will be
ADC #$40                                                    ;
STA FreezeTimer                                             ;

JSR CODE_83B8

CODE_8161:
JSR WaitAFrame_FFAC                                         ;
JSR HandleControllerInputs_A10A                             ;
JSR HandleCameraScrolling_8459                              ;
JSR HandleEntities_8A8C                                     ;
JSR HandleEntityGraphics_8A12                               ;
JSR HandleGameplayTileAnimations_94EB                       ;

LDA FreezeTimer                                             ;check if the timer is almost over
CMP #$01                                                    ;
BNE CODE_8161                                               ;

LDA #Entity_ID_READYString                                  ;remove ready string in case it was spawned
JSR RemoveCertainEntities_827C                              ;

LDA DemoMovementIndex                                       ;initialize game over string, maybe
BEQ CODE_8187                                               ;

LDA #TileStripeID_GameOver                                  ;GAME OVER during demo
JSR DrawTileStripes_9B80                                    ;

CODE_8187:
LDA #$00                                                    ;initialize level beaten flag and ghost combo
STA LevelBeatenFlag                                         ;
STA EatenGhostCombo                                         ;

LOOP_818E:
JSR WaitAFrame_FFAC
JSR HandleControllerInputs_A10A
JSR HandleCameraScrolling_8459
JSR CODE_8499

LDA $04FB
STA $04FC

LDA #$00
STA $04FB

JSR HandleBouncingItemSpawn_93A7
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12
JSR HandleGameplayTileAnimations_94EB
JSR CODE_9605
JSR HandleGhostScatterTimerAndTimedTurning_9310             ;tick down scatter mode timer and make ghosts turn around at certain points
JSR CheckRemainingDots_8519                                 ;check if the level should count as beaten when all dots are gobbled

LDA LevelSelectInputCounter                                 ;check if entered the full level skip code
CMP #$1E                                                    ;
BNE CODE_81CB                                               ;

LDA Player1Inputs_Press                                     ;pressing select will mark the level as beaten
AND #Input_Select                                           ;
BEQ CODE_81CB                                               ;

LDA #$01                                                    ;level beaten flag?
STA LevelBeatenFlag                                         ;beat it!

CODE_81CB:
LDA LevelBeatenFlag                                         ;see if the level is beaten
BEQ CODE_81D2

JMP InitVictorySequenceDelay_81DC                           ;level complete

CODE_81D2:
LDA Player_WhoDied                                          ;check if anyone died
BEQ CODE_81D9

JMP InitDeathDelay_82A5

CODE_81D9:
SEC
BCS LOOP_818E

InitVictorySequenceDelay_81DC:
LDA #$80                                                    ;FREEZE!
STA FreezeTimer

HandleVictorySequenceDelay_81E0:
JSR WaitAFrame_FFAC
JSR HandleCameraScrolling_8459
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA FreezeTimer
CMP #$01
BNE HandleVictorySequenceDelay_81E0

JSR DisableSounds_F3A3                                      ;no more sounds

JSR RemoveNonPlayerEntities_825C                            ;only player(s) remain

LDA #$00
STA FrameCounter

LDA #$C8
STA FreezeTimer

CODE_8200:
JSR WaitAFrame_FFAC
JSR ScrollCameraToTheTop_844E
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12
JSR BlinkStageColors_8926                                   ;blink stage colors

LDA FreezeTimer
CMP #$01
BNE CODE_8200

JSR ResetBufferVariables_9AC1
JSR RemoveAllEntities_89DC
JSR MaybePlayActCutscene_EB47

LDA CurrentLevel                                            ;
CMP #31                                                     ;check if beat level 32
BNE CODE_8244                                               ;

LDA #$FF                                                    ;this player has technically game overed, since they beat it.
STA CurrentPlayerLives                                      ;

LDA Options_Type                                            ;check if in 2 player alternating mode
CMP #Options_Type_2PlayerAlternating                        ;
BNE CODE_8237                                               ;straight up return to the title screen

LDA OtherPlayerLives                                        ;check if player 2 has cleared level 32
BMI CODE_8237                                               ;if so, both players are winners
JMP CODE_836F                                               ;player 1 finished the game, turn for the player 2

CODE_8237:
LDA #$04                                                    ;reset continues to max
STA ContinuesRemaining                                      ;

LDA #$06                                                    ;set starting level to 7 for some reason
STA Options_StartingLevel                                   ;
JMP CODE_8741

CODE_8244:
INC CurrentLevel                                            ;move onto the next level
JMP CODE_80D8

;Unused code that would display "LEVEL XX" string, where XX is current level value. Given it's printing location, it was supposed to be used in mazes.
;Possibly an early implementation of the level counter display, which was relegated to the HUD.
;It's worth noting that there's no code to call the also unused EmptyLevelXXString, which suggests that this idea was abandoned half-way through.
DrawCurrentLevelNumber_8249:
UNUSED_8249:
LDA #TileStripeID_UnusedLevelXX                             ;
JSR DrawTileStripes_9B80                                    ;draw string

Macro_SetWord $2332, $8F

LDA CurrentLevel                                            ;draw current level number
JSR DisplayLevelNumber_F800                                 ;
RTS                                                         ;

;remove all entities except the player (beat level)
RemoveNonPlayerEntities_825C:
LDX #$0F                                                    ;

LOOP_825E:
LDA Entity_ID,x                                             ;check if player
CMP #Entity_ID_Player                                       ;
BEQ CODE_8268                                               ;

LDA #Entity_ID_None                                         ;otherwise remove
STA Entity_ID,x                                             ;

CODE_8268:
DEX                                                         ;
BPL LOOP_825E                                               ;
RTS                                                         ;

;Input A - entity slot that should remain, others will be cleared
RemoveEntityExceptSlot_826C:
STA $89                                                     ;

LDX #$0F                                                    ;

LOOP_8270:
CPX $89                                                     ;
BEQ CODE_8278                                               ;

LDA #Entity_ID_None                                         ;
STA Entity_ID,x                                             ;

CODE_8278:
DEX                                                         ;
BPL LOOP_8270                                               ;
RTS                                                         ;

;Input A - entity ID, entities that match it will be removed
RemoveCertainEntities_827C:
STA $89                                                     ;

LDX #$0F                                                    ;

LOOP_8280:
LDA Entity_ID,x                                             ;
CMP $89                                                     ;
BNE CODE_828A                                               ;

LDA #Entity_ID_None                                         ;sorry, nothing
STA Entity_ID,x                                             ;

CODE_828A:
DEX                                                         ;
BPL LOOP_8280                                               ;
RTS                                                         ;

;normally unused code, check if specific entity exists
;input A - entity ID to search for
;output A and $89 - if FF, entity exists, if 00, entity doesn't exist. X is entity's slot in case it exists.
CheckEntityPresence_828E:
UNUSED_828E:
STA $89                                                     ;

LDX #$0F                                                    ;

LOOP_8292:
LDA Entity_ID,x                                             ;does this entity match with what we're looking for?
CMP $89                                                     ;
BNE CODE_829D                                               ;

LDA #$FF                                                    ;entity exists
STA $89                                                     ;
RTS                                                         ;

CODE_829D:
DEX                                                         ;
BPL LOOP_8292                                               ;

LDA #$00                                                    ;entity does not exist
STA $89                                                     ;
RTS                                                         ;insert joke here

InitDeathDelay_82A5:
LDA #$A0                                                    ;
STA FrameCounter                                            ;

HandleDeathDelay_82A9:
JSR WaitAFrame_FFAC
JSR HandleGameplayTileAnimations_94EB
JSR HandleEntityGraphics_8A12

LDA FrameCounter                                            ;wait for a while
BNE HandleDeathDelay_82A9                                   ;

LDA Player_WhoDied                                          ;checks who dieds
CMP #$01                                                    ;
BNE CODE_82C1                                               ;

LDA Player1EntitySlot                                       ;player 1
CLV                                                         ;
BVC CODE_82C3                                               ;

CODE_82C1:
LDA Player2EntitySlot                                       ;no, wait, it's player 2!

CODE_82C3:
JSR RemoveEntityExceptSlot_826C                             ;either player 1 or 2 only remain
JSR DisableCurrentBouncingItem_83A8

LDA #128                                                    ;rotate in place. "dramatically swoons and falls" as the original arcade puts it
LDY Player1EntitySlot                                       ;
BMI CODE_82D2                                               ;if player 1 does not exist, don't dramatically swoon and falls.
STA $0020,Y                                                 ;

CODE_82D2:
LDY Player2EntitySlot                                       ;check if player 2 is knocked out of comission
BMI CODE_82D9                                               ;
STA $0020,Y                                                 ;

CODE_82D9:
JSR DisableSounds_F3A3                                      ;a moment of silence for the falling (ms.) pac-man

LDA #Sound_Death                                            ;tun, dun, dudun, dun, dudun, dudun, duduuuuuuuuuuun!
JSR PlaySound_F2FF                                          ;

LDA #129                                                    ;play animation for 256-129 = 127 frames
STA FrameCounter                                            ;

HandleDeathAnimation_82E5:
JSR WaitAFrame_FFAC
JSR HandleCameraScrolling_8459
JSR HandleGameplayTileAnimations_94EB
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA FrameCounter                                            ;
BNE HandleDeathAnimation_82E5                               ;

LDA Player_WhoDied
CMP #$01                                                    ;again, check who dead
BNE CODE_8303                                               ;played 2 died?

DEC CurrentPlayerLives                                      ;-1 of player whatever's precious lives (most likely player 1)
CLV                                                         ;
BVC CODE_8306                                               ;

CODE_8303:
DEC Player2Lives                                            ;-1 of player 2's precious lives

CODE_8306:
BPL CODE_8356                                               ;

LDA Options_Type                                            ;check for Options_Type_1Player
BNE CODE_8310
JMP CODE_8710

CODE_8310:
CMP #Options_Type_2PlayerAlternating                        ;if alternating, maybe change players
BNE CODE_8333

LDA OtherPlayerLives                                        ;check if BOTH player 1 and 2 gameovered
BPL CODE_831F                                               ;
JMP CODE_8710                                               ;rest in peace, you'll be missed... or not, depends.

;unused
CLV                                                         ;
BVC CODE_8330                                               ;

CODE_831F:
LDA CurrentPlayerConfiguration                              ;check if player 1 is playing
BNE CODE_8328                                               ;

LDA #TileStripeID_MazePlayer1                               ;
CLV                                                         ;
BVC CODE_832A                                               ;

CODE_8328:
LDA #TileStripeID_MazePlayer2                               ;

CODE_832A:
JSR DrawTileStripes_9B80                                    ;Player...
JSR SpawnGameOverStringEntity_9671                          ;game over

CODE_8330:
JMP CODE_8356

CODE_8333:
LDA CurrentPlayerLives                                      ;see if both players have lives?
AND Player2Lives                                            ;
BPL CODE_833D                                               ;

JMP CODE_8710                                               ;GAME OVER, YEAAAAAAAAAAAAH! wait, wrong game

CODE_833D:
LDA CurrentPlayerLives
BPL CODE_834A

LDA #$01                                                    ;player 2 only
STA CurrentPlayerConfiguration

LDA #TileStripeID_MazePlayer1                               ;"PLAYER 1" STRING
CLV
BVC CODE_8350

CODE_834A:
LDA #$00                                                    ;player 1 only
STA CurrentPlayerConfiguration

LDA #TileStripeID_MazePlayer2                               ;"player 2" string

CODE_8350:
JSR DrawTileStripes_9B80
JSR CODE_8757

CODE_8356:
LDX Player2EntitySlot
BMI CODE_8361

JSR RemoveEntity_8A5C

LDA #$FF
STA Player2EntitySlot

CODE_8361:
LDX Player1EntitySlot
BMI CODE_836C

JSR RemoveEntity_8A5C

LDA #$FF
STA Player1EntitySlot

CODE_836C:
JSR CODE_83CE

CODE_836F:
LDA Options_Type
CMP #Options_Type_2PlayerAlternating
BNE CODE_838F

LDA OtherPlayerLives                                        ;see if either game overed?
BMI CODE_838F

LDA CurrentPlayerConfiguration                              ;switch from player 1 to player 2 and vice versa
EOR #$01                                                    ;
STA CurrentPlayerConfiguration                              ;

JSR CODE_868C

LDA #Entity_ID_GAME_OVERString
JSR RemoveCertainEntities_827C
JSR CODE_E4F3
JSR CODE_83CE

CODE_838F:
LDA DemoMovementIndex                                       ;demo?
BEQ CODE_839C                                               ;

LDX #$FF
TXS
JSR InitTitleScreenAndCredits_80AB
JMP InitCreditsScreen_F5FB                                  ;

;load demo I guess.
CODE_839C:
JSR CODE_841E
JSR RemoveAllEntities_89DC
JSR LoadPlayers_8557                                        ;place players
JMP CODE_80DE

;this is used to disable the currently spawned bouncing item if it wasn't picked up - it won't spawn again.
DisableCurrentBouncingItem_83A8:
LDA BouncingItemState                                       ;
CMP #$01                                                    ;check if the bouncing item was already on-screen
BNE CODE_83B1                                               ;

INC BouncingItemState                                       ;can spawn the next item
RTS                                                         ;

CODE_83B1:
CMP #$03                                                    ;check if the second bouncing item was already on-screen
BNE RETURN_83B7                                             ;

INC BouncingItemState                                       ;cannot spawn any more

RETURN_83B7:
RTS                                                         ;

CODE_83B8:
LDA Score_CurrentPlayer                                     ;check if the player has any score
ORA Score_CurrentPlayer+1                                   ;
ORA Score_CurrentPlayer+2                                   ;
BNE RETURN_83CD                                             ;

LDA DemoMovementIndex                                       ;check demo mode
BNE CODE_83C9

LDA #$C0
CLV
BVC CODE_83CB

;freeze for shorter amount of time?
CODE_83C9:
LDA #$80

CODE_83CB:
STA FreezeTimer

RETURN_83CD:
RTS

CODE_83CE:
LDA CameraPositionY
SBC #$18
ADC #$40
STA FreezeTimer

JSR CODE_83B8

LDA #$01
STA $C0

CODE_83DD:
JSR WaitAFrame_FFAC
JSR ScrollCameraToTheTop_844E
JSR HandleGameplayTileAnimations_94EB
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA FreezeTimer
CMP #$01
BNE CODE_83DD
RTS

;LoadGameOver_83F3:
CODE_83F3:
LDA #$00                                                    ;reset frame counter
STA FrameCounter+1                                          ;
STA FrameCounter                                            ;

LDA #$01                                                    ;some variable idk
STA $C0

HandleGameOver_83FD:
LOOP_83FD:
JSR WaitAFrame_FFAC                                         ;
JSR HandleControllerInputs_A10A                             ;
JSR ScrollCameraToTheTop_844E                               ;camera goes up
JSR HandleGameplayTileAnimations_94EB                       ;
JSR HandleEntities_8A8C                                     ;
JSR HandleEntityGraphics_8A12                               ;

LDA FrameCounter+1                                          ;wait until frame counter reaches at least 512 frames
CMP #$02                                                    ;
BCC CODE_8416                                               ;
RTS                                                         ;

CODE_8416:
JSR GetPlayersPressInputs_8488                              ;
AND #Input_Start                                            ;
BEQ LOOP_83FD                                               ;or wait until player presses pause
RTS                                                         ;quit game over state

CODE_841E:
LDA CameraBottomBoundary
SBC CameraPositionY
ADC #$40
STA FreezeTimer

JSR CODE_83B8

LDA #$01
STA $C0

CODE_842D:
JSR WaitAFrame_FFAC
JSR ScrollCameraToTheBottom_8443
JSR HandleGameplayTileAnimations_94EB
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA FreezeTimer
CMP #$01
BNE CODE_842D
RTS

;This code will move the camera to the bottom of the maze
ScrollCameraToTheBottom_8443:
LDA CameraPositionY                                         ;
CMP CameraBottomBoundary                                    ;check if reached the bottom boundary of this maze
BCS CODE_844B                                               ;
ADC #$01                                                    ;scroll down

CODE_844B:
STA CameraPositionY                                         ;
RTS                                                         ;

;this code will move the camera to the very top of the maze (when dying or winning)
ScrollCameraToTheTop_844E:
LDA CameraPositionY                                         ;check if reached the top
CMP #$18                                                    ;
BCC CODE_8456                                               ;
SBC #$01                                                    ;scroll up

CODE_8456:
STA CameraPositionY                                         ;
RTS                                                         ;

;something to with the players and screen position...
;I think it's suppoesd to keep the camera "balanced" around two players, depending on their distance
HandleCameraScrolling_8459:
LDX Player1EntitySlot                                       ;is player 1 not real and can't hurt you?
BMI CODE_846A                                               ;

LDA Entity_YPos,X                                           ;
LDX Player2EntitySlot                                       ;check if player 2 is present
BMI CODE_8467                                               ;if not, will position the camera relative to player 1
CLC                                                         ;
ADC Entity_YPos,X                                           ;distance between first player and second player's y posisiotns
ROR A                                                       ;multiply by two

CODE_8467:
CLV                                                         ;
BVC CODE_8475                                               ;

CODE_846A:
LDX Player2EntitySlot                                       ;player 2, do they exist?
BMI CODE_8473                                               ;

LDA Entity_YPos,X                                           ;position camera relative to player 2's position
CLV                                                         ;
BVC CODE_8475                                               ;

CODE_8473:
LDA #$80                                                    ;default camera position (does not scroll anywhere)

CODE_8475:
STA $91                                                     ;if the player('s distance) is 144 pixels or below the top of the screen
CMP #$90
BCC CODE_847E

JSR ScrollCameraToTheBottom_8443                            ;play catch up

CODE_847E:
LDA $91                                                     ;112 pixels or above
CMP #$70                                                    ;
BCS RETURN_8487                                             ;

JSR ScrollCameraToTheTop_844E                               ;camera will scroll up

RETURN_8487:
RTS                                                         ;

;this routine is used to get player or both players' inputs, depending on current player configuration (player 1, player 2 or both)
GetPlayersPressInputs_8488:
LDA Player1Inputs_Press
LDX CurrentPlayerConfiguration                              ;check if player 1
BEQ RETURN_8498                                             ;player 1 only presses
DEX                                                         ;player 2?
BEQ CODE_8496                                               ;will take player 2 only presses

ORA Player2Inputs_Press                                     ;both player 1 and 2 presses count

CLV                                                         ;
BVC RETURN_8498                                             ;can be replaced with RTS

CODE_8496:
LDA Player2Inputs_Press                                     ;player 2 only presses

RETURN_8498:
RTS                                                         ;

;HandlePauseFunctions_8499:
CODE_8499:
JSR GetPlayersPressInputs_8488                              ;
AND #Input_Start                                            ;check if player 1 or two (or either) pressed start
BEQ RETURN_850B                                             ;no

LDA DemoMovementIndex                                       ;see if we're in demo mode
BEQ CODE_84A7                                               ;handle pausing
JMP GoToTitleScreen_80A2                                    ;return to title screen then

CODE_84A7:
LDA PauseCounter                                            ;if pause counter equals 255
CMP #$FF                                                    ;
BNE CODE_84AF                                               ;
RTS                                                         ;can't pause anymore

CODE_84AF:
INC PauseCounter                                            ;you can use the pause button one less time

LDA #TileStripeID_Pause                                     ;display pause text
JSR DrawTileStripes_9B80                                    ;

LDA CameraPositionY                                         ;remember where the camera was
STA CameraPositionY_BeforePause                             ;

JSR DisableSounds_F3A3                                      ;clear all sound byte slots, effectively muting everything

ExecutePausedState_84BE:
JSR WaitForNMI_FFB6                                         ;
JSR HandleControllerInputs_A10A                             ;
JSR HandleGameplayTileAnimations_94EB                       ;animate everything there is in the maze itself
JSR HandleLevelSelectCheatTrigger_8784                      ;can try out the super secret cheat code
JSR HandleControlReversalCombos_87A3                        ;can try out the not-so-super-secret not-so-cheat code

LDA CameraPositionY_BeforePause                             ;default camera to this position
STA CameraPositionY                                         ;

JSR GetCurrentPlayerInput_E1AB                              ;
PHA                                                         ;
AND #Input_Up                                               ;check if the player holds up
BEQ CODE_84DD                                               ;

LDA #$18                                                    ;place camera at the top
STA CameraPositionY                                         ;

CODE_84DD:
PLA                                                         ;
AND #Input_Down                                             ;check if player holds down
BEQ CODE_84E6                                               ;

LDA CameraBottomBoundary                                    ;place camera at the bottom
STA CameraPositionY                                         ;

CODE_84E6:
JSR GetCurrentPlayerInputPress_E1C4                         ;
AND #Input_Select                                           ;check if player presses select
BEQ CODE_84F2                                               ;

LDA #TileStripeID_PauseEmpry                                ;remove "PAUSE" string
JSR DrawTileStripes_9B80                                    ;

CODE_84F2:
JSR CODE_850C
JSR HandleEntityGraphics_8A12                               ;

JSR GetPlayersPressInputs_8488                              ;check if the player presses start
AND #Input_Start                                            ;
BEQ ExecutePausedState_84BE                                 ;if not, continue being paused

LDA #TileStripeID_PauseEmpry                                ;remove "PAUSE" string for sure
JSR DrawTileStripes_9B80                                    ;

LDA CameraPositionY_BeforePause                             ;restore camera
STA CameraPositionY                                         ;

JSR CODE_850C

RETURN_850B:
RTS


CODE_850C:
LDX #$0F

LOOP_850E:
LDA Entity_ID,x
BEQ CODE_8515

JSR HandleEntityVisualPosition_A383

CODE_8515:
DEX
BPL LOOP_850E
RTS

CheckRemainingDots_8519:
LDA CurrentDotsRemaining                                    ;check if dots are remaining to be collected
BNE RETURN_8528                                             ;

LDA CurrentDotsRemaining+1                                  ;
BNE RETURN_8528                                             ;

LDA #$01                                                    ;
STA LevelBeatenFlag                                         ;level beaten!
RTS                                                         ;

RETURN_8528:
RTS                                                         ;

;a little easter egg, hinted at in the manual
MaybeSpawnPacJunior_8529:
LDA CurrentLevel                                            ;check if in level 10 or above
CMP #9                                                      ;
BMI RETURN_8556                                             ;

LDA PacJuniorCount                                          ;did we spawn all juniors?
BMI RETURN_8556                                             ;

LDA #Entity_ID_PacJunior                                    ;
JSR SpawnEntity_8A61                                        ;
BMI RETURN_8556                                             ;can't spawn if all slots are filled

DEC PacJuniorCount                                          ;can spawn one less junior

LDA #$00                                                    ;
STA Entity_CurrentTileSubXPosition,X                        ;

LDA #$10                                                    ;appears where the ghost gate is
STA Entity_CurrentTileXPosition,X                           ;

LDA #$80                                                    ;
STA Entity_CurrentTileSubYPosition,X                        ;

LDA #$0B                                                    ;
STA Entity_CurrentTileYPosition,X                           ;

JSR HandleEntityVisualPosition_A383                         ;
JSR PlayJuniorSpawnSFX_EF01                                 ;ding!

RETURN_8556:
RTS

LoadPlayers_8557:
LDA #$FF                                                    ;init slots
STA Player1EntitySlot                                       ;
STA Player2EntitySlot                                       ;

LDA Options_Type                                            ;check if in two players at the same time type of game
CMP #Options_Type_2PlayerCompetitive                        ;
BCS CODE_8588

LDA #Entity_ID_Player                                       ;spawn a player charaacter
JSR SpawnEntity_8A61                                        ;
BMI CODE_8582                                               ;imagine failing to spawn the player character, right?

LDA #$00
STA Entity_CurrentTileSubXPosition,X                        ;default x-pos for 1 player

LDA #$10                                                    ;
STA Entity_CurrentTileXPosition,X                           ;

JSR SetPlayerStartingYPosition_85E8                         ;
STX Player1EntitySlot                                       ;player 1 slot

JSR InitPlayerStatus_85DC                                   ;

LDA #Player_Character_MsPacMan                              ;is ms. pac-man
STA Entity_PlayerCharacter,X                                ;

CODE_8582:
JSR CODE_E89C
CLV
BVC CODE_85D7

CODE_8588:
LDA CurrentPlayerLives                                      ;check if player 1 has lives
BMI CODE_85AD                                               ;

LDA #Entity_ID_Player                                       ;
JSR SpawnEntity_8A61                                        ;
BMI CODE_85AD                                               ;branch if somehow failed, which shouldn't be possible

LDA #$00
STA Entity_CurrentTileSubXPosition,X

LDA #$0F                                                    ;first player is over here
STA Entity_CurrentTileXPosition,X                           ;

JSR SetPlayerStartingYPosition_85E8
STX Player1EntitySlot                                       ;player 1's slot is filled

JSR InitPlayerStatus_85DC

LDA #Player_Character_MsPacMan                              ;female pac-man
STA Entity_PlayerCharacter,X                                ;

JSR CODE_E89C

CODE_85AD:
LDA Player2Lives                                            ;check if player 2 should be alive
BMI CODE_85D7

LDA #Entity_ID_Player                                       ;spawn player
JSR SpawnEntity_8A61                                        ;
BMI CODE_85D7                                               ;check if couldn't spawn in... this should be impossible, right?

LDA #$00
STA Entity_CurrentTileSubXPosition,X

LDA #$11                                                    ;second player is over there
STA Entity_CurrentTileXPosition,X

JSR SetPlayerStartingYPosition_85E8                         ;
STX Player2EntitySlot                                       ;player 2 a go

JSR InitPlayerStatus_85DC

LDA #Player_Character_PacMan                                ;male pac-man
STA Entity_PlayerCharacter,X                                ;

LDA #Entity_Direction_Right
STA Entity_Direction,X                                      ;facing right

JSR CODE_E888

CODE_85D7:
LDA #$00
STA $C0
RTS

InitPlayerStatus_85DC:
JSR HandleEntityVisualPosition_A383                         ;visually adjust their position when spawning

LDA #$00
STA $0280,X                                                 ;player is not depressed by default
STA Entity_PlayerPacBoosterState,X                          ;pac booster is off by default
RTS                                                         ;

SetPlayerStartingYPosition_85E8:
LDA #$80                                                    ;4 pixels down
STA Entity_CurrentTileSubYPosition,X                        ;

LDY CurrentMazeLayout                                       ;
LDA PlayerStartingYPositionsPerMazeLayout_AD74,Y            ;
STA Entity_CurrentTileYPosition,X                           ;position them in the world vertically
RTS                                                         ;

;loads them into the gameplay
PlaceGhostsInMaze_85F6:
LDA #$0F
STA $8D

LDA #Entity_ID_Ghost
JSR SpawnEntity_8A61
BMI CODE_8619

LDA #$00
STA Entity_CurrentTileSubXPosition,X

LDA #$10
STA Entity_CurrentTileXPosition,x

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDA #$0B
STA Entity_CurrentTileYPosition,x

LDA #Entity_Ghost_Character_Blinky
STA Entity_Ghost_Character,X                                ;spawn blinky

CODE_8619:
LDA #Entity_ID_Ghost
JSR SpawnEntity_8A61
BMI CODE_8639

LDA #$0E
STA Entity_CurrentTileXPosition,x
JSR CODE_867A

LDA #Entity_Ghost_Character_Inky
STA Entity_Ghost_Character,X                                ;spawn inky

LDY CurrentLevel
CPY #$04                                                    ;level 5 check...
BCC CODE_8634

LDY #$03

CODE_8634:
LDA DATA_EFDB,Y
STA $20,X

CODE_8639:
LDA #Entity_ID_Ghost
JSR SpawnEntity_8A61
BMI CODE_8659

LDA #$10
STA Entity_CurrentTileXPosition,x
JSR CODE_867A

LDA #Entity_Ghost_Character_Pinky
STA Entity_Ghost_Character,X                                ;

LDY CurrentLevel
CPY #$04                                                    ;level 5 check...
BCC CODE_8654

LDY #$03

CODE_8654:
LDA DATA_EFD7,Y
STA $20,X

CODE_8659:
LDA #Entity_ID_Ghost
JSR SpawnEntity_8A61
BMI RETURN_8679

LDA #$12
STA Entity_CurrentTileXPosition,x
JSR CODE_867A

LDA #Entity_Ghost_Character_Sue
STA Entity_Ghost_Character,X                                ;last ghost to spawn - sue

LDY CurrentLevel                                            ;something to do with level 5
CPY #4
BCC CODE_8674

LDY #$03

CODE_8674:
LDA DATA_EFDF,Y
STA $20,X

RETURN_8679:
RTS

CODE_867A:
LDA #$00
STA Entity_CurrentTileSubXPosition,x
STA Entity_CurrentTileSubYPosition,x

LDA $8D
STA Entity_CurrentTileYPosition,x

LDA #Entity_Direction_Up
STA Entity_Direction,X
RTS

CODE_868C:
LDX #$08

LOOP_868E:
LDA $CF,X
PHA

LDA $039F,X
STA $CF,X

PLA
STA $039F,X
DEX
BNE LOOP_868E

LDX #$B2

LOOP_869F:
LDA EatenDotStateBits-1,X                                   ;swap eaten dot bits when changing players
PHA

LDA OtherPlayerDotStateBits-1,X
STA EatenDotStateBits-1,X

PLA
STA OtherPlayerDotStateBits-1,X
DEX
BNE LOOP_869F
RTS

;prepare various variables used during normal gameplay (just started playing the game)
InitializeGameplayVariables_86B1:
LDA Options_StartingLevel                                   ;start from this level
STA CurrentLevel                                            ;

LDA #$02                                                    ;
STA CurrentPlayerLives                                      ;player 1 lives
STA Player2Lives                                            ;player 2 lives (simultaneous only)

LDA #$00                                                    ;
STA OneUpScoreTargetIndex                                   ;
STA Player2_OneUpScoreTargetIndex                           ;
STA Score_CurrentPlayer                                     ;
STA Score_CurrentPlayer+1                                   ;score is 0
STA Score_CurrentPlayer+2                                   ;
STA Score_Player2                                           ;
STA Score_Player2+1                                         ;
STA Score_Player2+2                                         ;
STA Score_Total                                             ;
STA Score_Total+1                                           ;
STA Score_Total+2                                           ;
STA PauseCounter                                            ;
STA CurrentPlayerConfiguration                              ;by default, one player only on-screen

LDA Options_Type                                            ;
CMP #Options_Type_2PlayerCompetitive                        ;if started gaming in 2 player co-op or competitive...
BCC CODE_86EC                                               ;

LDA #CurrentPlayerConfiguration_BothPlayers                 ;both players are present
STA CurrentPlayerConfiguration                              ;

CODE_86EC:
LDA #$05                                                    ;can spawn 6 juniors total
STA PacJuniorCount                                          ;
RTS                                                         ;

;InitMazeVariables_86F1:
CODE_86F1:
JSR ResetBufferVariables_9AC1                               ;
JSR RemoveAllEntities_89DC                                  ;

LDA #$FF
LDX #$95

LOOP_86FB:
STA $02ED,X
DEX
BNE LOOP_86FB

LDA #$00                                                    ;
LDX #$05                                                    ;

LOOP_8705:
STA PowerPelletsVRAMPosLow,X                                ;temporarily set their position to indicate that they aren't eaten ($FF would indicate a lack of a power-pellet)
DEX                                                         ;
BPL LOOP_8705                                               ;

LDA #$00                                                    ;
STA BouncingItemState                                       ;items can spawn anew
RTS                                                         ;

CODE_8710:
JSR CODE_8757

LDA Options_Type
CMP #Options_Type_2PlayerAlternating
BNE CODE_872C

LDA CurrentLevel                                            ;check if either player is ahead
CMP OtherPlayerLevel                                        ;
BCC CODE_8726                                               ;

LDA CurrentLevel
CLV
BVC CODE_8729

CODE_8726:
LDA OtherPlayerLevel

CODE_8729:
CLV
BVC CODE_872E

CODE_872C:
LDA CurrentLevel

CODE_872E:
CMP #$07                                                    ;check if level 8 or above (enables continue system)
BMI CODE_8741                                               ;

DEC ContinuesRemaining                                      ;-1 continues
BPL CODE_873E                                               ;check if ran out of continues

LDA #$04                                                    ;reset continues
STA ContinuesRemaining                                      ;

LDA #$06                                                    ;default to level 7

CODE_873E:
STA Options_StartingLevel                                   ;

CODE_8741:
LDA #$00
STA CameraPositionY
STA CameraBasePositionOffset
STA CurrentLevel
STA Options_CursorPosition

JSR ResetBufferVariables_9AC1
JSR RemoveAllEntities_89DC
JSR HandleEntityGraphics_8A12
JMP InitOptionsScreen_F64B

CODE_8757:
JSR RemoveAllEntities_89DC
JSR SpawnGameOverStringEntity_9671                          ;display game over string, sprite edition
JSR CODE_83F3

LDA #TileStripeID_MazePlayerXEmpty                          ;summon empty player string
JSR DrawTileStripes_9B80                                    ;
RTS                                                         ;

LevelSelectCheatInputs_8766:
.byte Input_A
.byte Input_A
.byte Input_A
.byte Input_B
.byte Input_B
.byte Input_B
.byte Input_Up
.byte Input_Down
.byte Input_Left
.byte Input_Right ;input until this point to unlock partial level select
.byte Input_A
.byte Input_B
.byte Input_A
.byte Input_B
.byte Input_A
.byte Input_B
.byte Input_Up
.byte Input_Down
.byte Input_Left
.byte Input_Right
.byte Input_B
.byte Input_A
.byte Input_B
.byte Input_A
.byte Input_A
.byte Input_A
.byte Input_Up
.byte Input_Down
.byte Input_Left
.byte Input_Right

HandleLevelSelectCheatTrigger_8784:
JSR GetPlayersPressInputs_8488                              ;
AND #Input_AllDirectional|Input_A|Input_B                   ;check if we have pressed any of the valid inputs for the cheat (d-pad directions, A, B)
BEQ RETURN_87A2                                             ;

LDX LevelSelectInputCounter                                 ;
CMP LevelSelectCheatInputs_8766,X                           ;check if pressed this button/d-pad direction
BNE CODE_8799                                               ;if wrong, you ruined the combo!

INC LevelSelectInputCounter                                 ;
CLV                                                         ;
BVC RETURN_87A2                                             ;

CODE_8799:
CPX #$1E                                                    ;already activated it, can't disable it
BCS RETURN_87A2                                             ;

LDA #$00                                                    ;entered wrong input, reset the counter
STA LevelSelectInputCounter                                 ;

RETURN_87A2:
RTS                                                         ;

;handles control reversing during pause, which is a feature mentioned in the manual
HandleControlReversalCombos_87A3:
LDA Player1Inputs                                           ;
CMP #Input_Select|Input_A                                   ;select+A reverts the change back
BNE CODE_87AE                                               ;

LDA #$00                                                    ;clear control reversing flag
STA Player1ReverseControlFlag                               ;

CODE_87AE:
LDA Player1Inputs                                           ;
CMP #Input_Select|Input_B                                   ;select+B makes reverses controls
BNE CODE_87B9                                               ;

LDA #$FF                                                    ;desrever era slortnoc eno reyalp
STA Player1ReverseControlFlag                               ;(player two controls are reversed)

CODE_87B9:
LDA Player2Inputs                                           ;same checks for player 2
CMP #Input_Select|Input_A                                   ;
BNE CODE_87C4                                               ;

LDA #$00                                                    ;un-reverse controls for player 2
STA Player2ReverseControlFlag                               ;

CODE_87C4:
LDA Player2Inputs                                           ;
CMP #Input_Select|Input_B                                   ;
BNE RETURN_87CF                                             ;

LDA #$FF                                                    ;reverse controls for player 2
STA Player2ReverseControlFlag                               ;

RETURN_87CF:
RTS                                                         ;

.include "Data/PaletteData.asm"

;calculate the first BG palette's index, related to the maze itself
GetCurrentMazePaletteIndex_8898:
LDA Options_MazeSelection                                   ;check maze selection
BNE CODE_88B3                                               ;other than arcade

LDA CurrentLevel                                            ;current level
SEC                                                         ;
SBC #$05                                                    ;if current level is 1 through 5
BCC CODE_88AA                                               ;do not use current level, instead it'll be maze layout that determines the palette
LSR A                                                       ;
LSR A                                                       ;levels beyond 6 get divided by 6, then summed with maze layout to get appropriate palette
LSR A                                                       ;

CLV                                                         ;
BVC CODE_88AC                                               ;

CODE_88AA:
LDA #$00                                                    ;

CODE_88AC:
ASL A                                                       ;level*2
CLC                                                         ;
ADC CurrentMazeLayout                                       ;+layout

CLV                                                         ;
BVC CODE_88C6                                               ;

;non-arcade maze palettes
CODE_88B3:
LDA CurrentMazeLayout                                       ;if maze layout less than 4 (acrade mazes...)
CMP #$04
BCC CODE_88C6

LDA CurrentLevel
CMP #31                                                     ;level 32
BCS CODE_88C6
CMP #27                                                     ;level 28
BCC CODE_88C6                                               ;

JSR PollRandomNumber_A3D8                                   ;levels between 28 and 31, use... random number to set the palette

CODE_88C6:
AND #$3F                                                    ;don't overflow palette index
CMP #36                                                     ;maze palette index is more or equals 36?
BCC CODE_88CE                                               ;if not, use it

SBC #36                                                     ;-36

CODE_88CE:
ASL A                                                       ;calculate palette pointer proper
ASL A                                                       ;
RTS                                                         ;

;Default palettes
LoadDefaultPalettes_88D1:
LDY #$0F                                                    ;background palettes

LOOP_88D3:
LDA DefaultBackgroundPalettes_8870,Y                        ;
STA PaletteStorage+Palette_Background0,Y                    ;by the way, that table overlaps with bouncing item palettes, so the implication is that only BG0 palette matters
DEY                                                         ;but it's replaced right after, so what's the point? could've loaded something unrelated or just made them all use the same value.
BPL LOOP_88D3                                               ;

JSR GetCurrentMazePaletteIndex_8898                         ;calculate current maze palette index...
CLC                                                         ;
ADC #$03                                                    ;going from the top
TAY                                                         ;

LDX #$03                                                    ;

LOOP_88E5:
LDA MazePalettes_87E4,Y                                     ;
STA PaletteStorage+Palette_Background0,X                    ;the first background palette is maze's palette
DEY                                                         ;
DEX                                                         ;
BPL LOOP_88E5                                               ;

LDY #$0F                                                    ;sprite palettes

LOOP_88F1:
LDA DefaultSpritePalettes_87D8,Y                            ;init sprite palettes
STA PaletteStorage+Palette_Sprite0,Y                        ;
DEY                                                         ;
BPL LOOP_88F1                                               ;
RTS                                                         ;

;This palette is used in act 3 cutscene by stork and bag
Act3SpritePalette1_88FB:
.byte $0F,$28,$21,$30

;set palette for stork and the bag its holding in its beak
SetupAct3StorkAndBagPalette_88FF:
LDY #$03                                                    ;

LOOP_8901:
LDA Act3SpritePalette1_88FB,Y                               ;
STA PaletteStorage+Palette_Sprite1,Y                        ;
DEY                                                         ;
BPL LOOP_8901                                               ;
RTS                                                         ;

;uploads the entirety of PaletteStorage into PPU, specifically, palettes
UploadPalettes_890B:
BIT HardwareStatus                                          ;make sure we're ready for write, I guess

LDA #$3F                                                    ;VRAM $3F00 - this is where palettes are
STA VRAMPointerReg                                          ;

LDA #$00                                                    ;
STA VRAMPointerReg                                          ;

LDX #$00                                                    ;

LOOP_891A:
LDA PaletteStorage,X                                        ;
STA VRAMUpdateRegister                                      ;
INX                                                         ;
CPX #32                                                     ;loop until all palettes are done
BNE LOOP_891A                                               ;
RTS                                                         ;

;used for when beating the level
BlinkStageColors_8926:
LDA FreezeTimer                                             ;don't blink after a while
CMP #$50                                                    ;
BCC RETURN_8959                                             ;

LDA FrameCounter                                            ;handle stage end blinking
CMP #$18                                                    ;change color at this moment
BCS CODE_894B                                               ;
CMP #$0C                                                    ;restore colors at this moment
BNE CODE_8948                                               ;

JSR GetCurrentMazePaletteIndex_8898                         ;calculate current level's color palette selection
TAY                                                         ;
INY                                                         ;
LDA MazePalettes_87E4,Y                                     ;
STA PaletteStorage+(Palette_Background0 + 1)                ;restore the two colors

INY                                                         ;
LDA MazePalettes_87E4,Y                                     ;
STA PaletteStorage+(Palette_Background0 + 2)                ;second color

CODE_8948:
CLV                                                         ;
BVC RETURN_8959                                             ;

CODE_894B:
LDA #$0F                                                    ;the first color is black
STA PaletteStorage+(Palette_Background0 + 1)                ;

LDA #$30                                                    ;second is white
STA PaletteStorage+(Palette_Background0 + 2)                ;

LDA #$00                                                    ;reset frame counter 
STA FrameCounter                                            ;

RETURN_8959:
RTS                                                         ;

;exclusive to maze layout 34 (strange 15), rotates color palette of the maze leftward
HandleRotatingPalette_895A:
LDA CurrentMazeLayout                                       ;
CMP #33                                                     ;ONLY maze layout 34 (strange 15)
BNE RETURN_897B                                             ;

LDA FrameCounter                                            ;change palette every 8th frame
AND #$07                                                    ;
BNE RETURN_897A                                             ;

LDA PaletteStorage+(Palette_Background0 + 1)                ;swap color around
PHA                                                         ;
LDA PaletteStorage+(Palette_Background0 + 2)                ;
STA PaletteStorage+(Palette_Background0 + 1)                ;

LDA PaletteStorage+(Palette_Background0 + 3)                ;
STA PaletteStorage+(Palette_Background0 + 2)                ;
PLA                                                         ;
STA PaletteStorage+(Palette_Background0 + 3)                ;

RETURN_897A:
RTS                                                         ;

RETURN_897B:
RTS                                                         ;

;graphics pointers for each entity
EntityGFXPointers_897C:
.word EntityGFXPointers_PlayableCharacters_A3E7             ;player (pac-man or ms. pac-man)
.word EntityGFXPointers_Ghosts_A681                         ;ghost 
.word EntityGFXPointers_VulnerableGhosts_A6C1               ;ghost under the power pellet influence
.word EntityGFXPointers_Items_A99F                          ;the item that bounces around
.word EntityGFXPointers_EatenGhostScore_ABB3                ;score left by the eaten ghost
.word EntityGFXPointers_CollectedItemScore_AAA9             ;score left by the collected item
.word EntityGFXPointers_GhostEyes_AC0B                      ;chomp!
.word EntityGFXPointers_GameOverString_AC7F                 ;scrolling game over string
.word EntityGFXPointers_ReadyString_ACA2                    ;ready! string
.word EntityGFXPointers_PacJunior_AC63                      ;
.word EntityGFXPointers_Clapper_ACBD                        ;cutscene clapper
.word EntityGFXPointers_Stork_ACFA                          ;cutscene stork
.word EntityGFXPointers_CutscenePacJunior_AD43              ;cutscene pac-man junior
.word EntityGFXPointers_Heart_AD30                          ;cutscene heart
.word EntityGFXPointers_PlayableCharacters_A3E7             ;cutscene player (again, pac-man or ms. pac-man)
.word EntityGFXPointers_Ghosts_A681                         ;cutscene ghost

;entity main code pointers
EntityMainCodePointers_899C:
.word EntityMainCode_PlayableCharacters_DF3A
.word EntityMainCode_Ghost_8D29
.word EntityMainCode_VulnerableGhost_8E0B
.word EntityMainCode_BouncingItem_9440
.word EntityMainCode_EatenGhostScore_9371
.word EntityMainCode_CollectedItemScore_9359
.word EntityMainCode_GhostEyes_8BC6 
.word EntityMainCode_GAMEOVER_9698 
.word EntityMainCode_READY_96CF
.word EntityMainCode_PacJunior_99E5
.word EntityMainCode_ClapperPart_96E3 
.word EntityMainCode_Stork_9712
.word EntityMainCode_CutscenePacJunior_9767 
.word EntityMainCode_CutsceneHeart_9744                     ;heart has no function whatsoever. it's literally just a sprite.
.word EntityMainCode_CutscenePlayableCharacters_9869
.word EntityMainCode_CutsceneGhost_979E

;entity init pointers
EntityInitCodePointers_89BC:
.word CODE_E40D                                             ;generic init for players and ghosts
.word CODE_E40D
.word RETURN_E412
.word EntityInitCode_BouncingItem_E413                      ;bouncing item init
.word RETURN_E412
.word RETURN_E412
.word RETURN_E412
.word RETURN_E412
.word RETURN_E412
.word CODE_E40D
.word RETURN_E412
.word RETURN_E412
.word RETURN_E412
.word RETURN_E412
.word RETURN_E412
.word RETURN_E412

;remove all entities I think
RemoveAllEntities_89DC:
LDA #Entity_ID_None                                         ;no entity
LDX #$0F                                                    ;all slots

LOOP_89E0:
STA Entity_ID,x                                             ;this entity is no longer real
DEX                                                         ;
BPL LOOP_89E0                                               ;

JSR HandleEntityGraphics_8A12                               ;something animation related... what
RTS                                                         ;

;a very simple OAM clearing loop, unused
UNUSED_89E9:
LDX #$00                                                    ;
LDA #$F4                                                    ;

LOOP_89ED:
STA OAM_Y,X                                                 ;default OAM stuff
DEX                                                         ;
BNE LOOP_89ED                                               ;
RTS                                                         ;

;initialize all unused tiles that are not currently in use
ClearRemainingOAM_89F4:
LDA UsedOAMSlotsValue                                       ;check if all slots full
CMP #$40                                                    ;
BEQ RETURN_8A11                                             ;nothing to clear
ASL A                                                       ;
ASL A                                                       ;
TAX                                                         ;

LDA #$F4                                                    ;default

LOOP_89FF:
STA OAM_Y,X                                                 ;initialize everything
INX                                                         ;
STA OAM_Tile-1,X                                            ;
INX                                                         ;
STA OAM_Prop-2,X                                            ;
INX                                                         ;
STA OAM_X-3,X                                               ;
INX                                                         ;
BNE LOOP_89FF                                               ;

RETURN_8A11:
RTS                                                         ;

HandleEntityGraphics_8A12:
LDY Player1EntitySlot                                       ;check if player 1 should be present
BMI CODE_8A19                                               ;

JSR CheckForFlickering_E480                                 ;flicker detection... requires a player for that

CODE_8A19:
LDY Player2EntitySlot                                       ;check if player 2 should be present
BMI CODE_8A20                                               ;

JSR CheckForFlickering_E480                                 ;detect flicker for player 2 now

CODE_8A20:
LDA #$00                                                    ;start drawing from OAM slot 0
STA UsedOAMSlotsValue                                       ;

LDA #$0A                                                    ;
STA $93                                                     ;

LOOP_8A28:
LDA FrameCounter                                            ;let frame counter decide in which order the entities are drawn (only affects flickering)
AND #$01                                                    ;
BNE CODE_8A3B                                               ;

LDX #$00                                                    ;entity 16 first, entity 1 last

LOOP_8A30:
JSR CODE_8A4B                                               ;check if this entity's gfx should be drawn right now

INX                                                         ;
CPX #$10                                                    ;
BNE LOOP_8A30                                               ;

CLV                                                         ;
BVC CODE_8A43                                               ;

CODE_8A3B:
LDX #$0F                                                    ;entity 1 first, entity 16 last

LOOP_8A3D:
JSR CODE_8A4B                                               ;maybe draw this guy's visuals

DEX                                                         ;
BPL LOOP_8A3D                                               ;

CODE_8A43:
DEC $93                                                     ;next priority level
BPL LOOP_8A28                                               ;

JSR ClearRemainingOAM_89F4                                  ;
RTS                                                         ;

CODE_8A4B:
LDA Entity_ID,x                                             ;if no entity is occupying this slot, no graphics, obviously
BEQ RETURN_8A5B                                             ;
ASL A                                                       ;
TAY                                                         ;
LDA Entity_DrawingPriority,X                                ;check if entity's drawing priority matches
CMP $93                                                     ;
BNE RETURN_8A5B                                             ;if not, don't draw yet

JSR DrawEntityGraphics_8AB7                                 ;draw shenanigans

RETURN_8A5B:
RTS

;Remove an Entity
;input X - entity slot
RemoveEntity_8A5C:
LDA #Entity_ID_None                                         ;
STA Entity_ID,X                                             ;no entity in this slot
RTS                                                         ;

;Spawn an Entity
;Input A - Entity ID
SpawnEntity_8A61:
LDX #$0F                                                    ;

LOOP_8A63:
LDY Entity_ID,X                                             ;check if this slot is claimed by something
BNE CODE_8A79                                               ;
STA Entity_ID,X                                             ;

LDA #$00                                                    ;init some tables
STA Entity_GFXFrame,X                                       ;
STA Entity_GFXProperties,x                                  ;
STA $20,X                                                   ;default movement is none I think

LDA Entity_ID,X                                             ;
JSR RunEntityInitCode_8AA8                                  ;init...

LDA #$00                                                    ;output zero - entity spawned
RTS

CODE_8A79:
DEX                                                         ;
BPL LOOP_8A63                                               ;
RTS                                                         ;output the same value as the input - entity spawn failed

;an unused "forced" spawn routine.
;alternatively it could've been used to replace an entity with another
;Input A - Entity ID, X - spawn slot
ForceSpawnEntity_8A7D:
UNUSED_8A7D:
STA Entity_ID,x                                             ;ID

LDA #$00                                                    ;init some general tables
STA Entity_GFXFrame,X                                       ;
STA Entity_GFXProperties,x                                  ;
STA $20,X                                                   ;

LDA Entity_ID,x                                             ;init
JMP RunEntityInitCode_8AA8                                  ;

HandleEntities_8A8C:
LDX #$0F                                                    ;

LOOP_8A8E:
LDA Entity_ID,x                                             ;if entity is non-existent, skip
BEQ CODE_8A95                                               ;

JSR RunEntityMainCode_8A99                                  ;run its code

CODE_8A95:
DEX                                                         ;
BPL LOOP_8A8E                                               ;
RTS                                                         ;

;load the pointer and jump there
RunEntityMainCode_8A99:
ASL A                                                       ;
TAY                                                         ;
LDA EntityMainCodePointers_899C-2,Y                         ;
STA $95                                                     ;

LDA EntityMainCodePointers_899C-1,Y                         ;
STA $96                                                     ;

JMP ($0095)                                                 ;

RunEntityInitCode_8AA8:
ASL A                                                       ;
TAY                                                         ;
LDA EntityInitCodePointers_89BC-2,Y                         ;
STA $95                                                     ;

LDA EntityInitCodePointers_89BC-1,Y                         ;
STA $96                                                     ;

JMP ($0095)                                                 ;

;graphics!
;TEMP_CurrentEntity_GFXPointers = $8B ;points to all potential pointers based on gfx frame
;TEMP_CurrentEntity_GFXDataPointer = $89 ;points to current data target
;TEMP_OAMPointer = $8B
DrawEntityGraphics_8AB7:
LDA EntityGFXPointers_897C-2,Y                              ;get graphical pointers for this entity
STA $8B                                                     ;

LDA EntityGFXPointers_897C-1,Y                              ;
STA $8C                                                     ;

LDA Entity_GFXFrame,X                                       ;the visual appearance will be based on current animation frame
ASL A                                                       ;
TAY                                                         ;

LDA ($8B),Y                                                 ;fetch a pointer to the graphics data for current graphical frame
STA $89                                                     ;
INY                                                         ;
LDA ($8B),Y                                                 ;
STA $8A                                                     ;

LDY #$00                                                    ;
LDA ($89),Y                                                 ;very first byte is amount of tiles this entity's animation uses
ASL A                                                       ;
ASL A                                                       ;
STA LastOAMByteToUpdate                                     ;amount of OAM bytes to write to (each tile takes 4 bytes of data)
BNE CODE_8ADA                                               ;if umm, ackstshkhujhally there's nothing to draw, it'll draw...
RTS                                                         ;nothing! shocking, I know.

CODE_8ADA:
LDA Entity_YPos,X                                           ;if y-position is not at the very top of the screen
BNE CODE_8ADF                                               ;can draw maybe
RTS                                                         ;can't draw definitely

CODE_8ADF:
CMP #$F4                                                    ;check if offscreen
BNE CODE_8AE4                                               ;
RTS                                                         ;cant draw, sowwy

CODE_8AE4:
INC $89                                                     ;start reading tile entries now
BNE CODE_8AEA                                               ;

INC $8A                                                     ;lets not forget high byte

CODE_8AEA:
LDA #>OAM_Y                                                 ;
STA $8C                                                     ;point to OAM page

LDA UsedOAMSlotsValue                                       ;starting OAM slot this entity occupies
ASL A                                                       ;
ASL A                                                       ;times 4 because we working from top to bottom
STA $8B                                                     ;

LDA Entity_GFXProperties,x                                  ;
AND #OAMProp_YFlip|OAMProp_XFlip                            ;
BNE CODE_8B27                                               ;check if flipped X or Y, draw slightly differently

LDY #$00                                                    ;

LOOP_8AFC:
LDA UsedOAMSlotsValue                                       ;
CMP #$40                                                    ;
BNE CODE_8B03                                               ;see if there are no slots available
RTS                                                         ;cant keep drawing

;draw in a normal way
CODE_8B03:
LDA ($89),Y                                                 ;y-position displacement
CLC                                                         ;
ADC Entity_YPos,X                                           ;+current y-pos
STA ($8B),Y                                                 ;

INY                                                         ;
LDA ($89),Y                                                 ;sprite tile
STA ($8B),Y                                                 ;

INY                                                         ;
LDA ($89),Y                                                 ;
EOR Entity_GFXProperties,x                                  ;combine with whatever OAM property bits we have here
STA ($8B),Y                                                 ;

INY                                                         ;
LDA Entity_XPos,X                                           ;current x-pos
CLC                                                         ;
ADC ($89),Y                                                 ;+x-position displacement
STA ($8B),Y                                                 ;

INY                                                         ;
INC UsedOAMSlotsValue                                       ;next OAM slot
CPY LastOAMByteToUpdate                                     ;check if we drew them all
BNE LOOP_8AFC                                               ;
RTS                                                         ;DRAWING OVER

;x-flipped, y-flipped or both
CODE_8B27:
LDA Entity_GFXProperties,x                                  ;check if y-flipped
AND #OAMProp_YFlip                                          ;
BNE CODE_8B5D                                               ;

LDY #$00                                                    ;

LOOP_8B2F:
LDA UsedOAMSlotsValue                                       ;check if out of sprite slots
CMP #$40                                                    ;
BNE CODE_8B36                                               ;
RTS                                                         ;cannot go on...

;draw x-flipped image
CODE_8B36:
LDA ($89),Y                                                 ;y-position displacement
CLC                                                         ;
ADC Entity_YPos,X                                           ;+current y-pos
STA ($8B),Y                                                 ;

INY                                                         ;
LDA ($89),Y                                                 ;sprite tile
STA ($8B),Y                                                 ;

INY                                                         ;
LDA ($89),Y                                                 ;
EOR Entity_GFXProperties,x                                  ;combine with whatever OAM property bits we have here (which includes x-flip bit for certain)
STA ($8B),Y                                                 ;

INY                                                         ;
LDA Entity_XPos,X                                           ;since the image is mirrored horizontally, its tile positions are different
SEC                                                         ;
SBC ($89),Y                                                 ;
SEC                                                         ;
SBC #$08                                                    ;align proper
STA ($8B),Y                                                 ;

INY                                                         ;
INC UsedOAMSlotsValue                                       ;next OAM slot
CPY LastOAMByteToUpdate                                     ;check if we drew them all
BNE LOOP_8B2F                                               ;
RTS                                                         ;yes, we did drew them all

CODE_8B5D:
LDA Entity_GFXProperties,x                                  ;check if also x-flipped
AND #OAMProp_XFlip                                          ;
BNE UNUSED_8B93                                             ;I guess there are no entities that can be both x flipped and y flipped...

LDY #$00                                                    ;

LOOP_8B65:
LDA UsedOAMSlotsValue                                       ;ARE THERE ANY FREE SPRITE SLOTS???
CMP #$40                                                    ;
BNE CODE_8B6C                                               ;
RTS                                                         ;NO

;draw y-flipped image
CODE_8B6C:
LDA Entity_YPos,X                                           ;image is vertically mirrored, different tile y-positions
SEC                                                         ;
SBC ($89),Y                                                 ;
SEC                                                         ;
SBC #$08                                                    ;align proper
STA ($8B),Y                                                 ;

INY                                                         ;
LDA ($89),Y                                                 ;sprite tile
STA ($8B),Y                                                 ;

INY                                                         ;
LDA ($89),Y                                                 ;
EOR Entity_GFXProperties,x                                  ;combine with whatever OAM property bits we have here (which includes y-flip bit for certain)
STA ($8B),Y                                                 ;

INY                                                         ;
LDA ($89),Y                                                 ;x-position displacement
CLC                                                         ;
ADC Entity_XPos,X                                           ;+current x-position
STA ($8B),Y                                                 ;(did you notice the order here is different compared to before?)

INY                                                         ;
INC UsedOAMSlotsValue                                       ;next OAM slot
CPY LastOAMByteToUpdate                                     ;check if we drew them all
BNE LOOP_8B65                                               ;
RTS                                                         ;

;draw both x and y-flipped image (this particular drawing method seems to be unused)
UNUSED_8B93:
LDY #$00                                                    ;

LOOP_8B95:             
LDA UsedOAMSlotsValue                                       ;are there any sprites slo-
CMP #$40                                                    ;
BNE CODE_8B9C                                               ;
RTS                                                         ;no!!!

CODE_8B9C:
LDA Entity_YPos,X                                           ;
SEC                                                         ;
SBC ($89),Y                                                 ;
SEC                                                         ;
SBC #$08                                                    ;
STA ($8B),Y                                                 ;tile y-position

INY                                                         ;
LDA ($89),Y                                                 ;sprite tile
STA ($8B),Y                                                 ;

INY                                                         ;
LDA ($89),Y                                                 ;
EOR Entity_GFXProperties,X                                  ;combine with whatever OAM property bits we have here (which includes y-flip and x-flip bits for certain)
STA ($8B),Y                                                 ;

INY                                                         ;
LDA Entity_XPos,X                                           ;
SEC                                                         ;
SBC ($89),Y                                                 ;
SEC                                                         ;
SBC #$08                                                    ;
STA ($8B),Y                                                 ;tile x-position

INY                                                         ;
INC UsedOAMSlotsValue                                       ;next OAM slot
CPY LastOAMByteToUpdate                                     ;check if we drew them all
BNE LOOP_8B95                                               ;
RTS                                                         ;the end

EntityMainCode_GhostEyes_8BC6:
LDA FrameCounter                                            ;every 64th frame...
AND #$3F                                                    ;
BNE CODE_8BCF                                               ;

INC $0280,X                                                 ;increase this counter

CODE_8BCF:
JSR SetGhostColor_8FB0                                      ;color eyes appropriately.

LDA Entity_Direction,X                                      ;direction dictates graphical appearance
STA Entity_GFXFrame,X                                       ;

LDA $20,X                                                   ;check if entering ghost gate
CMP #$02
BNE CODE_8C07

LDA #Entity_Direction_Down                                  ;moving down
STA Entity_Direction,X                                      ;

LDA #$20
STA Entity_YSpeed,X

LDA #$00
STA Entity_XSpeed,X

JSR CODE_A32C

LDA Entity_CurrentTileYPosition,X                           ;don't turn into a ghost yet if haven't gone far enough
CMP #$0F                                                    ;
BNE CODE_8C04                                               ;

LDA #Entity_ID_Ghost                                        ;turn back into a ghost
STA Entity_ID,x                                             ;

LDA #$02
STA $20,X

LDA #Entity_Direction_Up                                    ;move up
STA Entity_Direction,X

LDA #$00                                                    ;
STA Entity_GFXFrame,X                                       ;

CODE_8C04:
CLV                                                         ;
BVC CODE_8C71                                               ;

CODE_8C07:
LDA #$40                                                    ;high speed for this one
STA CurrentEntitySpeed                                      ;

LDA $0280,X                                                 ;if at least 512 frames have been reached
CMP #$08
BCC CODE_8C3F

LDA FrameCounter                                            ;something every 16th frame...
AND #$0F
BNE CODE_8C3C

LDA $0280,X
AND #$04                                                    ;additionally, every 256 frames...
BNE CODE_8C32                                               ;change its target location back to the ghost gate

JSR PollRandomNumber_A3D8
AND #$1F                                                    ;give random location to reach.
STA Entity_TargetTileXPosition,X

JSR PollRandomNumber_A3D8                                   ;this is supposed to break them out of infinitely looping in certain stages by giving them a different coordinate to reach and hopefully getting out
AND #$1F
STA Entity_TargetTileYPosition,X

CLV
BVC CODE_8C3C

CODE_8C32:
LDA #$0B
STA Entity_TargetTileYPosition,X

LDA #$10
STA Entity_TargetTileXPosition,X

CODE_8C3C:
CLV
BVC CODE_8C49

CODE_8C3F:
LDA #$0B
STA Entity_TargetTileYPosition,X                            ;literally the same values as above...

LDA #$10
STA Entity_TargetTileXPosition,X

CODE_8C49:
JSR CODE_909C

LDA Entity_CurrentTileYPosition,x                           ;check if it managed to reach the ghost gate's y-position
CMP #$0B
BNE CODE_8C71

LDA Entity_CurrentTileXPosition,x
LDY Entity_Direction,X                                      ;check if moving left
CPY #Entity_Direction_Left
BNE CODE_8C5F
CLC
ADC #$01

CODE_8C5F:
CMP #$10                                                    ;check if reached it horizontally
BNE CODE_8C71

LDA #$10
STA Entity_CurrentTileXPosition,x                           ;snap to it

LDA #$00
STA Entity_CurrentTileSubXPosition,x                        ;

LDA #$02                                                    ;start entering the ghost gate
STA $20,X

CODE_8C71:
LDA #$00
STA Entity_GFXProperties,X

JSR HandleEnteringTunnel_E459
JSR HandleEntityVisualPosition_A383

DEC $04FB                                                   ;some counter....
RTS                                                         ;

CODE_8C7F:
LDA #OAMProp_BGPriority                                     ;go behind background
STA Entity_GFXProperties,X

LDA $20,X
CMP #$03
BNE CODE_8CC4

LDA #$00
STA Entity_YSpeed,X

LDA Entity_CurrentTileXPosition,x
CMP #$10
BPL CODE_8CA5

LDA #Entity_Direction_Right
STA Entity_Direction,X

LDA #$10
STA Entity_XSpeed,X

JSR CODE_A32C
RTS

CLV                                                         ;\unused
BVC CODE_8CC4                                               ;/

CODE_8CA5:
LDA Entity_CurrentTileXPosition,x
CMP #$10
BNE CODE_8CB8

LDA Entity_CurrentTileSubXPosition,x
CMP #$20
BCS CODE_8CB8

LDA #$02
STA $20,X
RTS

CODE_8CB8:
LDA #Entity_Direction_Left
STA Entity_Direction,X

LDA #-$10
STA Entity_XSpeed,X
JSR CODE_A32C

CODE_8CC4:
LDA $20,X
CMP #$02
BNE CODE_8CEC

LDA #Entity_Direction_Up
STA Entity_Direction,X

LDA #-$10
STA Entity_YSpeed,X

LDA #$00
STA Entity_XSpeed,X

JSR CODE_A32C

LDA Entity_CurrentTileYPosition,x
CMP #$0B
BNE RETURN_8CEB

LDA #$00
STA $20,X

LDA #Entity_Direction_Left
STA Entity_Direction,X
RTS

RETURN_8CEB:
RTS

CODE_8CEC:
LDA Entity_Direction,X
CMP #Entity_Direction_Up
BNE CODE_8D0A

LDA #-$10
STA Entity_YSpeed,X

LDA #$00
STA Entity_XSpeed,X

JSR CODE_A32C

LDA Entity_CurrentTileYPosition,x
CMP #$0D
BNE CODE_8D0A

LDA #Entity_Direction_Down
STA Entity_Direction,X

CODE_8D0A:
CMP #Entity_Direction_Down
BNE RETURN_8D28

LDA #$10
STA Entity_YSpeed,X

LDA #$00
STA Entity_XSpeed,X
JSR CODE_A32C

LDA Entity_CurrentTileYPosition,x
CMP #$0F
BNE RETURN_8D28

LDA #Entity_Direction_Up
STA Entity_Direction,X

DEC $20,X

RETURN_8D28:
RTS

EntityMainCode_Ghost_8D29:
JSR SetGhostColor_8FB0                                      ;appropriate ghost should look appropriately
JSR HandleGhostAnimation_9082                               ;animate
JSR HandleGhostSpeed_8FDE                                   ;prepare this ghost's movement speed

LDA FreezeTimer                                             ;if freeze timer is active, cannot act
BNE CODE_8D4C                                               ;

LDA $20,X
CMP #$02                                                    ;some sort of state I don't know about.
BMI CODE_8D46

JSR CODE_8C7F
JSR HandleEnteringTunnel_E459
JSR HandleEntityVisualPosition_A383
RTS

CODE_8D46:
JSR CODE_8DAD
JSR CODE_909C

CODE_8D4C:
LDA #$00                                                    ;no special props
STA Entity_GFXProperties,X

JSR HandleEnteringTunnel_E459
JSR HandleEntityVisualPosition_A383

LDY Player1EntitySlot
BMI CODE_8D65

LDA #$04
JSR CODE_A35B                                               ;player 1, prepare to meet thy maker!
BNE CODE_8D65

LDA #$01                                                    ;RIP player 1
STA Player_WhoDied                                          ;

CODE_8D65:
LDY Player2EntitySlot
BMI RETURN_8D74

LDA #$04
JSR CODE_A35B                                               ;player 2, en guarde!
BNE RETURN_8D74

LDA #$02                                                    ;RIP player 2
STA Player_WhoDied                                          ;

RETURN_8D74:
RTS

;grab one of the players' slots. alternates between player 1 and 2 every 256 frames (provided both are on-screen at once)
GetPlayerSlot_8D75:
PHA                                                         ;
LDA FrameCounter+1                                          ;
AND #$01                                                    ;alternate which player to detect every 256 frames
BNE CODE_8D85                                               ;

LDY Player1EntitySlot                                       ;check if player 1 exists
BPL CODE_8D82                                               ;

LDY Player2EntitySlot                                       ;player 2

CODE_8D82:
CLV                                                         ;
BVC CODE_8D8B                                               ;

CODE_8D85:
LDY Player2EntitySlot                                       ;check if player 2 exists
BPL CODE_8D8B                                               ;

LDY Player1EntitySlot                                       ;player 1

CODE_8D8B:
PLA                                                         ;
RTS                                                         ;

;offsets for tile a tile at player's position that each ghost attempts to reach for each ghost, based on player's direction and what character. used when chasing the player
;this is horizontal
;in following order: player faces right, up, left, down
GhostTargetingRelativeToPlayerOffset_Horz_8D8D:
.byte $00,$00,$00,$00 ;blinky (tries to reach the exact tile the player is on)
.byte -$02,$00,$02,$00 ;sue (tries to get behind of the player)
.byte $04,-$01,-$04,$01 ;inky (tries to get ahead of the player+slight offset to one side)
.byte $04,$01,-$04,-$01 ;pinky (tries to get ahead of the player+slight offset to another side)

;vertical
GhostTargetingRelativeToPlayerOffset_Vert_8D9D:
.byte $00,$00,$00,$00
.byte $00,$02,$00,-$02
.byte $01,-$04,-$01,$04
.byte -$01,-$04,$01,$04

;chase the player or scatter
;HandleGhostTargeting_8DAD:
CODE_8DAD:
LDA DemoMovementIndex                                       ;check if in demo mode
BNE HandleGhostChasingPlayers_8DD9                          ;always chase the player

LDA GhostScatterTimer+1                                     ;check if scatter tume has ended
BMI HandleGhostChasingPlayers_8DD9                          ;get to chasing

;ghost scattering behavior here
LDA FrameCounter                                            ;
AND #$3F                                                    ;do nothing special for 64 frames
BNE RETURN_8DD8                                             ;

JSR PollRandomNumber_A3D8                                   ;change the tile its chasing
AND #$0F                                                    ;between 0-15...
ADC #$04                                                    ;+4, so that's tile 4-19.
STA Entity_TargetTileXPosition,X                            ;horizontal

JSR PollRandomNumber_A3D8                                   ;
LDY CurrentLevel                                            ;
CPY #$05                                                    ;level 6 onward...
BCS CODE_8DD3                                               ;
AND #$0F                                                    ;between tiles 0-15
CLV                                                         ;
BVC CODE_8DD5                                               ;

CODE_8DD3:
AND #$1F                                                    ;larger area of randomness (0-31)

CODE_8DD5:
STA Entity_TargetTileYPosition,X                            ;

RETURN_8DD8:
RTS                                                         ;

;ghost chasing behavior here
HandleGhostChasingPlayers_8DD9:
JSR GetPlayerSlot_8D75                                      ;get one of the players' slots

LDA Entity_Ghost_Character,X                                ;
ASL A                                                       ;
ASL A                                                       ;
ADC Entity_Direction,Y                                      ;player's direction
STA $89                                                     ;
TAY                                                         ;

LDA GhostTargetingRelativeToPlayerOffset_Vert_8D9D,Y        ;offset vertical target tile orientation
JSR GetPlayerSlot_8D75                                      ;
CLC                                                         ;
ADC Entity_CurrentTileYPosition,Y                           ;see if the player is near the top of the screen
BPL CODE_8DF4                                               ;

LDA #$00                                                    ;default vertical tile to chase so it doesn't overflow into something Bad

CODE_8DF4:
STA Entity_TargetTileYPosition,X                            ;Chase That Spot I Think

LDY $89                                                     ;
LDA GhostTargetingRelativeToPlayerOffset_Horz_8D8D,Y        ;
JSR GetPlayerSlot_8D75                                      ;
CLC                                                         ;
ADC Entity_CurrentTileXPosition,Y                           ;if the player is about to enter the tunnel and go offscreen
BPL CODE_8E07                                               ;

LDA #$00                                                    ;chase the very left side of the screen

CODE_8E07:
STA Entity_TargetTileXPosition,X                            ;chase that spot i think
RTS                                                         ;

EntityMainCode_VulnerableGhost_8E0B:
JSR SetVulnerableGhostPaletteColors_8FC8                    ;

LDA FreezeTimer                                             ;cannot act if this timer is set
BEQ CODE_8E16                                               ;

JSR HandleEntityVisualPosition_A383                         ;only display graphics
RTS                                                         ;

CODE_8E16:
LDA PowerPelletTimer+1                                      ;power pellet timer on?
BNE CODE_8E31                                               ;

LDA PowerPelletTimer                                        ;power pellet almost ran out?
CMP #$01                                                    ;
BNE CODE_8E31                                               ;nope, still vulnerable

LDA #Entity_ID_Ghost                                        ;turn into a normal ghost
STA Entity_ID,x                                             ;

LDA #$00                                                    ;init visual appearance
STA Entity_GFXFrame,X                                       ;
STA Entity_GFXProperties,X                                  ;

JSR HandleEnteringTunnel_E459
JSR HandleEntityVisualPosition_A383
RTS

CODE_8E31:
LDA Entity_Ghost_Character,X                                ;
ASL A                                                       ;
STA Entity_GFXFrame,X                                       ;the graphical appearance depends on the ghost character

LDA PowerPelletTimer+1
BNE CODE_8E48

LDA PowerPelletTimer                                        ;check if power pellet is about to run out...
CMP #$C0                                                    ;
BCS CODE_8E48                                               ;not about to run out
AND #$10                                                    ;every 16 frames, will change from blinking to not blinking
BNE CODE_8E48                                               ;

LDA #$08                                                    ;blink frame
STA Entity_GFXFrame,X                                       ;

CODE_8E48:
LDA $20,X
CMP #$02
BMI CODE_8E58

JSR CODE_8C7F
JSR HandleEnteringTunnel_E459
JSR HandleEntityVisualPosition_A383
RTS

CODE_8E58:
LDA #$10                                                    ;low speed
STA CurrentEntitySpeed                                      ;

LDA Entity_CurrentTileYPosition,x                           ;
ASL A                                                       ;
JSR GetPlayerSlot_8D75                                      ;get player 1 or player 2 to prioritize
SEC                                                         ;
SBC Entity_CurrentTileYPosition,Y                           ;try to move away from the player
STA Entity_TargetTileYPosition,X                            ;

LDA Entity_CurrentTileXPosition,x                           ;
ASL A                                                       ;
SEC                                                         ;
SBC Entity_CurrentTileXPosition,Y                           ;get the HELL outta here!
STA Entity_TargetTileXPosition,X                            ;

JSR CODE_909C

LDA FrameCounter                                            ;animate vulnerable ghost
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
AND #$01                                                    ;
CLC                                                         ;
ADC Entity_GFXFrame,X                                       ;
STA Entity_GFXFrame,X                                       ;

LDA #$00                                                    ;refresh props
STA Entity_GFXProperties,X                                  ;

JSR HandleEnteringTunnel_E459
JSR HandleEntityVisualPosition_A383

LDY Player1EntitySlot                                       ;check if player 1 is among us
BMI CODE_8E9E                                               ;

LDA #$04
JSR CODE_A35B                                               ;check if player 1 touches this ghost
BNE CODE_8E9E

LDA #$01
JSR CODE_8EAF

CODE_8E9E:
LDY Player2EntitySlot                                       ;check if player 2 is alive and well
BMI RETURN_8EAE                                             ;

LDA #$04                                                    ;check if player 2 touches this ghost (does that mean that both player 1 and player 2 can trigger this interaction at the same time? probably not)
JSR CODE_A35B
BNE RETURN_8EAE

LDA #$02
JSR CODE_8EAF

RETURN_8EAE:
RTS

CODE_8EAF:
STA $89

LDA $0280,Y
BMI RETURN_8ED5                                             ;if player is upset, nothing happens I guess.

LDA $89
STA $C0

LDA #Entity_ID_GhostScore                                   ;
STA Entity_ID,x                                             ;ghost turns into score when eaten

LDA #$20
STA FreezeTimer                                             ;freeze for 32 frames
STA $20,X

LDA Entity_PlayerCharacter,Y                                ;whichever player ate this ghost gets a nice surprise!
STA Score_RewardedPlayer                                    ;

JSR EntityMainCode_EatenGhostScore_9371
JSR GiveGhostScore_8ED6

LDA #Sound_GhostEaten                                       ;mmm, tastes like chicken
JSR PlaySound_F2FF                                          ;

RETURN_8ED5:
RTS                                                         ;

GiveGhostScore_8ED6:
LDA EatenGhostCombo                                         ;give score depending on current ghost combo
BNE CODE_8EE1

LDA #ScoreReward_200Pts                                     ;give 200 score
JSR GiveScore_FDB3                                          ;
RTS                                                         ;

CODE_8EE1:
CMP #$01                                                    ;
BNE CODE_8EEB                                               ;

LDA #ScoreReward_400Pts                                     ;give 400 score
JSR GiveScore_FDB3                                          ;
RTS                                                         ;

CODE_8EEB:
CMP #$03
BNE CODE_8EF4

LDA #ScoreReward_800Pts                                     ;give 800 score
JSR GiveScore_FDB3

CODE_8EF4:
LDA #ScoreReward_800Pts                                     ;give 800 score... to simulate 1600 points (or just 800 score if we skipped that previous reward routine)
JSR GiveScore_FDB3                                          ;
RTS                                                         ;

;background collision detection?
CODE_8EFA:
Macro_SetWord MazeSolidTileBits, $89

LDA Entity_CurrentTileYPosition,x
ASL A
ASL A
STA $8B

LDA Entity_CurrentTileXPosition,x
SEC
SBC #$01
STA $8D
LSR A
LSR A
LSR A
CLC
ADC $8B
TAY
LDA ($89),Y
STA $8F

LDA $8D
AND #$07
TAY
LDA DATA_E13A,Y
AND $8F
RTS

CODE_8F27:
LDA #$5A
STA $89

LDA #$04
STA $8A

LDA Entity_CurrentTileYPosition,x
ASL A
ASL A
STA $8B

LDA Entity_CurrentTileXPosition,x
CLC
ADC #$01
STA $8D
LSR A
LSR A
LSR A
CLC
ADC $8B
TAY
LDA ($89),Y
STA $8F

LDA $8D
AND #$07
TAY
LDA DATA_E13A,Y
AND $8F
RTS

CODE_8F54:
LDA #$5A
STA $89

LDA #$04
STA $8A

LDA Entity_CurrentTileYPosition,x
SEC
SBC #$01
ASL A
ASL A
STA $8B

LDA Entity_CurrentTileXPosition,x
LSR A
LSR A
LSR A
CLC
ADC $8B
TAY
LDA ($89),Y
STA $8F

LDA Entity_CurrentTileXPosition,x
AND #$07
TAY
LDA DATA_E13A,Y
AND $8F
RTS

CODE_8F80:
LDA #$5A
STA $89

LDA #$04
STA $8A

LDA Entity_CurrentTileYPosition,x
CLC
ADC #$01
ASL A
ASL A
STA $8B

LDA Entity_CurrentTileXPosition,x
LSR A
LSR A
LSR A
CLC
ADC $8B
TAY
LDA ($89),Y
STA $8F

LDA Entity_CurrentTileXPosition,x
AND #$07
TAY
LDA DATA_E13A,Y
AND $8F
RTS

DrawingPriorityPerGhost_8FAC:
.byte $04,$03,$01,$02

;used to define ghost's color, especially after being vulnerable (and drawing priority)
SetGhostColor_8FB0:
LDY Entity_Ghost_Character,X                                ;type of ghost (inky, pinky, sue or blinky)
LDA DrawingPriorityPerGhost_8FAC,Y                          ;
CLC                                                         ;
ADC #$05                                                    ;
STA Entity_DrawingPriority,X                                ;give them differing drawing priorities (higher than vulnerable ghosts')

LDA NormalGhostPaletteColors_87D0,Y                         ;
PHA                                                         ;
LDA NormalGhostPaletteColorIndexes_87D4,Y                   ;
TAY                                                         ;
PLA                                                         ;
STA PaletteStorage,Y                                        ;
RTS                                                         ;

;Set color and graphical priority for vulnerable ghosts
SetVulnerableGhostPaletteColors_8FC8:
LDY Entity_Ghost_Character,X                                ;
LDA DrawingPriorityPerGhost_8FAC,Y                          ;
STA Entity_DrawingPriority,X                                ;relatively low drawing priority

LDA NormalGhostPaletteColorIndexes_87D4,Y                   ;
TAY                                                         ;
LDA #$01                                                    ;dark blue color
STA PaletteStorage,Y                                        ;
RTS                                                         ;

;base speed values for each ghost
;For Blinky, Sue, Inky and Pinky, respectively.
SpeedModifierPerGhost_8FDA:
.byte $03,$02,$01,$00

HandleGhostSpeed_8FDE:
LDY CurrentLevel                                            ;
CPY #13                                                     ;level 14 check
BCC CODE_8FE6                                               ;if below that, take variable speed

LDY #12                                                     ;cap level speed values

CODE_8FE6:
LDA GhostSpeedPerLevel_EFCA,Y                               ;speed is determined by level
LDY Entity_Ghost_Character,X                                ;
CLC                                                         ;
ADC SpeedModifierPerGhost_8FDA,Y                            ;speed is determined by individual ghost
LDY Options_GameDifficulty                                  ;
CLC                                                         ;
ADC GhostSpeedPerDifficulty_EFB8,Y                          ;speed is determined by difficulty
STA CurrentEntitySpeed                                      ;result = probably speedy boi

LDA CurrentLevel                                            ;
CMP #$04                                                    ;check if level 4 or lower...
BCC CODE_901E                                               ;ignore speed modification from remaining dots
CPY #Options_GameDifficulty_Normal                          ;if the game difficulty is NOT normal, ignore speed modification based on dots count.
BNE CODE_901E                                               ;

LDA CurrentDotsRemaining+1                                  ;check for remaining dots
BNE CODE_901E                                               ;if at least 256 dots remain, ignore

LDA CurrentDotsRemaining                                    ;
CMP #32                                                     ;
BCS CODE_901E                                               ;if there are more than 31 dots, ignore
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
EOR #$FF                                                    ;for every 8 dots...
CLC                                                         ;
ADC #$01                                                    ;
CLC                                                         ;
ADC #$04                                                    ;??? can't you just CLC ADC #$05?
CLC                                                         ;
ADC CurrentEntitySpeed                                      ;become EVEN FASTER, the less dots remain, the faster you are!
STA CurrentEntitySpeed                                      ;

CODE_901E:
JSR AlterGhostSpeedInTunnel_9022                            ;
RTS                                                         ;

;check if the ghost is in the tunnel's range and slow it down if it is
AlterGhostSpeedInTunnel_9022:
JSR CheckIfGhostGoesInTunnel_902F                           ;

LDA $89                                                     ;check if ghost did enter a tunnel
BEQ RETURN_902E                                             ;

LDA CurrentEntitySpeed                                      ;hold your horses. hope they're not too heavy for you to handle.
LSR A                                                       ;
STA CurrentEntitySpeed                                      ;half ghost's speed when entering a tunnel

RETURN_902E:
RTS                                                         ;

;check if the ghost goes in the tunnel
CheckIfGhostGoesInTunnel_902F:
LDA #$00                                                    ;by default it's not in the tunnel. we'll figure that out later.
STA $89                                                     ;

LDA CurrentMazeLayout                                       ;
ASL A                                                       ;
TAY                                                         ;
LDA MazeTunnelDataPointers_AD98,Y                           ;get maze location/width pointers
STA $97                                                     ;

LDA MazeTunnelDataPointers_AD98+1,Y                         ;
STA $98                                                     ;

LDY #$00                                                    ;
LDA #$03                                                    ;check 4 possible tunnels
STA $99                                                     ;

LOOP_9047:
LDA ($97),Y                                                 ;
STA $8B                                                     ;

INY                                                         ;
LDA ($97),Y                                                 ;
STA $8D                                                     ;
INY                                                         ;
JSR CheckGhostAlignmentWithTunnel_9060                      ;
BEQ CODE_905B                                               ;check next tunnel

LDA #$01                                                    ;
STA $89                                                     ;the ghost entered the tunnel
RTS                                                         ;

CODE_905B:
DEC $99                                                     ;
BPL LOOP_9047                                               ;
RTS                                                         ;looped through all tunnels, result - did not enter a tunnel

CheckGhostAlignmentWithTunnel_9060:
LDA Entity_CurrentTileYPosition,X                           ;check if ghost's current row position alignes with the tunnel
CMP $8B                                                     ;
BEQ CODE_906A                                               ;

LDA #$00                                                    ;cannot enter this tunnel
RTS                                                         ;

CODE_906A:
LDA Entity_CurrentTileXPosition,X                           ;check if the ghost is on the right or the left side of the screen
CMP #$10                                                    ;
BCC CODE_9078                                               ;
SBC #$20                                                    ;if in the right side, check for the right tunnel (since it's position is mirrored)
EOR #$FF                                                    ;
CLC                                                         ;
ADC #$01                                                    ;

CODE_9078:
CMP $8D                                                     ;
BPL CODE_907F                                               ;

LDA #$01                                                    ;entered the tunnel
RTS                                                         ;

CODE_907F:
LDA #$00                                                    ;did not enter the tunnel
RTS                                                         ;

;animates ghost
HandleGhostAnimation_9082:
LDA FrameCounter                                            ;animate between two frames
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
AND #$01                                                    ;
STA Entity_GFXFrame,X                                       ;

LDA Entity_Direction,X                                      ;
ASL A                                                       ;direction dictates appearance
ADC Entity_GFXFrame,X                                       ;
STA Entity_GFXFrame,X                                       ;

LDA Entity_Ghost_Character,X                                ;what ghost it is also dictates its visuals
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;
ADC Entity_GFXFrame,X                                       ;
STA Entity_GFXFrame,X                                       ;
RTS                                                         ;

;handle directional movement?
CODE_909C:
LDA Player_WhoDied                                          ;checks for death??
BEQ CODE_90A1
RTS

CODE_90A1:
LDA Entity_Direction,X                                      ;check if moving direction = left
CMP #Entity_Direction_Left
BNE CODE_90AB

JSR CODE_90C3
RTS

CODE_90AB:
CMP #Entity_Direction_Right                                 ;moving direction = right
BNE CODE_90B3

JSR CODE_911B
RTS

CODE_90B3:
CMP #Entity_Direction_Up                                    ;moving direction = up
BNE CODE_90BB
JSR CODE_916E
RTS

CODE_90BB:
CMP #Entity_Direction_Down                                  ;moving direction = down
BNE RETURN_90C2                                             ;can't interact if you're moving in an invalid direction.

JSR CODE_91C6

RETURN_90C2:
RTS

CODE_90C3:
LDA CurrentEntitySpeed
EOR #$FF
CLC
ADC #$01
STA Entity_XSpeed,X

LDA #$00
STA Entity_YSpeed,X

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDA Entity_CurrentTileXPosition,X
STA $8F
JSR CODE_A32C

LDA $20,X
BNE CODE_90EF

LDA Entity_CurrentTileXPosition,X
CMP $8F
BEQ RETURN_90EE

LDA #$01
STA $20,X

RETURN_90EE:
RTS

CODE_90EF:
LDA Entity_CurrentTileSubXPosition,x
BPL CODE_90F5
RTS

CODE_90F5:
JSR CODE_9219

LDA #$00
STA $20,X

LDA $C2
CMP #$01
BNE CODE_910B

LDA #$80
STA Entity_CurrentTileSubXPosition,x

LDA #Entity_Direction_Up
STA Entity_Direction,X

CODE_910B:
LDA $C2
CMP #$03
BNE RETURN_911A

LDA #$80
STA Entity_CurrentTileSubXPosition,x

LDA #Entity_Direction_Down
STA Entity_Direction,X

RETURN_911A:
RTS

CODE_911B:
LDA CurrentEntitySpeed
STA Entity_XSpeed,X

LDA #$00
STA Entity_YSpeed,X

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDA Entity_CurrentTileXPosition,x
STA $8F
JSR CODE_A32C

LDA $20,X
BNE CODE_9142

LDA Entity_CurrentTileXPosition,x
CMP $8F
BEQ RETURN_9142

LDA #$01
STA $20,X

RETURN_9142:
RTS

CODE_9142:
LDA Entity_CurrentTileSubXPosition,x
BMI CODE_9148
RTS

CODE_9148:
JSR CODE_9219

LDA #$00
STA $20,X

LDA $C2
CMP #$01
BNE CODE_915E

LDA #$80
STA Entity_CurrentTileSubXPosition,x

LDA #Entity_Direction_Up
STA Entity_Direction,X

CODE_915E:
LDA $C2
CMP #$03
BNE RETURN_916D

LDA #$80
STA Entity_CurrentTileSubXPosition,x

LDA #Entity_Direction_Down
STA Entity_Direction,X

RETURN_916D:
RTS

CODE_916E:
LDA CurrentEntitySpeed
EOR #$FF
CLC
ADC #$01
STA Entity_YSpeed,X

LDA #$00
STA Entity_XSpeed,X

LDA #$80
STA Entity_CurrentTileSubXPosition,x

LDA Entity_CurrentTileYPosition,x
STA $8F
JSR CODE_A32C

LDA $20,X
BNE CODE_919A

LDA Entity_CurrentTileYPosition,x
CMP $8F
BEQ RETURN_9199

LDA #$01
STA $20,X

RETURN_9199:
RTS

CODE_919A:
LDA Entity_CurrentTileSubYPosition,x
BPL CODE_91A0
RTS

CODE_91A0:
JSR CODE_9219

LDA #$00
STA $20,X

LDA $C2
CMP #$02
BNE CODE_91B6

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDA #Entity_Direction_Left
STA Entity_Direction,X

CODE_91B6:
LDA $C2
CMP #$00
BNE RETURN_91C5

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDA #Entity_Direction_Right
STA Entity_Direction,X

RETURN_91C5:
RTS

CODE_91C6:
LDA CurrentEntitySpeed
STA Entity_YSpeed,X

LDA #$00
STA Entity_XSpeed,X

LDA #$80
STA Entity_CurrentTileSubXPosition,x

LDA Entity_CurrentTileYPosition,x
STA $8F
JSR CODE_A32C

LDA $20,X
BNE CODE_91ED

LDA Entity_CurrentTileYPosition,x
CMP $8F
BEQ RETURN_91EC

LDA #$01
STA $20,X

RETURN_91EC:
RTS

CODE_91ED:
LDA Entity_CurrentTileSubYPosition,x
BMI CODE_91F3
RTS

CODE_91F3:
JSR CODE_9219

LDA #$00
STA $20,X

LDA $C2
CMP #$02
BNE CODE_9209

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDA #Entity_Direction_Left
STA Entity_Direction,X

CODE_9209:
LDA $C2
CMP #$00
BNE RETURN_9218

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDA #Entity_Direction_Right
STA Entity_Direction,X

RETURN_9218:
RTS

CODE_9219:
LDA #$00
STA $C2
STA $C3

LDA Entity_Direction,X
CMP #Entity_Direction_Right
BEQ CODE_923D

JSR CODE_8EFA
BNE CODE_923D

LDA #$02
JSR CODE_9298
STA $89
CMP $C3
BCC CODE_923D

LDA #$02
STA $C2

LDA $89
STA $C3

CODE_923D:
LDA Entity_Direction,X
CMP #Entity_Direction_Left
BEQ CODE_925B

JSR CODE_8F27
BNE CODE_925B

LDA #$00
JSR CODE_9298
STA $89
CMP $C3
BCC CODE_925B

LDA #$00
STA $C2

LDA $89
STA $C3

CODE_925B:
LDA Entity_Direction,X
CMP #Entity_Direction_Up
BEQ CODE_9279

JSR CODE_8F80
BNE CODE_9279

LDA #$03
JSR CODE_9298
STA $89
CMP $C3
BCC CODE_9279

LDA #$03
STA $C2

LDA $89
STA $C3

CODE_9279:
LDA Entity_Direction,X
CMP #Entity_Direction_Down
BEQ RETURN_9297

JSR CODE_8F54
BNE RETURN_9297

LDA #$01
JSR CODE_9298
STA $89
CMP $C3
BCC RETURN_9297

LDA #$01
STA $C2

LDA $89
STA $C3

RETURN_9297:
RTS

CODE_9298:
STA $89

JSR CODE_92CE
ASL A
ASL A
ADC $89
TAY
LDA DATA_92A6,Y
RTS

DATA_92A6:
.byte $50,$30,$20,$40,$50,$40,$20,$30
.byte $40,$50,$30,$20,$30,$50,$40,$20
.byte $20,$40,$50,$30,$20,$30,$50,$40
.byte $30,$20,$40,$50,$40,$20,$30,$50

DATA_92C6:
.byte $01,$02,$04,$03,$00,$07,$05,$06

CODE_92CE:
LDA Entity_CurrentTileYPosition,X
SEC
SBC Entity_TargetTileYPosition,X
STA $8B

LDA Entity_TargetTileXPosition,X
SEC
SBC Entity_CurrentTileXPosition,X
STA $8D

LDA #$00
STA $8F

LDA $8B
BPL CODE_92F3
EOR #$FF
CLC
ADC #$01
STA $8B

LDA #$04
STA $8F

CODE_92F3:
LDA $8D
BPL CODE_9302
EOR #$FF
CLC
ADC #$01
STA $8D

INC $8F
INC $8F

CODE_9302:
LDA $8B
CMP $8D
BMI CODE_930A

INC $8F

CODE_930A:
LDY $8F
LDA DATA_92C6,Y
RTS

HandleGhostScatterTimerAndTimedTurning_9310:
JSR CODE_9320

LDA GhostScatterTimer+1                                      ;check if done counting this timer down
BMI RETURN_931F

LDA GhostScatterTimer                                       ;
BNE CODE_931D                                               ;

DEC GhostScatterTimer+1                                     ;don't forget to tick high byte

CODE_931D:
DEC GhostScatterTimer                                       ;

RETURN_931F:
RTS                                                         ;

CODE_9320:
LDA FrameCounter                                            ;must be in 256 frame intervals
BNE RETURN_9332                                             ;

LDA FrameCounter+1                                          ;check if...
CMP #$03                                                    ;768 frames have passed
BEQ CODE_932F                                               ;ghosts will turn opposite directions
CMP #$0A                                                    ;if 2560 frames have passed...
BEQ CODE_932F                                               ;also turn around
RTS                                                         ;

CODE_932F:
JSR CODE_9333                                               ;used to make the game slightly less predictable?

RETURN_9332:
RTS                                                         ;

CODE_9333:
TXA
PHA
LDX #$0F

LOOP_9337:
LDA Entity_ID,x                                             ;check if its a ghost
CMP #Entity_ID_Ghost                                        ;
BNE CODE_9340                                               ;

JSR CODE_9346                                               ;it suddenly turns around. surprise!

CODE_9340:
DEX
BPL LOOP_9337
PLA
TAX
RTS

;I think this turns an entity the opposite way?
CODE_9346:
LDA $20,X
CMP #$02
BCS RETURN_9358

LDA Entity_Direction,X
EOR #$02
STA Entity_Direction,X

LDA $20,X
EOR #$01
STA $20,X

RETURN_9358:
RTS

EntityMainCode_CollectedItemScore_9359:
DEC $20,X
BNE CODE_9360                                               ;check if its existence timer is ticking

JSR RemoveEntity_8A5C                                       ;disappear

CODE_9360:
LDA #$00                                                    ;pretty low priority, not that important
STA Entity_DrawingPriority,X                                ;

JSR HandleEntityVisualPosition_A383                         ;
RTS                                                         ;

GhostScoreOAMProps_9369:
.byte OAMProp_Palette1,OAMProp_Palette1,OAMProp_Palette2,OAMProp_Palette2

;$04 - offset to Sue/Pinky score graphics
GhostScoreGFXFrames_936D:
.byte $00,$04,$00,$04

;ghost score code
EntityMainCode_EatenGhostScore_9371:
LDA #$0A                                                    ;
STA Entity_DrawingPriority,X                                ;give it high priority

LDY Entity_Ghost_Character,X                                ;determine what ghost has been eaten
LDA GhostScoreOAMProps_9369,Y                               ;
STA Entity_GFXProperties,X                                  ;

LDA EatenGhostCombo                                         ;visual appearance will depend on current combo
CLC                                                         ;
ADC GhostScoreGFXFrames_936D,Y                              ;and the ghost itself (color-related)
STA Entity_GFXFrame,X                                       ;

LDA NormalGhostPaletteColorIndexes_87D4,Y                   ;
TAY                                                         ;
LDA #$21                                                    ;light blue color
STA PaletteStorage,Y                                        ;

JSR HandleEntityVisualPosition_A383                         ;

DEC $20,X                                                   ;timer for this score to be alive
BNE RETURN_93A6                                             ;

LDA #Entity_ID_GhostEyes                                    ;score disappears, ghost eyes appear
STA Entity_ID,x                                             ;

LDA #$01
STA $20,X

LDA #$00
STA $0280,X

INC EatenGhostCombo                                         ;string those ghosts together for more points!

RETURN_93A6:
RTS

HandleBouncingItemSpawn_93A7:
LDA CurrentDotsRemaining+1                                  ;if there are 256+ dots remaining...
BNE RETURN_93CB                                             ;cannot spawn items

LDA BouncingItemState                                       ;see if we spawned one bouncing nitem
BNE CODE_93BB                                               ;

LDA CurrentDotsRemaining                                    ;
CMP #161                                                    ;
BNE CODE_93BB                                               ;

JSR SpawnBouncingItem_93CC                                  ;
RTS                                                         ;

CODE_93BB:
LDA BouncingItemState                                       ;see if we spawned two bouncing items
CMP #$02                                                    ;
BNE RETURN_93CB                                             ;no more

LDA CurrentDotsRemaining                                    ;
CMP #50                                                     ;
BNE RETURN_93CB                                             ;

JSR SpawnBouncingItem_93CC                                  ;

RETURN_93CB:
RTS                                                         ;

SpawnBouncingItem_93CC:
LDA #Entity_ID_BouncingItem                                 ;boing boung item!
JSR SpawnEntity_8A61                                        ;
BMI RETURN_9421                                             ;sucks to be you! you didn't spawn!

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDA CurrentMazeLayout
ASL A
TAY
LDA MazeTunnelDataPointers_AD98,Y
STA $97

LDA MazeTunnelDataPointers_AD98+1,Y
STA $98

LDY #$00
JSR PollRandomNumber_A3D8                                   ;come from the first or second tunnel, depends on the RNG
AND #$01
BEQ CODE_93F1
INY
INY

CODE_93F1:
LDA ($97),Y
STA $CF
STA Entity_CurrentTileYPosition,x

LDA #$00
STA Entity_CurrentTileSubXPosition,x
STA $CC
STA $CD

JSR GetPlayerSlot_8D75

LDA Entity_CurrentTileXPosition,Y                           ;check if the player is on the right or the left side of the screen
CMP #$10
BPL CODE_9414

LDA #Entity_Direction_Left
STA Entity_Direction,X

LDA #$1E                                                    ;spawn on the right side of the screen
CLV
BVC CODE_941A

CODE_9414:
LDA #Entity_Direction_Right
STA Entity_Direction,X

LDA #$01                                                    ;spawn on the left side of the screen

CODE_941A:
STA $CE
STA Entity_CurrentTileXPosition,x

INC BouncingItemState                                       ;this item has been spawned, maybe will spawn the next one, or none at all

RETURN_9421:
RTS                                                         ;

;palette configurations (see PaletteData.asm -> BouncingItemPalettes_8874 for the color palettes themselves)
BouncingItemPaletteIndex_9422:
.byte $02                                                   ;cherry
.byte $02                                                   ;strawberry
.byte $01                                                   ;orange
.byte $01                                                   ;pretzel
.byte $02                                                   ;apple
.byte $01                                                   ;pear
.byte $00                                                   ;banana
.byte $06                                                   ;drink
.byte $07                                                   ;ice cream
.byte $04                                                   ;high heel
.byte $08                                                   ;PA star
.byte $03                                                   ;clax
.byte $01                                                   ;ring
.byte $05                                                   ;flower

;vertical dispositions to simulate bouncing movement
BouncingItemYOffsets_9430:
.byte $00,$01,$01,$02,$02,$03,$03,$03
.byte $03,$03,$03,$02,$02,$01,$01,$00

EntityMainCode_BouncingItem_9440:
INC $CC
BNE CODE_9446

INC $CD

CODE_9446:
LDA #$08
STA Entity_DrawingPriority,X

LDA #$0C                                                    ;low speed
STA CurrentEntitySpeed                                      ;

LDA #$00
STA Entity_GFXProperties,X

JSR HandleEnteringTunnel_E459

LDA FreezeTimer
BNE CODE_9495

LDA #$10
STA Entity_TargetTileXPosition,X

LDA #$0E
STA Entity_TargetTileYPosition,X                            ;default tile on y-axis to reach

LDA $CD
CMP #$06
BCC CODE_947E

LDA $CF
STA Entity_TargetTileYPosition,X

LDA $CE
STA Entity_TargetTileXPosition,X
CMP Entity_CurrentTileXPosition,x                           ;check if aligns with current position
BNE CODE_947E

JSR RemoveEntity_8A5C                                       ;item disappears

INC BouncingItemState                                       ;it cannot reappear again

CODE_947E:
JSR CODE_909C

LDA FrameCounter
AND #$0F
BNE CODE_948E

LDA #Sound_Bounce                                           ;
JSR PlaySound_F2FF                                          ;indicate your boingy presence

LDA #$00                                                    ;

CODE_948E:
TAY
LDA BouncingItemYOffsets_9430,Y
CLV
BVC CODE_9497

CODE_9495:
LDA #$00

CODE_9497:
STA EntityVisualYOffset

JSR HandleEntityVisualPosition_A383

LDA #$00                                                    ;reset right after so nothing else is affected by bouncing shenanigans
STA EntityVisualYOffset                                     ;

LDY Player1EntitySlot
BMI CODE_94B0

LDA #$04
JSR CODE_A35B
BNE CODE_94B0

JSR ConsumedBouncingItem_94CD

CODE_94B0:
LDY Player2EntitySlot
BMI RETURN_94BE

LDA #$04
JSR CODE_A35B                                               ;check collision with player 2...?
BNE RETURN_94BE                                             ;

JSR ConsumedBouncingItem_94CD                               ;the item is eaten

RETURN_94BE:
RTS                                                         ;

BouncingItem_ScoreRewardIndexes_94BF:
.byte ScoreReward_100Pts
.byte ScoreReward_200Pts
.byte ScoreReward_500Pts
.byte ScoreReward_700Pts
.byte ScoreReward_1000Pts
.byte ScoreReward_2000Pts
.byte ScoreReward_5000Pts
.byte ScoreReward_3000Pts
.byte ScoreReward_4000Pts
.byte ScoreReward_6000Pts
.byte ScoreReward_7000Pts
.byte ScoreReward_8000Pts
.byte ScoreReward_9000Pts
.byte ScoreReward_Ten000Pts

ConsumedBouncingItem_94CD:
LDA Entity_PlayerCharacter,Y                                ;whoever touched it receives score
STA Score_RewardedPlayer                                    ;

LDY Entity_GFXFrame,X                                       ;score depends on the visual appearance of the item
LDA BouncingItem_ScoreRewardIndexes_94BF,Y                  ;
JSR GiveScore_FDB3                                          ;

LDA #Sound_ItemCollected                                    ;tastes like [insert item here]
JSR PlaySound_F2FF                                          ;

LDA #Entity_ID_ItemScore                                    ;change into score
STA Entity_ID,x                                             ;

LDA #$80                                                    ;
STA $20,X                                                   ;

INC BouncingItemState                                       ;maybe spawn the next one
RTS                                                         ;

;blink 1UP/2UP strings, animate power pellets and handle rotating palette (one strange maze)
HandleGameplayTileAnimations_94EB:
LDA FrameCounter                                            ;something every 8th frame...
AND #$07                                                    ;
BNE CODE_9508                                               ;

LDA FrameCounter                                            ;
AND #$0F                                                    ;on 16th frame it'll be an empty tile, on 8th...
BEQ CODE_94F9                                               ;

LDA #PowerPelletTile                                        ;power pellet tile

CODE_94F9:
STA $8B                                                     ;

LDY #$05                                                    ;check through all power pellets

LOOP_94FD:
LDA PowerPelletsVRAMPosLow,Y                                ;check if power pellet exists
BMI CODE_9505                                               ;

JSR UpdatePowerPelletTile_9549

CODE_9505:
DEY
BPL LOOP_94FD

CODE_9508:
LDA FrameCounter
AND #$1F
BNE CODE_953F

LDA FrameCounter                                            ;every 64th frame...
AND #$3F                                                    ;will blink 1UP or 2UP text
BNE CODE_952B

LDA CurrentPlayerConfiguration                              ;
CMP #CurrentPlayerConfiguration_Player2                     ;player 2 is currently on
BEQ CODE_951F                                               ;

LDA #TileStripeID_1UPEmpty                                  ;empty 1up string
JSR DrawTileStripes_9B80                                    ;

CODE_951F:
LDA CurrentPlayerConfiguration                              ;check if...........
BEQ CODE_9528                                               ;player 1 is on

LDA #TileStripeID_2UPEmpty                                  ;empty 2UP string
JSR DrawTileStripes_9B80                                    ;

CODE_9528:
CLV                                                         ;skip over drawing 1UP/2UP drawing since we just cleared them
BVC CODE_953F                                               ;

CODE_952B:
LDA CurrentPlayerConfiguration                              ;check if...........
CMP #$01                                                    ;player 2 is currently on
BEQ CODE_9536                                               ;

LDA #TileStripeID_1UP                                       ;draw 1UP string on the hud
JSR DrawTileStripes_9B80                                    ;

CODE_9536:
LDA CurrentPlayerConfiguration                              ;check if...........
BEQ CODE_953F                                               ;player 1 is currently on

LDA #TileStripeID_2UP                                       ;draw 2UP string on the hud
JSR DrawTileStripes_9B80                                    ;

CODE_953F:
LDA CurrentMazeLayout                                       ;
CMP #32                                                     ;this check seems pointless, because the routine has its own check for specific maze layout
BCC RETURN_9548                                             ;

JSR HandleRotatingPalette_895A                              ;special palette animation

RETURN_9548:
RTS                                                         ;

;used for animating or removing the power pellet.
UpdatePowerPelletTile_9549:
LDA #$01                                                    ;one tile
JSR EnableBufferSequencingAndUpdateTileBuffer_9AF7          ;

LDA PowerPelletsVRAMPosLow,Y                                ;get VRAM in
JSR UpdateTileBuffer_9AD0                                   ;

LDA PowerPelletsVRAMPosHigh,Y                               ;
JSR UpdateTileBuffer_9AD0                                   ;

LDA $8B                                                     ;
JSR UpdateTileBuffer_9AD0                                   ;tile in place of power-pellet (either nothing or the dot itself)
JSR DisableBufferSequencing_9AFD                            ;
RTS                                                         ;

;power-pellet related?
ConsumedPowerPellet_9563:
LDA CurrentDotsRemaining                                    ;
BNE CODE_956B                                               ;
DEC CurrentDotsRemaining+1                                  ;high byte

CODE_956B:
DEC CurrentDotsRemaining                                    ;power pellet counts as a dot

LDA #$00                                                    ;
STA $8B                                                     ;
JSR UpdatePowerPelletTile_9549                              ;replace with an empty tile

LDA #$FF                                                    ;ate this pellet
STA PowerPelletsVRAMPosLow,Y                                ;

LDA Entity_PlayerCharacter,X                                ;
STA Score_RewardedPlayer                                    ;reward this player

LDA #ScoreReward_50Pts                                      ;give score
JSR GiveScore_FDB3                                          ;

LDA #$00                                                    ;
STA EatenGhostCombo                                         ;reset c-c-combo!!!

LDY CurrentLevel                                            ;if in levels 20+
CPY #19
BCC CODE_9592

LDY #18                                                     ;fix range

CODE_9592:
LDA Options_MazeSelection                                   ;
BNE CODE_95A3                                               ;the timer of the power pellet will depend on current level

LDA DATA_EFA1,Y
CPY #19
BCC CODE_95A0

LDA #$00

CODE_95A0:
CLV
BVC CODE_95A6

CODE_95A3:
LDA DATA_EFA1,Y

CODE_95A6:
TAY
BEQ CODE_9601
STA PowerPelletTimer

LDA #$00                                                    ;default high byte
STA PowerPelletTimer+1

ASL PowerPelletTimer                                        ;
ROL PowerPelletTimer+1                                      ;

ASL PowerPelletTimer                                        ;times 4?
ROL PowerPelletTimer+1                                      ;

TXA
PHA

LDX #$0F                                                    ;

LOOP_95BB:
LDA Entity_ID,x                                             ;
CMP #Entity_ID_Ghost                                        ;check if a normal ghost is present
BNE CODE_95CC                                               ;

LDA #Entity_ID_VulnerableGhost                              ;make it vulnerable
STA Entity_ID,x                                             ;

LDA #$00                                                    ;default its gfx
STA Entity_GFXFrame,X                                       ;

JSR CODE_9346

CODE_95CC:
DEX
BPL LOOP_95BB

PLA
TAX

LDA Options_Type                                            ;
CMP #Options_Type_2PlayerCompetitive                        ;see if both players are competing against each other
BNE CODE_95F9                                               ;

LDA $0280,X                                                 ;check if the player was sad
BMI CODE_95F6                                               ;snap out of it

LDA CurrentPlayerConfiguration                              ;check if both players are present
CMP #CurrentPlayerConfiguration_BothPlayers                 ;
BNE CODE_95F3                                               ;

CPX Player1EntitySlot                                       ;check if player 1 grabbed the power pellet
BNE CODE_95EC

LDY Player2EntitySlot                                       ;make player 2 upset
CLV
BVC CODE_95EE

CODE_95EC:
LDY Player1EntitySlot                                       ;make player 1 upset

CODE_95EE:
LDA #$FF                                                    ;
STA $0280,Y                                                 ;this player can't eat dots and is sad emoji

CODE_95F3:
CLV                                                         ;
BVC CODE_95F9                                               ;

CODE_95F6:
INC $0280,X                                                 ;this player also has power pellet, ha!

CODE_95F9:
LDA #Sound_PowerPellet                                      ;
JSR PlaySound_F2FF                                          ;appropriate sound

CLV                                                         ;can be replaced with RTS
BVC RETURN_9604                                             ;

CODE_9601:
JSR CODE_9333                                               ;something about normal ghosts

RETURN_9604:
RTS                                                         ;

CODE_9605:
LDA FreezeTimer
BNE CODE_962F

LDA PowerPelletTimer                                        ;check if power pellet timer ran out
ORA PowerPelletTimer+1                                      ;
BEQ CODE_962F                                               ;

LDA PowerPelletTimer                                        ;don't forget high byte
BNE CODE_9615                                               ;

DEC PowerPelletTimer+1                                      ;

CODE_9615:
DEC PowerPelletTimer                                        ;pellet timer -1

LDA PowerPelletTimer                                        ;check if power pellet timer ran out
ORA PowerPelletTimer+1                                      ;
BNE CODE_962F                                               ;

LDX Player1EntitySlot                                       ;check if either player was powerless
BMI CODE_9626                                               ;

LDA #$00                                                    ;player 1 is feeling neutral
STA $0280,X                                                 ;

CODE_9626:
LDX Player2EntitySlot                                       ;player 2 now, are you sad?
BMI CODE_962F                                               ;

LDA #$00                                                    ;no more
STA $0280,X                                                 ;

CODE_962F:
LDA FrameCounter                                            ;every 16th frame...
AND #$0F
BNE CODE_965B

LDA $04FB
BEQ CODE_963F

LDA #Sound_GhostRetreat                                     ;
JSR PlaySound_F2FF                                          ;

CODE_963F:
LDA PowerPelletTimer
ORA PowerPelletTimer+1
ORA $04FB
BNE CODE_965B

LDA #Sound_Ghost
LDY CurrentDotsRemaining+1
BNE CODE_9658

LDY CurrentDotsRemaining                                    ;
CPY #32                                                     ;check if only 31 or less dots remain
BCS CODE_9658                                               ;

LDA #Sound_GhostFaster                                      ;sound loop but its sped up

CODE_9658:
JSR PlaySound_F2FF                                          ;

CODE_965B:
LDA PowerPelletTimer
ORA PowerPelletTimer+1
BEQ RETURN_9670

LDA $04FB
BNE RETURN_9670

LDA $04FC
BEQ RETURN_9670

LDA #Sound_PowerPellet                                      ;
JSR PlaySound_F2FF                                          ;

RETURN_9670:
RTS

SpawnGameOverStringEntity_9671:
LDA #Entity_ID_GAME_OVERString                              ;
JSR SpawnStringEntity_967D                                  ;
RTS                                                         ;

SpawnReadyStringEntity_9677:
LDA #Entity_ID_READYString                                  ;
JSR SpawnStringEntity_967D                                  ;
RTS                                                         ;

;shared by (sprite) game over and ready!
SpawnStringEntity_967D:
JSR SpawnEntity_8A61                                        ;

LDA #$20                                                    ;position
STA Entity_CurrentTileSubXPosition,x                        ;

LDA #$10                                                    ;
STA Entity_CurrentTileXPosition,x                           ;

LDA #$80                                                    ;
STA Entity_CurrentTileSubYPosition,x                        ;

LDA #$11                                                    ;
STA Entity_CurrentTileYPosition,x                           ;

JSR HandleEntityVisualPosition_A383                         ;position visually
RTS                                                         ;

EntityMainCode_GAMEOVER_9698:
LDA Options_MazeSelection                                   ;the game over text scrolls when in any maze selection but Arcade
BEQ CODE_96A0                                               ;

JSR HandleGameOverStringScrolling_96A4                      ;

CODE_96A0:
JSR HandleEntityVisualPosition_A383                         ;
RTS                                                         ;

HandleGameOverStringScrolling_96A4:
LDA Entity_CurrentTileXPosition,x                           ;check if reached this position
CMP #$10                                                    ;
BNE CODE_96B1                                               ;

LDA Entity_CurrentTileSubXPosition,x                        ;and no more pixels
BNE CODE_96B1                                               ;
RTS                                                         ;won't scroll anymore

CODE_96B1:
LDA Entity_CurrentTileSubXPosition,x                        ;
CLC                                                         ;
ADC #$20                                                    ;move right 1 pixel every frame
STA Entity_CurrentTileSubXPosition,x                        ;

LDA Entity_CurrentTileXPosition,x                           ;
ADC #$00                                                    ;
STA Entity_CurrentTileXPosition,x                           ;

LDA Entity_CurrentTileXPosition,x                           ;check if went offscreen to the right
CMP #$20                                                    ;
BNE RETURN_96CE                                             ;

LDA #$00                                                    ;appear on the left side
STA Entity_CurrentTileXPosition,x                           ;

RETURN_96CE:
RTS                                                         ;

EntityMainCode_READY_96CF:
JSR HandleEntityVisualPosition_A383                         ;do nothing but appear properly on-screen
RTS                                                         ;

ClapperAnimationFrames_96D3:
.byte $00,$01,$02,$02,$02,$02,$02,$02
.byte $02,$02,$02,$02,$02,$02,$02,$02

EntityMainCode_ClapperPart_96E3:
LDA FrameCounter                                            ;animate clapper
LSR A                                                       ;
LSR A                                                       ;
AND #$0F                                                    ;
TAY                                                         ;
LDA ClapperAnimationFrames_96D3,Y                           ;
STA Entity_GFXFrame,X                                       ;

JSR HandleEntityVisualPosition_A383                         ;
RTS                                                         ;

SpawnClapperEntity_96F3:
LDA #Entity_ID_ClapperPart
JSR SpawnEntity_8A61
BMI CODE_970E                                               ;if somehow failed, abort

LDA #$00                                                    ;
STA Entity_CurrentTileSubXPosition,x                        ;

LDA #$08                                                    ;
STA Entity_CurrentTileXPosition,x                           ;

LDA #$40                                                    ;
STA Entity_CurrentTileSubYPosition,x                        ;

LDA #$01                                                    ;
STA Entity_CurrentTileYPosition,x                           ;

CODE_970E:
JSR HandleEntityVisualPosition_A383                         ;
RTS                                                         ;

EntityMainCode_Stork_9712:
LDA FrameCounter                                            ;flap
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
AND #$01                                                    ;
STA Entity_GFXFrame,X                                       ;

LDA Entity_XPos,X                                           ;check if at a certain position
CMP #$A0                                                    ;
BCC CODE_9727                                               ;

JSR EntityMoveLeft1PX_EveryOtherFrame_9753                  ;keep flapping to the left

CLV                                                         ;
BVC CODE_972A                                               ;

CODE_9727:
JSR EntityMoveLeft1PX_975C                                  ;flap to the left but faster

CODE_972A:
LDA Entity_XPos,X                                           ;check if close to the left side of the screen
CMP #$04                                                    ;
BCS RETURN_9733                                             ;

JSR RemoveEntity_8A5C                                       ;delete

RETURN_9733:
RTS                                                         ;

SpawnCutsceneStork_9734:
LDA #Entity_ID_Stork                                        ;
JSR SpawnEntity_8A61                                        ;

LDA #$40                                                    ;
STA Entity_YPos,X                                           ;

LDA #$E0                                                    ;
STA Entity_XPos,X                                           ;

STX Player1EntitySlot                                       ;??? is player 1 a stork during act 3 cutscene? doesn't make too much sense...
RTS                                                         ;

EntityMainCode_CutsceneHeart_9744:
RTS                                                         ;functionally does nothing.

SpawnCutscenePacJunior_9745:
LDA #Entity_ID_CutscenePacJunior                            ;
JSR SpawnEntity_8A61                                        ;

LDA #$4C                                                    ;
STA Entity_YPos,X                                           ;
 
LDA #$E2                                                    ;
STA Entity_XPos,X                                           ;
RTS                                                         ;

EntityMoveLeft1PX_EveryOtherFrame_9753:
LDA FrameCounter                                            ;move every other frame
AND #$01                                                    ;
BNE RETURN_975B                                             ;

DEC Entity_XPos,X                                           ;move left 1 pixel

RETURN_975B:
RTS                                                         ;

;a very simple routine, though JSRing to this is a little wasteful, since JSR is one byte extra+cycles (and a tiny amount of space)
EntityMoveLeft1PX_975C:
DEC Entity_XPos,X                                           ;move left 1 pixel
RTS                                                         ;

;this is used for the bag bouncing after it lands on the ground. also used by ghosts in act one when they collide with one another
Entity_BounceSpeeds_975F:
.byte $02,$01,$01,$00,$00,$FF,$FF,$FE

EntityMainCode_CutscenePacJunior_9767:
LDA Entity_XPos,X
CMP #$A0
BCC CODE_9771

JSR EntityMoveLeft1PX_EveryOtherFrame_9753
RTS

CODE_9771:
LDA Entity_XPos,X
CMP #$80
BCC CODE_9782

JSR EntityMoveLeft1PX_EveryOtherFrame_9753

LDA Entity_YPos,X                                           ;plummet to earth!
CLC                                                         ;
ADC #$02                                                    ;
STA Entity_YPos,X                                           ;
RTS

CODE_9782:
LDA Entity_XPos,X                                           ;
CMP #$60                                                    ;
BCC CODE_9799                                               ;

DEC Entity_XPos,X                                           ;1 pixel up

LDA Entity_XPos,X                                           ;
LSR A                                                       ;
AND #$07                                                    ;
TAY                                                         ;
LDA Entity_BounceSpeeds_975F,Y                              ;bounce speeds
CLC                                                         ;
ADC Entity_YPos,X                                           ;simulate bouncing from impact
STA Entity_YPos,X                                           ;
RTS                                                         ;

CODE_9799:
LDA #$01                                                    ;change to normal left-facing pac-junior
STA Entity_GFXFrame,X                                       ;
RTS                                                         ;

;cutscene ghost main code
EntityMainCode_CutsceneGhost_979E:
JSR SetGhostColor_8FB0
JSR HandleGhostAnimation_9082

LDA $20,X
BNE CODE_97C4

LDA Entity_Direction,X                                      ;
CMP #Entity_Direction_Right                                 ;
BNE CODE_97B6                                               ;check if moving left or right

LDA Entity_XPos,X
CLC
ADC #$02                                                    ;go right 2 pixels
CLV
BVC CODE_97BB

CODE_97B6:
LDA Entity_XPos,X                                           ;
SEC                                                         ;
SBC #$02                                                    ;go left 2 pixels

CODE_97BB:
STA Entity_XPos,X

JSR CODE_9845
JSR RemoveEntityWhenOffscreenHorizontally_999F
RTS

CODE_97C4:
CMP #$02
BNE CODE_97DA

LDA Entity_XPos,X
CMP #$60
BCC CODE_97D6

DEC Entity_XPos,X                                           ;fo left 1 pixel

JSR HandleAct1GhostCollisionBounce_9837                     ;bounce off other ghost

CLV                                                         ;\can be replaced with RTS
BVC RETURN_97D9                                             ;/

CODE_97D6:
JSR RemoveEntity_8A5C                                       ;leave pac-man and ms.pac-man alone

RETURN_97D9:
RTS                                                         ;

CODE_97DA:
CMP #$03
BNE CODE_97F0

LDA Entity_XPos,X
CMP #$A0
BCS CODE_97EC

INC Entity_XPos,X                                           ;go right 1 pixel

JSR HandleAct1GhostCollisionBounce_9837                     ;bounce off other ghost

CLV                                                         ;\can be replaced with RTS
BVC RETURN_97EF                                             ;/

CODE_97EC:
JSR RemoveEntity_8A5C                                       ;ghost gets deleted

RETURN_97EF:
RTS                                                         ;

CODE_97F0:
CMP #$04
BNE CODE_9823

;character cast cutscene movement
LDA Entity_XPos,X                                           ;check if reached far enough to the left
CMP #$30                                                    ;
BCS CODE_9816                                               ;

LDA Entity_YPos,X                                           ;
LDY Entity_Ghost_Character,X                                ;
CMP CharacterCast_GhostYPositionTargets_9833,Y              ;the y-poisiton it should reach depends on the character
BCC CODE_980F                                               ;
SEC                                                         ;
SBC #$02                                                    ;move up two pixels
STA Entity_YPos,X                                           ;

LDA #Entity_Direction_Up                                    ;face up
STA Entity_Direction,X                                      ;

CLV
BVC CODE_9813

CODE_980F:
LDA #Entity_Direction_Right                                 ;face right
STA Entity_Direction,X

CODE_9813:
CLV                                                         ;
BVC CODE_981F                                               ;

CODE_9816:
SEC
SBC #$02                                                    ;still move left 2 pixels
STA Entity_XPos,X

LDA #Entity_Direction_Left                                  ;face left
STA Entity_Direction,X

CODE_981F:
JSR RemoveEntityWhenOffscreenHorizontally_999F              ;
RTS                                                         ;

CODE_9823:
CMP #$05                                                    ;check movement type 5 - used during TENGEN PRESENTS screen
BNE RETURN_9832                                             ;

LDA Entity_XPos,X                                           ;ZOOM!
SEC                                                         ;
SBC #$08                                                    ;8 pixels per frame
STA Entity_XPos,X                                           ;

JSR RemoveEntityWhenOffscreenHorizontally_999F              ;will be removed when it reached the left side of the screen
RTS                                                         ;

RETURN_9832:
RTS                                                         ;UNUSED RTS!!!!!!! what a find

;what y-position each ghost should stop at
CharacterCast_GhostYPositionTargets_9833:
.byte $48,$78,$58,$68

HandleAct1GhostCollisionBounce_9837:
LDA FrameCounter                                            ;
AND #$07                                                    ;
TAY                                                         ;
LDA Entity_BounceSpeeds_975F,Y                              ;simulate bouncing off
CLC                                                         ;
ADC Entity_YPos,X                                           ;
STA Entity_YPos,X                                           ;
RTS                                                         ;

CODE_9845:
LDA Entity_YPos,X
CMP #$80
BNE RETURN_9868

LDA Entity_Direction,X
CMP #Entity_Direction_Right
BNE CODE_985E

LDA Entity_XPos,X
CMP #$78
BCC CODE_985B

LDA #$02
STA $20,X

CODE_985B:
CLV
BVC RETURN_9868

CODE_985E:
LDA Entity_XPos,X
CMP #$88
BCS RETURN_9868

LDA #$03
STA $20,X

RETURN_9868:
RTS

EntityMainCode_CutscenePlayableCharacters_9869:
LDA $20,X
BNE CODE_986E                                               ;check if actually doing something
RTS                                                         ;i guess we're just chilling

CODE_986E:
CMP #$01
BNE CODE_9891

JSR SetBasePlayerHorizontalFrame_99DB
JSR CODE_99D5
JSR CODE_99B1

LDA Entity_Direction,X
CMP #Entity_Direction_Left
BNE CODE_9885

LDA #OAMProp_XFlip                                          ;flipped horizontally
STA Entity_GFXProperties,X

CODE_9885:
LDA Entity_XPos,X
CLC
ADC Entity_XSpeed,X                                         ;some speed variable
STA Entity_XPos,X

JSR RemoveEntityWhenOffscreenHorizontally_999F              ;
RTS                                                         ;

CODE_9891:
CMP #$02
BNE CODE_98B3

DEC Entity_YPos,X                                           ;move up 1 pixel

LDA #OAMProp_YFlip                                          ;flipped vertically
STA Entity_GFXProperties,X
JSR SetBasePlayerHorizontalFrame_99DB

LDA Entity_GFXFrame,X                                       ;
CLC
ADC #$04
STA Entity_GFXFrame,X
JSR CODE_99D5

LDA Entity_YPos,X
CMP #$40
BCS RETURN_98B2

LDA #$03
STA $20,X

RETURN_98B2:
RTS

CODE_98B3:
CMP #$03
BNE CODE_98EC

LDA Entity_PlayerCharacter,X                                ;check which player character
BEQ CODE_98BE

LDA #OAMProp_XFlip                                          ;pac-man is flipped horizontally, ms.pac-man is not

CODE_98BE:
STA Entity_GFXProperties,X                                  ;

JSR SetBasePlayerHorizontalFrame_99DB

LDA FrameCounter+1
CMP #$02
BCS CODE_98D2

LDA FrameCounter
CMP #$A0
BCS CODE_98D2

JSR CODE_99D5

CODE_98D2:
LDA FrameCounter+1                                          ;
CMP #$01                                                    ;
BNE RETURN_98EB                                             ;

LDA FrameCounter                                            ;
CMP #$B0                                                    ;wait for ms. pac-man and pac-man to fall in love.
BNE RETURN_98EB                                             ;

LDA #Entity_ID_Heart                                        ;love is in the air!
JSR SpawnEntity_8A61                                        ;

LDA #$78                                                    ;its spawn coordinates
STA Entity_XPos,X                                           ;

LDA #$28                                                    ;
STA Entity_YPos,X                                           ;

RETURN_98EB:
RTS

CODE_98EC:
CMP #$04
BNE CODE_9942

LDA FrameCounter+1
BNE CODE_98F8

JSR SetBasePlayerHorizontalFrame_99DB                       ;stand there for a little bit
RTS                                                         ;

CODE_98F8:
CMP #$01                                                    ;check if 256 frames passed
BNE CODE_991E                                               ;

LDA FrameCounter                                            ;will wave after 128 frames
BPL CODE_9917

LDA Entity_PlayerCharacter,X                                ;depending on pac-man or ms. pac-man, the frames will be different, naturally
ASL A                                                       ;
ADC #$33                                                    ;waving frames base
STA $89                                                     ;

LDA FrameCounter                                            ;change frame every now and then
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
AND #$01                                                    ;
CLC                                                         ;
ADC $89                                                     ;
STA Entity_GFXFrame,X                                       ;make (ms.) pac-man wave

CLV                                                         ;\can be replaced with RTS
BVC RETURN_991D                                             ;/

CODE_9917:
JSR SetBasePlayerHorizontalFrame_99DB                       ;stand in place...
JSR CODE_99D5                                               ;but also animate moving (animate every other frame)

RETURN_991D:
RTS                                                         ;

CODE_991E:
LDA FrameCounter                                            ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
AND #$07                                                    ;
CLC
ADC #$23                                                    ;base for flying up frames
LDY Entity_PlayerCharacter,X
BEQ CODE_9931
CLC
ADC #$08                                                    ;jump over ms. pac-man's frames if mr.

CODE_9931:
STA Entity_GFXFrame,X                                       ;display into sky or into sunset frames... even though there's neither sky or sunset, only black matter... but you know what I mean

LDA Entity_YPos,X                                           ;
SEC                                                         ;
SBC #$02                                                    ;move up 2 pixels
STA Entity_YPos,X                                           ;
CMP #$40                                                    ;until they reach above this point, they'll continue moving.
BCS RETURN_9941                                             ;

JSR RemoveEntity_8A5C                                       ;delete them from existence

RETURN_9941:
RTS                                                         ;

CODE_9942:
CMP #$05
BNE CODE_996D

JSR SetBasePlayerHorizontalFrame_99DB                       ;set base horizontal movement frame
JSR CODE_99D5                                               ;adjust it to one of the horizontal movement frames

LDA Entity_Direction,X                                      ;see if moving left
CMP #Entity_Direction_Left
BNE CODE_9956

LDA #OAMProp_XFlip                                          ;flip the image
STA Entity_GFXProperties,X                                  ;

CODE_9956:
LDA Entity_XPos,X
CLC
ADC Entity_XSpeed,X
STA Entity_XPos,X

LDA Entity_XPos,X
CMP #$70
BCC RETURN_996C
CMP #$90
BCS RETURN_996C

LDA #$04
STA $20,X

RETURN_996C:
RTS

CODE_996D:
CMP #$06
BNE RETURN_999C

JSR SetBasePlayerHorizontalFrame_99DB

LDA Entity_XPos,X
LDY Entity_PlayerCharacter,X                                ;
CMP DATA_999D,Y
BCC CODE_9993

JSR CODE_99D5

LDA #OAMProp_XFlip
STA Entity_GFXProperties,X

LDA Entity_XPos,X
CLC
ADC Entity_XSpeed,X
STA Entity_XPos,X

JSR RemoveEntityWhenOffscreenHorizontally_999F

CLV
BVC RETURN_999B

CODE_9993:
CPY #Player_Character_PacMan
BNE RETURN_999B

LDA #$00                                                    ;pac-man is not flipped at all (or behind the background)
STA Entity_GFXProperties,X

RETURN_999B:
RTS

;ANOTHER UNUSED RTS!! POG
RETURN_999C:
RTS

DATA_999D:
.byte $8A,$76

RemoveEntityWhenOffscreenHorizontally_999F:
LDA Entity_XPos,X                                           ;to the far right?
CMP #$FC                                                    ;
BCC CODE_99A9                                               ;

JSR RemoveEntity_8A5C                                       ;delete
RTS                                                         ;

CODE_99A9:
CMP #$04                                                    ;to the far left?
BCS RETURN_99B0                                             ;

JSR RemoveEntity_8A5C                                       ;also delete

RETURN_99B0:
RTS                                                         ;

CODE_99B1:
LDA Entity_YPos,X
CMP #$80
BNE RETURN_99D4

LDA Entity_Direction,X
CMP #Entity_Direction_Right
BNE CODE_99CA

LDA Entity_XPos,X
CMP #$74
BCC CODE_99C7

LDA #$02
STA $20,X

CODE_99C7:
CLV
BVC RETURN_99D4

CODE_99CA:
LDA Entity_XPos,X
CMP #$8C
BCS RETURN_99D4

LDA #$02
STA $20,X

RETURN_99D4:
RTS

CODE_99D5:
LDA FrameCounter
LSR A
JMP CODE_E07D

SetBasePlayerHorizontalFrame_99DB:
LDA Entity_PlayerCharacter,X                                ;check if ms. pac-man character
BEQ CODE_99E2                                               ;base frame is 0

LDA #$10                                                    ;start from pac-man horizontal frames

CODE_99E2:
STA Entity_GFXFrame,X                                       ;
RTS                                                         ;

EntityMainCode_PacJunior_99E5:
LDA Entity_Direction,X                                      ;all of the frames are just directional
STA Entity_GFXFrame,X                                       ;

LDA #$40                                                    ;fast one!
STA CurrentEntitySpeed

JSR PollRandomNumber_A3D8
AND #$0F
STA Entity_TargetTileYPosition,X                            ;random tile on y-axis to reach

LDA #$10
STA Entity_TargetTileXPosition,X                            ;fixed tile on x-axis to reach

JSR CODE_909C

LDA #$00
STA Entity_GFXProperties,X
JSR HandleEnteringTunnel_E459
JSR HandleEntityVisualPosition_A383

LDY Player1EntitySlot
BMI CODE_9A15

LDA #$04
JSR CODE_A35B
BNE CODE_9A15

JSR PacJunior_RewardPlayer_9A24

CODE_9A15:
LDY Player2EntitySlot
BMI RETURN_9A23

LDA #$04
JSR CODE_A35B
BNE RETURN_9A23

JSR PacJunior_RewardPlayer_9A24

RETURN_9A23:
RTS

;collect pac junior for score
PacJunior_RewardPlayer_9A24:
LDA Entity_PlayerCharacter,Y                                ;whichever player touched it receives score
STA Score_RewardedPlayer                                    ;

LDA #ScoreReward_5000Pts                                    ;
JSR GiveScore_FDB3                                          ;

LDA #Sound_ItemCollected                                    ;tastes like... wait, we don't eat them.
JSR PlaySound_F2FF                                          ;

LDA #Entity_ID_ItemScore                                    ;turn into score
STA Entity_ID,x                                             ;

LDA #$06
STA Entity_GFXFrame,X

LDA #$80
STA $20,X
RTS

EnableRender_9A41:
LDA #$1E                                                    ;show sprites and background, including on leftmost 8px of the screen
STA RenderMirror                                            ;

LOOP_9A45:
LDA HardwareStatus                                          ;wait a frame...
BPL LOOP_9A45                                               ;
RTS                                                         ;

DisableRender_9A4B:
LDA #$00                                                    ;
STA RenderMirror                                            ;

LOOP_9A4F:
LDA HardwareStatus                                          ;wait a frame...
BPL LOOP_9A4F                                               ;
RTS                                                         ;

;also resets buffer things, just so you know
;and supposedly disables rendering, but it's weird (you still have to do it with a separate routine)
DisableNMI_9A55:
LDA #$10                                                    ;disable NMI
STA ControlBits                                             ;

LOOP_9A5A:
LDA HardwareStatus                                          ;wait a frame...
BPL LOOP_9A5A                                               ;

LDA #$00                                                    ;no rendering (directly to register)
STA RenderBits                                              ;or so I think?

BIT HardwareStatus                                          ;

LOOP_9A67:
LDA HardwareStatus                                          ;you guessed it, wait a frame...
BPL LOOP_9A67                                               ;

JSR ResetBufferVariables_9AC1                               ;iniitalize buffer
RTS                                                         ;

;what's the point of this? it waits for an NMI, but control mirror and render mirror values are already stored there, we don't need to store them again here?
;in fact, removing this routine doesn't break anything from what I can tell...
;Unless control mirror is set to disable NMI, but still, why?
StoreToControlAndRenderRegs_9A70:
LDA ControlMirror                                           ;
STA ControlBits                                             ;

LOOP_9A75:
LDA HardwareStatus                                          ;wait for the frame to pass...
BPL LOOP_9A75                                               ;

LDA RenderMirror                                            ;update rendering bits
STA RenderBits                                              ;

LOOP_9A7F:
LDA HardwareStatus                                          ;wait for the frame to pass... wake me up when it does, 'kay?
BPL LOOP_9A7F                                               ;
RTS                                                         ;

;Unused call to clear first screen only
UNUSED_9A85:
LDA #$00                                                    ;
JSR FillFirstScreen_9A91                                    ;
RTS                                                         ;

;Unused call to clear second screen only
UNUSED_9A8B:
LDA #$00                                                    ;
JSR FillSecondScreen_9AAC                                   ;
RTS                                                         ;

;fill first screen
FillFirstScreen_9A91:
STA $89                                                     ;

LDA #$20                                                    ;
STA VRAMPointerReg                                          ;

CODE_9A98:
LDA #$00                                                    ;
STA VRAMPointerReg                                          ;

TAX                                                         ;
LDY #$04                                                    ;
LDA $89                                                     ;

LOOP_9AA2:
STA VRAMUpdateRegister                                      ;
DEX                                                         ;
BNE LOOP_9AA2                                               ;

DEY                                                         ;still more to draw
BNE LOOP_9AA2                                               ;
RTS                                                         ;

FillSecondScreen_9AAC:
STA $89                                                     ;

LDA #$28                                                    ;second screen at VRAM $2800
STA VRAMPointerReg                                          ;
JMP CODE_9A98                                               ;

;Input A - tile with which the screens will be filled
;by default it's used to clear screens with empty tiles, but it can be used with any other tile
FillScreens_9AB6:
STA $89                                                     ;

JSR FillFirstScreen_9A91                                    ;

LDA $89                                                     ;
JSR FillSecondScreen_9AAC                                   ;bucket fill
RTS                                                         ;

;default tile buffer stuff
ResetBufferVariables_9AC1:
LDA #>TileBuffer                                            ;start from ground zero
STA TileBuffer_Pointer+1                                    ;
STA TileBuffer_Pointer2+1                                   ;

LDA #<TileBuffer                                            ;
STA TileBuffer_Pointer                                      ;
STA TileBuffer_Pointer2                                     ;
STA TileBuffer_SequenceFlag                                 ;reset this flag to apply all changes
RTS                                                         ;

;one change at a time
UpdateTileBuffer_9AD0:
STA $89                                                     ;

TYA                                                         ;
PHA                                                         ;

LDY #$00                                                    ;
LDA $89                                                     ;stuff this tile in there
STA (TileBuffer_Pointer2),Y                                 ;

INC TileBuffer_Pointer2                                     ;

PLA                                                         ;
TAY                                                         ;

LDA TileBuffer_Pointer2                                     ;check if we exceed the buffer
SEC                                                         ;
SBC TileBuffer_Pointer                                      ;
CMP #$C0                                                    ;
BCC RETURN_9AF6                                             ;if not, continue updating buffer stuff

LDA TileBuffer_SequenceFlag                                 ;
PHA                                                         ;

LDA #$00                                                    ;apply the changes we already had in there to free space for new ones
STA TileBuffer_SequenceFlag                                 ;

LOOP_9AEE:
LDA HardwareStatus                                          ;wait for NMI
BPL LOOP_9AEE                                               ;

PLA                                                         ;
STA TileBuffer_SequenceFlag                                 ;restore this flag

RETURN_9AF6:
RTS                                                         ;

;input A - amount of tiles to update
EnableBufferSequencingAndUpdateTileBuffer_9AF7:
INC TileBuffer_SequenceFlag                                 ;

JSR UpdateTileBuffer_9AD0                                   ;
RTS                                                         ;

DisableBufferSequencing_9AFD:
DEC TileBuffer_SequenceFlag                                 ;disable sequencing of buffered writes
RTS                                                         ;

;single tile update
;input A - tile
;$8F-$90 - VRAM position to draw this tile at
SingleTileIntoBuffer_9B00:
PHA                                                         ;
LDA #$01                                                    ;we'll be writing one tile
JSR EnableBufferSequencingAndUpdateTileBuffer_9AF7          ;

LDA $90                                                     ;deposit VRAM pos
JSR UpdateTileBuffer_9AD0                                   ;

LDA $8F                                                     ;still VRAM...
JSR UpdateTileBuffer_9AD0                                   ;

PLA
JSR UpdateTileBuffer_9AD0                                   ;finally, add the tile in
JSR DisableBufferSequencing_9AFD                            ;over, can now apply it
RTS                                                         ;

;takes stuff out of the tile update buffer and writes changes, if necessary
UpdateVRAM_9B18:
STA $8D                                                     ;how many things we can update at once

LDA TileBuffer_SequenceFlag                                 ;check if we're recording more VRAM changes...
BNE RETURN_9B35                                             ;don't draw anything yet!

LDA #$00                                                    ;
STA $89                                                     ;

LOOP_9B22:
LDX TileBuffer_Pointer                                      ;see if both buffer offsets are created equal
CPX TileBuffer_Pointer2                                     ;
BEQ RETURN_9B2E                                             ;

JSR WriteToPPU_9B36                                         ;update video random access memory (UVRAM)

CLV                                                         ;
BVC CODE_9B2F                                               ;

RETURN_9B2E:
RTS                                                         ;

CODE_9B2F:
LDA $89                                                     ;
CMP $8D                                                     ;check if updated enough for now
BCC LOOP_9B22                                               ;

RETURN_9B35:
RTS                                                         ;bail!

WriteToPPU_9B36:
LDY #$00                                                    ;
LDA (TileBuffer_Pointer),Y                                  ;check if we're drawing one tile only
CMP #$01                                                    ;
BNE CODE_9B58                                               ;

INC TileBuffer_Pointer                                      ;
LDA (TileBuffer_Pointer),Y                                  ;
STA VRAMPointerReg                                          ;VRAM first

INC TileBuffer_Pointer                                      ;
LDA (TileBuffer_Pointer),Y                                  ;
STA VRAMPointerReg                                          ;VRAM still

INC TileBuffer_Pointer                                      ;
LDA (TileBuffer_Pointer),Y                                  ;
STA VRAMUpdateRegister                                      ;draw this tile

INC $89                                                     ;
INC TileBuffer_Pointer                                      ;
RTS                                                         ;

CODE_9B58:
CMP #$03                                                    ;check if the draw mode is 3 (until $FF is encountered)
BNE RETURN_9B7F                                             ;note that there are no modes 0, 1 or 2. Any other value means we aren't doing an update

INC TileBuffer_Pointer                                      ;
LDA (TileBuffer_Pointer),Y                                  ;
STA VRAMPointerReg                                          ;VRAM first

INC TileBuffer_Pointer                                      ;
LDA (TileBuffer_Pointer),Y                                  ;
STA VRAMPointerReg                                          ;VRAM second

LOOP_9B6A:
INC TileBuffer_Pointer                                      ;
LDA (TileBuffer_Pointer),Y                                  ;
CMP #$FF                                                    ;check if we encountered a break command
BEQ CODE_9B7A                                               ;
STA VRAMUpdateRegister                                      ;tile the third

INC $89                                                     ;

CLV                                                         ;
BVC CODE_9B7D                                               ;

CODE_9B7A:
INC TileBuffer_Pointer                                      ;
RTS                                                         ;

CODE_9B7D:
BNE LOOP_9B6A                                               ;

RETURN_9B7F:
RTS                                                         ;useless

;This routine is used to draw a stripe or multiple stripes of tiles, usually text strings
;Input A - pointer for stripe data
DrawTileStripes_9B80:
ASL A                                                       ;
TAY                                                         ;
LDA TileStripeDataPointers_A098,Y                           ;data pointer
STA $91                                                     ;

LDA TileStripeDataPointers_A098+1,Y                         ;
STA $92                                                     ;

LDY #$00                                                    ;

LOOP_9B8E:
LDA ($91),Y                                                 ;check if encountered a zero
BEQ RETURN_9BB7                                             ;end drawing
CMP #$FF                                                    ;check if encountered $FF
BNE CODE_9BA7                                               ;

;not possible to trigger (same result as non-zero??? it simply skips the $FF and draws stuff after)
INY                                                         ;
LDA ($91),Y                                                 ;
STA $8F                                                     ;VRAM position

INY                                                         ;
LDA ($91),Y                                                 ;
STA $90                                                     ;

INY
JSR CODE_9BB8

CLV                      
BVC CODE_9BB4                

CODE_9BA7:
LDA ($91),Y
STA $8F

INY
LDA ($91),Y
STA $90

INY
JSR CODE_9BB8                                               ;actually go draw them

CODE_9BB4:
SEC
BCS LOOP_9B8E

RETURN_9BB7:
RTS

CODE_9BB8:
LDA #$03                                                    ;draw multiple tiles
JSR EnableBufferSequencingAndUpdateTileBuffer_9AF7

LDA $90                                                     ;VRAM locations
JSR UpdateTileBuffer_9AD0                                   ;

LDA $8F                                                     ;
JSR UpdateTileBuffer_9AD0                                   ;

LOOP_9BC7:
LDA ($91),Y
INY
CMP #$FF                                                    ;check if encountered a break
BEQ CODE_9BE1                                               ;stop drawing the row, maybe move onto the next one or just stop drawing altogether

CMP #GFX_FontTiles                                          ;I guess if you wanted to directly paste these font graphics, you could!
BCS CODE_9BDB                                               ;but this is used for non-font tiles that don't need offset

CMP #$20                                                    ;check for empty space
BNE CODE_9BD8                                               ;

LDA #GFX_FontTiles+UTFFontStart                             ;this will result in drawing tile $00 (empty space), because of overflow by adding FontTileOffset

CODE_9BD8:
CLC                                                         ;
ADC #FontTileOffset                                         ;conviniently offset to the correct placement of the font (I guess the programmer couldn't define their character set in their enviorement and had to work with UTF-8 format. at least the text is readable in hex editor)

CODE_9BDB:
JSR UpdateTileBuffer_9AD0                                   ;put it in a buffer

SEC                                                         ;similar to CLV:BVC, but it's SEC:BCS now
BCS LOOP_9BC7                                               ;

CODE_9BE1:
JSR UpdateTileBuffer_9AD0                                   ;put that break command in there
JSR DisableBufferSequencing_9AFD                            ;that's all, will draw all the stuff next time
RTS                                                         ;

;moved for ease of search and editing
.include "Data/StringAndStripeDataLoader.asm"

;should be self-explanatory, polls both players' controllers for inputs and related stuff
HandleControllerInputs_A10A:
LDA Player1Inputs                                           ;inputs from last frame...
STA Player1Inputs_LastFrame                                 ;go into inputs from last frame! makes sense

LDA Player2Inputs                                           ;
STA Player2Inputs_LastFrame                                 ;

LDX #$FF                                                    ;reset controller shenanigans
STX ControllerReg                                           ;
STX ControllerReg+1                                         ;
INX                                                         ;
STX ControllerReg                                           ;reset controller shenanigans AND inputs for this frame
STX ControllerReg+1                                         ;
STX Player1Inputs                                           ;
STX Player2Inputs                                           ;

;poll controller inputs
LDX #$07                                                    ;

LOOP_A127:
LDA ControllerReg                                           ;get inputs from controller 1
LSR A                                                       ;
ROR Player1Inputs                                           ;for player 1, naturally

LDA ControllerReg+1                                         ;get inputs from controller 2
LSR A                                                       ;
ROR Player2Inputs                                           ;

DEX                                                         ;loop until all buttons are done
BPL LOOP_A127                                               ;

LDA Player1ReverseControlFlag                               ;check if should reverse player controls
BEQ CODE_A153

LDA Player1Inputs                                           ;reverse player 1 controls
ASL A                                                       ;
AND #Input_Down|Input_Right                                 ;
STA $89                                                     ;

LDA Player1Inputs
LSR A
AND #Input_Up|Input_Left
ORA $89
STA $89

LDA Player1Inputs
AND #Input_AllNonDirectional
ORA $89                                                     ;
STA Player1Inputs                                           ;final inputs

CODE_A153:
LDA Player2ReverseControlFlag                               ;do the same for player 2
BEQ CODE_A170                                               ;

LDA Player2Inputs                                           ;change 
ASL A
AND #Input_Down|Input_Right                                 ;we'll swap down and right
STA $89

LDA Player2Inputs
LSR A
AND #Input_Up|Input_Left                                    ;reverse right and down as up and down and vice verase
ORA $89
STA $89

LDA Player2Inputs
AND #Input_AllNonDirectional                                ;A/B/Pause/Select remain the same
ORA $89
STA Player2Inputs

CODE_A170:
JSR HandleDemoInputs_A2DD                                   ;automated inputs in demo mode (directionals)

LDA Player1Inputs_LastFrame                                 ;
EOR #$FF                                                    ;
AND Player1Inputs                                           ;get the difference between last frame's inputs and new ones
STA Player1Inputs_Press                                     ;store input presses for player 1

LDA Player2Inputs_LastFrame                                 ;
EOR #$FF                                                    ;
AND Player2Inputs                                           ;
STA Player2Inputs_Press                                     ;store input presses for player 2

LDA Player1Inputs                                           ;
ORA Player2Inputs                                           ;
STA PlayersInputs                                           ;combine buttons held on both controllers

LDA Player1Inputs_Press                                     ;
ORA Player2Inputs_Press                                     ;
STA PlayersInputs_Press                                     ;combine presses on both controllers

LDA Player1Inputs
AND #Input_AllDirectional
BEQ CODE_A1D8

LDA Player1Inputs_Press
AND #Input_Left
BEQ CODE_A19F

LDA #Input_Left
STA Player1DirectionalInput

CODE_A19F:
LDA Player1Inputs_Press
AND #Input_Right
BEQ CODE_A1A9

LDA #Input_Right
STA Player1DirectionalInput

CODE_A1A9:
LDA Player1Inputs_Press
AND #Input_Up
BEQ CODE_A1B3

LDA #Input_Up
STA Player1DirectionalInput

CODE_A1B3:
LDA Player1Inputs_Press
AND #Input_Down
BEQ CODE_A1BD

LDA #Input_Down
STA Player1DirectionalInput

CODE_A1BD:
LDA Player1DirectionalInput
LDX Player1Inputs
CPX #Input_Left
BNE CODE_A1C6

TXA

CODE_A1C6:
CPX #Input_Right
BNE CODE_A1CB

TXA

CODE_A1CB:
CPX #Input_Up
BNE CODE_A1D0

TXA

CODE_A1D0:
CPX #Input_Down
BNE CODE_A1D5

TXA

CODE_A1D5:
CLV
BVC CODE_A1DA

CODE_A1D8:
LDA #$00

CODE_A1DA:
STA Player1DirectionalInput

LDA Player2Inputs                                           ;check if pressed any of the directionals
AND #Input_AllDirectional
BEQ CODE_A225

LDA Player2Inputs_Press
AND #Input_Left
BEQ CODE_A1EC

LDA #Input_Left
STA Player2DirectionalInput

CODE_A1EC:
LDA Player2Inputs_Press
AND #Input_Right
BEQ CODE_A1F6

LDA #Input_Right
STA Player2DirectionalInput

CODE_A1F6:
LDA Player2Inputs_Press
AND #Input_Up
BEQ CODE_A200

LDA #Input_Up
STA Player2DirectionalInput

CODE_A200:
LDA Player2Inputs_Press
AND #Input_Down
BEQ CODE_A20A

LDA #Input_Down
STA Player2DirectionalInput

CODE_A20A:
LDA Player2DirectionalInput
LDX Player2Inputs
CPX #Input_Left
BNE CODE_A213

TXA

CODE_A213:
CPX #Input_Right
BNE CODE_A218

TXA

CODE_A218:
CPX #Input_Up
BNE CODE_A21D

TXA

CODE_A21D:
CPX #Input_Down
BNE CODE_A222

TXA

CODE_A222:
CLV
BVC CODE_A227

CODE_A225:
LDA #$00

CODE_A227:
STA Player2DirectionalInput

LDA Player1Inputs                                           ;check if the player enters A+B+Start+Select
AND #Input_AllNonDirectional
CMP #Input_AllNonDirectional
BNE RETURN_A234

JMP SoftReset_8099                                          ;trigger soft reset

RETURN_A234:
RTS

;limit all inputs to A, B, Select and Start
DisableDPadInputs_Player1_A235:
LDA Player1Inputs                                           ;
AND #Input_A|Input_B|Input_Select|Input_Start               ;
STA Player1Inputs                                           ;

LDA Player1Inputs_Press                                     ;
AND #Input_A|Input_B|Input_Select|Input_Start               ;
STA Player1Inputs_Press                                     ;

LDA Player1DirectionalInput                                 ;this is pointless, because these addresses only hold one direction bit
AND #Input_A|Input_B|Input_Select|Input_Start               ;as you can imagine, D-pad direction != A, B, Select or Start
STA Player1DirectionalInput                                 ;
RTS                                                         ;

;same as above but for player 2
DisableDPadInputs_Player2_A248:
LDA Player2Inputs
AND #Input_A|Input_B|Input_Select|Input_Start
STA Player2Inputs

LDA Player2Inputs_Press
AND #Input_A|Input_B|Input_Select|Input_Start
STA Player2Inputs_Press

LDA Player2DirectionalInput                                 ;this is pointless, because I explained that above
AND #Input_A|Input_B|Input_Select|Input_Start               ;
STA Player2DirectionalInput                                 ;
RTS                                                         ;

.include "Data/DemoInputs.asm"

;Demo Mode related
HandleDemoInputs_A2DD:
LDA DemoMovementIndex                                       ;is demo mode on?
BNE CODE_A2E2                                               ;
RTS                                                         ;demo mode not on

CODE_A2E2:
DEC DemoMovementTiming                                      ;see if should move still
BNE CODE_A2F8                                               ;

LDY DemoMovementIndex                                       ;
INY                                                         ;
INY                                                         ;
STY DemoMovementIndex                                       ;
CPY #$84                                                    ;???
BNE CODE_A2F2                                               ;

LDY #$02                                                    ;fix the timing (the input itself will be different anyway)

CODE_A2F2:
INY                                                         ;
LDA DemoMovementData_A25B-2,Y                               ;how long to hold the (lack of) input(s)
STA DemoMovementTiming                                      ;

CODE_A2F8:
LDY DemoMovementIndex                                       ;
LDA DemoMovementData_A25B-2,Y                               ;
STA $89                                                     ;input

LDA Player1Inputs                                           ;
AND #Input_AllNonDirectional                                ;the player themselves have to press any of the non-directional buttons
ORA $89                                                     ;directional inputs
STA Player1Inputs                                           ;
RTS                                                         ;

CODE_A308:
LDA Entity_CurrentTileSubXPosition,x
CLC
ADC $89
STA Entity_CurrentTileSubXPosition,x

LDA Entity_CurrentTileXPosition,x
ADC $8A
STA Entity_CurrentTileXPosition,x
RTS

CODE_A31A:
LDA Entity_CurrentTileSubYPosition,x
CLC
ADC $89
STA Entity_CurrentTileSubYPosition,x

LDA Entity_CurrentTileYPosition,x
ADC $8A
STA Entity_CurrentTileYPosition,x
RTS

;handle movement i think
CODE_A32C:
LDA Entity_XSpeed,X
JSR CODE_A339

LDA Entity_YSpeed,X
JSR CODE_A34A
RTS

CODE_A339:
STA $89
BPL CODE_A342

LDA #$FF
CLV
BVC CODE_A344

CODE_A342:
LDA #$00

CODE_A344:
STA $8A
JSR CODE_A308
RTS

CODE_A34A:
STA $89
BPL CODE_A353

LDA #$FF
CLV
BVC CODE_A355

CODE_A353:
LDA #$00

CODE_A355:
STA $8A

JSR CODE_A31A
RTS

;collision or something?
CODE_A35B:
STA $89
ASL A
STA $8A

LDA Entity_XPos,X
ADC $89
SEC
SBC Entity_XPos,Y
BMI CODE_A380
CMP $8A
BCS CODE_A380

LDA Entity_YPos,X
ADC $89
SEC
SBC Entity_YPos,Y
BMI CODE_A380
CMP $8A
BCS CODE_A380

LDA #$00
STA $89

CODE_A380:
LDA $89
RTS

;place the entity in the world, at least visually
HandleEntityVisualPosition_A383:
LDA CameraPositionY                                         ;current camera position
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;divide by 8 to align to the row it's on
STA $89                                                     ;

LDA Entity_CurrentTileYPosition,X                           ;current row
CLC                                                         ;
ADC #$08                                                    ;+8
SEC                                                         ;
SBC $89                                                     ;if the entity is just under the camera
BPL CODE_A39A                                               ;

LDA #$00                                                    ;above the display area, offscreen
STA Entity_YPos,X                                           ;
RTS                                                         ;

CODE_A39A:
CMP #$1E                                                    ;check if below the camera
BMI CODE_A3A3                                               ;

LDA #$F4                                                    ;below display area, offscreen
STA Entity_YPos,X                                           ;
RTS                                                         ;

CODE_A3A3:
LDA Entity_CurrentTileXPosition,X                           ;current tile on the same row
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;*8
STA $89                                                     ;to get entity's true x-position

LDA Entity_CurrentTileSubXPosition,x
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;divide by 32
CLC                                                         ;
ADC $89                                                     ;to get sub position within 8x8 tile (slight offset)
STA Entity_XPos,X                                           ;to get an even truer x-posiiton

LDA Entity_CurrentTileYPosition,X                           ;
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;multiply by 8 to get its position aligning with an 8x8 tile that it's on
CLC                                                         ;
ADC #$3F                                                    ;always below the camera?
SEC                                                         ;
SBC CameraPositionY                                         ;make sure that it's relative to the camera
STA $89                                                     ;

LDA Entity_CurrentTileSubYPosition,x
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;divide by 32
CLC                                                         ;
ADC $89                                                     ;
SEC                                                         ;
SBC EntityVisualYOffset                                     ;additional Y-pos offset, used by e.g. bouncing item to simulate bouncing movement
STA Entity_YPos,X                                           ;
RTS                                                         ;

;this might be the game's RNG (pseudorandom).
;output A and RNG_Value - "random" number.
PollRandomNumber_A3D8:
LDA RNG_Value                                               ;
LSR A                                                       ;
BCC CODE_A3DF                                               ;
EOR #$B8                                                    ;

CODE_A3DF:
BNE CODE_A3E4                                               ;

LDA TrueFrameCounter                                        ;shake things up every once in a while

CODE_A3E4:
STA RNG_Value                                               ;
RTS                                                         ;

;a bunch of graphical data, moved to separate files so it looks neater and to make it easier to edit specific frames by storing them in specific files

.include "Data/SpriteGFXFrameData/MsAndPacManFrames.asm"
.include "Data/SpriteGFXFrameData/GhostFrames.asm"
.include "Data/SpriteGFXFrameData/BouncingItemFrames.asm"
.include "Data/SpriteGFXFrameData/BouncingItemScoreFrames.asm"
.include "Data/SpriteGFXFrameData/GhostScoreFrames.asm"
.include "Data/SpriteGFXFrameData/GhostEyesFrames.asm"
.include "Data/SpriteGFXFrameData/PacJuniorFrames.asm"
.include "Data/SpriteGFXFrameData/GameOverStringFrames.asm"
.include "Data/SpriteGFXFrameData/ReadyStringFrames.asm"
.include "Data/SpriteGFXFrameData/CutsceneClapperFrames.asm"
.include "Data/SpriteGFXFrameData/CutsceneStorkFrames.asm"
.include "Data/SpriteGFXFrameData/CutsceneHeartFrames.asm"
.include "Data/SpriteGFXFrameData/CutscenePacJuniorFrames.asm"

EntityGFXData_DrawNothing_AD4C:
.byte $00                                                    ;draw 0 tiles, which means... nothing!

;max camera y-positions depending on maze height, how far the camera can scroll down
CameraBottomBoundaryPerMazeHeight_AD4D:
.byte $38,$68,$98

;Maze height levels.
;0 - Short
;1 - Medium
;2 - Tall
;Used to place the bottom part of the HUD correctly
MazeLayoutHeightLevels_AD50:
.byte $01,$01,$01,$01
.byte $00,$00,$00,$00
.byte $02,$02,$02,$02
.byte $02,$02,$02,$02
.byte $01,$01,$01,$01
.byte $01,$01,$01,$01
.byte $01,$01,$01,$01
.byte $02,$02,$00,$00
.byte $01,$01,$01,$02

;the tile on y-axis on which the player spawns when loading a maze.
PlayerStartingYPositionsPerMazeLayout_AD74:
.byte $17,$17,$17,$17,$17,$17,$14,$17
.byte $1D,$20,$1D,$1D,$1E,$17,$1D,$1D
.byte $17,$17,$17,$17,$17,$17,$17,$17
.byte $17,$17,$17,$17,$1D,$1D,$17,$17
.byte $1A,$17,$17,$20

;maze layout stuff in these files
.include "Data/MazeTunnelData.asm"
.include "Data/MazeLayoutLoader.asm"

;base movement frames for player characters, depending on moving direction
DATA_DF00:
.byte $00,$04,$00,$04

;flips
DATA_DF04:
.byte $00,OAMProp_YFlip,OAMProp_XFlip,$00

;set graphical appearance based on direction
CODE_DF08:
TAY
LDA DATA_DF00,Y
STA Entity_GFXFrame,X

JSR SetPlayerEntityBaseGFXFrame_DF1D

LDA DATA_DF04,Y
STA Entity_GFXProperties,X

JSR CODE_E089
JSR HandleEntityVisualPosition_A383
RTS

SetPlayerEntityBaseGFXFrame_DF1D:
LDA Entity_PlayerCharacter,X                                ;check if pac-man
BEQ RETURN_DF29                                             ;if not, leave this routine

LDA Entity_GFXFrame,X                                       ;offset pac-man's graphical appearance so he looks like... well, pac-man.
CLC                                                         ;
ADC #$10                                                    ;
STA Entity_GFXFrame,X                                       ;

RETURN_DF29:
RTS                                                         ;

DATA_DF2A:
.byte $01,$01,$01,$01,$02,$03,$00,$01
.byte $02,$03,$00,$01,$02,$03,$03,$03

EntityMainCode_PlayableCharacters_DF3A:
LDA FreezeTimer                                             ;cannot do anything if frozen in time and space
BEQ CODE_DF58                                               ;

LDA $C0
BEQ CODE_DF52
SEC
SBC #$01
CMP Entity_PlayerCharacter,X                                ;check if pac-man or ms. pac-man
BNE CODE_DF52

LDA #$20                                                    ;draw... nothing!
STA Entity_GFXFrame,X                                       ;

JSR HandleEntityVisualPosition_A383                         ;
RTS                                                         ;

CODE_DF52:
LDA Entity_Direction,X
JSR CODE_DF08
RTS

CODE_DF58:
LDA $20,X
CMP #$02
BCC CODE_DF6D

DEC $20,X
LDA $20,X
LSR A
LSR A
LSR A
TAY
LDA DATA_DF2A,Y
JSR CODE_DF08
RTS

CODE_DF6D:
LDA $0280,X
BMI CODE_DF7B
BEQ CODE_DF7B

DEC $0280,X

JSR HandleEntityVisualPosition_A383
RTS

CODE_DF7B:
LDA #$00
STA $C0
STA Entity_GFXFrame,X

JSR SetPlayerEntityBaseGFXFrame_DF1D

LDA #$00
STA Entity_XSpeed,X
STA Entity_YSpeed,X

LDA #$05
STA Entity_DrawingPriority,X

LDA CurrentLevel                                            ;current level...
LSR A                                                       ;divide by 4... which means the actual speed value changes every 4 levels.
LSR A                                                       ;
TAY                                                         ;
CPY #$0E                                                    ;
BCC CODE_DF9C                                               ;

LDY #$0D                                                    ;put a cap on it

CODE_DF9C:
LDA PlayerSpeedPerLevels_EFBC,Y                             ;speed depends on which levels the player's in
LDY Options_GameDifficulty                                  ;base speed depends on difficulty
CLC                                                         ;
ADC PlayerSpeedPerDifficulty_EFB4,Y                         ;
STA CurrentEntitySpeed                                      ;

LDA PowerPelletTimer                                        ;power pellet timer ticking?
ORA PowerPelletTimer+1                                      ;
BEQ CODE_DFB5                                               ;

LDA CurrentEntitySpeed                                      ;become ever so slightly faster with the power pellet
CLC                                                         ;
ADC #$04                                                    ;
STA CurrentEntitySpeed                                      ;

CODE_DFB5:
JSR HandlePacBoosterFunctionality_F76A                      ;maybe speed up with pac booster

LDA $20,X
BEQ CODE_DFCF                                               ;check if got bumped by another player?

LDA CurrentEntitySpeed                                      ;double speed
ASL A                                                       ;
STA CurrentEntitySpeed                                      ;

CPX Player1EntitySlot                                       ;check if is player 1
BNE CODE_DFC8                                               ;

JSR DisableDPadInputs_Player1_A235                          ;can't move

CODE_DFC8:
CPX Player2EntitySlot                                       ;check if player 2
BNE CODE_DFCF                                               ;

JSR DisableDPadInputs_Player2_A248                          ;

CODE_DFCF:
LDA CurrentEntitySpeed                                      ;
BPL CODE_DFD7                                               ;

LDA #$7F                                                    ;cap speed, you can only move so fast
STA CurrentEntitySpeed                                      ;

CODE_DFD7:
JSR HandlePowerPelletConsumption_E0B7
JSR CODE_E09E

LDA $C1
BNE CODE_DFE6

LDA FrameCounter
JSR CODE_E07D

CODE_DFE6:
JSR CODE_E089

LDA Options_Type
CMP #Options_Type_2PlayerCompetitive
BCC CODE_E033

LDA CurrentPlayerConfiguration                              ;check if both players are present
CMP #CurrentPlayerConfiguration_BothPlayers                 ;
BNE CODE_E033                                               ;

;check both pac-guys collision with each other inside the tunnel
LDA $20,X
BNE CODE_E033
CPX Player2EntitySlot
BNE CODE_E003

LDY Player1EntitySlot
CLV
BVC CODE_E005

CODE_E003:
LDY Player2EntitySlot

CODE_E005:
LDA $0020,Y
BNE CODE_E033

LDA Entity_Direction,X                                      ;check if they're moving in the same direction
CMP Entity_Direction,Y                                      ;
BEQ CODE_E033                                               ;no spawning

LDA #$06
JSR CODE_A35B
BNE CODE_E033

JSR CODE_9346

;second player also turns around
TXA
PHA
TYA
TAX
JSR CODE_9346
PLA
TAX

LDA Entity_CurrentTileXPosition,x
CMP #$01
BNE CODE_E02E

JSR MaybeSpawnPacJunior_8529

CODE_E02E:
LDA #Sound_PlayersCollide                                   ;players collided SFX
JSR PlaySound_F2FF

CODE_E033:
LDA $0280,X
BMI RETURN_E07C
TXA
PHA
LDA Entity_CurrentTileYPosition,x
ASL A
ASL A
STA $8B

LDA Entity_CurrentTileXPosition,x
LSR A
LSR A
LSR A
CLC
ADC $8B
TAY

LDA Entity_CurrentTileXPosition,x                           ;check player overlapping with a dot
AND #$07
TAX
LDA DATA_E13A,X
AND EatenDotStateBits,Y
BEQ CODE_E07A                                               ;if there's no dot, then player gets nothing

LDA DATA_E13A,X
EOR #$FF
AND EatenDotStateBits,Y
STA EatenDotStateBits,Y

PLA
TAX
LDA Entity_PlayerCharacter,X
STA Score_RewardedPlayer                                    ;reward this player

LDA #ScoreReward_10Pts
JSR GiveScore_FDB3                                          ;give a tiny amount of score

LDA #$01                                                    ;ate dot state...?
STA $0280,X

JSR ConsumedDot_E142
RTS

CODE_E07A:
PLA
TAX

RETURN_E07C:
RTS

CODE_E07D:
AND #$03                                                    ;alternate between 3 frames
STA $89

LDA Entity_GFXFrame,X
CLC
ADC $89
STA Entity_GFXFrame,X
RTS

CODE_E089:
LDA $0280,X                                                 ;check if player isn't feeling very good
BPL CODE_E09A

LDA Entity_PlayerCharacter,X                                ;
CLC                                                         ;
ADC #$21                                                    ;display sad face
STA Entity_GFXFrame,X                                       ;

LDA #$00
STA Entity_GFXProperties,X

CODE_E09A:
JSR HandleEnteringTunnel_E459
RTS

CODE_E09E:
LDA Entity_Direction,X
ASL A
TAY
LDA POINTERS_E0AF,Y
STA $89

LDA POINTERS_E0AF+1,Y
STA $8A
JMP ($0089)

POINTERS_E0AF:
.word CODE_E27D
.word CODE_E2B1
.word CODE_E249
.word CODE_E2E8

;check if player is touching a power pellet tile
HandlePowerPelletConsumption_E0B7:
LDY #$05

LOOP_E0B9:
LDA PowerPelletsVRAMPosLow,Y                                ;is this power pellet present?
BMI CODE_E0C9                                               ;

JSR CheckPowerPelletCollision_E0CD                          ;eat it up (maybe)

LDA $89
BEQ CODE_E0C9

JSR ConsumedPowerPellet_9563                                ;player DID consume the dot
RTS                                                         ;

CODE_E0C9:
DEY                                                         ;next power pellet
BPL LOOP_E0B9                                               ;
RTS                                                         ;didn't get any

CheckPowerPelletCollision_E0CD:
LDA #$00                                                    ;
STA $89                                                     ;

LDA PowerPelletsTileXPos,Y                                  ;
CMP Entity_CurrentTileXPosition,X                           ;check if they're on the same line
BNE CODE_E0DB                                               ;

DEC $89                                                     ;

CODE_E0DB:
LDA Entity_CurrentTileSubXPosition,x                        ;but actually overlapping
CMP #$A0
BCC CODE_E0EE

LDA PowerPelletsTileXPos,Y                                  ;check again, but see if the dot is to the LEFT of the player
SBC #$01
CMP Entity_CurrentTileXPosition,X
BNE CODE_E0EE

DEC $89

CODE_E0EE:
LDA Entity_CurrentTileSubXPosition,x                        ;check sub column AGAIN
CMP #$60
BCS CODE_E101

LDA PowerPelletsTileXPos,Y
ADC #$01
CMP Entity_CurrentTileXPosition,X                           ;is the dot TO THE RIGHT???
BNE CODE_E101

DEC $89

CODE_E101:
LDA $89
BEQ RETURN_E139

LDA #$00
STA $89

LDA PowerPelletsTileYPos,Y
CMP Entity_CurrentTileYPosition,X
BNE CODE_E113

DEC $89

CODE_E113:
LDA Entity_CurrentTileSubYPosition,x
CMP #$A0
BCC CODE_E126

LDA PowerPelletsTileYPos,Y                                  ;check if power pellet is above the player
SBC #$01
CMP Entity_CurrentTileYPosition,X
BNE CODE_E126

DEC $89

CODE_E126:
LDA Entity_CurrentTileSubYPosition,x
CMP #$60
BCS RETURN_E139

LDA PowerPelletsTileYPos,Y                                  ;check if power pellet is below the player
ADC #$01
CMP Entity_CurrentTileYPosition,X
BNE RETURN_E139

DEC $89

RETURN_E139:
RTS

;each bit value
DATA_E13A:
.byte $80,$40,$20,$10,$08,$04,$02,$01

;player just ate a normal dot
ConsumedDot_E142:
LDA CurrentDotsRemaining                                    ;check if ate 256 dots
BNE CODE_E14A                                               ;

DEC CurrentDotsRemaining+1                                  ;high byte

CODE_E14A:
DEC CurrentDotsRemaining                                    ;-1 dot for the count

LDA #$01                                                    ;one tile
JSR EnableBufferSequencingAndUpdateTileBuffer_9AF7          ;

LDA Entity_CurrentTileYPosition,X                           ;check if too low on-screen (ensure the dot update is on a proper nametable)
CMP #$16                                                    ;
BPL CODE_E164                                               ;
STA $8B                                                     ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
CLC                                                         ;
ADC #$21                                                    ;VRAM in range $2100 (just below score)
CLV                                                         ;
BVC CODE_E16F                                               ;

CODE_E164:
SEC                                                         ;start from $00
SBC #$16                                                    ;
STA $8B                                                     ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
CLC                                                         ;
ADC #$28                                                    ;high byte of $2800 area

CODE_E16F:
JSR UpdateTileBuffer_9AD0                                   ;part one of VRAM loc

LDA Entity_CurrentTileXPosition,X                           ;
STA $89                                                     ;

LDA $8B                                                     ;
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;
CLC                                                         ;
ADC $89                                                     ;
JSR UpdateTileBuffer_9AD0                                   ;part two of where to write

LDA #$00                                                    ;generate empty space
JSR UpdateTileBuffer_9AD0                                   ;
JSR DisableBufferSequencing_9AFD                            ;

LDA #Sound_DotEaten                                         ;yummy
JSR PlaySound_F2FF                                          ;
RTS                                                         ;

CODE_E192:
LDA Options_Type                                            ;check if in game type that has both players on screen
CMP #Options_Type_2PlayerCompetitive                        ;
BCS CODE_E19E                                               ;

LDA CurrentPlayerConfiguration
CLV
BVC CODE_E1A1

CODE_E19E:
LDA Entity_PlayerCharacter,X

CODE_E1A1:
BNE CODE_E1A8

LDA Player1DirectionalInput
CLV
BVC RETURN_E1AA

CODE_E1A8:
LDA Player2DirectionalInput

RETURN_E1AA:
RTS

GetCurrentPlayerInput_E1AB:
LDA Options_Type                                            ;check if in two player simultaneous game...
CMP #Options_Type_2PlayerCompetitive                        ;
BCS CODE_E1B7                                               ;

LDA CurrentPlayerConfiguration                              ;otherwise, current playing... player will determine who's inputs we're taking (player 1 or two)
CLV                                                         ;
BVC CODE_E1BA                                               ;

CODE_E1B7:
LDA Entity_PlayerCharacter,X                                ;character determines inputs (pac-man - player 2, ms. pac-man - player 1)

CODE_E1BA:
BNE CODE_E1C1

LDA Player1Inputs
CLV
BVC REETURN_E1C3

CODE_E1C1:
LDA Player2Inputs

REETURN_E1C3:
RTS

;get current player entity's input (either player 1 or 2)
GetCurrentPlayerInputPress_E1C4:
LDA Options_Type                                            ;check if in one of those "two players at the same time" types
CMP #Options_Type_2PlayerCompetitive                        ;
BCS CODE_E1D0                                               ;

LDA CurrentPlayerConfiguration                              ;current configuration will determine what player inputs to take (either player 1 or two)
CLV                                                         ;
BVC CODE_E1D3                                               ;

CODE_E1D0:
LDA Entity_PlayerCharacter,X                                ;get player character value to determine if it's player 1 or 2

CODE_E1D3:
BNE CODE_E1DA                                               ;

LDA Player1Inputs_Press                                     ;get player 1 presses
CLV                                                         ;
BVC RETURN_E1DC                                             ;

CODE_E1DA:
LDA Player2Inputs_Press                                     ;

RETURN_E1DC:
RTS                                                         ;

CODE_E1DD:
LDA $C1
BNE CODE_E1E9

JSR CODE_E192
CMP #Input_Right
CLV
BVC RETURN_E1F7

CODE_E1E9:
JSR GetCurrentPlayerInput_E1AB
AND #Input_Right
BEQ CODE_E1F5

LDA #$00
CLV
BVC RETURN_E1F7

CODE_E1F5:
LDA #$FF

RETURN_E1F7:
RTS

CODE_E1F8:
LDA $C1
BNE CODE_E204

JSR CODE_E192
CMP #Input_Left
CLV
BVC RETURN_E212

CODE_E204:
JSR GetCurrentPlayerInput_E1AB
AND #Input_Left
BEQ CODE_E210

LDA #$00
CLV
BVC RETURN_E212

CODE_E210:
LDA #$FF

RETURN_E212:
RTS

CODE_E213:
LDA $C1
BNE CODE_E21F

JSR CODE_E192
CMP #Input_Down
CLV
BVC RETURN_E22D

CODE_E21F:
JSR GetCurrentPlayerInput_E1AB
AND #Input_Down
BEQ CODE_E22B

LDA #$00
CLV
BVC RETURN_E22D

CODE_E22B:
LDA #$FF

RETURN_E22D:
RTS

CODE_E22E:
LDA $C1
BNE CODE_E23A

JSR CODE_E192
CMP #Input_Up
CLV
BVC RETURN_E248

CODE_E23A:
JSR GetCurrentPlayerInput_E1AB
AND #Input_Up
BEQ CODE_E246

LDA #$00
CLV
BVC RETURN_E248

CODE_E246:
LDA #$FF

RETURN_E248:
RTS

;move left
CODE_E249:
JSR CODE_E34F

LDA #OAMProp_XFlip
STA Entity_GFXProperties,x

JSR HandleEntityVisualPosition_A383
JSR CODE_E1DD
BNE CODE_E25D

LDA #Entity_Direction_Right
STA Entity_Direction,X                                      ;direction = right
RTS

CODE_E25D:
JSR CODE_E22E
BNE CODE_E26D

LDA Entity_CurrentTileSubXPosition,x
CMP #$60
BCC RETURN_E26C

JSR CODE_E33B

RETURN_E26C:
RTS

CODE_E26D:
JSR CODE_E213
BNE RETURN_E27C

LDA Entity_CurrentTileSubXPosition,x
CMP #$60
BCC RETURN_E27C

JSR CODE_E345

RETURN_E27C:
RTS

;moving right
CODE_E27D:
JSR CODE_E381

LDA #$00
STA Entity_GFXProperties,x

JSR HandleEntityVisualPosition_A383
JSR CODE_E1F8
BNE CODE_E291

LDA #Entity_Direction_Left                                  ;move left
STA Entity_Direction,X
RTS

CODE_E291:
JSR CODE_E22E
BNE CODE_E2A1

LDA Entity_CurrentTileSubXPosition,x
CMP #$A0
BCS RETURN_E2A0

JSR CODE_E33B

RETURN_E2A0:
RTS

CODE_E2A1:
JSR CODE_E213
BNE RETURN_E2B0

LDA Entity_CurrentTileSubXPosition,x
CMP #$A0
BCS RETURN_E2B0

JSR CODE_E345

RETURN_E2B0:
RTS

;move up
CODE_E2B1:
JSR CODE_E3AE

LDA #OAMProp_YFlip
STA Entity_GFXProperties,x

JSR CODE_E31F
JSR HandleEntityVisualPosition_A383
JSR CODE_E1F8
BNE CODE_E2CE

LDA Entity_CurrentTileSubYPosition,x
CMP #$60
BCC RETURN_E2CD

JSR CODE_E327

RETURN_E2CD:
RTS

CODE_E2CE:
JSR CODE_E1DD
BNE CODE_E2DE

LDA Entity_CurrentTileSubYPosition,x
CMP #$60
BCC RETURN_E2DD

JSR CODE_E331

RETURN_E2DD:
RTS

CODE_E2DE:
JSR CODE_E213
BNE RETURN_E2E7

LDA #Entity_Direction_Down
STA Entity_Direction,X

RETURN_E2E7:
RTS

;move down
CODE_E2E8:
JSR CODE_E3E0

LDA #$00
STA Entity_GFXProperties,x

JSR CODE_E31F
JSR HandleEntityVisualPosition_A383
JSR CODE_E1F8
BNE CODE_E305

LDA Entity_CurrentTileSubYPosition,x
CMP #$A0
BCS RETURN_E304

JSR CODE_E327

RETURN_E304:
RTS

CODE_E305:
JSR CODE_E1DD
BNE CODE_E315

LDA Entity_CurrentTileSubYPosition,x
CMP #$A0
BCS RETURN_E314

JSR CODE_E331

RETURN_E314:
RTS

CODE_E315:
JSR CODE_E22E
BNE RETURN_E31E

LDA #Entity_Direction_Up
STA Entity_Direction,X

RETURN_E31E:
RTS

CODE_E31F:
LDA Entity_GFXFrame,X
CLC
ADC #$04
STA Entity_GFXFrame,X
RTS

CODE_E327:
JSR CODE_8EFA
BNE RETURN_E330

LDA #Entity_Direction_Left
STA Entity_Direction,X

RETURN_E330:
RTS

CODE_E331:
JSR CODE_8F27
BNE RETURN_E33A

LDA #Entity_Direction_Right
STA Entity_Direction,X

RETURN_E33A:
RTS

CODE_E33B:
JSR CODE_8F54
BNE RETURN_E344

LDA #Entity_Direction_Up
STA Entity_Direction,X

RETURN_E344:
RTS

CODE_E345:
JSR CODE_8F80
BNE RETURN_E34E

LDA #Entity_Direction_Down
STA Entity_Direction,X

RETURN_E34E:
RTS

CODE_E34F:
LDA #$00
STA $C1

LDA CurrentEntitySpeed
EOR #$FF
CLC
ADC #$01
STA Entity_XSpeed,X

LDA #$00
STA Entity_YSpeed,X

LDA #$80
STA Entity_CurrentTileSubYPosition,x

JSR CODE_A32C
JSR CODE_8EFA
BEQ RETURN_E380

LDA Entity_CurrentTileSubXPosition,x
BMI RETURN_E380

LDA #$80
STA Entity_CurrentTileSubXPosition,x

LDY #$FF
STY $C1
INY
STY $20,X

RETURN_E380:
RTS

CODE_E381:
LDA #$00
STA $C1

LDA CurrentEntitySpeed
STA Entity_XSpeed,X

LDA #$00
STA Entity_YSpeed,X

LDA #$80
STA Entity_CurrentTileSubYPosition,x

JSR CODE_A32C
JSR CODE_8F27
BEQ RETURN_E3AD

LDA Entity_CurrentTileSubXPosition,x
BPL RETURN_E3AD

LDA #$80
STA Entity_CurrentTileSubXPosition,x

LDY #$FF
STY $C1
INY
STY $20,X

RETURN_E3AD:
RTS

CODE_E3AE:
LDA #$00
STA $C1

LDA CurrentEntitySpeed
EOR #$FF
CLC
ADC #$01
STA Entity_YSpeed,X

LDA #$00
STA Entity_XSpeed,X

LDA #$80
STA Entity_CurrentTileSubXPosition,x

JSR CODE_A32C
JSR CODE_8F54
BEQ RETURN_E3DF

LDA Entity_CurrentTileSubYPosition,x
BMI RETURN_E3DF

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDY #$FF
STY $C1
INY
STY $20,X

RETURN_E3DF:
RTS

CODE_E3E0:
LDA #$00
STA $C1

LDA CurrentEntitySpeed
STA Entity_YSpeed,X

LDA #$00
STA Entity_XSpeed,X

LDA #$80
STA Entity_CurrentTileSubXPosition,x

JSR CODE_A32C
JSR CODE_8F80
BEQ RETURN_E40C

LDA Entity_CurrentTileSubYPosition,x
BPL RETURN_E40C

LDA #$80
STA Entity_CurrentTileSubYPosition,x

LDY #$FF
STY $C1
INY
STY $20,X

RETURN_E40C:
RTS

CODE_E40D:
LDA #Entity_Direction_Left
STA Entity_Direction,X
RTS

RETURN_E412:
RTS

;initializes its graphical appearance and palette
EntityInitCode_BouncingItem_E413:
LDA CurrentLevel
CMP #7
BCC CODE_E424

JSR PollRandomNumber_A3D8                                   ;
AND #$07                                                    ;the item will be random
CMP #$07                                                    ;
BNE CODE_E424                                               ;

LDA #$06                                                    ;default to banana.

CODE_E424:
STA Entity_GFXFrame,X                                       ;

LDA Options_MazeSelection                                   ;
CMP #Options_MazeSelection_Strange                          ;check specifically for the strange maze selection
BNE CODE_E43D                                               ;

LDA CurrentLevel                                            ;
CMP #14                                                     ;level FIFTEEN or above
BCC CODE_E43B

JSR PollRandomNumber_A3D8                                   ;the visual appearance will be random
AND #$07                                                    ;
CLC                                                         ;
ADC #$06                                                    ;but also start showing strange items

CODE_E43B:
STA Entity_GFXFrame,X                                       ;

CODE_E43D:
LDA Entity_GFXFrame,X                                       ;get the type of bouncing item
TAY                                                         ;
LDA BouncingItemPaletteIndex_9422,Y                         ;get appropriate palette index
ASL A                                                       ;
ASL A                                                       ;
TAY                                                         ;

LDA BouncingItemPalettes_8874+1,Y                           ;
STA PaletteStorage+(Palette_Sprite3 + 1)                    ;set palette for the bouncy item

LDA BouncingItemPalettes_8874+2,Y                           ;
STA PaletteStorage+(Palette_Sprite3 + 2)                    ;

LDA BouncingItemPalettes_8874+3,Y                           ;
STA PaletteStorage+(Palette_Sprite3 + 3)                    ;
RTS                                                         ;

;let the tunnel conceal you with the masking tiles and BG Priority OAM property bit.
;and lets you appear on the other side of the screen if went far enough in
HandleEnteringTunnel_E459:
LDA Entity_CurrentTileXPosition,x                           ;
CMP #$03                                                    ;check if 3 tiles or less to the left
BMI CODE_E465                                               ;
CMP #$1D                                                    ;same but on the other side
BPL CODE_E465                                               ;
RTS                                                         ;

CODE_E465:
LDA Entity_GFXProperties,x                                  ;go behind bg
EOR #OAMProp_BGPriority                                     ;
STA Entity_GFXProperties,x                                  ;

LDA Entity_CurrentTileXPosition,x                           ;check if went far enough to the left
BNE CODE_E476                                               ;

LDA #$1E                                                    ;appear on the right side of the screen
STA Entity_CurrentTileXPosition,x
RTS

CODE_E476:
CMP #$1F                                                    ;check if went far enough to the right
BNE RETURN_E47F

LDA #$01                                                    ;appear on the left side of the screen
STA Entity_CurrentTileXPosition,x                           ;

RETURN_E47F:
RTS                                                         ;

;related with flicker in some way, shape, form or color.
CheckForFlickering_E480:
LDA Entity_CurrentTileYPosition,Y                           ;save the player's y-pos
STA $89                                                     ;

LDA #$00                                                    ;
STA $8B                                                     ;

LDX #$0F                                                    ;

LOOP_E48B:
LDA Entity_ID,x                                             ;if this entity is unalive, don't care
BEQ CODE_E4AA                                               ;

LDA Entity_CurrentTileYPosition,x                           ;check if on the same vertical level as something else
SEC                                                         ;
SBC $89                                                     ;
CLC                                                         ;
ADC #$01                                                    ;
BMI CODE_E4AA                                               ;
CMP #$03                                                    ;if in range of 4 levels
BPL CODE_E4AA                                               ;if not, means not in range

INC $8B                                                     ;up for the count
LDA $8B                                                     ;
CMP #$05                                                    ;
BNE CODE_E4AA                                               ;check if there are 5 things on the same line

JSR ResetEntityDrawingPriority_E4AE                         ;flicker enabled
RTS                                                         ;

CODE_E4AA:
DEX                                                         ;
BPL LOOP_E48B                                               ;
RTS                                                         ;no flicker then

;Let frame counter determine OAM tile drawing priority
ResetEntityDrawingPriority_E4AE:
LDA #$00                                                    ;
LDX #$0F                                                    ;

LOOP_E4B2:
STA Entity_DrawingPriority,X                                ;
DEX                                                         ;
BPL LOOP_E4B2                                               ;
RTS                                                         ;

;used to calculate maze layout based on maze selection and level
GetCurrentMazeLayoutValue_E4B9:
LDA Options_MazeSelection                                   ;based on maze selection...
ASL A                                                       ;
TAY                                                         ;
LDA MazeLayoutsPerSelectionPointers_EF20,Y                  ;calculate proper pointer for its pack of designs
STA $89                                                     ;

LDA MazeLayoutsPerSelectionPointers_EF20+1,Y                ;
STA $8A                                                     ;

LDY #$00                                                    ;very first byte
LDA CurrentLevel                                            ;current level...
SEC                                                         ;
SBC ($89),Y                                                 ;minus the very first value
BCC CODE_E4D9                                               ;if it didn't underflow...
AND #$0F                                                    ;limit to 16 (these layouts will be on repeat)
CLC                                                         ;
ADC ($89),Y                                                 ;+said offset
CLV                                                         ;
BVC CODE_E4DB                                               ;

CODE_E4D9:
LDA CurrentLevel                                            ;take current level

CODE_E4DB:
CLC                                                         ;+1
ADC #$01                                                    ;
TAY                                                         ;
LDA ($89),Y                                                 ;final result
RTS                                                         ;

;Bottom HUD display coordinates (VRAM)
VRAMBottomHUDCoordsHigh_E4E2:
.byte >HUDBottom_VRAMCoordinatesShortLayout
.byte >HUDBottom_VRAMCoordinatesMediumLayout
.byte >HUDBottom_VRAMCoordinatesTallLayout

VRAMBottomHUDCoordsLow_E4E5:
.byte <HUDBottom_VRAMCoordinatesShortLayout
.byte <HUDBottom_VRAMCoordinatesMediumLayout
.byte <HUDBottom_VRAMCoordinatesTallLayout

CODE_E4E8:
LDX #$95
LDA #$FF

LOOP_E4EC:
STA $0459,X
DEX
BNE LOOP_E4EC
RTS

CODE_E4F3:
JSR GetCurrentMazeLayoutValue_E4B9                          ;
STA CurrentMazeLayout                                       ;calculated maze layout
TAX                                                         ;
LDY MazeLayoutHeightLevels_AD50,X                           ;how tall the maze layout is
STY CurrentMazeSize                                         ;

LDA VRAMBottomHUDCoordsHigh_E4E2,Y                          ;used to place the bottom portion of the HUD correctly
STA $84                                                     ;

LDA VRAMBottomHUDCoordsLow_E4E5,Y                           ;
STA $83                                                     ;

LDA CameraBottomBoundaryPerMazeHeight_AD4D,Y                ;set a boundary of how far the camera can scroll down (or moved to when moving the camera during pause)
STA CameraBottomBoundary                                    ;

JSR DisableNMI_9A55                                         ;

LDA #$00                                                    ;
JSR FillScreens_9AB6                                        ;
JSR DrawMaze_E55F                                           ;
JSR DisableUnusedPowerPellets_E54F                          ;
JSR LoadMazeVisuals_E701                                    ;
JSR LoadDefaultPalettes_88D1                                ;

LDA Options_Type                                            ;
CMP #Options_Type_2PlayerCompetitive                        ;check if type is 2P competitive or higher
BCS CODE_E533                                               ;

LDA #TileStripeID_HighScore                                 ;
JSR DrawTileStripes_9B80                                    ;draw "HIGH SCORE" string
JSR DrawTopScoreCounter_FD6E                                ;display said high score

CLV                                                         ;
BVC CODE_E548                                               ;

CODE_E533:
BNE CODE_E540                                               ;check if specifically 2 player competitive

LDA #TileStripeID_Leader                                    ;draw "LEADER" string
JSR DrawTileStripes_9B80                                    ;
JSR DrawLeaderString_FD17                                   ;init leader display

CLV                                                         ;
BVC CODE_E548                                               ;

CODE_E540:
LDA #TileStripeID_Total                                     ;in 2P cooperative.
JSR DrawTileStripes_9B80                                    ;draw TOTAL string
JSR DrawTotalScore_FCF8                                     ;init total score display

CODE_E548:
JSR DrawPlayersScore_FE64                                   ;init player score display
JSR StoreToControlAndRenderRegs_9A70                        ;
RTS                                                         ;

;this basically removes power pellets that aren't placed in the maze, at least internally. if the low VRAM position is set to 0 (initialized to this value on level load), it'll be disabled
DisableUnusedPowerPellets_E54F:
LDX #$05                                                    ;

LOOP_E551:
LDA PowerPelletsVRAMPosLow,X                                ;
BNE CODE_E55B                                               ;

LDA #$FF                                                    ;
STA PowerPelletsVRAMPosLow,X                                ;

CODE_E55B:
DEX                                                         ;
BPL LOOP_E551                                               ;
RTS                                                         ;

;puts the maze together behind the scenes.
DrawMaze_E55F:
LDA CurrentMazeLayout                                       ;
ASL A                                                       ;
TAX                                                         ;
LDA MazeLayoutPointers_AEB0,X                               ;
STA $89                                                     ;

LDA MazeLayoutPointers_AEB0+1,X                             ;
STA $8A                                                     ;

LDA #$21                                                    ;
STA VRAMPointerReg                                          ;
STA $8C                                                     ;

LDA #$00
STA VRAMPointerReg
STA $8B

JSR CODE_E4E8

LDA #$00
STA $0386
STA CurrentDotsRemaining
STA CurrentDotsRemaining+1
STA $0385
STA $0387
STA $8F

JSR CODE_EA14
JSR CODE_EA14

LDY #$00                                                    ;

LOOP_E599:
LDA ($89),Y                                                 ;value 80-FF...
BMI CODE_E5A3                                               ;means command

JSR CODE_E9C4                                               ;draw this tile

CLV                                                         ;next byte to check
BVC CODE_E5BE                                               ;

CODE_E5A3:
CMP #Maze_EndMazeBuilding                                   ;terminate layout building?
BNE CODE_E5A8                                               ;if not, then it's a repeat of the same tile
RTS                                                         ;

CODE_E5A8:
SEC                                                         ;
SBC #Maze_RepeatTileCommand                                 ;
TAX                                                         ;get the amount of tile we're repeating

INC $89                                                     ;
BNE CODE_E5B2                                               ;

INC $8A                                                     ;high byte ofc

CODE_E5B2:
LDA ($89),Y                                                 ;
STA $8D                                                     ;remember what tile we're repeating

LOOP_E5B6:
LDA $8D                                                     ;
JSR CODE_E9C4                                               ;draw the tile

DEX                                                         ;next repeat
BPL LOOP_E5B6                                               ;

CODE_E5BE:
INC $89                                                     ;continue drawing, maybe
BNE CODE_E5C4                                               ;

INC $8A                                                     ;

CODE_E5C4:
CLC                                                         ;
BCC LOOP_E599                                               ;always branch
RTS                                                         ;cant quite reach this

.include "Data/PPUAttributeData.asm"

;attribute indexes for maze screens (first 8 values: screen 1, last 8 values - screen 2)
;first two are always HUD (score & indicators), the rest depend on the size of the maze. $01s by default are maze design
;then the botom part of the HUD, where lives and items reside
PPUAttributeConfiguration_MediumMaze_1Player_E64A:
.byte $0C,$0C,$01,$01,$01,$01,$01,$01
.byte $01,$01,$02,$00,$00,$00,$00,$00

PPUAttributeConfiguration_MediumMaze_2Players_E65A:
.byte $0C,$0C,$01,$01,$01,$01,$01,$01
.byte $01,$01,$03,$00,$00,$00,$00,$00

PPUAttributeConfiguration_MiniMaze_1Player_E66A:
.byte $0C,$0C,$01,$01,$01,$01,$01,$01
.byte $01,$04,$00,$00,$00,$00,$00,$00

PPUAttributeConfiguration_MiniMaze_2Players_E67A:
.byte $0C,$0C,$01,$01,$01,$01,$01,$01
.byte $01,$05,$00,$00,$00,$00,$00,$00

PPUAttributeConfiguration_BigMaze_1Player_E68A:
.byte $0C,$0C,$01,$01,$01,$01,$01,$01
.byte $01,$01,$01,$01,$04,$00,$00,$00

PPUAttributeConfiguration_BigMaze_2Players_E69A:
.byte $0C,$0C,$01,$01,$01,$01,$01,$01
.byte $01,$01,$01,$01,$05,$00,$00,$00

GetCurrentMazePPUAttributeConfiguration_E6AA:
LDA CurrentMazeSize                                         ;check if the maze is small
BNE CODE_E6BF                                               ;

LDA Options_Type                                            ;
CMP #Options_Type_2PlayerCompetitive                        ;
BCC CODE_E6BB                                               ;

LDA PPUAttributeConfiguration_MiniMaze_2Players_E67A,X      ;two player attributes

CLV                                                         ;can be replaced with RTS
BVC RETURN_E6BE                                             ;

CODE_E6BB:
LDA PPUAttributeConfiguration_MiniMaze_1Player_E66A,X       ;

RETURN_E6BE:
RTS                                                         ;

CODE_E6BF:
CMP #$01                                                    ;is the maze medium sized?
BNE CODE_E6D4                                               ;

LDA Options_Type                                            ;
CMP #Options_Type_2PlayerCompetitive                        ;
BCC CODE_E6D0                                               ;

LDA PPUAttributeConfiguration_MediumMaze_2Players_E65A,X    ;

CLV                                                         ;can be replaced with RTS
BVC RETURN_E6D3                                             ;

CODE_E6D0:
LDA PPUAttributeConfiguration_MediumMaze_1Player_E64A,X     ;

RETURN_E6D3:
RTS                                                         ;

CODE_E6D4:
LDA Options_Type                                            ;
CMP #Options_Type_2PlayerCompetitive                        ;
BCC CODE_E6E1                                               ;

LDA PPUAttributeConfiguration_BigMaze_2Players_E69A,X       ;

CLV                                                         ;can be replaced with what? A) RTS, B) INC $19, C) A stupid reference and D) Nothing, it's perfect as is
BVC RETURN_E6E4                                             ;

CODE_E6E1:
LDA PPUAttributeConfiguration_BigMaze_1Player_E68A,X        ;

RETURN_E6E4:
RTS                                                         ;

SetPPUAttributesForMaze_Row_E6E5:
JSR GetCurrentMazePPUAttributeConfiguration_E6AA            ;
ASL A                                                       ;
TAY                                                         ;
LDA PPUAttributeRowValuePointers_E5C8,Y                     ;
STA $89                                                     ;

LDA PPUAttributeRowValuePointers_E5C8+1,Y                   ;
STA $8A                                                     ;

LDY #$00                                                    ;

LOOP_E6F6:
LDA ($89),Y                                                 ;fill an entire row with attributes
STA VRAMUpdateRegister                                      ;
INY                                                         ;
CPY #$08                                                    ;
BNE LOOP_E6F6                                               ;
RTS                                                         ;

;pretty much everything related to the maze (HUD, attributes) is set here, except for palette and level design
LoadMazeVisuals_E701:
LDA #$23                                                    ;prepare to write to background attributes (PPU attributes)
STA VRAMPointerReg                                          ;

LDA #$C0                                                    ;
STA VRAMPointerReg                                          ;

LDX #$00                                                    ;

LOOP_E70D:
JSR SetPPUAttributesForMaze_Row_E6E5

INX
CPX #$08
BNE LOOP_E70D                                               ;are all 8 rows done

LDA #$2B                                                    ;next screen
STA VRAMPointerReg

LDA #$C0
STA VRAMPointerReg

LDX #$08

LOOP_E721:
JSR SetPPUAttributesForMaze_Row_E6E5

INX
CPX #$10
BNE LOOP_E721

LDA Options_MazeSelection                                   ;check if playing in arcade maze
ORA Options_GameDifficulty                                  ;normal difficulty
ORA Options_PacBooster                                      ;no pac booster
BEQ CODE_E797                                               ;vanilla gameplay, do not draw the indicator bar

LDX #HUD_IndicatorBar_LeftEnd
LDA #$08
STA $89
JSR DrawOneIndicatorBarTile_E985

LDA #$0E
STA $8B

LOOP_E741:
LDX #HUD_IndicatorBar_Middle
LDA $8B
CLC
ADC #$09
STA $89
JSR DrawOneIndicatorBarTile_E985

DEC $8B
BPL LOOP_E741

LDX #HUD_IndicatorBar_RightEnd                              ;indicator bar right end tile
LDA #$17                                                    ;VRAM offset
STA $89
JSR DrawOneIndicatorBarTile_E985

LDY Options_MazeSelection
LDX HUD_MazeIndicatorTiles_E807,Y
LDA #$13
STA $89

LDA HUD_MazeIndicatorSizes_E80B,Y
CMP #$02
BNE CODE_E771

JSR DrawTwoIndicatorBarTiles_E996

CLV
BVC CODE_E778

CODE_E771:
CMP #$03
BNE CODE_E778

JSR DrawThreeIndicatorBarTiles_E9AB

CODE_E778:
LDY Options_GameDifficulty
LDX HUD_DifficultyIndicatorTiles_E80F,Y
LDA HUD_DifficultyIndicatorSizes_E813,Y
BEQ CODE_E78A

LDA #$0F
STA $89
JSR DrawTwoIndicatorBarTiles_E996

CODE_E78A:
LDY Options_PacBooster
LDX HUD_PacBoosterIndicatorTiles_E817,Y
LDA #$0A                                                    ;VRAM offset
STA $89
JSR DrawOneIndicatorBarTile_E985

CODE_E797:
LDA Options_MazeSelection                                   ;do not display level counter if in arcade mazes
BEQ LoadPlayersLivesAndItemsDisplay_E7CA                    ;

;display level counter
LDA CurrentLevel
JSR GetLevelDisplayTilesForHUD_E81A

LDA #$1C                                                    ;vram offset
STA $89
JSR DrawLevelCounterTop_E95B

LDX #HUD_LevelCounter_LEVTile
LDY #HUD_LevelCounter_ELTile
LDA #$1C
STA $89
JSR DrawLevelCounterBottom_E96F

;do that again but on the left side of the screen (I'm convinced it was supposed to display maze number before, judging by the unused MAZE tiles)
LDA CurrentLevel
JSR GetLevelDisplayTilesForHUD_E81A

LDA #$02
STA $89
JSR DrawLevelCounterTop_E95B

LDX #HUD_LevelCounter_LEVTile
LDY #HUD_LevelCounter_ELTile
LDA #$02
STA $89
JSR DrawLevelCounterBottom_E96F

LoadPlayersLivesAndItemsDisplay_E7CA:
JSR LoadPlayer1LivesDisplay_E82B                            ;

LDA Options_Type                                            ;if in 2 player simultaneous
CMP #Options_Type_2PlayerCompetitive                        ;
BCS LoadPlayer2LivesDisplay_E7DA                            ;display both players' lives... maybe.

JSR DisplayHUDItems_E862                                    ;items

CLV                                                         ;
BVC RETURN_E806                                             ;

LoadPlayer2LivesDisplay_E7DA:
LDA CurrentPlayerConfiguration                              ;check if player 1
BNE CODE_E7DF                                               ;NOT player 1, which means player 2 IS present
RTS                                                         ;

CODE_E7DF:
LDA Player2Lives                                            ;chceck how many lives player 2 has
CMP #$05                                                    ;
BCC CODE_E7E8                                               ;

LDA #$04                                                    ;keep player 2 lives at the maximum of 5

CODE_E7E8:
STA $8D
CMP #$00
BEQ RETURN_E806
BMI RETURN_E806

LOOP_E7F0:
LDX #HUD_PacMan
LDA $8D
ASL A
EOR #$FF
CLC
ADC #$01
CLC
ADC #$1A
STA $89

JSR Draw16x16BGImage_E92E

DEC $8D
BPL LOOP_E7F0

RETURN_E806:
RTS

;tiles for the top of the screen, that indicate the game's properties (such as pac-booster on, if the game is crazy difficult, et cetera)
;starting tiles for mazes: Arcade (empty), Mini, Big, Strange
HUD_MazeIndicatorTiles_E807:
.byte HUD_IndicatorBar_Middle
.byte HUD_MazeIndicatorTile_Mini
.byte HUD_MazeIndicatorTile_Big
.byte HUD_MazeIndicatorTile_Strange

;sizes for these indicators (how many tiles do they take to draw)
HUD_MazeIndicatorSizes_E80B:
.byte $00
.byte $02
.byte $02
.byte $03

;difficulty indicators
;normal, easy, hard, CRAZY
HUD_DifficultyIndicatorTiles_E80F:
.byte HUD_IndicatorBar_Middle
.byte HUD_DifficultyIndicatorTile_Easy
.byte HUD_DifficultyIndicatorTile_Hard
.byte HUD_DifficultyIndicatorTile_Crazy

;amount of tiles they take
HUD_DifficultyIndicatorSizes_E813:
.byte $00
.byte $02
.byte $02
.byte $02

;pac-booster indicator
;no, yes, also yes
HUD_PacBoosterIndicatorTiles_E817:
.byte HUD_IndicatorBar_Middle
.byte HUD_PacBoosterIndicatorTile
.byte HUD_PacBoosterIndicatorTile

GetLevelDisplayTilesForHUD_E81A:
CLC                                                         ;on-screen value and internal values are slightly different
ADC #$01                                                    ;
JSR HexToDecLevelNumber_F7DE                                ;
CLC                                                         ;
ADC #HUD_LevelCounter_TensTileOffest                        ;
TAX                                                         ;display tens

LDA $8D                                                     ;
CLC                                                         ;
ADC #HUD_LevelCounter_OnesTileOffest                        ;
TAY                                                         ;
RTS                                                         ;

LoadPlayer1LivesDisplay_E82B:
LDA Options_Type                                            ;check if in two player alternating or 1 player mode
CMP #Options_Type_2PlayerCompetitive                        ;
BCC CODE_E839                                               ;

LDA CurrentPlayerConfiguration                              ;check if player 2
CMP #CurrentPlayerConfiguration_Player2                     ;
BNE CODE_E839                                               ;not player 2, means player 1
RTS                                                         ;

CODE_E839:
LDA CurrentPlayerLives
CMP #$05
BCC CODE_E841

LDA #$04                                                    ;limit the number of lives displayed (can't exactly draw 255 of pac-women on the hud in case the player wins the game and gets 255 lives)

CODE_E841:
STA $8D
CMP #$00
BEQ RETURN_E85A
BMI RETURN_E85A

LOOP_E849:
LDX #HUD_MsPacMan                                           ;ms. pac-man tile for the hud (will draw a 16x16 image)
LDA $8D
ASL A
CLC
ADC #$04
STA $89
JSR Draw16x16BGImage_E92E

DEC $8D
BPL LOOP_E849

RETURN_E85A:
RTS

;starting tiles for each of the fruits (and a pretzel) in the hud
;they go from right to left
HUD_ItemTiles_E85B:
.byte HUD_CherryTile
.byte HUD_StrawberryTile
.byte HUD_OrangeTile
.byte HUD_PretzelTile                                       ;must be someone's favorite fruit
.byte HUD_AppleTile
.byte HUD_PearTile
.byte HUD_BananaTile

DisplayHUDItems_E862:
LDA CurrentLevel                                            ;check the level we're on (to set an appropriate amount of items on HUD)
CMP #$06                                                    ;
BMI CODE_E86A                                               ;apparently BMI works differently than I thought... it'll trigger if below 6 AND if current level number is above $80+$06 (that's levels 135 and above)

LDA #$06                                                    ;display all 7 items

CODE_E86A:
STA $8D                                                     ;store the amount of items to loop through

LDA #$1A
STA $89

LDA #$00
STA $8B

LOOP_E874:
LDY $8B
LDA HUD_ItemTiles_E85B,Y
TAX
JSR Draw16x16BGImage_E92E

DEC $89
DEC $89

INC $8B

DEC $8D                                                     ;maybe draw the next item...
BPL LOOP_E874                                               ;this is why the killscreen or any sort of corruption does not happen. if the level is already above 128, this will trigger prematurely.
RTS                                                         ;that does mean only one item is displayed

;adjusts lives display? apparently it draws 1 extra, and then removes it.
;this is for player 2
CODE_E888:
LDA Player2Lives                                            ;check if player 2 has less than 5 lives
CMP #$05                                                    ;
BCC CODE_E890                                               ;
RTS                                                         ;

CODE_E890:
ASL A
EOR #$FF
CLC
ADC #$01
CLC
ADC #$1A
JMP CODE_E8A7

;player 1 version
CODE_E89C:
LDA CurrentPlayerLives
CMP #$05
BCC CODE_E8A3
RTS

CODE_E8A3:
ASL A
CLC
ADC #$04

CODE_E8A7:
CLC
ADC $83
STA $8F

LDA $84
STA $90
JSR BlankOutTile_E928

INC $8F
LDA #$00
JSR BlankOutTile_E928

LDA $8F
CLC
ADC #$1F
STA $8F
JSR BlankOutTile_E928

INC $8F
JSR BlankOutTile_E928
RTS

;adds one life to the display
AddExtraLifeDisplay_Player1_E8CA:
LDA CurrentPlayerLives                                      ;player 1 lives
CMP #$06                                                    ;check if player lives count exceeds. can only display 5 lives
BCC CODE_E8D1                                               ;
RTS                                                         ;player 1 is already full.

CODE_E8D1:
ASL A
CLC
ADC #$02
JSR CODE_E8F8

LDA #HUD_MsPacMan                                           ;draw an extra life icon
JSR Append16x16BGImage_E902
RTS

AddExtraLifeDisplay_Player2_E8DE:
LDA Player2Lives                                            ;check if player 2 lives are... less than 6??
CMP #$06                 
BCC CODE_E8E6                
RTS

CODE_E8E6:
ASL A                    
EOR #$FF                 
CLC                      
ADC #$01                 
CLC                      
ADC #$1C                 
JSR CODE_E8F8
  
LDA #HUD_PacMan                                             ;display pac-man's lives
JSR Append16x16BGImage_E902                
RTS                      

CODE_E8F8:
CLC
ADC $83
STA $8F

LDA $84
STA $90
RTS

;used to draw a new extra life when got it during gameplay.
;input A - first tile of the 16x16 image
Append16x16BGImage_E902:
STA $8B

JSR SingleTileIntoBuffer_9B00

INC $8F

INC $8B
LDA $8B
JSR SingleTileIntoBuffer_9B00

LDA $8F
CLC
ADC #$1F                                                    ;bottom row, one tile to the left
STA $8F

INC $8B
LDA $8B
JSR SingleTileIntoBuffer_9B00

INC $8F

INC $8B
LDA $8B
JSR SingleTileIntoBuffer_9B00
RTS

;this is used for removing life display from the HUD, though it's so generic, it could be used for blanking anything.
;Input $8F-$90 - VRAM position
BlankOutTile_E928:
LDA #EmptyTile                                              ;
JSR SingleTileIntoBuffer_9B00                               ;
RTS                                                         ;

;used for HUD items and lives
;Input:
;X - tile offset for 4 consecutive tiles
;$83-$84 - base VRAM where to draw
;$89 - VRAM offset from the base VRAM
;note that this is used behind the scenes when loading a level and isn't usable during mazes. see
Draw16x16BGImage_E92E:
LDA $84                                                     ;
STA VRAMPointerReg                                          ;

LDA $83                                                     ;
CLC                                                         ;
ADC $89                                                     ;
STA VRAMPointerReg                                          ;

STX VRAMUpdateRegister                                      ;draw two consecutive tiles
INX                                                         ;
STX VRAMUpdateRegister                                      ;

LDA $84                                                     ;
STA VRAMPointerReg                                          ;

LDA $83                                                     ;
CLC                                                         ;
ADC #$20                                                    ;will draw bottom half now
CLC                                                         ;
ADC $89                                                     ;
STA VRAMPointerReg                                          ;

INX                                                         ;two more tiles
STX VRAMUpdateRegister                                      ;
INX                                                         ;
STX VRAMUpdateRegister                                      ;
RTS                                                         ;

;Input:
;$83-84 - VRAM location to draw to, X and Y are tiles to draw
;$89 - VRAM offset
;X and Y - tiles to draw, left and right tiles respectively
DrawLevelCounterTop_E95B:
LDA $84                                                     ;
STA VRAMPointerReg                                          ;

LDA $83                                                     ;
CLC                                                         ;
ADC $89                                                     ;
STA VRAMPointerReg                                          ;

STX VRAMUpdateRegister                                      ;write tiles
STY VRAMUpdateRegister                                      ;
RTS                                                         ;

;Input:
;$83-84 - VRAM location to draw to, X and Y are tiles to draw
;$89 - VRAM offset
;X and Y - tiles to draw, left and right tiles respectively
DrawLevelCounterBottom_E96F:
LDA $84                                                     ;
STA VRAMPointerReg                                          ;

LDA $83                                                     ;
CLC                                                         ;
ADC #$20                                                    ;they're 1 tile below the actual level count
ADC $89                                                     ;
STA VRAMPointerReg                                          ;

STX VRAMUpdateRegister                                      ;write tiles
STY VRAMUpdateRegister                                      ;
RTS                                                         ;

;input:
;$89 - VRAM offset
;X - tile to draw
DrawOneIndicatorBarTile_E985:
LDA #>HUD_BaseMazeIndicatorVRAMPosition                     ;
STA VRAMPointerReg                                          ;

LDA $89                                                     ;draw at this position
CLC                                                         ;
ADC #<HUD_BaseMazeIndicatorVRAMPosition                     ;
STA VRAMPointerReg                                          ;

STX VRAMUpdateRegister                                      ;draw this tile
RTS                                                         ;

;input:
;$89 - VRAM offset
;X - tiles to draw, takes X for first tile and X+1 for the second one
DrawTwoIndicatorBarTiles_E996:
LDA #>HUD_BaseMazeIndicatorVRAMPosition                     ;
STA VRAMPointerReg                                          ;

LDA $89                                                     ;draw at this position
CLC                                                         ;
ADC #<HUD_BaseMazeIndicatorVRAMPosition                     ;
STA VRAMPointerReg                                          ;

STX VRAMUpdateRegister                                      ;draw first tile
INX                                                         ;
STX VRAMUpdateRegister                                      ;second tile
RTS                                                         ;

;X - tiles to draw, X - first tile, X+1 - second tile, X+2 - third tile
DrawThreeIndicatorBarTiles_E9AB:
LDA #>HUD_BaseMazeIndicatorVRAMPosition                     ;
STA VRAMPointerReg                                          ;

LDA $89                                                     ;draw at this position
CLC                                                         ;
ADC #<HUD_BaseMazeIndicatorVRAMPosition                     ;
STA VRAMPointerReg                                          ;

STX VRAMUpdateRegister                                      ;tile 1
INX                                                         ;
STX VRAMUpdateRegister                                      ;tile 2
INX                                                         ;
STX VRAMUpdateRegister                                      ;tile 3
RTS                                                         ;

CODE_E9C4:
STA $91                                                     ;remember the tile we're drawing

JSR CODE_EA54                                               ;

TXA                                                         ;
PHA                                                         ;
LDX $8F                                                     ;
LDA $91                                                     ;
STA MazeLayoutMirrorBuffer,X                                ;remember the tile we drew for the left side to also draw on the right side
CPX #13                                                     ;drew left side of the screen?
BNE CODE_EA0F                                               ;

LOOP_E9D6:
LDA MazeLayoutMirrorBuffer,X                                ;check if the tile is in the range from $40 to $7F
CMP #$40                                                    ;
BCC CODE_E9DF                                               ;if not, it can't be flipped (only really applies to tiles $00-$0F, good luck using other tiles)
EOR #$20                                                    ;-$20 or +$20 - flip this tile on the right side

CODE_E9DF:
JSR CODE_EA54                                               ;

DEX                                                         ;keep on going
BPL LOOP_E9D6                                               ;

JSR CODE_EA14
JSR CODE_EA14

LDA $8C                                                     ;check if we reached the bottom of the full screen
CMP #$23                                                    ;
BNE CODE_EA05                                               ;not there yet...

LDA $8B                                                     ;maybe?
CMP #$C0                                                    ;
BNE CODE_EA05                                               ;nope...

LDA #$28                                                    ;start drawing on the second screen
STA $8C                                                     ;
STA VRAMPointerReg                                          ;

LDA #$00                                                    ;
STA $8B                                                     ;
STA VRAMPointerReg                                          ;

CODE_EA05:
JSR CODE_EA14
JSR CODE_EA14

LDA #$FF                                                    ;make sure the offset is 0 (to be combined with the INC right after)
STA $8F                                                     ;because we're not doing incremental draws on the right side of the screen

CODE_EA0F:
INC $8F                                                     ;next tile
PLA                                                         ;
TAX                                                         ;
RTS

CODE_EA14:
LDA #MaskingTile
JSR CODE_EA54
RTS

CODE_EA1A:
LDX PowerPelletsRemaining                                   ;
INC PowerPelletsRemaining                                   ;will check the next big dot
LDA PowerPelletsVRAMPosLow,X                                ;has it been consumed?
BPL CODE_EA2A                                               ;nope

LDA #EmptyTile                                              ;the dot is not there anymore
STA $95                                                     ;
RTS                                                         ;

CODE_EA2A:
LDA $8C                                                     ;remember where it's at
STA PowerPelletsVRAMPosLow,X

LDA $8B
STA PowerPelletsVRAMPosHigh,X

LDA $0385
AND #$03
ASL A
ASL A
ASL A
CLC
ADC $0386
STA PowerPelletsTileXPos,X

LDA $0385
LSR A
LSR A
STA PowerPelletsTileYPos,X

INC CurrentDotsRemaining                                    ;the big dot is there & remains to be eaten
BNE RETURN_EA53                                             ;

INC CurrentDotsRemaining+1                                  ;dont forget high byte

RETURN_EA53:
RTS                                                         ;

;input A - background tile
CODE_EA54:
STA $95
TXA
PHA
TYA
PHA
LDA $95
CMP #PowerPelletTile                                        ;check if its a large dot tile (power pellet)
BNE CODE_EA63

JSR CODE_EA1A

CODE_EA63:
LDA $95
CMP #SmallDotTile                                           ;check if a regular dot
BEQ CODE_EA6F

JSR CODE_EAC0

CLV
BVC CODE_EA72

CODE_EA6F:
JSR CODE_EAD2                                               ;small dot

CODE_EA72:
LDA $95
BNE CODE_EA79                                               ;check if we've generated an empty space

JSR UnsetSolidSpaceBit_EAAE                                 ;empty space is not solid, naturally

CODE_EA79:
LDA $95
CMP #SmallDotTile
BNE CODE_EA82

JSR UnsetSolidSpaceBit_EAAE                                 ;small dot can be passed through

CODE_EA82:
LDA $95
CMP #PowerPelletTile
BNE CODE_EA8B

JSR UnsetSolidSpaceBit_EAAE                                 ;power pellet is like thin air - can be walked through

CODE_EA8B:
LDA $95                                                     ;check if it's a masking tile
CMP #MaskingTile
BNE CODE_EA9B

JSR CODE_EAF9                                               ;do... something. idk what

LDA $93
BEQ CODE_EA9B

JSR UnsetSolidSpaceBit_EAAE

CODE_EA9B:
JSR CODE_EB2C                                               ;something else about dots/whatever

PLA
TAY
PLA
TAX
LDA $95                                                     ;draw this tile
STA VRAMUpdateRegister                                      ;

INC $8B                                                     ;next tile or command, please
BNE RETURN_EAAD                                             ;

INC $8C                                                     ;high byte

RETURN_EAAD:
RTS                                                         ;

;used to tell which spaces the entities can move around freely in
UnsetSolidSpaceBit_EAAE:
LDX $0386
LDA DATA_E13A,X
EOR #$FF
LDY $0385
AND MazeSolidTileBits,Y
STA MazeSolidTileBits,Y
RTS

;big dot counts as a dot
CODE_EAC0:
LDX $0386
LDA DATA_E13A,X
EOR #$FF
LDY $0385
AND EatenDotStateBits,Y
STA EatenDotStateBits,Y
RTS

;count small dots
CODE_EAD2:
LDX $0386
LDA DATA_E13A,X
LDY $0385
AND EatenDotStateBits,Y
BEQ CODE_EAF4

LDA DATA_E13A,X
ORA EatenDotStateBits,Y
STA EatenDotStateBits,Y

INC CurrentDotsRemaining                                    ;dot remains
BNE CODE_EAF1                                               ;

INC CurrentDotsRemaining+1                                  ;high byte ofc

CODE_EAF1:
CLV                                                         ;\can be replaced with just RTS
BVC RETURN_EAF8                                             ;/

CODE_EAF4:
LDA #$00                                                    ;dot eaten, generate empty space in its place
STA $95                                                     ;

RETURN_EAF8:
RTS                                                         ;

CODE_EAF9:
LDA #$00
STA $93

LDA $0385
LSR A
LSR A
STA $94

LDA CurrentMazeLayout
ASL A
TAY

LDA MazeTunnelDataPointers_AD98,Y                            ;tunnels!
STA $97

LDA MazeTunnelDataPointers_AD98+1,Y
STA $98

LDY #$00
TXA
PHA

LDX #$03

LOOP_EB18:
LDA ($97),Y
BEQ CODE_EB24
CMP $94
BNE CODE_EB24

LDA #$01
STA $93

CODE_EB24:
INY
INY
DEX
BPL LOOP_EB18

PLA
TAX
RTS

CODE_EB2C:
INX
CPX #$08
BNE CODE_EB36

INC $0385

LDX #$00

CODE_EB36:
STX $0386
RTS

;this contains the act value for each level between level 1 and 13 to play
;if 0, no cutscene will play, while 1-3 will play the respective act cutscene
ActPerLevel1Through13_EB3A:
.byte $00,$01,$00,$00,$02,$00,$00,$00
.byte $03,$00,$00,$00,$03

;checks if beat a specific level to trigger a cutscene
MaybePlayActCutscene_EB47:
LDY CurrentLevel
CPY #31                                                     ;play act 4 cutscene if in level 32 (don't forget that it's 0 inclusive)
BNE CODE_EB52

LDA #$04                                                    ;play act 4 cutscene
JMP CODE_EB5D

CODE_EB52:
CPY #13                                                     ;below level 14, the acts will play in specific levels
BCC CODE_EB57
RTS

CODE_EB57:
LDA ActPerLevel1Through13_EB3A,Y                            ;
BNE CODE_EB5D                                               ;
RTS                                                         ;

CODE_EB5D:
STA CurrentActCutscene                                      ;current act cutscene value...

JSR CODE_EB67
JSR CODE_EBB2                                               ;draw clapper and probably other stuff
RTS

CODE_EB67:
CMP #$01                                                    ;check if act 1
BNE CODE_EB76                                               ;

LDA #Sound_Act1Part1
JSR PlaySound_F2FF

LDA #Sound_Act1Part2
JSR PlaySound_F2FF
RTS

CODE_EB76:
CMP #$02                                                    ;act 2
BNE CODE_EB85

LDA #Sound_Act2Part1
JSR PlaySound_F2FF

LDA #Sound_Act2Part2
JSR PlaySound_F2FF
RTS

CODE_EB85:
CMP #$04                                                    ;act 4
BNE CODE_EB94

LDA #Sound_Act4Part1
JSR PlaySound_F2FF

LDA #Sound_Act4Part2
JSR PlaySound_F2FF
RTS

;play act 3
CODE_EB94:
LDA #Sound_Act3Part1
JSR PlaySound_F2FF

LDA #Sound_Act3Part2
JSR PlaySound_F2FF
RTS

;clapboard tiles for the act cutscenes
ActCutscene_ClapboardTilemap_EB9F:
.byte $B0,$B1,$B1,$B1,$B2
.byte $B3,$B4,$B5,$00,$B6                                   ;the $00 is a placeholder for the act number
.byte $B7,$B8,$B8,$B8,$B9

;VRAM offsets for each row (high byte is constant)
ActCutscene_ClapboardVRAMOffsetLow_EBAE:
.byte <ClapperBaseVRAMPosition
.byte <ClapperBaseVRAMPosition+$20
.byte <ClapperBaseVRAMPosition+$40
 
 ;a lonely duplicate of the above (was it supposed to be 5x4 intead of 5x3?)
.byte <ClapperBaseVRAMPosition+$40

CODE_EBB2:
JSR DefaultVisuals_F91D

LDA #$00
STA CameraPositionY
STA CameraBasePositionOffset

LDA #$00
STA $89

LOOP_EBBF:
LDA #>ClapperBaseVRAMPosition
STA VRAMPointerReg

LDX $89

LDA ActCutscene_ClapboardVRAMOffsetLow_EBAE,X               ;
STA VRAMPointerReg

LDX #$04                                                    ;5 tiles per row

LOOP_EBCE:
CPY #$08
BNE CODE_EBDB

LDA CurrentActCutscene                                      ;act number
CLC                                                         ;
ADC #GFX_FontTiles                                          ;base offset for the font characters
CLV                                                         ;
BVC CODE_EBDE                                               ;

CODE_EBDB:
LDA ActCutscene_ClapboardTilemap_EB9F,Y                     ;get the clapperboard tiles

CODE_EBDE:
STA VRAMUpdateRegister                                      ;draw the clapboard (or clapperboard or dumb slate or movie slate or whatever you wanna call it)

INY                                                         ;next tile
DEX                                                         ;
BPL LOOP_EBCE                                               ;did we draw all of the clapboard tiles on the same row?

INC $89                                                     ;next one

LDA $89                                                     ;check if drew all rows
CMP #$03                                                    ;
BNE LOOP_EBBF                                               ;

LDA #>ItemBasePositionDuringAct
STA $84

LDA #<ItemBasePositionDuringAct
STA $83
JSR DisplayHUDItems_E862

LDA #$18
STA $8B
JSR SetPPUAttributesForSpecialscreen_FB34
JSR StoreToControlAndRenderRegs_9A70

LDA #$00
STA CurrentMazeLayout
JSR LoadDefaultPalettes_88D1

LDA CurrentActCutscene                                      ;check if the last cutscene ever!!
CMP #$04                                                    ;
BNE CODE_EC15                                               ;

LDA #TileStripeID_ActName_TheEnd                            ;this one is a separate ID for some reason
CLV                                                         ;
BVC CODE_EC18                                               ;

CODE_EC15:
CLC
ADC #TileStripeID_ActName_TheyMeet-1                        ;the three other IDs must be together! this is the base

CODE_EC18:
JSR DrawTileStripes_9B80                                    ;
JSR EnableRender_9A41                                       ;
JSR SpawnClapperEntity_96F3                                 ;

LDA #$00
STA FrameCounter+1
STA FrameCounter

LOOP_EC27:
JSR WaitAFrame_FFAC
JSR HandleControllerInputs_A10A
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA FrameCounter                                            ;after a little bit, will remove act name
CMP #$40                                                    ;
BNE CODE_EC3E                                               ;

LDA #TileStripeID_ActNameEmpty                              ;remove act name
JSR DrawTileStripes_9B80                                    ;

CODE_EC3E:
LDA CurrentActCutscene                                      ;check if in cutscene 4
CMP #$04                                                    ;
BEQ CODE_EC4C                                               ;cannot use pause to skip it, you'll watch it wether you like it or not.

LDA Player1Inputs_Press                                     ;
AND #Input_Start                                            ;press start to skip the cutscene
BEQ CODE_EC4C                                               ;
RTS                                                         ;

CODE_EC4C:
LDA FrameCounter                                            ;check if reached this number (it's big!)
CMP #$80                                                    ;
BCC LOOP_EC27                                               ;

JSR RemoveAllEntities_89DC                                  ;clear all entities, more specifically, the sprite part of the clapper.

LDA #TileStripeID_RemoveClapper                             ;remove the BG tiles of the clapper
JSR DrawTileStripes_9B80                                    ;

LDA CurrentActCutscene                                      ;check if cutscene act 1
CMP #$01                                                    ;
BNE CODE_EC64                                               ;

JMP InitAct1Cutscene_ECB9                                   ;run it

CODE_EC64:
CMP #$02                                                    ;cutscene 2?
BNE CODE_EC6B                                               ;

JMP InitAct2Cutscene_EDD9                                   ;run it

CODE_EC6B:
CMP #$04                                                    ;cutscene 4?
BNE InitAct3Cutscene_EC72

JMP InitAct4Cutscene_EE72                                   ;run it

;cutscene 3 code
InitAct3Cutscene_EC72:
JSR SpawnCutsceneStork_9734
JSR SpawnCutscenePacJunior_9745

LDA #Entity_ID_CutscenePlayer
JSR SpawnEntity_8A61

LDA #$40                                                    ;spawn at these coordinates
STA Entity_XPos,X

LDA #$CA
STA Entity_YPos,X

LDA #Entity_ID_CutscenePlayer
JSR SpawnEntity_8A61

LDA #$30
STA Entity_XPos,X

LDA #$CA
STA Entity_YPos,X

LDA #$10                                                    ;visually, this player is a pac-man
STA Entity_GFXFrame,X                                       ;

JSR SetupAct3StorkAndBagPalette_88FF                        ;load stork and its bag palette

LDA #$00
STA FrameCounter+1
STA FrameCounter

ExecuteAct3Cutscene_EC9F:
JSR WaitAFrame_FFAC
JSR HandleControllerInputs_A10A
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA Player1Inputs_Press                                     ;check if player presses...
AND #Input_Start                                            ;start
BEQ CODE_ECB2                                               ;
RTS                                                         ;skip cutscene

CODE_ECB2:
LDA FrameCounter+1
CMP #$02
BCC ExecuteAct3Cutscene_EC9F
RTS

InitAct1Cutscene_ECB9:
LDA #Entity_ID_CutscenePlayer
JSR SpawnEntity_8A61

LDA #$F8
STA Entity_XPos,X

LDA #$C0
STA Entity_YPos,X

LDA #Entity_Direction_Left
STA Entity_Direction,X

LDA #-$02
STA Entity_XSpeed,X

LDA #Player_Character_MsPacMan                              ;ms-pac-man
STA Entity_PlayerCharacter,X                                ;

LDA #$01
STA $20,X

LDA #Entity_ID_CutscenePlayer
JSR SpawnEntity_8A61

LDA #$08
STA Entity_XPos,X

LDA #$40
STA Entity_YPos,X

LDA #Entity_Direction_Right
STA Entity_Direction,X

LDA #$02
STA Entity_XSpeed,X

LDA #Player_Character_PacMan                                ;mr. pac-man
STA Entity_PlayerCharacter,X                                ;

LDA #$01
STA $20,X

LDA #$00
STA FrameCounter+1
STA FrameCounter

ExecuteAct1Cutscene_ECFD:
JSR WaitAFrame_FFAC
JSR HandleControllerInputs_A10A
JSR HandleAct1CutsceneAction_ED24
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA Player1Inputs_Press
AND #Input_Start                                            ;press start to skip the cutscene
BEQ CODE_ED13                                               ;
RTS                                                         ;

CODE_ED13:
LDA FrameCounter+1
CMP #$02
BNE CODE_ED20

LDA FrameCounter
CMP #$80
BNE CODE_ED20
RTS

CODE_ED20:
SEC                                                         ;
BCS ExecuteAct1Cutscene_ECFD                                ;
RTS                                                         ;pointless

HandleAct1CutsceneAction_ED24:
LDA FrameCounter+1
CMP #$01
BNE CODE_ED6E

LDA FrameCounter
CMP #$10
BNE CODE_ED6E

LDA #Entity_ID_CutscenePlayer
JSR SpawnEntity_8A61

LDA #$08
STA Entity_XPos,X

LDA #$80
STA Entity_YPos,X

LDA #Entity_Direction_Right
STA Entity_Direction,X

LDA #$02
STA Entity_XSpeed,X

LDA #Player_Character_MsPacMan
STA Entity_PlayerCharacter,X

LDA #$01
STA $20,X

LDA #Entity_ID_CutscenePlayer
JSR SpawnEntity_8A61

LDA #$F8
STA Entity_XPos,X

LDA #$80
STA Entity_YPos,X

LDA #Entity_Direction_Left
STA Entity_Direction,X

LDA #-$02
STA Entity_XSpeed,X

LDA #Player_Character_PacMan
STA Entity_PlayerCharacter,X

LDA #$01
STA $20,X

CODE_ED6E:
LDA FrameCounter+1
BNE CODE_EDA2

LDA FrameCounter
CMP #$20
BNE CODE_EDA2

LDA #Entity_ID_CutsceneGhost
JSR SpawnEntity_8A61

LDA #$F8
STA Entity_XPos,X

LDA #$C0
STA Entity_YPos,X

LDA #Entity_Direction_Left
STA Entity_Direction,X

LDA #Entity_Ghost_Character_Pinky
STA Entity_Ghost_Character,X                                ;this is Pinky from Doom. wait, wrong franchise.

LDA #Entity_ID_CutsceneGhost
JSR SpawnEntity_8A61

LDA #$08
STA Entity_XPos,X

LDA #$40
STA Entity_YPos,X

LDA #Entity_Direction_Right
STA Entity_Direction,X

LDA #Entity_Ghost_Character_Inky
STA Entity_Ghost_Character,X                                ;inky

CODE_EDA2:
LDA FrameCounter+1
CMP #$01
BNE RETURN_EDD8

LDA FrameCounter
CMP #$40
BNE RETURN_EDD8

LDA #Entity_ID_CutsceneGhost
JSR SpawnEntity_8A61

LDA #$10
STA Entity_XPos,X

LDA #$80
STA Entity_YPos,X

LDA #Entity_Direction_Right
STA Entity_Direction,X

LDA #Entity_Ghost_Character_Pinky
STA Entity_Ghost_Character,X                                ;this character is Pinky Pie. wait, wrong fanchise.

LDA #Entity_ID_CutsceneGhost
JSR SpawnEntity_8A61

LDA #$F0
STA Entity_XPos,X

LDA #$80
STA Entity_YPos,X

LDA #Entity_Direction_Left
STA Entity_Direction,X

LDA #Entity_Ghost_Character_Inky
STA Entity_Ghost_Character,X                                ;inky

RETURN_EDD8:
RTS

InitAct2Cutscene_EDD9:
LDA #$00                                                    ;
STA FrameCounter+1                                          ;
STA FrameCounter                                            ;

LDA #$FF                                                    ;
STA Act2Cutscene_CharacterAppearancePhase                   ;

LDA #$90                                                    ;
STA Act2Cutscene_CharacterAppearanceTimer                   ;

ExecuteAct2Cutscene_EDE9:
JSR WaitAFrame_FFAC
JSR HandleControllerInputs_A10A
JSR HandleAct2CutsceneAction_EE07
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA Player1Inputs_Press                                     ;check if player pressed start
AND #Input_Start                                            ;
BEQ CODE_EDFF                                               ;
RTS                                                         ;skip this cutscene

CODE_EDFF:
LDA Act2Cutscene_CharacterAppearancePhase                   ;
CMP #$0A                                                    ;when reaches this value, the cutscene ends
BNE ExecuteAct2Cutscene_EDE9                                ;
RTS                                                         ;cutscene ends

HandleAct2CutsceneAction_EE07:
DEC Act2Cutscene_CharacterAppearanceTimer                   ;timer ticks
BNE RETURN_EE24                                             ;

INC Act2Cutscene_CharacterAppearancePhase                   ;next stage of this cutscene

LDY Act2Cutscene_CharacterAppearancePhase                   ;
LDA Act2Cutscene_PhaseTimings_EE25,Y                        ;
STA Act2Cutscene_CharacterAppearanceTimer                   ;set timer before next character appearance

LDA #Entity_ID_CutscenePlayer                               ;spawn cutscene version of pac-man/ms. pac-man
JSR SpawnEntity_8A61                                        ;

JSR SetAct2CharacterVariables_EE39                          ;

LDA #$01                                                    ;basic horizontal movement state
STA $20,X

RETURN_EE24:
RTS                                                         ;

;timing for pac-man/ms.pac-man appearance on-screen (or for ending the cutscene for the very last value
Act2Cutscene_PhaseTimings_EE25:
.byte $30,$C8
.byte $30,$D8
.byte $30,$D0
.byte $10,$30
.byte $10,$F8

Act2Cutscene_CharacterSpawnYPositions_EE2F:
.byte $30,$B0,$90,$40,$C0

;horizontal speed only
Act2Cutscene_CharacterSpeeds_EE34:
.byte $02,-$02,$02,-$08,$08

;set position, speed and so on of pac-man and ms. pac-man when they're chasing one another
SetAct2CharacterVariables_EE39:
LDA Act2Cutscene_CharacterAppearancePhase                   ;
LSR A                                                       ;
TAY                                                         ;
LDA Act2Cutscene_CharacterSpawnYPositions_EE2F,Y            ;
STA Entity_YPos,X                                           ;

LDA Act2Cutscene_CharacterSpeeds_EE34,Y                     ;
STA Entity_XSpeed,X                                         ;
TYA                                                         ;
AND #$01                                                    ;
BNE CODE_EE53                                               ;

LDA #$08                                                    ;spawn on the left side of the screen
CLV                                                         ;
BVC CODE_EE55                                               ;

CODE_EE53:
LDA #$F8                                                    ;spawn on the right side of the screen

CODE_EE55:
STA Entity_XPos,X                                           ;
TYA                                                         ;
AND #$01                                                    ;
BNE CODE_EE61                                               ;different direction too

LDA #Entity_Direction_Right                                 ;
CLV                                                         ;
BVC CODE_EE63                                               ;

CODE_EE61:
LDA #Entity_Direction_Left                                  ;

CODE_EE63:
STA Entity_Direction,X                                      ;

LDA Act2Cutscene_CharacterAppearancePhase                   ;
CLC                                                         ;
ADC #$01                                                    ;
LSR A                                                       ;
AND #$01                                                    ;alternate character spawn (pac-man or ms. pac-man)
STA Entity_PlayerCharacter,X                                ;
RTS                                                         ;

;cutscene 4 code
InitAct4Cutscene_EE72:
LDA #Entity_ID_CutscenePlayer
JSR SpawnEntity_8A61

LDA #$F8
STA Entity_XPos,X

LDA #$A0
STA Entity_YPos,X

LDA #Entity_Direction_Left
STA Entity_Direction,X

LDA #-$01
STA Entity_XSpeed,X

LDA #Player_Character_MsPacMan
STA Entity_PlayerCharacter,X

LDA #$05
STA $20,X

LDA #Entity_ID_CutscenePlayer
JSR SpawnEntity_8A61

LDA #$08
STA Entity_XPos,X

LDA #$A0
STA Entity_YPos,X

LDA #Entity_Direction_Right
STA Entity_Direction,X

LDA #$01
STA Entity_XSpeed,X

LDA #Player_Character_PacMan
STA Entity_PlayerCharacter,X

LDA #$05
STA $20,X

LDA #$FF                                                    ;
STA Player1EntitySlot                                       ;
STA Player2EntitySlot                                       ;

LDA #$00                                                    ;init frame counter
STA FrameCounter+1                                          ;
STA FrameCounter                                            ;

ExecuteAct4Cutscene_EEBC:
JSR WaitAFrame_FFAC                                         ;
JSR HandleControllerInputs_A10A                             ;

LDA FrameCounter+1                                          ;check for specific timings
CMP #$03                                                    ;see if in range between 768 frames and 1280 frames
BMI CODE_EEEA                                               ;
CMP #$05                                                    ;will spawn pac-juniors in that time frame
BPL CODE_EEEA                                               ;

LDA FrameCounter                                            ;
AND #$3F                                                    ;will spawn pac-man offspring every 64th frame
BNE CODE_EEEA                                               ;

LDA #Entity_ID_PacJunior                                    ;actual pac-man junior. not a special cutscene variant, this one will roam freely
JSR SpawnEntity_8A61                                        ;

JSR PollRandomNumber_A3D8                                   ;
AND #$0F                                                    ;
STA Entity_CurrentTileXPosition,X                           ;somewhat random horizontal position

LDA #$13
STA Entity_CurrentTileYPosition,X                           ;same vertical level

JSR HandleEntityVisualPosition_A383
JSR PlayJuniorSpawnSFX_EF01                                 ;play pacman junior appearance SFX

CODE_EEEA:
JSR HandleEntities_8A8C                                     ;
JSR HandleEntityGraphics_8A12                               ;

LDA FrameCounter+1                                          ;check if we reached the 1280 frame mark
CMP #$05                                                    ;
BNE CODE_EEFD                                               ;

LDA FrameCounter                                            ;
CMP #$20                                                    ;wait 32 more frames before this entire scene ends
BMI CODE_EEFD                                               ;
RTS                                                         ;

CODE_EEFD:
SEC                                                         ;
BCS ExecuteAct4Cutscene_EEBC                                ;an interesting branch.
RTS                                                         ;RTS you can't trigger

PlayJuniorSpawnSFX_EF01:
JSR PollRandomNumber_A3D8                                   ;
AND #$01                                                    ;alternate sound somewhat randomly
BNE CODE_EF15                                               ;

LDA #Sound_PacJrAppear2Part1                                ;
JSR PlaySound_F2FF                                          ;

LDA #Sound_PacJrAppear2Part2                                ;
JSR PlaySound_F2FF                                          ;

CLV                                                         ;\can be replaced with RTS
BVC RETURN_EF1F                                             ;/

CODE_EF15:
LDA #Sound_PacJrAppear1Part1                                ;
JSR PlaySound_F2FF                                          ;

LDA #Sound_PacJrAppear1Part2                                ;
JSR PlaySound_F2FF                                          ;

RETURN_EF1F:
RTS                                                         ;

;maze layout values for each selection
MazeLayoutsPerSelectionPointers_EF20:
.word ArcadeMazeSelectionLayouts_EF28
.word MiniMazeSelectionLayouts_EF3E
.word BigMazeSelectionLayouts_EF5F
.word StrangeMazeSelectionLayouts_EF80

;maze layout values for each selection
;first byte indicates the size of the first pack of level layouts that never repeat
;the rest are levels that repeat the layout every 16 mazes
ArcadeMazeSelectionLayouts_EF28:
.byte @RepeatingMazes-ArcadeMazeSelectionLayouts_EF28-1
.byte $00,$00,$01,$01,$01 ;levels 1-5

@RepeatingMazes:
.byte $02,$02,$02,$02,$03,$03,$03,$03 ;level 6 onward
.byte $02,$02,$02,$02,$03,$03,$03,$03

MiniMazeSelectionLayouts_EF3E:
.byte @RepeatingMazes-MiniMazeSelectionLayouts_EF3E-1
.byte $04,$05,$04,$05,$06,$04,$05,$06 ;levels 1-16
.byte $07,$04,$05,$06,$07,$04,$05,$06

@RepeatingMazes:
.byte $07,$1E,$1E,$07,$06,$05,$04,$1F ;levels 17 onward
.byte $04,$05,$06,$07,$1E,$05,$06,$1F

BigMazeSelectionLayouts_EF5F:
.byte @RepeatingMazes-BigMazeSelectionLayouts_EF5F-1
.byte $0A,$0B,$0C,$0A,$0B,$0C,$0D,$0E ;levels 1-16
.byte $08,$09,$0E,$0C,$0D,$0F,$0B,$0A

@RepeatingMazes:
.byte $09,$08,$09,$0A,$1D,$0C,$0D,$0E ;levels 17 onward
.byte $0F,$1C,$0F,$0E,$1D,$0B,$1C,$23

StrangeMazeSelectionLayouts_EF80:
.byte @RepeatingMazes-StrangeMazeSelectionLayouts_EF80-1
.byte $19,$11,$12,$16,$15,$22,$1A,$20 ;levels 1-16
.byte $1B,$09,$10,$18,$22,$0F,$14,$1E

@RepeatingMazes:
.byte $08,$13,$0A,$0B,$0C,$0D,$0E,$16 ;levels 17 onward
.byte $1C,$1D,$17,$1E,$20,$07,$18,$21

;power pellet timers, depending on difficulty or something
DATA_EFA1:
.byte $60,$50,$40,$30,$20,$50,$20,$1C
.byte $18,$40,$20,$1C,$18,$20,$1C,$18

;unknown
.byte $00,$18

;known
.byte $20

;speed modifier for each game difficulty.
PlayerSpeedPerDifficulty_EFB4:
.byte $00                                                   ;normal
.byte -$04                                                  ;easy (slighly slower)
.byte $0C                                                   ;hard
.byte $18                                                   ;crazy

;speed modifier for each game difficulty.
GhostSpeedPerDifficulty_EFB8:
.byte $00                                                   ;normal
.byte -$08                                                  ;easy (slow down instead of speed up)
.byte $10                                                   ;hard
.byte $20                                                   ;C R A Z Y

;determines player speed, the speed changes every 4 levels
PlayerSpeedPerLevels_EFBC:
.byte $20 ;levels 1-4
.byte $24 ;levels 5-8
.byte $24 ;levels 9-12
.byte $28 ;levels 13-16
.byte $27 ;levels 17-20
.byte $26 ;levels 21-24
.byte $25 ;levels 25-28
.byte $24 ;levels 29-32
.byte $23 ;levels 33-36 (these are normally inaccessible without cheats)
.byte $22 ;levels 37-40
.byte $20 ;levels 41-44
.byte $1F ;levels 45-48
.byte $1E ;levels 49-52
.byte $1C ;levels 53 and beyond

;determines ghost speed for levels 1-13.
;The last value applies to level 13 and above.
GhostSpeedPerLevel_EFCA:
.byte $18,$18,$18,$18                                       ;levels 1-4
.byte $20,$21,$22,$23                                       ;levels 5-8
.byte $24,$25,$26,$27                                       ;levels 9-12
.byte $28                                                   ;level 13+

DATA_EFD7:
.byte $08,$04,$03,$03

DATA_EFDB:
.byte $10,$08,$04,$03

DATA_EFDF:
.byte $20,$10,$08,$03

;these bits are used to enable respective channel playback
;Square 1, Square 2, Triangle, Noise, DMC
;Noise and DMC are unused
SoundChannelEnableBits_EFE3:
.byte $01,$02,$04,$08,$10

.include "Data/SoundDataLoader.asm"                         ;moved sound data & pointers to separate files

;input A for specific sound effect/jingle/sound loop/whatever
PlaySound_F2FF:
TAY                                                         ;
LDA DemoMovementIndex                                       ;if currently playing DEMO mode...
BEQ CODE_F305                                               ;oh, are we? well, if not, play sounds
RTS                                                         ;NO SOUND!

CODE_F305:
TXA                                                         ;preserve X and a few other things we're messing with
PHA                                                         ;
LDA $89                                                     ;
PHA                                                         ;
LDA $8A                                                     ;
PHA                                                         ;

TYA                                                         ;
ASL A                                                       ;get sound data pointer
TAY                                                         ;
LDA SoundDataPointers_EFE8,Y                                ;
STA $89                                                     ;

LDA SoundDataPointers_EFE8+1,Y                              ;
STA $8A                                                     ;

LDY #$00
LDA ($89),Y                                                 ;get sound slot
AND #$0F                                                    ;
TAX                                                         ;

LDA ($89),Y                                                 ;get sound channel
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
STA $94                                                     ;

INY                                                         ;
LDA ($89),Y                                                 ;
STA $93                                                     ;

LDA Sound_ChannelEnabledFlag,X                              ;is this sound slot occupied by something?
BEQ CODE_F340                                               ;

LDA Sound_PriorityLevel,X                                   ;
SEC                                                         ;
SBC #$01                                                    ;
CMP $93                                                     ;check if the this sound is important than what's currently being played
BMI CODE_F340                                               ;can override

JMP CODE_F35C                                               ;cannot play this sound byte, sorry.

CODE_F340:
LDA #$01                                                    ;obviously this channel is enabled for playback
STA Sound_ChannelEnabledFlag,X                              ;

LDA $93                                                     ;
STA Sound_PriorityLevel,X                                   ;important or not

LDA $94                                                     ;play on this channel
STA Sound_AssignedChannel,X                                 ;

LDA #$FF                                                    ;default props
STA Sound_CurrentNoteParameters,X                           ;

LDA #$01                                                    ;
JSR OffsetSoundDataPointer_F38D                             ;
JSR ReadSoundData_F3F9                                      ;start getting sound playing under way

CODE_F35C:
PLA                                                         ;
STA $8A                                                     ;
PLA                                                         ;
STA $89                                                     ;
PLA                                                         ;
TAX                                                         ;
RTS                                                         ;

;takes 4 bytes of data to initialize the sound channel playback (or re-initialize)
InitSoundChannel_F365:
INY                                                         ;
LDA ($89),Y                                                 ;
STA Sound_ChannelVariable1,X                                ;

INY                                                         ;
LDA ($89),Y                                                 ;
STA Sound_ChannelVariable2,X                                ;

INY                                                         ;
LDA ($89),Y                                                 ;
STA Sound_ChannelVariable3,X                                ;

INY                                                         ;
LDA ($89),Y                                                 ;
STA Sound_ChannelVariable4,X                                ;

LDA #$05                                                    ;skip over
JMP OffsetSoundDataPointer_F38D                             ;

SetNoteProperty_F382:
INY                                                         ;
LDA ($89),Y                                                 ;
STA Sound_CurrentNoteParameters,X                           ;set frequency/timing instead of modifying its

LDA #$02                                                    ;skip over
JMP OffsetSoundDataPointer_F38D                             ;

;input A - offset
OffsetSoundDataPointer_F38D:
CLC                                                         ;
ADC $89                                                     ;
STA Sound_DataPointerLow,X                                  ;offset by A
STA $89                                                     ;

LDA $8A                                                     ;
ADC #$00                                                    ;
STA Sound_DataPointerHigh,X                                 ;
STA $8A                                                     ;

LDY #$00                                                    ;
LDA ($89),Y                                                 ;load something next
RTS                                                         ;

;Stops all currently playing sounds (even power pellet loop!)
DisableSounds_F3A3:
LDA #$00                                                    ;
LDX #$05                                                    ;

LOOP_F3A7:
STA Sound_ChannelEnabledFlag,X                              ;not playing this
DEX                                                         ;
BPL LOOP_F3A7                                               ;

LDA #$0F                                                    ;all channels enabled
STA APU_SoundChannels                                       ;
RTS                                                         ;

HandleSound_F3B3:
LDX #$05                                                    ;6 sound slots to check through

LOOP_F3B5:
LDA Sound_ChannelEnabledFlag,X                              ;see if this sound slot is playing sound
BEQ CODE_F3C2

DEC Sound_NoteLength,X                                      ;keep at it, you're doing great
BNE CODE_F3C2                                               ;

JSR ReadSoundData_F3F9                                      ;

CODE_F3C2:
DEX                                                         ;
BPL LOOP_F3B5                                               ;next sound slot
RTS                                                         ;

;used to load the next instruction/value
OffsetSoundDataPointerBy1_F3C6:
LDA Sound_DataPointerLow,X                                  ;
CLC                                                         ;
ADC #$01                                                    ;
STA Sound_DataPointerLow,X                                  ;
STA $89                                                     ;

LDA Sound_DataPointerHigh,X                                 ;
ADC #$00                                                    ;
STA Sound_DataPointerHigh,X                                 ;

LDA Sound_DataPointerHigh,X                                 ;>this is not needed, this LDA specifically
STA $8A                                                     ;
RTS                                                         ;

RepeatPreviousPairOfData_F3DF:
LDA Sound_DataPointerLow,X                                  ;
CLC                                                         ;
ADC #$FE                                                    ;throw back a couple of bytes
STA Sound_DataPointerLow,X                                  ;
STA $89                                                     ;

LDA Sound_DataPointerHigh,X                                 ;
ADC #$FF                                                    ;
STA Sound_DataPointerHigh,X                                 ;
STA $8A                                                     ;look ma, LDA!

LDY #$00                                                    ;
LDA ($89),Y                                                 ;
RTS                                                         ;

ReadSoundData_F3F9:
JSR OffsetSoundDataPointerBy1_F3C6                          ;prepare to load the next value

LDY #$00                                                    ;
LDA ($89),Y                                                 ;

LOOP_F400:
CMP #$FF                                                    ;check if encountered a stop command
BNE CODE_F40A                                               ;

LDA #$00                                                    ;sound over
STA Sound_ChannelEnabledFlag,X                              ;
RTS                                                         ;

CODE_F40A:
CMP #SoundCommand_InitChannel                               ;see if we need to initialize the sound
BNE CODE_F414

JSR InitSoundChannel_F365                                   ;initialize channel
JMP LOOP_F400

CODE_F414:
CMP #SoundCommand_SetNoteProperties                         ;see if we need to set the property for the current note
BNE CODE_F41E                                               ;

JSR SetNoteProperty_F382                                    ;
JMP LOOP_F400

CODE_F41E:
CMP #SoundCommand_RepeatAPairOfBytes                        ;see if we need to loop back
BNE CODE_F428

JSR RepeatPreviousPairOfData_F3DF                           ;TIME PARADOX
JMP LOOP_F400

;none of the commands...
CODE_F428:
PHA
AND #$1F                                                    ;first 5 bits...
CMP #$10                                                    ;check if its less than 10
BPL CODE_F439                                               ;
CLC                                                         ;frequency decreases
ADC Sound_CurrentNoteParameters,X                           ;
STA Sound_CurrentNoteParameters,X                           ;

CLV
BVC CODE_F44A

CODE_F439:
BNE CODE_F440                                               ;check if exactly 10...

LDA #$4A                                                    ;set frequency to 0
CLV                                                         ;
BVC CODE_F44A                                               ;

CODE_F440:
CLC                                                         ;frequency increases instead
ADC #$E0                                                    ;
CLC                                                         ;
ADC Sound_CurrentNoteParameters,X                           ;
STA Sound_CurrentNoteParameters,X                           ;

;sound channel's frequency is stored here
CODE_F44A:
CMP #$4B
BCS CODE_F468                                               ;can't set frequency if out of bounds
ASL A
TAY
LDA ChannelFrequencyLookup_F4AE,Y
STA Sound_ChannelVariable3,X

LDA Sound_ChannelVariable4,X                                ;
AND #$F8                                                    ;remember bit 3 (used for continuous playback that is broken by an external timer)
STA $89                                                     ;

LDA ChannelFrequencyLookup_F4AE+1,Y
ORA $89
STA Sound_ChannelVariable4,X

CLV
BVC CODE_F46D

CODE_F468:
LDA #$FF                                                    ;don't change frequency
STA Sound_CurrentNoteParameters,X

CODE_F46D:
LDA Sound_AssignedChannel,X
TAY
LDA SoundChannelEnableBits_EFE3,Y
ORA APU_SoundChannels                                       ;mix with whatever we had before
STA APU_SoundChannels
TYA
ASL A
ASL A
TAY
LDA Sound_ChannelVariable1,X                                ;store SFX stuff into appropriate channel
STA APU_Square1DutyAndVolume,Y                              ;note that this isn't eqlusively square 1, it can be any of the channels (depending on Y offset)

INY
LDA Sound_ChannelVariable2,X
STA APU_Square1DutyAndVolume,Y

INY
LDA Sound_ChannelVariable3,X
STA APU_Square1DutyAndVolume,Y

INY
LDA Sound_ChannelVariable4,X
STA APU_Square1DutyAndVolume,Y

PLA
LSR A
LSR A
LSR A
LSR A
LSR A
TAY                                                         ;last 3 bits are used determine the note's length
LDA NoteLengthLookup_F4A7,Y                                 ;
STA Sound_NoteLength,X                                      ;play for this long
RTS

;timing things
NoteLengthLookup_F4A7:
.byte $01,$08,$10,$20,$0C,$04,$18

;various pre-calculated frequency values for channels that use it (that means not noise and DMC)
;most of these values are unused.
ChannelFrequencyLookup_F4AE:
.word $06AE,$064E,$05F4,$059E
.word $054D,$0501,$04B9,$0475
.word $0435,$03F9,$03C0,$038A
.word $0357,$0327,$02FA,$02CF
.word $02A7,$0281,$025D,$023B
.word $021B,$01FC,$01E0,$01C5
.word $01AC,$0194,$017D,$0168
.word $0153,$0140,$012E,$011D
.word $010D,$00FE,$00F0,$00E2
.word $00D6,$00CA,$00BE,$00B4
.word $00AA,$00A0,$0097,$008F
.word $0087,$007F,$0078,$0071
.word $006B,$0065,$005F,$005A
.word $0055,$0050,$004C,$0047
.word $0043,$0040,$003C,$0039
.word $0035,$0032,$0030,$002D
.word $002A,$0028,$0026,$0024
.word $0022,$0020,$001E,$001C
.word $001B,$0001,$0000

;initialize all options... as it says on the tin can of beans it's found on
InitOptions_F544:
LDX #$04                                                    ;go through all 5 option variables
LDA #$00                                                    ;oops, all zeroes!

LOOP_F548:
STA Options_Type,X                                          ;
DEX                                                         ;
BPL LOOP_F548                                               ;
RTS                                                         ;

DrawOptionsCursor_F54F:
JSR HandleCursorPosition_F56B                               ;draw it in an appropriate position

LDA #OptionsScreen_CursorTile                               ;
JSR SingleTileIntoBuffer_9B00                               ;cram that information into buffer
RTS                                                         ;

;make sure the cursor from the previous position is erased
BlankPreviousOptionsCursorPosition_F558:
JSR HandleCursorPosition_F56B                               ;or the lack thereof

LDA #EmptyTile                                              ;empty tile
JSR SingleTileIntoBuffer_9B00                               ;
RTS                                                         ;

;vram position offsets for cursor's position
CursorVRAMPositionOffsetsHigh_F561:
.byte $00,$00,$00,$01,$01

CursorVRAMPositionOffsetsLow_F566:
.byte $00,$60,$C0,$20,$80

;handles wrap-around and VRAM position for drawing
HandleCursorPosition_F56B:
LDA Options_CursorPosition                                  ;check if its position is wrapped around
BPL CODE_F577                                               ;

LDA Options_MaxOptions                                      ;make sure it wraps around to the last option (starting level)
SEC                                                         ;
SBC #$01                                                    ;

CLV                                                         ;
BVC CODE_F57D                                               ;

CODE_F577:
CMP Options_MaxOptions                                      ;did it go past the last option?
BMI CODE_F57D                                               ;

LDA #$00                                                    ;wrap around to the first option (type)

CODE_F57D:
STA Options_CursorPosition                                  ;
TAY                                                         ;

LDA CursorVRAMPositionOffsetsHigh_F561,Y                    ;
STA $90                                                     ;

LDA CursorVRAMPositionOffsetsLow_F566,Y                     ;
STA $8F                                                     ;

LDA $8F                                                     ;
CLC                                                         ;
ADC Options_DefaultVRAMPos                                  ;
STA $8F                                                     ;

LDA $90                                                     ;
ADC Options_DefaultVRAMPos+1                                ;
STA $90                                                     ;
RTS                                                         ;

CODE_F598:
JSR CODE_F88E

LDA #$00
STA FrameCounter+1

LOOP_F59F:
JSR WaitAFrame_FFAC
JSR HandleControllerInputs_A10A
JSR CODE_F96B
JSR HandleEntities_8A8C
JSR HandleEntityGraphics_8A12

LDA FrameCounter+1
CMP #$04
BNE CODE_F5D0

LDX #$04
LDA Options_Type

LOOP_F5B9:
ORA Options_Type,X
DEX
BNE LOOP_F5B9
CMP #$00
BNE CODE_F5CD

LDA #$02
STA DemoMovementIndex                                       ;start demo mode
JMP CODE_80CC

;unused
CLV                                                         ;
BVC CODE_F5D0                                               ;

CODE_F5CD:
JMP InitOptionsScreen_F64B

CODE_F5D0:
LDA Player1Inputs_Press                                     ;pressed start?
AND #Input_Start                                            ;
BEQ LOOP_F59F                                               ;negative
JMP InitOptionsScreen_F64B

;handle palette animation for TENGEN PRESENTS and "PRESS START" strings (former for both game load and title screen, latter is title screen only)
AnimateTengenPresentsAndPressStartText_F5D9:
CODE_F5D9:
LDA FrameCounter                                            ;create an illusion of PRESS START text blinking (by changing its palette)
AND #$20                                                    ;
BNE CODE_F5E4                                               ;change every 32 frames

LDA #$30                                                    ;white color
CLV                                                         ;
BVC CODE_F5E6                                               ;

CODE_F5E4:
LDA #$0F                                                    ;black color

CODE_F5E6:
STA PaletteStorage+(Palette_Background0 + 3)                ;fourth color of BG palette 0

LDA FrameCounter                                            ;animate the fourth color in BG palette 1
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;change color every 16 frames
AND #$03                                                    ;only colors 1, 11, 21 and 31
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;*16
ADC #$01                                                    ;make sure the base color is blue ($01)
STA PaletteStorage+(Palette_Background1 + 3)                ;animate the fourth color in BG palette 1
RTS                                                         ;

;Credits for Ms. Pac-Man screen
InitCreditsScreen_F5FB:
JSR DrawCredits_F8F3                                        ;

LDA #$00                                                    ;
STA FrameCounter+1                                          ;

ExecuteCreditsScreen_F602:
JSR WaitAFrame_FFAC                                         ;basic screen functionality, pass a frame...
JSR HandleControllerInputs_A10A                             ;and handle controller.

LDA FrameCounter+1                                          ;
CMP #$03                                                    ;check if 768 frames passed
BNE CODE_F611
JMP LoadTitleScreen_F626                                    ;apparently just skips all the resetting stuff...? doesn't seem to have any bearing anyway.

CODE_F611:
LDA Player1Inputs_Press                                     ;
AND #Input_Start                                            ;start 2 skip
BEQ ExecuteCreditsScreen_F602                               ;

JSR DisableRender_9A4B                                      ;pretty standard resetting visuals type of stuff. that don't seem necessary since it's all skipped if the timer runs out naturally
JSR DisableNMI_9A55                                         ;
JSR ResetBufferVariables_9AC1                               ;
JSR RemoveAllEntities_89DC                                  ;
JSR StoreToControlAndRenderRegs_9A70                        ;

LoadTitleScreen_F626:
LDA #$00                                                    ;
STA CameraBasePositionOffset                                ;
STA CameraPositionY                                         ;

JSR DrawTitleScreen_F847                                    ;

LDA #$00                                                    ;
STA FrameCounter+1                                          ;

;Title Screen code
ExecuteTitleScreen_F633:
JSR WaitAFrame_FFAC
JSR HandleControllerInputs_A10A
JSR AnimateTengenPresentsAndPressStartText_F5D9

LDA FrameCounter+1                                          ;check if the player hasn't pressed anything for 512 frames
CMP #$02
BNE CODE_F645
JMP CODE_F598                                               ;character intros or game demo or something

CODE_F645:
LDA Player1Inputs_Press                                     ;check if pressed start to go to options
AND #Input_Start
BEQ ExecuteTitleScreen_F633

InitOptionsScreen_F64B:
JSR DrawOptions_F86E                                        ;
JSR InitializeOptionChoicesDisplay_F7AB                     ;

LDY #$04                                                    ;loop through 5 menu items

LOOP_F653:
LDA MaxChoicesPerOption_F74E,Y                              ;
STA Options_OptionMaxChoices,Y                              ;initialize option choice maximum
DEY                                                         ;
BPL LOOP_F653                                               ;

LDA LevelSelectInputCounter                                 ;check if entered the level select combo partially
CMP #$0A                                                    ;
BCC CODE_F668                                               ;

LDA #$1E                                                    ;max level = 30
STA LevelSelect_MaxLevel                                    ;

CODE_F668:
LDA LevelSelectInputCounter                                 ;check if entered the level select combo fully
CMP #$1E                                                    ;
BNE CODE_F674                                               ;

LDA #$63                                                    ;can change the level up to 99
STA LevelSelect_MaxLevel                                    ;

CODE_F674:
LDA Options_StartingLevel                                   ;
CMP LevelSelect_MaxLevel                                    ;
BCC CODE_F697                                               ;
SBC #$FF                                                    ;
STA LevelSelect_MaxLevel                                    ;basically increase the upper level that can be selected for each subsequent level the player has beaten

LDA #TileStripeID_Continues                                 ;draw continues
JSR DrawTileStripes_9B80                                    ;

Macro_SetWord OptionsScreen_CreditsVRAMPosition, $8F

LDA ContinuesRemaining                                      ;draw continues number tile
CLC                                                         ;
ADC #OptionsScreen_CreditsNumberTilesBase                   ;
JSR SingleTileIntoBuffer_9B00                               ;

CODE_F697:
LDA #$05                                                    ;
STA Options_MaxOptions                                      ;there are max 5 options

Macro_SetWord OptionsScree_CursorBaseVRAMPosition, Options_DefaultVRAMPos

LDA #$00                                                    ;
STA Options_CursorPosition                                  ;default the cursor on TYPE option
STA FrameCounter+1                                          ;
JSR DrawOptionsCursor_F54F                                  ;display cursor when the screen loads in

;ExecuteOptionsScreen_F6AC:
LOOP_F6AC:
JSR HandleMovingCursor_F81A                                 ;handle options screen functionality
JSR HandleOptionChange_F6CC                                 ;

LDA Player1Inputs_Press                                     ;check if player pressed ANYTHING
BEQ CODE_F6BA                                               ;if not, can transition to attract demo and stuff

LDA #$00                                                    ;clear frame counter, delay the attract demo
STA FrameCounter+1                                          ;

CODE_F6BA:
LDA FrameCounter+1                                          ;
CMP #$06                                                    ;check if reached 1536 frames
BNE CODE_F6C3                                               ;
JMP LoadTitleScreen_F626                                    ;return to title screen

CODE_F6C3:
LDA Player1Inputs_Press                                     ;
AND #Input_Start                                            ;check if player pressed pause
BEQ LOOP_F6AC                                               ;
JMP CODE_80CC

;handles option changing when player chooses new option item
HandleOptionChange_F6CC:
LDX Options_CursorPosition                                  ;check if on a specific one
CPX #$05                                                    ;
BNE CODE_F6D3                                               ;
RTS                                                         ;

CODE_F6D3:
LDA Player1Inputs_Press                                     ;
AND #Input_B                                                ;check if pressed B
BEQ CODE_F6F5                                               ;

LDA Options_Type,X                                          ;game type scrolls back
SEC                                                         ;
SBC #$01                                                    ;
BCS CODE_F6E6                                               ;see if scrolled from first option to last

LDA Options_OptionMaxChoices,X                              ;appropriately set the choice to last option
ADC #$FF                                                    ;

CODE_F6E6:
STA Options_Type,X                                          ;

JSR UpdateOptionString_F723                                 ;

LDA #Sound_OptionChange                                     ;change option SFX
JSR PlaySound_F2FF                                          ;

JSR InitHighScoreOnOptionChange_F717                        ;
RTS                                                         ;

CODE_F6F5:
LDA Player1Inputs_Press                                     ;
AND #Input_A                                                ;check if pressed A
BEQ RETURN_F716                                             ;

LDA Options_Type,X                                          ;
CLC                                                         ;
ADC #$01                                                    ;
CMP Options_OptionMaxChoices,X                              ;
BCC CODE_F708                                               ;

LDA #$00                                                    ;wrap to the first option

CODE_F708:
STA Options_Type,X                                          ;

JSR UpdateOptionString_F723                                 ;

LDA #Sound_OptionChange                                     ;play appropriate SFX when changing options
JSR PlaySound_F2FF                                          ;

JSR InitHighScoreOnOptionChange_F717                        ;

RETURN_F716:
RTS                                                         ;

InitHighScoreOnOptionChange_F717:
CPX #$01                                                    ;check if the option we changed was... type
BCC RETURN_F722                                             ;
CPX #$04                                                    ;check if the option we changed was... starting level
BCS RETURN_F722                                             ;

JSR InitializeHighScore_FD83                                ;invalidate the previous high score (if changed type, difficulty or maze selection)

RETURN_F722:
RTS                                                         ;

;will draw a new string over the old one, indicating option change
UpdateOptionString_F723:
CPX #$04                                                    ;check if we were changing level number
BPL CODE_F73F                                               ;

LDY Options_Type,X                                          ;
TXA                                                         ;
ASL A                                                       ;
TAX                                                         ;
LDA OptionsStripePointers_F753,X                            ;
STA $89                                                     ;

LDA OptionsStripePointers_F753+1,X                          ;
STA $8A                                                     ;

LDA ($89),Y                                                 ;update this option's text
JSR DrawTileStripes_9B80                                    ;

CLV                                                         ;\can be replaced with RTS
BVC RETURN_F74D                                             ;/

;initialize level display in options screen (set it to the max you can select)
CODE_F73F:
Macro_SetWord OptionsScreen_SelectedLevelVRAMPosition, $8F

LDA Options_StartingLevel                                   ;
JSR DisplayLevelNumber_F800                                 ;

RETURN_F74D:
RTS                                                         ;

;used to tell how many options a particular choice have (the choices themselves are below
;the last value is used as a default for the max level you can select
MaxChoicesPerOption_F74E:
.byte $04,$03,$04,$04,$07

;contains pointers to stripe IDs representing option choices for each option
OptionsStripePointers_F753:
.word OptionStripeIDs_Type_F75B
.word OptionStripeIDs_PacBooster_F75F
.word OptionStripeIDs_Difficulty_F762
.word OptionStripeIDs_MazeSelection_F766

OptionStripeIDs_Type_F75B:
.byte TileStripeID_Option_Type_1P
.byte TileStripeID_Option_Type_2PAlternating
.byte TileStripeID_Option_Type_2PCompetitive
.byte TileStripeID_Option_Type_2Cooperative

OptionStripeIDs_PacBooster_F75F:
.byte TileStripeID_Option_PacBooster_Off
.byte TileStripeID_Option_PacBooster_UseAorB
.byte TileStripeID_Option_PacBooster_AlwaysOn

OptionStripeIDs_Difficulty_F762:
.byte TileStripeID_Option_Difficulty_Normal
.byte TileStripeID_Option_Difficulty_Easy
.byte TileStripeID_Option_Difficulty_Hard
.byte TileStripeID_Option_Difficulty_Crazy

OptionStripeIDs_MazeSelection_F766:
.byte TileStripeID_Option_MazeSelection_Arcade
.byte TileStripeID_Option_MazeSelection_Mini
.byte TileStripeID_Option_MazeSelection_Big
.byte TileStripeID_Option_MazeSelection_Strange

HandlePacBoosterFunctionality_F76A:
LDA Options_PacBooster                                      ;check for Options_PacBooster_Off
BEQ RETURN_F79A                                             ;cannot use pac booster at all
CMP #Options_PacBooster_UseAOrB                             ;check if need to use A or B to use it
BNE CODE_F797                                               ;

JSR GetCurrentPlayerInputPress_E1C4                         ;if current player.....
AND #Input_B                                                ;
BEQ CODE_F782                                               ;pressed B...

LDA Entity_PlayerPacBoosterState,X                          ;...toggle pac booster for the player
EOR #$FF                                                    ;
STA Entity_PlayerPacBoosterState,X                          ;

CODE_F782:
LDA Entity_PlayerPacBoosterState,X                          ;check if have pac-booster toggled
BPL CODE_F78A                                               ;if not, check for A input
JMP CODE_F79B                                               ;

CODE_F78A:
JSR GetCurrentPlayerInput_E1AB                              ;current player...
AND #Input_A                                                ;held A....
BEQ CODE_F794                                               ;
JMP CODE_F79B                                               ;more speed!

CODE_F794:
CLV                                                         ;
BVC RETURN_F79A                                             ;

CODE_F797:
JMP CODE_F79B                                               ;pac-booster is always ON

RETURN_F79A:
RTS                                                         ;

CODE_F79B:
LDA CurrentEntitySpeed                                      ;woosh! +1/2 speed added
LSR A                                                       ;
CLC                                                         ;
ADC CurrentEntitySpeed                                      ;
STA CurrentEntitySpeed                                      ;

LDA Entity_GFXFrame,X                                       ;pac-booster moving frames
CLC                                                         ;
ADC #$08                                                    ;offset
STA Entity_GFXFrame,X                                       ;
RTS

InitializeOptionChoicesDisplay_F7AB:
LDY Options_Type                                            ;load the latest choices we made (or default in case of a reset)
LDA OptionStripeIDs_Type_F75B,Y                             ;
JSR DrawTileStripes_9B80                                    ;

LDY Options_PacBooster                                      ;
LDA OptionStripeIDs_PacBooster_F75F,Y                       ;
JSR DrawTileStripes_9B80                                    ;

LDY Options_GameDifficulty                                  ;
LDA OptionStripeIDs_Difficulty_F762,Y                       ;
JSR DrawTileStripes_9B80                                    ;

LDY Options_MazeSelection                                   ;
LDA OptionStripeIDs_MazeSelection_F766,Y                    ;
JSR DrawTileStripes_9B80                                    ;

Macro_SetWord OptionsScreen_SelectedLevelVRAMPosition, $8F

LDA Options_StartingLevel                                   ;level
JSR DisplayLevelNumber_F800                                 ;
RTS                                                         ;

HexToDecLevelNumber_F7DE:
CMP #$0A                                                    ;check if level number is 10 or above
BCS CODE_F7E7                                               ;actually do hex to dec

STA $8D                                                     ;straight up display this number (from 1 to 9)

LDA #$00                                                    ;tens is a zero
RTS                                                         ;

CODE_F7E7:
STA $8D                                                     ;remember our hex value for the level

LDA #$01                                                    ;tens is 1 by default
STA $93                                                     ;

LOOP_F7ED:
LDA $8D                                                     ;
SEC                                                         ;
SBC #$0A                                                    ;-10
STA $8D                                                     ;
CMP #$0A                                                    ;check if the hex value is still 10 or more
BCS CODE_F7FB                                               ;increase decimal tens and continue this loop

LDA $93                                                     ;display tens digit
RTS                                                         ;

CODE_F7FB:
INC $93                                                     ;tens increased by 1
SEC                                                         ;
BCS LOOP_F7ED                                               ;

;input $8E-$8F - where to draw the level value in VRAM
DisplayLevelNumber_F800:
CLC                                                         ;
ADC #$01                                                    ;add +1 because the hex value starts from 0, while the display starts from 1
JSR HexToDecLevelNumber_F7DE                                ;
TAX                                                         ;
BEQ CODE_F80C                                               ;check if we need to display tens. if it's a zero, then an empty tile is displayed (which just so happens to be tile $00)
CLC                                                         ;
ADC #GFX_FontTiles                                          ;actual font tiles

CODE_F80C:
JSR SingleTileIntoBuffer_9B00                               ;draw tens (or the lack thereof)

INC $8F                                                     ;next tile in VRAM

LDA $8D                                                     ;display ones
CLC                                                         ;
ADC #GFX_FontTiles                                          ;
JSR SingleTileIntoBuffer_9B00                               ;draw ones
RTS                                                         ;

;player can change cursor position with this routine
HandleMovingCursor_F81A:
JSR WaitAFrame_FFAC                                         ;
JSR HandleControllerInputs_A10A                             ;

LDA Player1Inputs_Press                                     ;
AND #Input_Down|Input_Select                                ;pressed either down or select = cursor moves down
BEQ CODE_F833                                               ;

JSR BlankPreviousOptionsCursorPosition_F558                 ;

INC Options_CursorPosition                                  ;down one point

LDA #Sound_OptionCursorMove                                 ;
JSR PlaySound_F2FF                                          ;

JSR DrawOptionsCursor_F54F                                  ;draw cursor at new position

CODE_F833:
LDA Player1Inputs_Press                                     ;check if pressed up
AND #Input_Up                                               ;
BEQ RETURN_F846                                             ;dont move cursor up if did not

JSR BlankPreviousOptionsCursorPosition_F558                 ;

DEC Options_CursorPosition                                  ;cursor one point up

LDA #Sound_OptionCursorMove                                 ;
JSR PlaySound_F2FF                                          ;

JSR DrawOptionsCursor_F54F                                  ;draw cursor at new position

RETURN_F846:
RTS                                                         ;

DrawTitleScreen_F847:
JSR DefaultVisuals_F91D                                     ;

LDA #$10                                                    ;
STA $8B                                                     ;
JSR SetPPUAttributesForSpecialscreen_FB34                   ;

JSR StoreToControlAndRenderRegs_9A70                        ;

LDA #$04                                                    ;only needed for palette
STA CurrentMazeLayout                                       ;
JSR LoadDefaultPalettes_88D1                                ;

LDA #$28                                                    ;yellow color for the game's title
STA PaletteStorage+(Palette_Background2 + 1)                ;

LDA #$25                                                    ;pink color for the copyright text
STA PaletteStorage+(Palette_Background3 + 3)                ;

LDA #TileStripeID_TitleScreen                               ;draw title screen
JSR DrawTileStripes_9B80                                    ;
JSR EnableRender_9A41                                       ;
RTS                                                         ;

;init options screen visuals
DrawOptions_F86E:
JSR DefaultVisuals_F91D                                     ;

LDA #$00                                                    ;
STA $8B                                                     ;
JSR SetPPUAttributesForSpecialscreen_FB34                   ;

JSR StoreToControlAndRenderRegs_9A70                        ;

LDA #$01                                                    ;maze layout 2 - arcade 2
STA CurrentMazeLayout                                       ;
JSR LoadDefaultPalettes_88D1                                ;
JSR DrawOptionsAndCreditsBars_F936                          ;

LDA #TileStripeID_OptionsText                               ;draw all of the options strings
JSR DrawTileStripes_9B80                                    ;

JSR EnableRender_9A41                                       ;show it all
RTS                                                         ;

;load character cast screen
CODE_F88E:
JSR DefaultVisuals_F91D

LDA #$08
STA $8B
JSR SetPPUAttributesForSpecialscreen_FB34

JSR StoreToControlAndRenderRegs_9A70

LDA #$00
STA CurrentMazeLayout
JSR LoadDefaultPalettes_88D1

LDA #$05
STA PaletteStorage+(Palette_Background2 + 3)

LDA #$28
STA PaletteStorage+(Palette_Background3 + 3)

LDA #$08
STA $8F

LDA #$21
STA $90

LDA #NeonSignBorder_HorzTopNoLights                         ;draw the top border
JSR DrawHorizontalNeonSignBorder_FB5E

LDA #$07
STA $8F

LDA #$21
STA $90

LDA #NeonSignBorder_VertLeftNoLights
JSR DrawVerticalNeonSignBorder_FB6D

LDA #$E8
STA $8F

LDA #$21
STA $90

LDA #NeonSignBorder_HorzBottomNoLights                      ;draw the bottom border
JSR DrawHorizontalNeonSignBorder_FB5E

LOOP_F8D3:
LDA HardwareStatus
BPL LOOP_F8D3

LDA #$18
STA $8F

LDA #$21
STA $90

LDA #NeonSignBorder_VertRightNoLights
JSR DrawVerticalNeonSignBorder_FB6D

LOOP_F8E5:
LDA HardwareStatus                                          ;wait a frame...
BPL LOOP_F8E5                                               ;

LDA #TileStripeID_CharacterCast_GameTitle                   ;don't forget, the characters are a part of this game
JSR DrawTileStripes_9B80                                    ;
JSR EnableRender_9A41                                       ;
RTS                                                         ;display

DrawCredits_F8F3:
JSR DefaultVisuals_F91D                                     ;

LDA #$20                                                    ;
STA $8B                                                     ;
JSR SetPPUAttributesForSpecialscreen_FB34                   ;

JSR StoreToControlAndRenderRegs_9A70                        ;

LDA #$07                                                    ;set palette to that of this maze
STA CurrentMazeLayout                                       ;

JSR LoadDefaultPalettes_88D1                                ;

LDA #$19                                                    ;green color
STA PaletteStorage+(Palette_Background0 + 3)                ;

LDA #$23                                                    ;some purple-ish color
STA PaletteStorage+(Palette_Background1 + 3)                ;

JSR DrawOptionsAndCreditsBars_F936                          ;can't forget bars on top and bottom

LDA #TileStripeID_CreditsText                               ;display credits
JSR DrawTileStripes_9B80                                    ;
JSR EnableRender_9A41                                       ;show them, naturally
RTS                                                         ;

;defaults all sorts of visual related stuff like palettes, entities and blanking the screens out
DefaultVisuals_F91D:
JSR DisableRender_9A4B                                      ;
JSR ResetBufferVariables_9AC1                               ;pointless? the routine down below also calls for this
JSR RemoveAllEntities_89DC                                  ;

LDA #$00                                                    ;default maze layout (for palette, really)
STA CurrentMazeLayout                                       ;

JSR LoadDefaultPalettes_88D1                                ;initialize palette stuff
JSR DisableNMI_9A55                                         ;set registers & reset buffer things (because apparently just using this instead of above disable register isn't enough)

LDA #$00                                                    ;void...
JSR FillScreens_9AB6                                        ;
RTS                                                         ;

;this routine is used to draw bars at the top and bottom in credits and options screens
DrawOptionsAndCreditsBars_F936:
Macro_SetWord CreditsAndOptions_BorderTopVRAMPosition, $8F

LDA #CreditsAndOptions_BorderTileTop                        ;top half of the top bar
JSR DrawEntireRow_FB4F                                      ;

;bottom part of the bar
Macro_SetWord (CreditsAndOptions_BorderTopVRAMPosition+$20), $8F

LDA #CreditsAndOptions_BorderTileBottom                     ;bottom half of the top bar
JSR DrawEntireRow_FB4F                                      ;

Macro_SetWord CreditsAndOptions_BorderBottomVRAMPosition, $8F

LDA #CreditsAndOptions_BorderTileTop                        ;top half of the bottom bar
JSR DrawEntireRow_FB4F                                      ;

Macro_SetWord (CreditsAndOptions_BorderBottomVRAMPosition+$20), $8F

LDA #CreditsAndOptions_BorderTileBottom                     ;bottom half of the bottom bar.
JSR DrawEntireRow_FB4F                                      ;
RTS                                                         ;the end

CODE_F96B:
LDA FrameCounter                                            ;every fourth frame
AND #$03
BNE CODE_F9CE

LDA FrameCounter                                            ;
LSR A
LSR A
AND #$07
STA $8B

;animate horizontal lights
LDA #$0F
JSR CODE_FAAE

LDA #$17
JSR CODE_FAAE

;animate vertical lights
LDA #$E8
JSR CODE_FACF

LDA #$F0
JSR CODE_FACF

LDA $8B
ASL A
ASL A
ASL A
ASL A
ASL A
STA $8B
ADC #$07
STA $8F

LDA #$21
STA $90

LDA #NeonSignBorder_VertLeftLitBottom
JSR SingleTileIntoBuffer_9B00

LDA $8F
SEC
SBC #$20
STA $8F

LDA #NeonSignBorder_VertLeftNoLights
JSR SingleTileIntoBuffer_9B00

LDA #$E0
SEC
SBC $8B
CLC
ADC #$18
STA $8F

LDA #$21
STA $90

LDA #NeonSignBorder_VertRightLitTop
JSR SingleTileIntoBuffer_9B00

LDA $8F
CLC
ADC #$20
STA $8F

LDA #NeonSignBorder_VertRightNoLights
JSR SingleTileIntoBuffer_9B00

CODE_F9CE:
LDX #$1E

LOOP_F9D0:
JSR CODE_FA3B

DEX
DEX
BPL LOOP_F9D0
RTS

;timings for string display during character cast, 16-bit
CharacterCastStringDisplayTimings_F9D8:
.byte $40,$00
.byte $B8,$00
.byte $BC,$00
.byte $C0,$00
.byte $38,$01
.byte $3C,$01
.byte $40,$01
.byte $B8,$01
.byte $BC,$01
.byte $C0,$01
.byte $38,$02
.byte $3C,$02
.byte $40,$02
.byte $B8,$02
.byte $BC,$02
.byte $C0,$02

;string display data, comes in pairs. both can be set to draw something or set to 0 to not display anything
CharacterCastStringsData_F9F8:
.byte TileStripeID_CharacterCast_With,TileStripeID_CharacterCast_Blinky
.byte TileStripeID_CharacterCast_WithEmpty,TileStripeID_CharacterCast_CharNameEmpty
.byte $00,$00
.byte TileStripeID_CharacterCast_Inky,$00
.byte TileStripeID_CharacterCast_CharNameEmpty,$00
.byte $00,$00
.byte TileStripeID_CharacterCast_Pinky,$00
.byte TileStripeID_CharacterCast_CharNameEmpty,$00
.byte $00,$00
.byte TileStripeID_CharacterCast_Sue,$00
.byte TileStripeID_CharacterCast_CharNameEmpty,$00
.byte $00,$00
.byte TileStripeID_CharacterCast_PacMan,$00
.byte TileStripeID_CharacterCast_CharNameEmpty,$00
.byte $00,$00
.byte TileStripeID_CharacterCast_StarringMsPacMan,$00

;palettes for text strings during character cast
DATA_FA18:
.byte $05
.byte $05
.byte $11
.byte $11
.byte $11
.byte $25
.byte $25
.byte $25
.byte $16
.byte $16
.byte $16
.byte $28
.byte $28
.byte $28
.byte $28
.byte $28
.byte $28 ;placeholder?

;$FF - no one appears, other values are used for respective character appearance
CharacterCastCharacterAppearanceData_FA29:
.byte Entity_Ghost_Character_Blinky
.byte $FF,$FF
.byte Entity_Ghost_Character_Inky 
.byte $FF,$FF
.byte Entity_Ghost_Character_Pinky
.byte $FF,$FF
.byte Entity_Ghost_Character_Sue
.byte $FF,$FF
.byte Player_Character_PacMan+5
.byte $FF,$FF
.byte Player_Character_MsPacMan+5
.byte $FF,$FF ;placeholder?

;character cast stuff
CODE_FA3B:
LDA CharacterCastStringDisplayTimings_F9D8,X
CMP FrameCounter
BNE RETURN_FAAD

LDA CharacterCastStringDisplayTimings_F9D8+1,X
CMP FrameCounter+1
BNE RETURN_FAAD

LDA CharacterCastStringsData_F9F8,X
BEQ CODE_FA51

JSR DrawTileStripes_9B80

CODE_FA51:
LDA CharacterCastStringsData_F9F8+1,X
BEQ CODE_FA59

JSR DrawTileStripes_9B80

CODE_FA59:
TXA
LSR A
TAY
LDA DATA_FA18,Y
STA PaletteStorage+(Palette_Background2 + 3)

LDA CharacterCastCharacterAppearanceData_FA29,Y
BMI RETURN_FAAD
STA $8D
TXA
PHA
LDA $8D
CMP #$04
BCS CODE_FA89

LDA #Entity_ID_CutsceneGhost
JSR SpawnEntity_8A61

LDA #$F8
STA Entity_XPos,X

LDA #$90
STA Entity_YPos,X

LDA #$04
STA $20,X

LDA $8D                                                     ;chraracter
STA Entity_Ghost_Character,X                                ;

CLV
BVC CODE_FAAB

CODE_FA89:
LDA #Entity_ID_CutscenePlayer                               ;player entity used in cutscenes
JSR SpawnEntity_8A61

LDA #$F8
STA Entity_XPos,X

LDA #$90
STA Entity_YPos,X

LDA #Entity_Direction_Left
STA Entity_Direction,X

LDA #-$02
STA Entity_XSpeed,X

LDA #$06
STA $20,X

LDA $8D
SEC
SBC #$05
STA Entity_PlayerCharacter,X

CODE_FAAB:
PLA
TAX

RETURN_FAAD:
RTS

CODE_FAAE:
SEC
SBC $8B
STA $8F

LDA #$21
STA $90

LDA #NeonSignBorder_HorzTopLitRight
JSR SingleTileIntoBuffer_9B00

INC $8F

LDA $8B
BNE CODE_FAC9

LDA $8F
SEC
SBC #$08
STA $8F

CODE_FAC9:
LDA #NeonSignBorder_HorzTopNoLights
JSR SingleTileIntoBuffer_9B00
RTS

CODE_FACF:
CLC
ADC $8B
STA $8F

LDA #$21
STA $90

LDA #NeonSignBorder_HorzBottomLitLeft                       ;light this
JSR SingleTileIntoBuffer_9B00                               ;

DEC $8F

LDA $8B
BNE CODE_FAEA

LDA $8F
CLC
ADC #$08                                                    ;wrap around
STA $8F

CODE_FAEA:
LDA #NeonSignBorder_HorzBottomNoLights                      ;no lights there.
JSR SingleTileIntoBuffer_9B00                               ;
RTS                                                         ;

;specialized attribute value indexes for specific screens
PPUAttributeConfigurations_SpecialScreens_FAF0:
.byte $08,$08,$06,$07,$07,$09,$08,$08                       ;$00 - options
.byte $00,$00,$08,$0A,$00,$00,$00,$00                       ;$08 - Character Cast screen
.byte $03,$03,$0C,$0C,$08,$00,$00,$00                       ;$10 - title screen
.byte $00,$00,$00,$00,$00,$00,$02,$02                       ;$18 - act cutscene?
.byte $08,$00,$0B,$0B,$0B,$08,$08,$08                       ;$20 - credits

;X - attribute pointer index for the current attribute row
SetPPUAttributesForSpecialscreen_Row_FB18:
LDA PPUAttributeConfigurations_SpecialScreens_FAF0,X        ;
ASL A                                                       ;
TAY                                                         ;
LDA PPUAttributeRowValuePointers_E5C8,Y                     ;
STA $89                                                     ;

LDA PPUAttributeRowValuePointers_E5C8+1,Y                   ;
STA $8A                                                     ;

LDY #$00                                                    ;

LOOP_FB29:
LDA ($89),Y                                                 ;
STA VRAMUpdateRegister                                      ;
INY                                                         ;
CPY #$08                                                    ;see if all attributes have been filled on this row
BNE LOOP_FB29                                               ;
RTS                                                         ;

;Input A index for attributes, must be divisible by 8 (because it sets appropriate attributes for the entire screen)
SetPPUAttributesForSpecialscreen_FB34:
LDA #$23                                                    ;where attributes are ($23C0)
STA VRAMPointerReg                                          ;

LDA #$C0                                                    ;
STA VRAMPointerReg                                          ;

LDX $8B                                                     ;
TXA                                                         ;
CLC                                                         ;
ADC #$08                                                    ;8 rows of attributes, the entire screen
STA $8B                                                     ;

LOOP_FB46:
JSR SetPPUAttributesForSpecialscreen_Row_FB18               ;

INX                                                         ;
CPX $8B                                                     ;next one...
BNE LOOP_FB46                                               ;
RTS                                                         ;done

;input A - tile to draw
;this is used to draw an entire width worth of tiles (32 8x8 tiles).
;Input:
;A - tile to draw
;$8F-$90 - VRAM position to start drawing at
DrawEntireRow_FB4F:
STA $8B                                                     ;

LDX #$20                                                    ;32 tiles in one row

LOOP_FB53:
LDA $8B                                                     ;load this tile in
JSR SingleTileIntoBuffer_9B00                               ;yep, it basically makes one tile change at a time in buffer, instead of stringing them all at once

INC $8F                                                     ;offset VRAM location by 1
DEX                                                         ;
BNE LOOP_FB53                                               ;
RTS                                                         ;

;input A - tile (bottom and top border tiles)
DrawHorizontalNeonSignBorder_FB5E:
STA $8B                                                     ;

LDX #$10                                                    ;16 tiles

LOOP_FB62:
LDA $8B                                                     ;
JSR SingleTileIntoBuffer_9B00                               ;

INC $8F                                                     ;
DEX                                                         ;
BNE LOOP_FB62                                               ;
RTS                                                         ;

;input A - tile (left and right border tiles)
DrawVerticalNeonSignBorder_FB6D:
STA $8B                                                     ;

LDX #$08                                                    ;8 tiles

LOOP_FB71:
LDA $8B                                                     ;
JSR SingleTileIntoBuffer_9B00                               ;

LDA $8F                                                     ;offset by 1 tile vertically
ADC #$20                                                    ;(I guess carry is already cleared in the routine above, otherwise there'd be... issues)
STA $8F                                                     ;

LDA $90                                                     ;
ADC #$00                                                    ;
STA $90                                                     ;

DEX                                                         ;
BNE LOOP_FB71                                               ;
RTS                                                         ;

NMI_FB86:
PHA                                                         ;pretty standard value preservation
TXA                                                         ;
PHA                                                         ;
TYA                                                         ;
PHA                                                         ;

LDX #$09                                                    ;save some temporary values so we don't break stuff once we leave NMI

LOOP_FB8D:
LDA $89,X                                                   ;
PHA                                                         ;
DEX                                                         ;
BPL LOOP_FB8D                                               ;

LDA #$00                                                    ;disable rendering???
STA RenderBits                                              ;

LDA #$00                                                    ;mysterious register
STA OAMAddress                                              ;

LDA #>OAM_Y                                                 ;upload sprite tiles
STA OAMDMAReg                                               ;

JSR UpdateVRAMAndPalettes_FBD5                              ;update PPU and stuff

BIT HardwareStatus

LDA CameraPositionX                                         ;camera's x-pos
STA VRAMRenderAreaReg                                       ;

LDA CameraPositionY                                         ;I'm sure you can figure out this one
STA VRAMRenderAreaReg                                       ;

LDA CameraBasePositionOffset                                ;offset camera vertically (by default anyway)
AND #$01                                                    ;
ASL A                                                       ;if the game used vertical mirroring, this wouldn't be necessary (it doesn't)
ORA ControlMirror                                           ;some PPU control bits
STA ControlBits                                             ;

LDA RenderMirror                                            ;rendering (enable it, maybe?)
STA RenderBits                                              ;

LDA #$01                                                    ;
STA FrameFlag                                               ;frame passed

LDX #$00                                                    ;restore some temporary values

LOOP_FBC7:
PLA                                                         ;
STA $89,X                                                   ;
INX                                                         ;
CPX #$0A                                                    ;
BNE LOOP_FBC7                                               ;

PLA                                                         ;pretty standard NMI ending
TAY                                                         ;
PLA                                                         ;
TAX                                                         ;
PLA                                                         ;
RTI                                                         ;i mean, which games on NES have a non-standard NMI ending?

UpdateVRAMAndPalettes_FBD5:
INC TrueFrameCounter                                        ;frame counter.......... yeah

LDA #$08                                                    ;apparently we can change 8 things at a time
JSR UpdateVRAM_9B18                                         ;update... something. depends on what we have in the buffer

JSR UploadPalettes_890B                                     ;update palettes
RTS                                                         ;

IRQ_FBE1:
RTI                                                         ;unused (the game does not use IRQ)

;score reward data
;First byte - what digit we're updating, range from 0 to 5, where 0 is ones, and 5 is hundred thousands.
;Second byte is how much score is added.
ScoreAwardData_FBE2:
.byte $01,$01 ;10 score
.byte $01,$05 ;this gives 50 score
.byte $02,$01 ;100 score
.byte $02,$02 ;200 score
.byte $02,$04 ;give 400 score
.byte $02,$05 ;500 score
.byte $02,$07 ;700 score
.byte $02,$08 ;800
.byte $03,$01 ;1000
.byte $03,$02 ;2000
.byte $03,$05 ;5000
.byte $03,$03 ;3000
.byte $03,$04 ;4000
.byte $03,$06 ;6000
.byte $03,$07 ;7000
.byte $03,$08 ;8000
.byte $03,$09 ;9000
.byte $04,$01 ;Ten!000

;input:
;A - score award data offset (must be an even value)
;ScoreCounterPointer - score counter to add score to
UpdateScoreCounter_FC06:
ASL A                                                       ;
TAY                                                         ;
TXA                                                         ;
PHA                                                         ;
LDX ScoreAwardData_FBE2,Y                                   ;extract digit we're updating
LDA ScoreAwardData_FBE2+1,Y                                 ;extract what amount we're giving
JSR CODE_FC16                                               ;actually process update routine
PLA                                                         ;
TAX                                                         ;
RTS                                                         ;

CODE_FC16:
STA $89                                                     ;
STX $8A                                                     ;

LOOP_FC1A:
LDA $89                                                     ;if we're done awaring score...
BEQ RETURN_FC47                                             ;quit

LDY $8A                                                     ;what digit we're updating? odd or even (in this case, it's high nibble/low nibble that matters)
TYA                                                         ;
LSR A                                                       ;
TAY                                                         ;
BCS CODE_FC48                                               ;if we're updating tens, one thousands and hundred thousands, we're going that way (high nibble)

LDA (ScoreCounterPointer),Y                                 ;
TAX                                                         ;
AND #$F0                                                    ;
STA $8B                                                     ;remember high nibble
TXA                                                         ;
AND #$0F                                                    ;low nibble
CLC                                                         ;
ADC $89                                                     ;low nibble + score we're adding
LDX #$00                                                    ;default to stopping right after this calculation
CMP #$0A                                                    ;more than or equal 10?
BCC CODE_FC3E                                               ;
SEC                                                         ;
SBC #$0A                                                    ;round to 9
INX                                                         ;next digit gets a +1
INC $8A                                                     ;yes, next digit

CODE_FC3E:
STX $89                                                     ;
ORA $8B                                                     ;combine resulting digit with high nibble
STA (ScoreCounterPointer),Y                                 ;
JMP LOOP_FC1A                                               ;maybe there's more to update

RETURN_FC47:
RTS                                                         ;

CODE_FC48:
LDA (ScoreCounterPointer),Y                                 ;high nibble
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;push it into low nibble
CLC                                                         ;
ADC $89                                                     ;+score we're adding
LDX #$00                                                    ;
CMP #$0A                                                    ;check if 10+
BCC CODE_FC5D                                               ;
SEC                                                         ;
SBC #$0A                                                    ;round
INX                                                         ;next digit receives a plus one
INC $8A                                                     ;uh-huh

CODE_FC5D:
STX $89                                                     ;
ASL A                                                       ;restore it back into high nibble
ASL A                                                       ;
ASL A                                                       ;
ASL A                                                       ;
STA $8B                                                     ;

LDA (ScoreCounterPointer),Y                                 ;
AND #$0F                                                    ;
ORA $8B                                                     ;combine with low nibble
STA (ScoreCounterPointer),Y                                 ;result

JMP LOOP_FC1A                                               ;anything else?

;used to extract digits and display them on-screen
;input:
;A - VRAM offset
;ScoreCounterPointer - score counter to extract digits from and display them on screen
;Misc RAM Purposes:
;$8A - force draw flag, this is used to draw digits after leading zeroes.
;$8D - A input storage
DrawScoreCounter_FC70:
STA $8D

LDA #$00
STA $8A

LDY #$02                                                    ;
LDA (ScoreCounterPointer),Y                                 ;take hundred thousands...
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LDX #$00                                                    ;extra offset from the original VRAM offset
JSR DrawScoreDigit_FCC3

LDY #$02                                                    ;
LDA (ScoreCounterPointer),Y                                 ;take ten thousands...
AND #$0F                                                    ;
LDX #$01                                                    ;next tile
JSR DrawScoreDigit_FCC3

LDY #$01                                                    ;
LDA (ScoreCounterPointer),Y                                 ;take ones thousands
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LDX #$02                                                    ;
JSR DrawScoreDigit_FCC3

LDY #$01                                                    ;
LDA (ScoreCounterPointer),Y                                 ;take hundreds
AND #$0F                                                    ;
LDX #$03                                                    ;
JSR DrawScoreDigit_FCC3

LDY #$00                                                    ;
LDA (ScoreCounterPointer),Y                                 ;take tens
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LSR A                                                       ;
LDX #$04                                                    ;
JSR DrawScoreDigit_FCC3                                     ;

LDA #$01                                                    ;
STA $8A                                                     ;ones are ALWAYS drawn on-screen

LDY #$00                                                    ;
LDA (ScoreCounterPointer),Y                                 ;take ones
AND #$0F                                                    ;
LDX #$05                                                    ;
JSR DrawScoreDigit_FCC3                                     ;
RTS                                                         ;

DrawScoreDigit_FCC3:
LDY $8A                                                     ;check if we should draw this digit regardless
BNE CODE_FCD2                                               ;
CMP #$00                                                    ;check if this digit equals zero
BNE CODE_FCD0                                               ;

LDA #EmptyTile-GFX_FontTiles                                ;draw empty space (to be combined with +GFX_FontTiles below)
CLV                                                         ;
BVC CODE_FCD2                                               ;

CODE_FCD0:
STA $8A                                                     ;remember that the last digit was something other than 0, the rest will be drawn

CODE_FCD2:
STA $8B                                                     ;the tile we're drawing
TXA                                                         ;vram offset for this digit
CLC                                                         ;
ADC $8D                                                     ;plus base vram offset
STA $8F                                                     ;

LDA #$01                                                    ;one tile please
JSR EnableBufferSequencingAndUpdateTileBuffer_9AF7          ;

LDA #>HUDTop_BaseScoreVRAMPosition                          ;base VRAM position for all counters
JSR UpdateTileBuffer_9AD0                                   ;

LDA #<HUDTop_BaseScoreVRAMPosition                          ;base VRAM position low byte
CLC                                                         ;
ADC $8F                                                     ;+offset from before
JSR UpdateTileBuffer_9AD0                                   ;

LDA $8B                                                     ;
CLC                                                         ;
ADC #GFX_FontTiles                                          ;add offset for font characters (or empty space if no digit displayed)
JSR UpdateTileBuffer_9AD0                                   ;
JSR DisableBufferSequencing_9AFD                            ;buffer write over
RTS                                                         ;

;draw score total number. just draw it. nothing else. yep.
DrawTotalScore_FCF8:
Macro_SetWord Score_Total, ScoreCounterPointer

LDA #$0B                                                    ;actually draw
JMP DrawScoreCounter_FC70                                   ;

;update score total counter
UpdateTotalScore_FD05:
Macro_SetWord Score_Total, ScoreCounterPointer

LDA $91                                                     ;add score to total
JSR UpdateScoreCounter_FC06                                 ;

LDA #$0B                                                    ;draw total score
JMP DrawScoreCounter_FC70                                   ;

;determines which player is leading (or if both are tied) and draws appropriate string under LEADER string.
DrawLeaderString_FD17:
JSR CheckPlayerScoresForLead_FD32                           ;
BNE CODE_FD22

LDA #TileStripeID_LeadingPlayer1                            ;player 1
JSR DrawTileStripes_9B80
RTS

CODE_FD22:
CMP #$01                                                    ;is player 2 leading?
BNE CODE_FD2C                                               ;

LDA #TileStripeID_LeadingPlayer2                            ;player 2
JSR DrawTileStripes_9B80                                    ;
RTS

CODE_FD2C:
LDA #TileStripeID_Tied                                      ;"TIED"
JSR DrawTileStripes_9B80                                    ;
RTS                                                         ;

;output A: lead. 0 - player 1 is leading, 1 - player 2 is leading, 2 - scores are tied.
CheckPlayerScoresForLead_FD32:
LDY #$02                                                    ;check score variables

LOOP_FD34:
LDA Score_CurrentPlayer,Y                                   ;check if player 1's score is higher than player 2
CMP Score_Player2,Y                                         ;
BCS CODE_FD3F                                               ;

LDA #$01                                                    ;player 2 is leading
RTS                                                         ;

CODE_FD3F:
LDA Score_Player2,Y                                         ;check if player 2's score is higher than player 1
CMP Score_CurrentPlayer,Y                                   ;
BCS CODE_FD4A                                               ;

LDA #$00                                                    ;player 1 is leading
RTS                                                         ;

CODE_FD4A:
DEY                                                         ;these values are matching, next!
BPL LOOP_FD34                                               ;

LDA #$02                                                    ;both scores are equal, TIED
RTS                                                         ;

;check if one of the players' score is higher than high score
HandleHighScore_FD50:
LDY #$02                                                    ;comb through all score addresses

LOOP_FD52:
LDA (ScoreCounterPointer),Y                                 ;check if score is higher than high score
CMP Score_HighScore,Y                                       ;
BCS CODE_FD5A                                               ;
RTS                                                         ;

CODE_FD5A:
BEQ CODE_FD6A                                               ;if equals, ignore

LDY #$02                                                    ;replace high score with player's score.

LOOP_FD5E:
LDA (ScoreCounterPointer),Y                                 ;
STA Score_HighScore,Y                                       ;
DEY                                                         ;
BPL LOOP_FD5E                                               ;

JSR DrawTopScoreCounter_FD6E                                ;
RTS                                                         ;

CODE_FD6A:
DEY                                                         ;next value to check
BPL LOOP_FD52                                               ;
RTS                                                         ;score comparison over

DrawTopScoreCounter_FD6E:
Macro_SetWord Score_HighScore, ScoreCounterPointer

LDA #$0B                                                    ;
JMP DrawScoreCounter_FC70                                   ;redraw high score counter with new numbers

SoftResetIndicatorValues_FD7B:
.byte $45,$67,$89,$12,$34,$56,$82,$75

;default top score to 10000
InitializeHighScore_FD83:
LDA #$00
STA Score_HighScore                                         ;ones and tens are zero
STA Score_HighScore+1                                       ;hundreds and thousands are zero

LDA #$01                                                    ;tens thousands = 1, hundreds thousands = 0
STA Score_HighScore+2                                       ;
RTS                                                         ;

CheckSoftReset_FD91:
LDX #$07                                                    ;

LOOP_FD93:
LDA SoftResetIndicator,X                                    ;check if even a single value doesn't match
CMP SoftResetIndicatorValues_FD7B,X                         ;
BEQ CODE_FDAF                                               ;

JSR InitializeHighScore_FD83                                ;default high score

LDA #$00                                                    ;disable level select cheat on hard reset/boot up
STA LevelSelectInputCounter                                 ;

LDX #$07                                                    ;

LOOP_FDA5:
LDA SoftResetIndicatorValues_FD7B,X                         ;store the values, indicating that we've just booted up Ms. Pac-Man NES Tengen Edition
STA SoftResetIndicator,X                                    ;
DEX                                                         ;
BPL LOOP_FDA5                                               ;
RTS                                                         ;

CODE_FDAF:
DEX                                                         ;
BPL LOOP_FD93                                               ;
RTS                                                         ;

;input A - score reward index (see ScoreAwardData_FBE2 for actual reward values)
GiveScore_FDB3:
STA $91                                                     ;
TXA                                                         ;
PHA                                                         ;

LDA Score_RewardedPlayer                                    ;which player to award score to?
BEQ CODE_FDCB                                               ;player 1 or 2... or whatever, depending on game type

Macro_SetWord Score_Player2, ScoreCounterPointer

LDA #$14                                                    ;player 2 score VRAM offset
STA $8D                                                     ;
CLV                                                         ;
BVC CODE_FDD7                                               ;

CODE_FDCB:
Macro_SetWord Score_CurrentPlayer, ScoreCounterPointer

LDA #$00                                                    ;
STA $8D                                                     ;player 1's score position in VRAM (PPU)

CODE_FDD7:
LDA $91                                                     ;retreive score value we're adding
JSR UpdateScoreCounter_FC06                                 ;

LDA CurrentPlayerConfiguration                              ;check if it's player 2's turn
CMP #CurrentPlayerConfiguration_Player2                     ;
BNE CODE_FDE7                                               ;

LDA #$14                                                    ;player 2 score VRAM offset
CLV                                                         ;
BVC CODE_FDE9                                               ;

CODE_FDE7:
LDA $8D                                                     ;

CODE_FDE9:
JSR DrawScoreCounter_FC70                                   ;

LDA Options_Type                                            ;
CMP #Options_Type_2PlayerCompetitive                        ;
BCS CODE_FDF9                                               ;

JSR HandleHighScore_FD50                                    ;1 player or 2 player alternative feature high score

CLV                                                         ;
BVC CODE_FE04                                               ;

CODE_FDF9:
BNE CODE_FE01                                               ;check if specifically 2P competitive.

JSR DrawLeaderString_FD17                                   ;initialize lead

CLV                                                         ;
BVC CODE_FE04                                               ;

CODE_FE01:
JSR UpdateTotalScore_FD05                                   ;in cooperative

CODE_FE04:
LDA OneUpScoreTargetIndex                                   ;check if player 1 received all 1-ups
CMP #$04                                                    ;
BCS CODE_FE23                                               ;go and check player 2 has yet to get some

JSR GetScoreTargetFor1UPIndex_FE49

LDA Score_CurrentPlayer+2                                   ;check if tens and hundreds thousands value matches
CMP ScoresFor1Ups_FE54,Y                                    ;with the target
BCC CODE_FE23

INC CurrentPlayerLives                                      ;give lives.
INC OneUpScoreTargetIndex                                   ;next score target to get an extra life.
JSR AddExtraLifeDisplay_Player1_E8CA

JSR DisableSounds_F3A3                                      ;mute everything else

LDA #Sound_ExtraLife                                        ;make the player feel good with an appropriate SFX
JSR PlaySound_F2FF                                          ;

CODE_FE23:
LDA Player2_OneUpScoreTargetIndex                           ;check if player 2 received all 1-ups
CMP #$04                                                    ;
BCS CODE_FE46                                               ;

JSR GetScoreTargetFor1UPIndex_FE49                          ;get score target index for player 2

LDA Score_Player2+2                                         ;
CMP ScoresFor1Ups_FE54,Y                                    ;check if player 2's score matches (simultaneous play)
BCC CODE_FE46

INC Player2Lives                                            ;+1 to player 1 lives
INC Player2_OneUpScoreTargetIndex                           ;next score target for player 2
JSR AddExtraLifeDisplay_Player2_E8DE                        ;

JSR DisableSounds_F3A3                                      ;silence...

LDA #Sound_ExtraLife                                        ;sound effect, again
JSR PlaySound_F2FF                                          ;

CODE_FE46:
PLA                                                         ;
TAX                                                         ;
RTS                                                         ;

;input A - player's current 1-up score target index (the latest one they have to reach)
GetScoreTargetFor1UPIndex_FE49:
STA $89                                                     ;

LDA Options_MazeSelection                                   ;targets depend on the maze selection
ASL A                                                       ;
ASL A                                                       ;
ADC $89                                                     ;
TAY                                                         ;
RTS                                                         ;

;Score Targets that award 1-up
;the values are for tens and hundreds thousands of points
ScoresFor1Ups_FE54:
;arcade mazes
.byte $01                                                   ;10000 score for 1-up, that's reasonable...
.byte $97                                                   ;...970000??? You're probably not meant to reach these normally...
.byte $98                                                   ;980000
.byte $99                                                   ;990000

;mini mazes
.byte $01                                                   ;10000 score (these values are the same for the rest)
.byte $05                                                   ;50000 score
.byte $10                                                   ;100000 score
.byte $30                                                   ;300000 score for the last 1-up

;Big mazes
.byte $01
.byte $05
.byte $10
.byte $30

;Strange mazes
.byte $01
.byte $05
.byte $10
.byte $30

;init player(s) score(s) display 
DrawPlayersScore_FE64:
LDA Options_Type                                            ;check for Options_Type_1Player
BNE CODE_FE72                                               ;

LDA #TileStripeID_1UP                                       ;draw "1UP" string
JSR DrawTileStripes_9B80                                    ;

JSR DrawPlayer1Score_FEC6                                   ;
RTS                                                         ;

CODE_FE72:
LDA #TileStripeID_1UP                                       ;draw "1UP" string
JSR DrawTileStripes_9B80

LDA #TileStripeID_2UP                                       ;draw "2UP" string
JSR DrawTileStripes_9B80                                    ;

LDA Options_Type                                            ;check if alternating game type
CMP #Options_Type_2PlayerAlternating                        ;
BNE DrawSimultaneousPlayersScore_FEB5                       ;

LDA CurrentPlayerConfiguration                              ;check if player 1 is currently playing
BNE DrawAlternatingPlayersScore_Player2Playing_FE9A         ;

JSR DrawPlayer1Score_FEC6                                   ;

Macro_SetWord OtherPlayerScore, ScoreCounterPointer

LDA #$14                                                    ;player 2's score
JSR DrawScoreCounter_FC70                                   ;

CLV                                                         ;can be replaced with rts
BVC RETURN_FEB4                                             ;

DrawAlternatingPlayersScore_Player2Playing_FE9A:
Macro_SetWord Score_CurrentPlayer, ScoreCounterPointer

LDA #$14                                                    ;
JSR DrawScoreCounter_FC70                                   ;

Macro_SetWord OtherPlayerScore, ScoreCounterPointer

LDA #$00                                                    ;
JSR DrawScoreCounter_FC70                                   ;

RETURN_FEB4:
RTS                                                         ;

DrawSimultaneousPlayersScore_FEB5:
JSR DrawPlayer1Score_FEC6                                   ;

Macro_SetWord Score_Player2, ScoreCounterPointer

LDA #$14                                                    ;draw player 2's score
JSR DrawScoreCounter_FC70                                   ;
RTS                                                         ;

DrawPlayer1Score_FEC6:
Macro_SetWord Score_CurrentPlayer, ScoreCounterPointer

LDA #$00                                                    ;player 1 score
JSR DrawScoreCounter_FC70                                   ;
RTS                                                         ;

;freespace
.byte $00,$00,$00,$00,$00,$00,$00,$00
.byte $00,$00,$00,$00

RESET_FEE0:
SEI                                                         ;standard init
CLD                                                         ;

LDX #$00                                                    ;disable screen rendering
STX ControlBits                                             ;
STX RenderBits                                              ;

LOOP_FEEA:
LDA HardwareStatus                                          ;wait for NES power on
BPL LOOP_FEEA                                               ;

LOOP_FEEF:
LDA HardwareStatus                                          ;still wait for NES power on
BPL LOOP_FEEF                                               ;

LDX #$00                                                    ;
TXA                                                         ;

LOOP_FEF7:
STA $0100,X                                                 ;clear stack (including all variables this game stores there)
DEX                                                         ;
BMI LOOP_FEF7                                               ;

LDX #$FF                                                    ;
TXS                                                         ;
JSR CODE_FF1C                                               ;this used to do... something.

JSR InitRAMAndRegs_FF77                                     ;go away, ram
JSR StoreToControlAndRenderRegs_9A70                        ;rendering and such

LDY #$1F                                                    ;
LDA #$0F                                                    ;default all colors to black

LOOP_FF0D:
STA PaletteStorage,Y                                        ;
DEY                                                         ;
BPL LOOP_FF0D                                               ;

JSR DisableSounds_F3A3                                      ;
JSR WaitAFrame_FFAC                                         ;
JMP InitTengenPresentsScreen_8000                           ;start the game with tengen's screen

CODE_FF1C:
RTS                                                         ;

;Mapper registers. Ms. Pac-Man does not use any special mapper, but other games programmed by one Franz Lanzinger do (at least Krazy Kreatures has a similar setup)
UNUSED_FF1D:
.byte $01,$8D,$00,$60                                       ;this is supposed to be LDA #$01 : STA,$6000, but the LDA opcode is overwritten by the RTS just above

LDA #$00
STA $8000

LDA #$1C
STA $8001

LDA #$01
STA $8000

LDA #$1E
STA $8001

LDA #$02
STA $8000

LDA #$18
STA $8001

LDA #$03
STA $8000

LDA #$19
STA $8001

LDA #$04
STA $8000

LDA #$1A
STA $8001

LDA #$05
STA $8000

LDA #$1B
STA $8001

LDA #$06
STA $8000

LDA #$0C
STA $8001

LDA #$07
STA $8000

LDA #$0D
STA $8001

LDA #$01
STA $6001
RTS

;clears all RAM, except for the stack area ($0100-$01FF)
;Also sets intital regs
InitRAMAndRegs_FF77:
LDX #$00                                                    ;
TXA                                                         ;

LOOP_FF7A:
STA $00,X                                                   ;clear $00-$FF
DEX                                                         ;
BNE LOOP_FF7A                                               ;

LOOP_FF7F:
STA $0200,x                                                 ;clear $0200-$02FF
DEX                                                         ;
BNE LOOP_FF7F                                               ;

LOOP_FF85:
STA $0300,X                                                 ;clear $0300-$03FF
DEX                                                         ;
BNE LOOP_FF85                                               ;

LOOP_FF8B:
STA $0400,X                                                 ;clear $0400-$04FF
DEX                                                         ;
BNE LOOP_FF8B                                               ;

LOOP_FF91:
STA $0500,X                                                 ;clear $0500-$05FF
DEX                                                         ;
BNE LOOP_FF91                                               ;

LOOP_FF97:
STA $0600,X                                                 ;clear $0600-$06FF
DEX                                                         ;
BNE LOOP_FF97                                               ;

LOOP_FF9D:
STA $0700,X                                                 ;clear $0700-$07FF
DEX                                                         ;
BNE LOOP_FF9D                                               ;

LDA #$1E                                                    ;set initial register mirrors (this one enables rendering)
STA RenderMirror                                            ;

LDA #$90                                                    ;enable NMI and backgrounds go into pattern table address $1000
STA ControlMirror                                           ;
RTS                                                         ;

;This routine is used to sync everything proper, make the game wait for the whole frame to pass (NMI)
WaitAFrame_FFAC:
JSR WaitForNMI_FFB6                                         ;

LDA FreezeTimer                                             ;make sure freeze counter also ticks down
BEQ RETURN_FFB5                                             ;

DEC FreezeTimer                                             ;

RETURN_FFB5:
RTS                                                         ;

WaitForNMI_FFB6:
LDA FrameFlag                                               ;check if the whole frame has passed
BEQ WaitForNMI_FFB6                                         ;

DEC FrameFlag                                               ;will wait again next time

JSR HandleSound_F3B3                                        ;note that if there's ever lag, that means the music will also slow down, since it's not handled during NMI

INC FrameCounter                                            ;frame counter counts up like normal
BNE RETURN_FFC5                                             ;

INC FrameCounter+1                                          ;16-bit frame counter

RETURN_FFC5:
RTS                                                         ;

;FREESPACE!!!
; .byte $00,$00,$00,$00,$00,$00,$00,$00
; .byte $00,$00,$00,$00,$00,$00,$00,$00
; .byte $00,$00,$00,$00,$00,$00,$00,$00
; .byte $00,$00,$00,$00,$00,$00,$00,$00
; .byte $00,$00,$00,$00,$00,$00,$00,$00
; .byte $00,$00,$00,$00,$00,$00,$00,$00
; .byte $00,$00,$00,$00

.segment "VECTORS"
.word NMI_FB86
.word RESET_FEE0
.word IRQ_FBE1