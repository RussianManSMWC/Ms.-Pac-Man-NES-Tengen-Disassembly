;maze layout values for each selection (determines the order they appear)
MazeLayoutsPerSelectionPointers_EF20:
.word ArcadeMazeSelectionLayouts_EF28
.word MiniMazeSelectionLayouts_EF3E
.word BigMazeSelectionLayouts_EF5F
.word StrangeMazeSelectionLayouts_EF80

;maze layout values for each selection (their order)
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