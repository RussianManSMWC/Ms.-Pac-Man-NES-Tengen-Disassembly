SndData_Act1Part1_F137:
.byte $00,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $30
.byte SoundCommand_SetNoteProperties,$2B
.byte $20,$22,$3E,$5D,$3B,$23,$21,$61
.byte $3E,$22,$3E,$3D,$28,$22,$3E,$5D
.byte $3B,$43,$7D,$30,$2C,$23,$21,$41
.byte $20,$BE,$A1,$3F,$3D,$3E,$3E,$22
.byte $3E,$22,$42,$3E,$3E,$3D,$3E,$22
.byte $3E,$3D,$23,$3D,$3E,$3E,$5D,$50
.byte SoundCommand_EndPlayback

SndData_Act1Part2_F172:
.byte $11,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $30
.byte SoundCommand_SetNoteProperties,$1C
.byte $40,$20,$40,$70,$40,$20,$60,$40
.byte $20,$60,$50,$5B,$20,$60,$65,$7E
.byte $7E,$7F,$45,$43,$42,$42,$23,$3D
.byte $3E,$3E,$3D,$30
.byte SoundCommand_InitChannel,$80,$A6,$00,$08
.byte SoundCommand_SetNoteProperties,$23
.byte $40
.byte SoundCommand_EndPlayback