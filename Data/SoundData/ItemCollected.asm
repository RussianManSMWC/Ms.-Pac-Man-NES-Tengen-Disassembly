SndData_ItemCollected_F08D:
.byte $04,$20
.byte SoundCommand_InitChannel,$8F,$93,$1C,$08
.byte SoundCommand_SetNoteProperties,$23
.byte $40
.byte SoundCommand_InitChannel,$8F,$9C,$FF,$22
.byte SoundCommand_SetNoteProperties,$0F
.byte $40
.byte SoundCommand_EndPlayback