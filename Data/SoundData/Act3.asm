SndData_Act3Part1_F27A:
.byte $00,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $30
.byte SoundCommand_SetNoteProperties,$1C
.byte $20,$3F,$21,$43,$3F,$41,$39,$3F
.byte $21,$44,$3F,$41,$25,$3F,$21,$42
.byte $25,$5E,$DE,$C0,$5D,$3E,$65
.byte SoundCommand_EndPlayback

SndData_Act3Part2_F29C:
.byte $11,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $30
.byte SoundCommand_SetNoteProperties,$18
.byte $C0,$44,$20,$3F,$3F,$DE,$40,$3B
.byte $22,$22,$C6,$5D,$39,$22,$22,$C5
.byte $C0,$41,$22,$7D
.byte SoundCommand_EndPlayback