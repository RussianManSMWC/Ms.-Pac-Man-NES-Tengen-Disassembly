;insert useful macros here

;Word - the 16-bit value we store, Addr - 16-bit address we store the word to. This can be used to set up pointers or VRAM locations to draw to in RAM.
.macro Macro_SetWord Word, Addr
  LDA #<Word
  STA Addr

  LDA #>Word
  STA Addr+1
.endmacro

.macro RepeatMazeTile Tile,Times
  .byte Maze_RepeatTileCommand|(Times-1),Tile
.endmacro

;also somewhat for readibility + it's slightly easier to modify attributes this way (as opposed to changing spooky bits)
.macro BGAttributeByte tL,tR,bL,bR
  .byte (bR<<6|bL<<4|tR<<2|tL)
.endmacro