SndData_GameStartPart1_F0F6:
.byte $00,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte SoundCommand_SetNoteProperties,$13
.byte $A0,$A2,$A2,$41,$44,$5E,$43,$3F
.byte $21,$22,$3D,$5E,$43,$3F,$21,$22
.byte $3D,$21,$22,$22,$22,$41,$5F,$41
.byte SoundCommand_EndPlayback

SndData_GameStartPart2_F118:
.byte $11,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $B0,$B0,$B0
.byte SoundCommand_SetNoteProperties,$0C
.byte $60,$67,$79,$22,$22,$21,$3D,$25
.byte $3E,$3F,$23,$3E,$3F,$3E,$25,$5D
.byte $43,$65
.byte SoundCommand_EndPlayback