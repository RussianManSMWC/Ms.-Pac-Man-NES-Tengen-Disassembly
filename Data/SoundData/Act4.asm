SndData_Act4Part1_F2BB:
.byte $00,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte SoundCommand_SetNoteProperties,$13
.byte $A0,$A2,$A2,$61,$63,$7F,$63,$5E
.byte $42,$42,$5C,$7F,$63,$5E,$42,$42
.byte $5C,$42,$42,$42,$42,$61,$7F,$61
.byte SoundCommand_EndPlayback

SndData_Act4Part2_F2DD:
.byte $11,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $B0,$B0,$B0
.byte SoundCommand_SetNoteProperties,$0C
.byte $60,$60,$67,$60,$79,$60,$42,$41
.byte $42,$5D,$45,$5E,$5E,$44,$5E,$5E
.byte $5F,$45,$7C,$64,$65
.byte SoundCommand_EndPlayback