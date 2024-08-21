;i think it's fair to put two part sound bytes together 
SndData_PacJrAppear1Part1_F01E:
.byte $00,$20
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $30
.byte SoundCommand_SetNoteProperties,$28
.byte $A0,$BF,$A1,$23,$BF,$21
.byte SoundCommand_EndPlayback

SndData_PacJrAppear1Part2_F02F:
.byte $11,$20
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $30
.byte SoundCommand_SetNoteProperties,$24
.byte $20,$B0,$44
.byte SoundCommand_EndPlayback