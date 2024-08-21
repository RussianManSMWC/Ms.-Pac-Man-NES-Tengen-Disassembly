;PPU Attribute value pointers (used for an entire row)
PPUAttributeRowValuePointers_E5C8:
.word DATA_E5E2
.word DATA_E5EA
.word DATA_E5F2
.word DATA_E5FA
.word DATA_E602
.word DATA_E60A
.word DATA_E612
.word DATA_E61A
.word DATA_E622
.word DATA_E62A
.word DATA_E632
.word DATA_E63A
.word DATA_E642

;attribute data
;Uses a macro to generate a proper attribute value
;format: BGAttributeByte TopLeft, TopRight, BottomLeft, BottomRight
;Each value sets respective 16x16 tile's palette)

;this one sets all tiles on the same row to palette 3
DATA_E5E2:
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3

DATA_E5EA:
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette1

DATA_E5F2:
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette2, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette2, BGAttribute_Palette2

;attributes used by TENGEN PRESENTS string (maybe something else, idk)
DATA_E5FA:
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette1, BGAttribute_Palette2, BGAttribute_Palette2

DATA_E602:
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette1, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette3, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette0, BGAttribute_Palette1

DATA_E60A:
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette1, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette0, BGAttribute_Palette1

DATA_E612:
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette3, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3

DATA_E61A:
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette3

;sets all tile to palette 0
DATA_E622:
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0

DATA_E62A:
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette3, BGAttribute_Palette3, BGAttribute_Palette0, BGAttribute_Palette0

DATA_E632:
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0
BGAttributeByte BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0, BGAttribute_Palette0

;sets all tiles to palette 1
DATA_E63A:
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1
BGAttributeByte BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1, BGAttribute_Palette1

;ms pac-man title+score during mazes
DATA_E642:
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2
BGAttributeByte BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2, BGAttribute_Palette2