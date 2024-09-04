;ghost and player speed values, depending on difficulty and current level.

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