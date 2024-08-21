;DEMO INPUTS HERE
;Each input is a pair of bytes
;Format: input, timing
;Note that input can be D-pad only, other buttons are filtered ($00 - no inputs)
DemoMovementData_A25B:
.byte $00,$75
.byte Input_Down,$62 
.byte Input_Down|Input_Left,$01
.byte Input_Left,$11
.byte Input_Down|Input_Left,$09
.byte Input_Down,$0E
.byte Input_Down|Input_Right,$02
.byte Input_Right,$6D
.byte Input_Up|Input_Right,$02
.byte Input_Up,$2E
.byte Input_Up|Input_Right,$01
.byte Input_Right,$17
.byte Input_Up|Input_Right,$07
.byte Input_Up,$9F
.byte Input_Up|Input_Left,$04
.byte Input_Left,$14
.byte Input_Down|Input_Left,$08
.byte Input_Down,$12
.byte Input_Down|Input_Left,$13
.byte Input_Left,$05
.byte Input_Up|Input_Left,$06
.byte Input_Left,$20
.byte Input_Up|Input_Left,$06
.byte Input_Up,$19 
.byte Input_Up|Input_Left,$3C
.byte Input_Up,$11
.byte Input_Up|Input_Right,$02
.byte Input_Right,$20
.byte $00,$01
.byte Input_Left,$15
.byte Input_Down|Input_Left,$01
.byte Input_Down,$11
.byte Input_Down|Input_Left,$03
.byte Input_Left,$11
.byte Input_Up|Input_Left,$03
.byte Input_Up,$15
.byte Input_Up|Input_Left,$04
.byte Input_Left,$40
.byte $00,$33
.byte Input_Down,$10
.byte Input_Down|Input_Right,$02
.byte Input_Right,$6F
.byte Input_Down|Input_Right,$08
.byte Input_Down,$1B
.byte $00,$01
.byte Input_Right,$01
.byte Input_Up,$12
.byte Input_Up|Input_Right,$02
.byte Input_Right,$3B
.byte Input_Down|Input_Right,$0B
.byte Input_Down,$0A
.byte Input_Down|Input_Left,$05
.byte Input_Left,$0C
.byte Input_Down|Input_Left,$07
.byte Input_Down,$4E
.byte Input_Down|Input_Left,$05
.byte Input_Left,$0B
.byte Input_Down|Input_Left,$03
.byte Input_Down,$16
.byte Input_Down|Input_Right,$08
.byte $00,$04
.byte Input_Right,$2E
.byte Input_Left,$08
.byte Input_Up,$FF                                          ;hold up for as long as possible (should be killed by the ghost)

;either a placeholder or an extension in case the ghost does not kill ms. pac-man and the demo continues.
.byte $00,$FF