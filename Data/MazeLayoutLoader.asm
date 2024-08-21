;note: certain strange mazes reuse the same layout as mini and big
;the inconsistent ordering implies that the layouts were shuffled around during development, and some mazes were added later on
;the fact that some are appended to the end indicates that originally there were 4 mini mazes, 8 big mazes and 12 strange mazes
MazeLayoutPointers_AEB0:
.word MazeLayout_Arcade1_AEF8
.word MazeLayout_Arcade2_B040
.word MazeLayout_Arcade3_B187
.word MazeLayout_Arcade4_B2DE
.word MazeLayout_Mini1_B431
.word MazeLayout_Mini2_B52D
.word MazeLayout_Mini3_B63D
.word MazeLayout_Mini4_B74D
.word MazeLayout_Big6_B85C
.word MazeLayout_Big7_BA00
.word MazeLayout_Big1_BB6E
.word MazeLayout_Big2_BCFA
.word MazeLayout_Big3_BE8C
.word MazeLayout_Big4_C028
.word MazeLayout_Big5_C1A4
.word MazeLayout_Big8_C343
.word MazeLayout_Strange10_C4DB
.word MazeLayout_Strange2_C62A
.word MazeLayout_Strange3_C779
.word MazeLayout_Strange13_C8B6
.word MazeLayout_Strange12_C9D6
.word MazeLayout_Strange5_CB3F
.word MazeLayout_Strange4_CCA8
.word MazeLayout_Strange14_CDFF
.word MazeLayout_Strange11_CF4D
.word MazeLayout_Strange1_D0A0
.word MazeLayout_Strange7_D1E5
.word MazeLayout_Strange9_D332
.word MazeLayout_Big10_D455
.word MazeLayout_Big9_D5DC
.word MazeLayout_Mini5_D772
.word MazeLayout_Mini6_D87A
.word MazeLayout_Strange8_D986
.word MazeLayout_Strange15_DAD9
.word MazeLayout_Strange6_DC22
.word MazeLayout_Big11_DD56 ;layout 36

.include "MazeLayouts/Arcade1.asm"
.include "MazeLayouts/Arcade2.asm"
.include "MazeLayouts/Arcade3.asm"
.include "MazeLayouts/Arcade4.asm"

.include "MazeLayouts/Mini1.asm"
.include "MazeLayouts/Mini2.asm"
.include "MazeLayouts/Mini3.asm"
.include "MazeLayouts/Mini4.asm"

.include "MazeLayouts/Big6.asm"
.include "MazeLayouts/Big7.asm"
.include "MazeLayouts/Big1.asm"
.include "MazeLayouts/Big2.asm"
.include "MazeLayouts/Big3.asm"
.include "MazeLayouts/Big4.asm"
.include "MazeLayouts/Big5.asm"
.include "MazeLayouts/Big8.asm"

.include "MazeLayouts/Strange10.asm"
.include "MazeLayouts/Strange2.asm"
.include "MazeLayouts/Strange3.asm"
.include "MazeLayouts/Strange13.asm"
.include "MazeLayouts/Strange12.asm"
.include "MazeLayouts/Strange5.asm"
.include "MazeLayouts/Strange4.asm"
.include "MazeLayouts/Strange14.asm"
.include "MazeLayouts/Strange11.asm"
.include "MazeLayouts/Strange1.asm"
.include "MazeLayouts/Strange7.asm"
.include "MazeLayouts/Strange9.asm"

.include "MazeLayouts/Big10.asm"
.include "MazeLayouts/Big9.asm"

.include "MazeLayouts/Mini5.asm"
.include "MazeLayouts/Mini6.asm"

.include "MazeLayouts/Strange8.asm"
.include "MazeLayouts/Strange15.asm"
.include "MazeLayouts/Strange6.asm"

.include "MazeLayouts/Big11.asm"