SndData_PowerPellet_F081:
.byte $15,$40
.byte SoundCommand_InitChannel,$88,$9B,$00,$08
.byte SoundCommand_SetNoteProperties,$28
.byte $20,$21
.byte SoundCommand_RepeatAPairOfBytes                       ;perpetually repeat the last two property bytes