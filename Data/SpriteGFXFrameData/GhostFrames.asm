;includes both normal and vulnerable variants (the eyes are in a separate file)

EntityGFXPointers_Ghosts_A681:
;Blinky movement animation frames
.word EntityGFXData_BlinkyHorizontalRight1_A6D5
.word EntityGFXData_BlinkyHorizontalRight2_A719
.word EntityGFXData_BlinkyVerticalUp1_A6E6
.word EntityGFXData_BlinkyVerticalUp2_A72A
.word EntityGFXData_BlinkyHorizontalLeft1_A6F7
.word EntityGFXData_BlinkyHorizontalLeft2_A73B
.word EntityGFXData_BlinkyVerticalDown1_A708
.word EntityGFXData_BlinkyVerticalDown2_A74C

;Sue movement animation frames
.word EntityGFXData_SueHorizontalRight1_A7A1
.word EntityGFXData_SueHorizontalRight2_A7E5
.word EntityGFXData_SueVerticalUp1_A7B2
.word EntityGFXData_SueVerticalUp2_A7F6
.word EntityGFXData_SueHorizontalLeft1_A7C3
.word EntityGFXData_SueHorizontalLeft2_A807
.word EntityGFXData_SueVerticalDown1_A7D4
.word EntityGFXData_SueVerticalDown2_A818

;Inky movement animation frames
.word EntityGFXData_InkyHorizontalRight1_A84B
.word EntityGFXData_InkyHorizontalRight2_A88F
.word EntityGFXData_InkyVerticalUp1_A85C
.word EntityGFXData_InkyVerticalUp2_A8A0
.word EntityGFXData_InkyHorizontalLeft1_A86D
.word EntityGFXData_InkyHorizontalLeft2_A8B1
.word EntityGFXData_InkyVerticalDown1_A87E
.word EntityGFXData_InkyVerticalDown2_A8C2

;Pinky movement animation frames
.word EntityGFXData_PinkyHorizontalRight1_A8F5
.word EntityGFXData_PinkyHorizontalRight2_A939
.word EntityGFXData_PinkyVerticalUp1_A906
.word EntityGFXData_PinkyVerticalUp2_A94A
.word EntityGFXData_PinkyHorizontalLeft1_A917
.word EntityGFXData_PinkyHorizontalLeft2_A95B
.word EntityGFXData_PinkyVerticalDown1_A928
.word EntityGFXData_PinkyVerticalDown2_A96C

EntityGFXPointers_VulnerableGhosts_A6C1:
;Blinky vulnerable frames
.word EntityGFXData_BlinkyVulnerable1_A75D
.word EntityGFXData_BlinkyVulnerable2_A76E

;Sue vulnerable frames
.word EntityGFXData_SueVulnerable1_A829
.word EntityGFXData_SueVulnerable2_A83A

;Inky vulnerable frames
.word EntityGFXData_InkyVulnerable1_A8D3
.word EntityGFXData_InkyVulnerable2_A8E4

;Pinky vulnerable frames
.word EntityGFXData_PinkyVulnerable1_A97D
.word EntityGFXData_PinkyVulnerable2_A98E

;these are shared between all ghosts
.word EntityGFXData_GhostVulnerableBlink1_A77F
.word EntityGFXData_GhostVulnerableBlink2_A790

EntityGFXData_BlinkyHorizontalRight1_A6D5:
.byte 4
.byte -8,$25,OAMProp_XFlip|OAMProp_Palette1,-8
.byte -8,$24,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$27,OAMProp_XFlip|OAMProp_Palette1,-8
.byte 0,$26,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_BlinkyVerticalUp1_A6E6:
.byte 4
.byte -8,$20,OAMProp_Palette1,-8
.byte -8,$20,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$21,OAMProp_Palette1,-8
.byte 0,$21,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_BlinkyHorizontalLeft1_A6F7:
.byte 4
.byte -8,$24,OAMProp_Palette1,-8
.byte -8,$25,OAMProp_Palette1,0
.byte 0,$26,OAMProp_Palette1,-8
.byte 0,$27,OAMProp_Palette1,0

EntityGFXData_BlinkyVerticalDown1_A708:
.byte 4
.byte -8,$22,OAMProp_Palette1,-8
.byte -8,$22,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$23,OAMProp_Palette1,-8
.byte 0,$23,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_BlinkyHorizontalRight2_A719:
.byte 4
.byte -8,$25,OAMProp_XFlip|OAMProp_Palette1,-8
.byte -8,$24,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$2B,OAMProp_XFlip|OAMProp_Palette1,-8
.byte 0,$2A,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_BlinkyVerticalUp2_A72A:
.byte 4
.byte -8,$20,OAMProp_Palette1,-8
.byte -8,$20,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$28,OAMProp_Palette1,-8
.byte 0,$28,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_BlinkyHorizontalLeft2_A73B:
.byte 4
.byte -8,$24,OAMProp_Palette1,-8
.byte -8,$25,OAMProp_Palette1,0
.byte 0,$2A,OAMProp_Palette1,-8
.byte 0,$2B,OAMProp_Palette1,0

EntityGFXData_BlinkyVerticalDown2_A74C:
.byte 4
.byte -8,$22,OAMProp_Palette1,-8
.byte -8,$22,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$29,OAMProp_Palette1,-8
.byte 0,$29,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_BlinkyVulnerable1_A75D:
.byte 4
.byte -8,$2C,OAMProp_Palette1,-8
.byte -8,$2C,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$2D,OAMProp_Palette1,-8
.byte 0,$2D,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_BlinkyVulnerable2_A76E:
.byte 4
.byte -8,$2C,OAMProp_Palette1,-8
.byte -8,$2C,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$2E,OAMProp_Palette1,-8
.byte 0,$2E,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_GhostVulnerableBlink1_A77F:
.byte 4
.byte -8,$48,OAMProp_Palette1,-8
.byte -8,$48,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$49,OAMProp_Palette1,-8
.byte 0,$49,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_GhostVulnerableBlink2_A790:
.byte 4
.byte -8,$48,OAMProp_Palette1,-8
.byte -8,$48,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$4A,OAMProp_Palette1,-8
.byte 0,$4A,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_SueHorizontalRight1_A7A1:
.byte 4
.byte -8,$35,OAMProp_XFlip|OAMProp_Palette1,-8
.byte -8,$34,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$37,OAMProp_XFlip|OAMProp_Palette1,-8
.byte 0,$36,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_SueVerticalUp1_A7B2:
.byte 4
.byte -8,$30,OAMProp_Palette1,-8
.byte -8,$30,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$31,OAMProp_Palette1,-8
.byte 0,$31,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_SueHorizontalLeft1_A7C3:
.byte 4
.byte -8,$34,OAMProp_Palette1,-8
.byte -8,$35,OAMProp_Palette1,0
.byte 0,$36,OAMProp_Palette1,-8
.byte 0,$37,OAMProp_Palette1,0

EntityGFXData_SueVerticalDown1_A7D4:
.byte 4
.byte -8,$32,OAMProp_Palette1,-8
.byte -8,$32,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$33,OAMProp_Palette1,-8
.byte 0,$33,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_SueHorizontalRight2_A7E5:
.byte 4
.byte -8,$35,OAMProp_XFlip|OAMProp_Palette1,-8
.byte -8,$34,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$3B,OAMProp_XFlip|OAMProp_Palette1,-8
.byte 0,$3A,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_SueVerticalUp2_A7F6:
.byte 4
.byte -8,$30,OAMProp_Palette1,-8
.byte -8,$30,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$38,OAMProp_Palette1,-8
.byte 0,$38,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_SueHorizontalLeft2_A807:
.byte 4
.byte -8,$34,OAMProp_Palette1,-8
.byte -8,$35,OAMProp_Palette1,0
.byte 0,$3A,OAMProp_Palette1,-8
.byte 0,$3B,OAMProp_Palette1,0

EntityGFXData_SueVerticalDown2_A818:
.byte 4
.byte -8,$32,OAMProp_Palette1,-8
.byte -8,$32,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$39,OAMProp_Palette1,-8
.byte 0,$39,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_SueVulnerable1_A829:
.byte 4
.byte -8,$3C,OAMProp_Palette1,-8
.byte -8,$3C,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$3D,OAMProp_Palette1,-8
.byte 0,$3D,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_SueVulnerable2_A83A:
.byte 4
.byte -8,$3C,OAMProp_Palette1,-8
.byte -8,$3C,OAMProp_XFlip|OAMProp_Palette1,0
.byte 0,$3E,OAMProp_Palette1,-8
.byte 0,$3E,OAMProp_XFlip|OAMProp_Palette1,0

EntityGFXData_InkyHorizontalRight1_A84B:
.byte 4
.byte -8,$43,OAMProp_XFlip|OAMProp_Palette2,-8
.byte -8,$42,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$27,OAMProp_XFlip|OAMProp_Palette2,-8
.byte 0,$26,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_InkyVerticalUp1_A85C:
.byte 4
.byte -8,$40,OAMProp_Palette2,-8
.byte -8,$40,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$21,OAMProp_Palette2,-8
.byte 0,$21,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_InkyHorizontalLeft1_A86D:
.byte 4
.byte -8,$42,OAMProp_Palette2,-8
.byte -8,$43,OAMProp_Palette2,0
.byte 0,$26,OAMProp_Palette2,-8
.byte 0,$27,OAMProp_Palette2,0

EntityGFXData_InkyVerticalDown1_A87E:
.byte 4
.byte -8,$22,OAMProp_Palette2,-8
.byte -8,$22,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$41,OAMProp_Palette2,-8
.byte 0,$41,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_InkyHorizontalRight2_A88F:
.byte 4
.byte -8,$43,OAMProp_XFlip|OAMProp_Palette2,-8
.byte -8,$42,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$2B,OAMProp_XFlip|OAMProp_Palette2,-8
.byte 0,$2A,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_InkyVerticalUp2_A8A0:
.byte 4
.byte -8,$40,OAMProp_Palette2,-8
.byte -8,$40,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$28,OAMProp_Palette2,-8
.byte 0,$28,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_InkyHorizontalLeft2_A8B1:
.byte 4
.byte -8,$42,OAMProp_Palette2,-8
.byte -8,$43,OAMProp_Palette2,0
.byte 0,$2A,OAMProp_Palette2,-8
.byte 0,$2B,OAMProp_Palette2,0

EntityGFXData_InkyVerticalDown2_A8C2:
.byte 4
.byte -8,$22,OAMProp_Palette2,-8
.byte -8,$22,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$44,OAMProp_Palette2,-8
.byte 0,$44,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_InkyVulnerable1_A8D3:
.byte 4
.byte -8,$2C,OAMProp_Palette2,-8
.byte -8,$2C,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$2D,OAMProp_Palette2,-8
.byte 0,$2D,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_InkyVulnerable2_A8E4:
.byte 4
.byte -8,$2C,OAMProp_Palette2,-8
.byte -8,$2C,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$2E,OAMProp_Palette2,-8
.byte 0,$2E,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyHorizontalRight1_A8F5:
.byte 4
.byte -8,$35,OAMProp_XFlip|OAMProp_Palette2,-8
.byte -8,$34,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$37,OAMProp_XFlip|OAMProp_Palette2,-8
.byte 0,$36,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyVerticalUp1_A906:
.byte 4
.byte -8,$30,OAMProp_Palette2,-8
.byte -8,$30,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$31,OAMProp_Palette2,-8
.byte 0,$31,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyHorizontalLeft1_A917:
.byte 4
.byte -8,$34,OAMProp_Palette2,-8
.byte -8,$35,OAMProp_Palette2,0
.byte 0,$36,OAMProp_Palette2,-8
.byte 0,$37,OAMProp_Palette2,0

EntityGFXData_PinkyVerticalDown1_A928:
.byte 4
.byte -8,$32,OAMProp_Palette2,-8
.byte -8,$32,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$33,OAMProp_Palette2,-8
.byte 0,$33,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyHorizontalRight2_A939:
.byte 4
.byte -8,$35,OAMProp_XFlip|OAMProp_Palette2,-8
.byte -8,$34,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$3B,OAMProp_XFlip|OAMProp_Palette2,-8
.byte 0,$3A,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyVerticalUp2_A94A:
.byte 4
.byte -8,$30,OAMProp_Palette2,-8
.byte -8,$30,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$38,OAMProp_Palette2,-8
.byte 0,$38,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyHorizontalLeft2_A95B:
.byte 4
.byte -8,$34,OAMProp_Palette2,-8
.byte -8,$35,OAMProp_Palette2,0
.byte 0,$3A,OAMProp_Palette2,-8
.byte 0,$3B,OAMProp_Palette2,0

EntityGFXData_PinkyVerticalDown2_A96C:
.byte 4
.byte -8,$32,OAMProp_Palette2,-8
.byte -8,$32,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$39,OAMProp_Palette2,-8
.byte 0,$39,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyVulnerable1_A97D:
.byte 4
.byte -8,$3C,OAMProp_Palette2,-8
.byte -8,$3C,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$3D,OAMProp_Palette2,-8
.byte 0,$3D,OAMProp_XFlip|OAMProp_Palette2,0

EntityGFXData_PinkyVulnerable2_A98E:
.byte 4
.byte -8,$3C,OAMProp_Palette2,-8
.byte -8,$3C,OAMProp_XFlip|OAMProp_Palette2,0
.byte 0,$3E,OAMProp_Palette2,-8
.byte 0,$3E,OAMProp_XFlip|OAMProp_Palette2,0