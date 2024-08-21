SndData_Act2Part1_F1A1:
.byte $00,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $30
.byte SoundCommand_SetNoteProperties,$1F
.byte $40,$24,$21,$21,$41,$3F,$41,$3D
.byte $23,$22,$41,$3F,$41,$26,$3E,$3E
.byte $3E,$3F,$21,$38,$22,$61,$50,$5B
.byte $29,$21,$21,$21,$39,$22,$21,$21
.byte $3C,$24,$3C,$5B,$3D,$21,$21,$61
.byte $63,$61,$50,$5C,$2A,$3D,$3B,$21
.byte $26,$3E,$3C,$21,$23,$23,$24,$5E
.byte $3E,$3D,$3D,$7E,$7E,$25,$22,$21
.byte $21,$39,$22,$21,$22,$22,$21,$21
.byte $21,$39,$22,$21,$21,$3C,$24,$3C
.byte $5B,$20,$3F,$21,$62,$7F,$61,$70
.byte $28,$3F,$3E,$5E,$22,$42,$20,$3E
.byte $3E,$5B,$3D,$21,$21,$61,$24,$26
.byte $38,$22,$61
.byte SoundCommand_EndPlayback

SndData_Act2Part2_F217:
.byte $11,$07
.byte SoundCommand_InitChannel,$88,$00,$05,$08
.byte $30,$50
.byte SoundCommand_SetNoteProperties,$23
.byte $20,$3F,$3F,$5E,$3F,$41,$3E,$3F
.byte $3F,$5F,$3F,$41,$79,$40,$B0,$A0
.byte $A2,$A2,$41,$44,$57,$49,$5C,$44
.byte $57,$49,$5C,$44,$57,$49,$5C,$44
.byte $57,$48,$5F,$43,$42,$5E,$5D,$43
.byte $5A,$46,$5D,$43,$5A,$46,$5A,$42
.byte $41,$41,$21,$21,$21,$21,$20,$3E
.byte $3F,$3E,$5E,$44,$57,$49,$5C,$44
.byte $57,$49,$5E,$43,$5F,$5D,$41,$5D
.byte $5E,$5E,$67,$50,$40,$7E,$50,$40
.byte $5F,$46,$5D,$43,$5B,$5B,$45
.byte SoundCommand_EndPlayback
