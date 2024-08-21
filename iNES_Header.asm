MAPPER = 0                                                  ;which mapper it's using (NROM)
MIRRORING = 0                                               ;horizontal mirroring (0 - horizontal, 1 - vertical)
REGION = 0                                                  ;NTSC

.byte "NES", $1A

.byte $02                                                   ;16KB PRG space (for code) = 2
.byte $01                                                   ;8KB CHR space (for GFX) = 1

.byte MAPPER<<4&$F0|MIRRORING                               ;Mapper = USER VALUE and Mirroring is NOT vertical, because it would cause glitches (the game is reliant on verticality)
.byte MAPPER&$F0                                            ;Mapper is still USER VALUE, and the system is NES (not PlayChoice-10)

.byte $00                                                   ;PRG RAM-Size (useless)
.byte REGION                                                ;the only thing that matters - TV System (NTSC or PAL)
.byte $00,$00,$00,$00,$00,$00                               ;the rest don't matter for this game