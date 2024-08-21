EntityGFXPointers_Clapper_ACBD:
.word EntityGFXData_ClapperClosed_ACC3
.word EntityGFXData_ClapperSlightlyOpen_ACD8
.word EntityGFXData_ClapperFullyOpen_ACE9

EntityGFXData_ClapperClosed_ACC3:
.byte 5
.byte 0,$D7,OAMProp_Palette1,0
.byte 0,$D8,OAMProp_Palette1,8
.byte 0,$D8,OAMProp_Palette1,16
.byte 0,$D8,OAMProp_Palette1,24
.byte 0,$D9,OAMProp_Palette1,32

EntityGFXData_ClapperSlightlyOpen_ACD8:
.byte 4
.byte 0,$D3,OAMProp_Palette1,0
.byte 0,$D4,OAMProp_Palette1,8
.byte -3,$D5,OAMProp_Palette1,16
.byte -6,$D6,OAMProp_Palette1,24

EntityGFXData_ClapperFullyOpen_ACE9:
.byte 4
.byte 0,$D0,OAMProp_Palette1,0
.byte -1,$D1,OAMProp_Palette1,8
.byte -5,$D1,OAMProp_Palette1,16
.byte -9,$D2,OAMProp_Palette1,24