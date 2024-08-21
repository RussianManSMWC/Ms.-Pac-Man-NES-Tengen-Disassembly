;pac-man junior of moving variety, appears after performing an easter egg or in act 4 cutscene
EntityGFXPointers_PacJunior_AC63:
.word EntityGFXData_PacJuniorHorizontalRight_AC75
.word EntityGFXData_PacJuniorVerticalUp_AC6B
.word EntityGFXData_PacJuniorHorizontalLeft_AC7A
.word EntityGFXData_PacJuniorVerticalDown_AC70

EntityGFXData_PacJuniorVerticalUp_AC6B:
.byte 1
.byte -4,$BE,OAMProp_Palette0,-4

;why not just y-flip the vertical up frame?
EntityGFXData_PacJuniorVerticalDown_AC70:
.byte 1
.byte -4,$BF,OAMProp_Palette0,-4

EntityGFXData_PacJuniorHorizontalRight_AC75:
.byte 1
.byte -4,$BB,OAMProp_Palette0,-4

EntityGFXData_PacJuniorHorizontalLeft_AC7A:
.byte $01
.byte -4,$BB,OAMProp_XFlip|OAMProp_Palette0,-4