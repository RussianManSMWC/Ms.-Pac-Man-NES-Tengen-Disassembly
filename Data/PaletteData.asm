;various color-related stuff here (maybe I'll separate them later)

;normal ghost palettes, used to be restored when the ghost becomes normal
NormalGhostPaletteColors_87D0:
.byte $05,$16,$11,$25

;these colors are modified by ghosts when they become vulnerable and vice-versa
NormalGhostPaletteColorIndexes_87D4:
.byte Palette_Sprite1 + 1,Palette_Sprite1 + 2,Palette_Sprite2 + 1,Palette_Sprite2 + 2

;palettes it seems
DefaultSpritePalettes_87D8:
.byte $0F,$28,$05,$01                                       ;Pac-Man Species
.byte $0F,$05,$16,$30                                       ;Blinky/Sue
.byte $0F,$11,$25,$30                                       ;Pinky/Inky
;the last palette doesn't matter, it's dynamically set when fruit/item spawns)

;BG1 palette for the current maze (depends on maze selection, layout and current level value)
MazePalettes_87E4:
.byte $0F,$36,$15,$30
.byte $0F,$21,$30,$28
.byte $0F,$16,$30,$15
.byte $0F,$01,$38,$30
.byte $0F,$35,$28,$30
.byte $0F,$36,$15,$30
.byte $0F,$17,$30,$30
.byte $0F,$13,$30,$28
.byte $0F,$0F,$30,$28
.byte $0F,$0F,$01,$30
.byte $0F,$14,$25,$30
.byte $0F,$15,$30,$30
.byte $0F,$1B,$30,$30
.byte $0F,$28,$30,$2A
.byte $0F,$1A,$30,$28
.byte $0F,$18,$30,$30
.byte $0F,$25,$30,$30
.byte $0F,$12,$30,$28
.byte $0F,$07,$30,$30
.byte $0F,$15,$25,$30
.byte $0F,$0F,$30,$1C
.byte $0F,$19,$30,$30
.byte $0F,$0C,$30,$14
.byte $0F,$23,$30,$2B
.byte $0F,$10,$30,$28
.byte $0F,$03,$30,$30
.byte $0F,$04,$30,$30
.byte $0F,$15,$30,$30
.byte $0F,$09,$30,$31
.byte $0F,$00,$19,$24
.byte $0F,$19,$30,$31
.byte $0F,$15,$25,$35
.byte $0F,$0C,$30,$30
.byte $0F,$15,$30,$30
.byte $0F,$0B,$30,$30

;default BG0 palette (replaced right after anyway, so it's of questionable use)
;technically also defaults BG1-BG3 with bouncing item palettes right below
DefaultBackgroundPalettes_8870:
.byte $0F,$08,$30,$30

;palettes for various bouncing items
BouncingItemPalettes_8874:
.byte $0F,$28,$05,$0F
.byte $0F,$1A,$16,$30
.byte $0F,$05,$1A,$30                                       ;cherry
.byte $0F,$28,$26,$07                                       ;orange
.byte $0F,$19,$3C,$0C
.byte $0F,$27,$17,$30
.byte $0F,$11,$25,$30
.byte $0F,$07,$36,$16
.byte $0F,$01,$26,$30