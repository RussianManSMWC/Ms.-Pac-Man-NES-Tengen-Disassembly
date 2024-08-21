;Data pointers for tunnels
;some are shared between mazes due to idencital tunnel locations and lengths
MazeTunnelDataPointers_AD98:
.word MazeTunnelData_Arcade1_ADE0
.word MazeTunnelData_Arcade2_ADF8
.word MazeTunnelData_Arcade3_ADE8
.word MazeTunnelData_Arcade4_ADF0
.word MazeTunnelData_Mini1_ADE0
.word MazeTunnelData_Mini2_ADF8
.word MazeTunnelData_Mini3_ADE8
.word MazeTunnelData_Mini4_AE00
.word MazeTunnelData_Big6_AE08
.word MazeTunnelData_Big7_AE10
.word MazeTunnelData_Big1_ADE8
.word MazeTunnelData_Big2_ADF0
.word MazeTunnelData_Big3_AE18
.word MazeTunnelData_Big4_ADF8
.word MazeTunnelData_Big5_AE20
.word MazeTunnelData_Big8_AE28
.word MazeTunnelData_Strange10_AE30
.word MazeTunnelData_Strange2_AE38
.word MazeTunnelData_Strange3_AE40
.word MazeTunnelData_Strange13_AE48
.word MazeTunnelData_Strange12_AE50
.word MazeTunnelData_Strange5_AE58
.word MazeTunnelData_Strange4_ADE0
.word MazeTunnelData_Strange14_AE60
.word MazeTunnelData_Strange11_AE68
.word MazeTunnelData_Strange1_AE70
.word MazeTunnelData_Strange7_AE78
.word MazeTunnelData_Strange9_AE80
.word MazeTunnelData_Big10_AE88
.word MazeTunnelData_Big9_AE90
.word MazeTunnelData_Mini5_ADE8
.word MazeTunnelData_Mini6_AE98
.word MazeTunnelData_Strange8_AEA0
.word MazeTunnelData_Strange15_ADF8
.word MazeTunnelData_Strange6_AE38
.word MazeTunnelData_Big11_AEA8

;first byte is which 8x8 tow the tunnel is on.
;second byte is how wide the tunnel is. this is mostly important for ghosts, since they slow down when entering a tunnel
;each maze layout supports up to 4 tunnels
MazeTunnelData_Arcade1_ADE0:
MazeTunnelData_Mini1_ADE0:
MazeTunnelData_Strange4_ADE0:
.byte $08,$05
.byte $11,$05
.byte $00,$00
.byte $00,$00

MazeTunnelData_Arcade3_ADE8:
MazeTunnelData_Mini3_ADE8:
MazeTunnelData_Mini5_ADE8:
MazeTunnelData_Big1_ADE8:
.byte $09,$03
.byte $09,$03
.byte $00,$00
.byte $00,$00

MazeTunnelData_Arcade4_ADF0:
MazeTunnelData_Big2_ADF0:
.byte $0D,$08
.byte $10,$08
.byte $00,$00
.byte $00,$00

MazeTunnelData_Arcade2_ADF8:
MazeTunnelData_Mini2_ADF8:
MazeTunnelData_Big4_ADF8:
MazeTunnelData_Strange15_ADF8:
.byte $01,$09
.byte $17,$05
.byte $00,$00
.byte $00,$00

MazeTunnelData_Mini4_AE00:
.byte $0D,$08
.byte $10,$03
.byte $00,$00
.byte $00,$00

MazeTunnelData_Big6_AE08:
.byte $08,$05
.byte $11,$05
.byte $1D,$03
.byte $23,$03

MazeTunnelData_Big7_AE10:
.byte $0E,$07
.byte $17,$05
.byte $00,$00
.byte $00,$00

MazeTunnelData_Big3_AE18:
.byte $04,$05
.byte $1E,$05
.byte $00,$00
.byte $00,$00

MazeTunnelData_Big5_AE20:
.byte $09,$03
.byte $14,$08
.byte $00,$00
.byte $00,$00

MazeTunnelData_Big8_AE28:
.byte $0D,$08
.byte $10,$08
.byte $23,$03
.byte $00,$00

MazeTunnelData_Strange10_AE30:
.byte $11,$03
.byte $11,$03
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange2_AE38:
MazeTunnelData_Strange6_AE38:
.byte $17,$05
.byte $17,$05
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange3_AE40:
.byte $01,$06
.byte $1D,$03
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange13_AE48:
.byte $0B,$05
.byte $0F,$05
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange12_AE50:
.byte $10,$03
.byte $10,$03
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange5_AE58:
.byte $0B,$03
.byte $1D,$03
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange14_AE60:
.byte $08,$03
.byte $11,$04
.byte $14,$06
.byte $00,$00

MazeTunnelData_Strange11_AE68:
.byte $0A,$03
.byte $0D,$03
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange1_AE70:
.byte $01,$0C
.byte $0D,$05
.byte $17,$05
.byte $00,$00

MazeTunnelData_Strange7_AE78:
.byte $01,$06
.byte $01,$06
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange9_AE80:
.byte $01,$0D
.byte $17,$05
.byte $09,$03
.byte $00,$00

MazeTunnelData_Big10_AE88:
.byte $01,$04
.byte $1D,$07
.byte $00,$00
.byte $00,$00

MazeTunnelData_Big9_AE90:
.byte $0E,$06
.byte $0E,$06
.byte $00,$00
.byte $00,$00

MazeTunnelData_Mini6_AE98:
.byte $0D,$05
.byte $10,$03
.byte $00,$00
.byte $00,$00

MazeTunnelData_Strange8_AEA0:
.byte $08,$05
.byte $11,$05
.byte $00,$00
.byte $00,$00

MazeTunnelData_Big11_AEA8:
.byte $01,$07
.byte $14,$03
.byte $02,$07
.byte $00,$00