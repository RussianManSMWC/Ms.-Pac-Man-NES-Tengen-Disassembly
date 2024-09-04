;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Constants (see also Enums.asm)

;controller input constants
Input_A = $01
Input_B = $02
Input_Select = $04
Input_Start = $08
Input_Up = $10
Input_Down = $20
Input_Left = $40
Input_Right = $80

Input_AllDirectional = Input_Up|Input_Down|Input_Right|Input_Left
Input_AllNonDirectional = Input_A|Input_B|Input_Select|Input_Start

Maze_RepeatTileCommand = $80
Maze_EndMazeBuilding = $FF

;background tile defines

;specific tiles
EmptyTile = $00                                             ;a chunk of nothing
SmallDotTile = $05
PowerPelletTile = $06                                       ;a big dot
MaskingTile = $09                                           ;uses solid color to mask sprites (black on black makes sense in this context, because of background priority)

;Options/Credits stuff
;this is shared between options and credits screens. Extra coding is required if you want the borders to be in different locations for both screens
CreditsAndOptions_BorderTopVRAMPosition = $2040
CreditsAndOptions_BorderBottomVRAMPosition = $2340

CreditsAndOptions_BorderTileTop = $04
CreditsAndOptions_BorderTileBottom = $03

;Options: specific stuff
OptionsScreen_CursorTile = $8E
OptionsScree_CursorBaseVRAMPosition = $2102 ;base position from which the cursor moves (or wraps around to)

OptionsScreen_CreditsNumberTilesBase = $E4
OptionsScreen_CreditsVRAMPosition = $229C

;these are specifically for choices.
OptionsScreen_TypeChoiceVRAMPosition = $210A
OptionsScreen_PacBoosterChoiceVRAMPosition = $2175
OptionsScreen_DifficultyChoiceVRAMPosition = $21D5
OptionsScreen_MazeSelectionChoiceVRAMPosition = $2235
OptionsScreen_SelectedLevelVRAMPosition = $2295

;these hud tiles take 4 subsequent tiles to form a 16x16 image (displayed at the bottom)
HUD_CherryTile = $10
HUD_StrawberryTile = $14
HUD_AppleTile = $18
HUD_OrangeTile = $1C
HUD_PretzelTile = $20
HUD_PearTile = $24
HUD_BananaTile = $28
HUD_MsPacMan = $2C                                          ;indicates ms. pac-man's lives
HUD_PacMan = $30                                            ;indicates pac-man's lives (2 player)

HUD_IndicatorBar_LeftEnd = $34
HUD_IndicatorBar_Middle = $35
HUD_IndicatorBar_RightEnd = $36

HUD_MazeIndicatorTile_Mini = $39
HUD_MazeIndicatorTile_Big = $3B
HUD_MazeIndicatorTile_Strange = $3D

HUD_DifficultyIndicatorTile_Hard = $BA
HUD_DifficultyIndicatorTile_Easy = $BC
HUD_DifficultyIndicatorTile_Crazy = $BE

HUD_PacBoosterIndicatorTile = $38

HUD_BaseMazeIndicatorVRAMPosition = $20E0

HUD_LevelCounter_TensTileOffest = $EA                       ;tile offset for level counter present in non-arcade mazes, tens
HUD_LevelCounter_OnesTileOffest = $F4                       ;tile offset for level counter present in non-arcade mazes, ones
HUD_LevelCounter_LEVTile = $CF                              ;these tiles form the LEVEL part of the hud level counter (bottom part of the square)
HUD_LevelCounter_ELTile = $FE

;more HUD stuff
;where score is located. Also acts as VRAM address for the first score counter
HUDTop_BaseScoreVRAMPosition = $20C2
;all score counters are on the same line

;where the bottom HUD stuff is located, based on the maze's height
HUDBottom_VRAMCoordinatesShortLayout = $2880
HUDBottom_VRAMCoordinatesMediumLayout = $2940
HUDBottom_VRAMCoordinatesTallLayout = $2A00

;cutscene
ClapperBaseVRAMPosition = $2148                             ;top-left corner which the clapper stems from
ItemBasePositionDuringAct = $2340

;character cast neon border thing
NeonSignBorder_HorzBottomNoLights = $D0
NeonSignBorder_HorzBottomLitLeft = $D4
NeonSignBorder_HorzTopNoLights = $D2
NeonSignBorder_HorzTopLitRight = $D6

NeonSignBorder_VertRightNoLights = $D1
NeonSignBorder_VertRightLitTop = $D5
NeonSignBorder_VertLeftNoLights = $D3
NeonSignBorder_VertLeftLitBottom = $D7

;font-related
GFX_FontTiles = $80                                         ;where the font graphics are actually stored in CHR-ROM

UTFFontStart = $30                                          ;standard UTF-8 symbols start from $30
FontTileOffset = GFX_FontTiles-UTFFontStart

;sound related things
SoundCommand_InitChannel = $E1
SoundCommand_SetNoteProperties = $E2
SoundCommand_RepeatAPairOfBytes = $E4
SoundCommand_EndPlayback = $FF

;player character variables
;i would've put them in an enum if there were more than 2
Player_Character_MsPacMan = 0
Player_Character_PacMan = 1

;easy OAM props, don't change these
OAMProp_YFlip = %10000000
OAMProp_XFlip = %01000000
OAMProp_BGPriority = %00100000
OAMProp_Palette0 = %00000000
OAMProp_Palette1 = %00000001
OAMProp_Palette2 = %00000010
OAMProp_Palette3 = %00000011

BGAttribute_Palette0 = %00000000
BGAttribute_Palette1 = %00000001
BGAttribute_Palette2 = %00000010
BGAttribute_Palette3 = %00000011

;palette offsets in PPU/RAM, don't touch
Palette_Background0 = 0
Palette_Background1 = 4
Palette_Background2 = 8
Palette_Background3 = 12

Palette_Sprite0 = 16
Palette_Sprite1 = 20
Palette_Sprite2 = 24
Palette_Sprite3 = 28