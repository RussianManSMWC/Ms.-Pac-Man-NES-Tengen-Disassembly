;item graphics pointers
EntityGFXPointers_Items_A99F:
.word EntityGFXData_CherryItem_A9BB                         ;cherry
.word EntityGFXData_StrawberryItem_A9CC                     ;strawberry
.word EntityGFXData_OrangeItem_A9EE                         ;orange
.word EntityGFXData_PretzelItem_A9FF                        ;pretzel
.word EntityGFXData_AppleItem_A9DD                          ;apple
.word EntityGFXData_PearItem_AA10                           ;pear
.word EntityGFXData_BananaItem_AA21                         ;banana
.word EntityGFXData_DrinkItem_AA98                          ;milk?
.word EntityGFXData_IceCreamItem_AA87                       ;ice cream
.word EntityGFXData_HighHeelItem_AA65                       ;high heel
.word EntityGFXData_PAStarItem_AA76                         ;PA star
.word EntityGFXData_KlaxItem_AA32                           ;Clax hand
.word EntityGFXData_RingItem_AA43                           ;ring
.word EntityGFXData_FlowerItem_AA54                         ;flower

EntityGFXData_CherryItem_A9BB:
.byte 4
.byte -8,$80,OAMProp_Palette3,-8
.byte -8,$81,OAMProp_Palette3,0
.byte 0,$82,OAMProp_Palette3,-8
.byte 0,$83,OAMProp_Palette3,0

EntityGFXData_StrawberryItem_A9CC:
.byte 4
.byte -8,$84,OAMProp_Palette3,-8
.byte -8,$85,OAMProp_Palette3,0
.byte 0,$86,OAMProp_Palette3,-8
.byte 0,$87,OAMProp_Palette3,0

EntityGFXData_AppleItem_A9DD:
.byte 4
.byte -8,$88,OAMProp_Palette3,-8
.byte -8,$89,OAMProp_Palette3,0
.byte 0,$8A,OAMProp_Palette3,-8
.byte 0,$8B,OAMProp_Palette3,0

EntityGFXData_OrangeItem_A9EE:
.byte 4
.byte -8,$8C,OAMProp_Palette3,-8
.byte -8,$8D,OAMProp_Palette3,0
.byte 0,$8E,OAMProp_Palette3,-8
.byte 0,$8F,OAMProp_Palette3,0

EntityGFXData_PretzelItem_A9FF:
.byte 4
.byte -8,$90,OAMProp_Palette3,-8
.byte -8,$91,OAMProp_Palette3,0
.byte 0,$92,OAMProp_Palette3,-8
.byte 0,$93,OAMProp_Palette3,0

EntityGFXData_PearItem_AA10:
.byte 4
.byte -8,$94,OAMProp_Palette3,-8
.byte -8,$95,OAMProp_Palette3,0
.byte 0,$96,OAMProp_Palette3,-8
.byte 0,$97,OAMProp_Palette3,0

EntityGFXData_BananaItem_AA21:
.byte 4
.byte -8,$98,OAMProp_Palette3,-8
.byte -8,$99,OAMProp_Palette3,0
.byte 0,$9A,OAMProp_Palette3,-8
.byte 0,$9B,OAMProp_Palette3,0

EntityGFXData_KlaxItem_AA32:
.byte 4
.byte -8,$F0,OAMProp_Palette3,-8
.byte -8,$F1,OAMProp_Palette3,0
.byte 0,$F2,OAMProp_Palette3,-8
.byte 0,$F3,OAMProp_Palette3,0

EntityGFXData_RingItem_AA43:
.byte 4
.byte -8,$F8,OAMProp_Palette3,-8
.byte -8,$F8,OAMProp_XFlip|OAMProp_Palette3,0
.byte 0,$F9,OAMProp_Palette3,-8
.byte 0,$F9,OAMProp_XFlip|OAMProp_Palette3,0

EntityGFXData_FlowerItem_AA54:
.byte 4
.byte -8,$9D,OAMProp_Palette3,-8
.byte -8,$9D,OAMProp_XFlip|OAMProp_Palette3,0
.byte 0,$9D,OAMProp_YFlip|OAMProp_Palette3,-8
.byte 0,$9D,OAMProp_YFlip|OAMProp_XFlip|OAMProp_Palette3,0

EntityGFXData_HighHeelItem_AA65:
.byte 4
.byte -8,$F4,OAMProp_Palette3,-8
.byte -8,$F5,OAMProp_Palette3,0
.byte 0,$F6,OAMProp_Palette3,-8
.byte 0,$F7,OAMProp_Palette3,0

EntityGFXData_PAStarItem_AA76:
.byte 4
.byte -8,$FA,OAMProp_Palette3,-8
.byte -8,$FB,OAMProp_Palette3,0
.byte 0,$FC,OAMProp_Palette3,-8
.byte 0,$FD,OAMProp_Palette3,0

EntityGFXData_IceCreamItem_AA87:
.byte 4
.byte -8,$E9,OAMProp_Palette3,-8
.byte -8,$E9,OAMProp_XFlip|OAMProp_Palette3,0
.byte 0,$EA,OAMProp_Palette3,-8
.byte 0,$EA,OAMProp_XFlip|OAMProp_Palette3,0

EntityGFXData_DrinkItem_AA98:
.byte 4
.byte -8,$EB,OAMProp_Palette3,-8
.byte -8,$EC,OAMProp_Palette3,0
.byte 0,$ED,OAMProp_Palette3,-8
.byte 0,$EE,OAMProp_Palette3,0