EntityGFXPointers_GhostEyes_AC0B:
.word EntityGFXData_InkySueEyesHorizontalRight_AC1B
.word EntityGFXData_InkySueEyesVerticalUp_AC24
.word EntityGFXData_InkySueEyesHorizontalLeft_AC2D
.word EntityGFXData_InkySueEyesVerticalDown_AC36
.word EntityGFXData_PinkyBlinkyEyesHorizontalRight_AC3F
.word EntityGFXData_PinkyBlinkyEyesVerticalUp_AC48
.word EntityGFXData_PinkyBlinkyEyesHorizontalLeft_AC51
.word EntityGFXData_PinkyBlinkyEyesVerticalDown_AC5A

;by default, the palettes are for Inky and Pinky, Sue and Blinky's eye colors are handled by the code
EntityGFXData_InkySueEyesHorizontalRight_AC1B:
.byte 2
.byte -4,$69,OAMProp_XFlip|OAMProp_Palette2,-6
.byte -4,$69,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_InkySueEyesVerticalUp_AC24:
.byte 2
.byte -4,$68,OAMProp_Palette2,-6
.byte -4,$68,OAMProp_Palette2,0

EntityGFXData_InkySueEyesHorizontalLeft_AC2D:
.byte 2
.byte -4,$69,OAMProp_Palette2,-6
.byte -4,$69,OAMProp_Palette2,0

EntityGFXData_InkySueEyesVerticalDown_AC36:
.byte 2
.byte -4,$68,OAMProp_YFlip|OAMProp_Palette2,-6
.byte -4,$68,OAMProp_YFlip|OAMProp_Palette2,0

EntityGFXData_PinkyBlinkyEyesHorizontalRight_AC3F:
.byte 2
.byte -4,$6B,OAMProp_XFlip|OAMProp_Palette2,-6
.byte -4,$6B,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyBlinkyEyesVerticalUp_AC48:
.byte 2
.byte -4,$6A,OAMProp_Palette2,-6
.byte -4,$6A,OAMProp_Palette2,0

EntityGFXData_PinkyBlinkyEyesHorizontalLeft_AC51:
.byte 2
.byte -4,$6B,OAMProp_Palette2,-6
.byte -4,$6B,OAMProp_Palette2,0

EntityGFXData_PinkyBlinkyEyesVerticalDown_AC5A:
.byte 2
.byte -4,$6A,OAMProp_YFlip|OAMProp_Palette2,-6
.byte -4,$6A,OAMProp_YFlip|OAMProp_Palette2,0