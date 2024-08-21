;For actual tile stripe data, check the "TileStripesAndTextStrings" folder and search individual files if you want to modify something specific
;this file is used as a set dressing - it loads all the files and puts them in order (as strange as that order may be)

.include "TileStripesAndTextStrings/TitleScreen.asm"
.include "TileStripesAndTextStrings/HUDStrings.asm"
.include "TileStripesAndTextStrings/StartingMazePlayerStrings.asm"
.include "TileStripesAndTextStrings/UNUSEDLevelStrings.asm"
.include "TileStripesAndTextStrings/GameOver.asm"
.include "TileStripesAndTextStrings/Options.asm"
.include "TileStripesAndTextStrings/Pause.asm"
.include "TileStripesAndTextStrings/ActNames.asm"
.include "TileStripesAndTextStrings/CharacterCast.asm"
.include "TileStripesAndTextStrings/Continues.asm"
.include "TileStripesAndTextStrings/Credits.asm"
.include "TileStripesAndTextStrings/TengenPresents.asm"

PutTitleScreenStripeData

PutHighScoreStringData

;these two are in-maze strings, not HUD-related
PutPlayerOneStringData
PutPlayerTwoStringData

PutUnusedLevelXXStringData

PutEmptyPlayerStringData

Put1UPStringData
PutEmpty1UPStringData

PutGameOverStringData

PutUnusedLevelXXEmptyStringData

PutOptionsScreenStringsData

PutPauseStringData

PutType2PAlternatingStringData
PutType2PCompetitiveStringData
PutType2PCooperativeStringData
PutType1PStringData

PutPacBoosterOffStringData
PutPacBoosterAorBStringData
PutPacBoosterAlwaysOnStringData

;maze selection strings
PutMazeSelectArcadeStringData
PutMazeSelectMiniStringData

PutPlayersStringData

Put2UPStringData
PutEmpty2UPStringData

;two player Co-op
PutTotalStringData

PutUnusedPlayersStringData

PutLeaderStringData
PutPlayer1LeaderStringData
PutPlayer2LeaderStringData
PutTiedStringData

PutPauseEmptyStringData ;blank out pause

;maze selection strings (cont)
PutMazeSelectBigStringData 
PutMazeSelectStrangeStringData

;difficulty
PutDifficultyNormalStringData 
PutDifficultyEasyStringData
PutDifficultyHardStringData
PutDifficultyCrazyStringData

;cutscene strings
PutAct1NameStringData
PutAct2NameStringData
PutAct3NameStringData
PutAct4NameStringData
PutActNameEmptyStringData
PutClapperRemovalStripeData

;character cast
PutGameNameStringData
PutStarringMsPacManStringData
PutWithStringData
PutBlinkyStringData
PutInkyStringData
PutPinkyStringData
PutSueStringData
PutWithEmptyStringData
PutCharacterNameEmptyStringData
PutPacManStringData

PutContinuesStringData

PutCreditsStringData

PutTengenPresentsStringData

;actual pointers at the end instead of the beginning for some reason
;don't forget to alter the enum in Defines_Enums.asm if you delete or add new pointers.
TileStripeDataPointers_A098:
.word TitleScreenTilemap_9BE8                               ;stripe 0 (i have yet to figure if I want proper constant defines for these instead of just values, it'd make code easier to read...)
.word HighScoreString_9C8A                                  ;stripe 1
.word PlayerOneString_9C98                                  ;stripe 2
.word PlayerTwoString_9CA6                                  ;stripe 3
.word LevelXXString_9CB4                                    ;stripe 4, unused "LEVEL XX" string (for unused code)
.word EmptyPlayerString_9CC0                                ;stripe 5
.word OneUPString_9CCE                                      ;stripe 6
.word Empty1UPString_9CD5                                   ;stripe 7
.word GameOverString_9CDC                                   ;stripe 8
.word EmptyLevelXXString_9CE9                               ;stripe 9, empty string (for aformentioned unused LEVEL XX string)
.word OptionsScreenStrings_9CF5                             ;stripe A
.word PauseString_9DB2                                      ;stripe B
.word Type2PlayerAlternatingString_9DBB                     ;stripe C
.word Type2PlayerCompetitiveString_9DD3                     ;stripe D
.word Type2PlayerCooperativeString_9DEB                     ;stripe E
.word PacBoosterOffString_9E1B                              ;stripe F
.word PacBoosterUseAOrBString_9E29                          ;stripe 10
.word PacBoosterAlwaysOnString_9E37                         ;stripe 11
.word MazeSelectionArcadeString_9E45                        ;stripe 12
.word MazeSelectionMiniString_9E50                          ;stripe 13
.word PlayersString_9E5B                                    ;stripe 14, used in simultenious 2P (
.word Type1PlayerString_9E03                                ;stripe 15
.word TwoUpString_9E69                                      ;stripe 16
.word Empty2UpString_9E70                                   ;stripe 17
.word TotalString_9E77                                      ;stripe 18
.word UnusedPlayersString_9E80                              ;stripe 19
.word LeaderString_9E8B                                     ;stripe 1A
.word Player1String_9E95                                    ;stripe 1B, unused duplicate (placeholder?)
.word Player1String_9E95                                    ;stripe 1C
.word Player2String_9EA1                                    ;stripe 1D
.word TiedString_9EAD                                       ;stripe 1E
.word EmptyPauseString_9EB9                                 ;stripe 1F
.word MazeSelectionBigString_9EC2                           ;stripe 20
.word MazeSelectionStrangeString_9ECD                       ;stripe 21
.word DifficultyNormalString_9ED8                           ;stripe 22
.word DifficultyEasyString_9EE2                             ;stripe 23
.word DifficultyHardString_9EEC                             ;stripe 24
.word DifficultyCrazyString_9EF6                            ;stripe 25
.word ActNameTheyMeet_9F00                                  ;stripe 26
.word ActNameTheChase_9F0D                                  ;stripe 27
.word ActNameJunior_9F1A                                    ;stripe 28
.word EmptyActName_9F2F                                     ;stripe 29
.word RemoveClapper_9F3C                                    ;stripe 2A
.word QuoteMsPacManUnquoteString_9F55                       ;stripe 2B
.word StarringMsPacManStrings_9F65                          ;stripe 2C
.word WithString_9F7E                                       ;stripe 2D
.word BlinkyString_9F86                                     ;stripe 2E
.word InkyString_9F90                                       ;stripe 2F
.word PinkyString_9F9A                                      ;stripe 30
.word SueString_9FA4                                        ;stripe 31
.word EmptyWithString_9FAE                                  ;stripe 32
.word EmptyCharacterName_9FB6                               ;stripe 33
.word ActNameTheEnd_9F24                                    ;stripe 34
.word PacManString_9FC0                                     ;stripe 35
.word ContinuesString_9FCB                                  ;stripe 36
.word CreditsStrings_9FD3                                   ;stripe 37
.word TengenPresentsString_A085                             ;stripe 38