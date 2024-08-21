;all text strings in the options screen
.macro PutOptionsScreenStringsData
OptionsScreenStrings_9CF5:
.word $20A7
.byte "MS PAC-MAN OPTIONS"
.byte $FF

.word $2104
.byte "TYPE:"
.byte $FF

.word $2164
.byte "PAC BOOSTER    :"
.byte $FF

.word $21C4
.byte "GAME DIFFICULTY:"
.byte $FF

.word $2224
.byte "MAZE SELECTION :"
.byte $FF

.word $2284
.byte "STARTING LEVEL :"
.byte $FF

.word $22E4
.byte "MOVE ARROW WITH JOYPAD"
.byte $FF

.word $2302
.byte "CHOOSE OPTIONS WITH A AND B"
.byte $FF

.word $2323
.byte "PRESS START TO START GAME"
.byte $FF
.byte $00
.endmacro

.macro PutType2PAlternatingStringData
Type2PlayerAlternatingString_9DBB:
.word OptionsScreen_TypeChoiceVRAMPosition
.byte "2 PLAYER ALTERNATING"
.byte $FF
.byte $00
.endmacro

.macro PutType2PCompetitiveStringData
Type2PlayerCompetitiveString_9DD3:
.word OptionsScreen_TypeChoiceVRAMPosition
.byte "2 PLAYER COMPETITIVE"
.byte $FF
.byte $00
.endmacro

.macro PutType2PCooperativeStringData
 Type2PlayerCooperativeString_9DEB:
.word OptionsScreen_TypeChoiceVRAMPosition
.byte "2 PLAYER COOPERATIVE"
.byte $FF
.byte $00
.endmacro

.macro PutType1PStringData
Type1PlayerString_9E03:
.word OptionsScreen_TypeChoiceVRAMPosition
.byte "1 PLAYER            "
.byte $FF
.byte $00
.endmacro

.macro PutPacBoosterOffStringData
PacBoosterOffString_9E1B:
.word OptionsScreen_PacBoosterChoiceVRAMPosition
.byte "OFF       "
.byte $FF
.byte $00
.endmacro

.macro PutPacBoosterAorBStringData
PacBoosterUseAOrBString_9E29:
.word OptionsScreen_PacBoosterChoiceVRAMPosition
.byte "USE A OR B"
.byte $FF
.byte $00
.endmacro

.macro PutPacBoosterAlwaysOnStringData
PacBoosterAlwaysOnString_9E37:
.word OptionsScreen_PacBoosterChoiceVRAMPosition
.byte "ALWAYS ON "
.byte $FF
.byte $00
.endmacro

.macro PutMazeSelectArcadeStringData
MazeSelectionArcadeString_9E45:
.word OptionsScreen_MazeSelectionChoiceVRAMPosition
.byte "ARCADE "
.byte $FF
.byte $00
.endmacro

.macro PutMazeSelectMiniStringData
MazeSelectionMiniString_9E50:
.word OptionsScreen_MazeSelectionChoiceVRAMPosition
.byte "MINI   "
.byte $FF
.byte $00
.endmacro

.macro PutMazeSelectBigStringData
MazeSelectionBigString_9EC2:
.word OptionsScreen_MazeSelectionChoiceVRAMPosition
.byte "BIG    "
.byte $FF
.byte $00
.endmacro

.macro PutMazeSelectStrangeStringData
MazeSelectionStrangeString_9ECD:
.word OptionsScreen_MazeSelectionChoiceVRAMPosition
.byte "STRANGE"
.byte $FF
.byte $00
.endmacro

.macro PutDifficultyNormalStringData
DifficultyNormalString_9ED8:
.word OptionsScreen_DifficultyChoiceVRAMPosition
.byte "NORMAL"
.byte $FF
.byte $00
.endmacro

.macro PutDifficultyEasyStringData
DifficultyEasyString_9EE2:
.word OptionsScreen_DifficultyChoiceVRAMPosition
.byte "EASY  "
.byte $FF
.byte $00
.endmacro

.macro PutDifficultyHardStringData
DifficultyHardString_9EEC:
.word OptionsScreen_DifficultyChoiceVRAMPosition
.byte "HARD  "
.byte $FF
.byte $00
.endmacro

.macro PutDifficultyCrazyStringData
DifficultyCrazyString_9EF6:
.word OptionsScreen_DifficultyChoiceVRAMPosition
.byte "CRAZY "
.byte $FF
.byte $00
.endmacro