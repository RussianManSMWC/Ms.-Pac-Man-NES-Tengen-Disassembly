;GRAPHICS DATA
EntityGFXPointers_PlayableCharacters_A3E7:

;Ms Pac-Man moving horizontally
.word EntityGFXData_MsPacManHorizontal1_A4FA
.word EntityGFXData_MsPacManHorizontal2_A50B
.word EntityGFXData_MsPacManHorizontal1_A4FA
.word EntityGFXData_MsPacManHorizontal3_A51C

;Ms Pac-Man moving vertically
.word EntityGFXData_MsPacManVertical1_A52D
.word EntityGFXData_MsPacManVertical2_A53E
.word EntityGFXData_MsPacManVertical1_A52D
.word EntityGFXData_MsPacManVertical3_A54F

;Ms Pac-Man moving horizontally with Pac Booster
.word EntityGFXData_MsPacManHorizontal1WithPacBooster_A560
.word EntityGFXData_MsPacManHorizontal2WithPacBooster_A571
.word EntityGFXData_MsPacManHorizontal1WithPacBooster_A560
.word EntityGFXData_MsPacManHorizontal3WithPacBooster_A582

;Ms Pac-Man moving vertically with Pac Booster
.word EntityGFXData_MsPacManVertical1WithPacBooster_A593
.word EntityGFXData_MsPacManVertical2WithPacBooster_A5A4
.word EntityGFXData_MsPacManVertical1WithPacBooster_A593
.word EntityGFXData_MsPacManVertical3WithPacBooster_A5B5

;Pac-Man moving horizontally
.word EntityGFXData_PacManHorizontal1_A5C6
.word EntityGFXData_PacManHorizontal2_A5D7
.word EntityGFXData_PacManHorizontal1_A5C6
.word EntityGFXData_PacManHorizontalAndVertical3_A5E8

;Pac-Man moving vertically
.word EntityGFXData_PacManVertical1_A5F9
.word EntityGFXData_PacManVertical2_A60A
.word EntityGFXData_PacManVertical1_A5F9
.word EntityGFXData_PacManHorizontalAndVertical3_A5E8

;Pac-Man moving horizontally with Pac Booster
.word EntityGFXData_PacManHorizontal1WithPacBooster_A61B
.word EntityGFXData_PacManHorizontal2WithPacBooster_A62C
.word EntityGFXData_PacManHorizontal1WithPacBooster_A61B
.word EntityGFXData_PacManHorizontal3WithPacBooster_A63D

;Pac-Man moving vertically with Pac Booster
.word EntityGFXData_PacManVertical1WithPacBooster_A64E
.word EntityGFXData_PacManVertical2WithPacBooster_A65F
.word EntityGFXData_PacManVertical1WithPacBooster_A64E
.word EntityGFXData_PacManVertical3WithPacBooster_A670

;I think this is used when the player dies and resurrects after a while
.word EntityGFXData_DrawNothing_AD4C

;Pac-Man and Ms Pac-Man looking sad after the other player consumes a power pellet (2P Competitive)
.word EntityGFXData_MsPacManSad_A4E9
.word EntityGFXData_PacManSad_A4D8

;Ms Pac-Man Act 4 Poses
.word EntityGFXData_MsPacManIntoSky1_A455
.word EntityGFXData_MsPacManIntoSky2_A466
.word EntityGFXData_MsPacManIntoSky3_A46B

;Pac-Man and Ms. Pac-Man were supposed to pop when they go into the background? These graphical pointers are unused.
.word UNUSED_A47A
.word UNUSED_A47F
.word EntityGFXData_DrawNothing_AD4C
.word EntityGFXData_DrawNothing_AD4C
.word EntityGFXData_DrawNothing_AD4C

;Pac-Man Act 4 Poses
.word EntityGFXData_PacManHorizontalAndVertical3_A5E8 ;basically PacManIntoSky1 2B
.word EntityGFXData_PacManIntoSky2_A470
.word EntityGFXData_PacManIntoSky3_A475

;See above
.word UNUSED_A47A
.word UNUSED_A47F
.word EntityGFXData_DrawNothing_AD4C
.word EntityGFXData_DrawNothing_AD4C
.word EntityGFXData_DrawNothing_AD4C

;Ms Pac-Man Waving (Act 4)
.word EntityGFXData_MsPacManWaving1_A484
.word EntityGFXData_MsPacManWaving2_A499

;Pac-Man Waving (Still act 4)
.word EntityGFXData_PacManWaving1_A4AE
.word EntityGFXData_PacManWaving2_A4C3

;cutscene frames for pac-man and ms.pacman

;These are specifically for act 4, where pac-man and ms. pac-man shoot into HEAVEN? And they DIE???? I don't know pac-man lore, sorry.
EntityGFXData_MsPacManIntoSky1_A455:
.byte 4
.byte -8,$E0,OAMProp_Palette0,-8
.byte -8,$E1,OAMProp_Palette0,0
.byte 0,$AA,OAMProp_Palette0,-8
.byte 0,$AB,OAMProp_Palette0,0

EntityGFXData_MsPacManIntoSky2_A466:
.byte 1
.byte -4,$E3,OAMProp_Palette0,-4

EntityGFXData_MsPacManIntoSky3_A46B:
.byte 1
.byte -4,$E5,OAMProp_Palette0,-4

EntityGFXData_PacManIntoSky2_A470:
.byte 1
.byte -4,$E2,OAMProp_Palette0,-4

EntityGFXData_PacManIntoSky3_A475:
.byte 1
.byte -4,$E4,OAMProp_Palette0,-4

;unknown dot graphic (pac-man and ms pac-man into sky 4?)
UNUSED_A47A:
.byte 1
.byte -4,$E7,OAMProp_Palette0,-4

;unknown pop graphic (pac-man and ms pac-man into sky 5?)
UNUSED_A47F:
.byte 1
.byte -4,$E6,OAMProp_Palette0,-4

EntityGFXData_MsPacManWaving1_A484:
.byte 5
.byte -8,$BC,OAMProp_Palette0,-8
.byte -8,$BD,OAMProp_Palette0,0
.byte 0,$9E,OAMProp_Palette0,-8
.byte 0,$9F,OAMProp_Palette0,0
.byte -8,$E8,OAMProp_XFlip|OAMProp_Palette2,-12

EntityGFXData_MsPacManWaving2_A499:
.byte 5
.byte -8,$BC,OAMProp_Palette0,-8
.byte -8,$BD,OAMProp_Palette0,0
.byte 0,$9E,OAMProp_Palette0,-8
.byte 0,$9F,OAMProp_Palette0,0
.byte -14,$E8,OAMProp_YFlip|OAMProp_XFlip|OAMProp_Palette2,-12

EntityGFXData_PacManWaving1_A4AE:
.byte 5
.byte -8,$B4,OAMProp_Palette0,-8
.byte -8,$B5,OAMProp_Palette0,0
.byte 0,$9E,OAMProp_Palette0,-8
.byte 0,$9F,OAMProp_Palette0,0
.byte -8,$E8,OAMProp_XFlip|OAMProp_Palette2,-12

EntityGFXData_PacManWaving2_A4C3:
.byte 5
.byte -8,$B4,OAMProp_Palette0,-8
.byte -8,$B5,OAMProp_Palette0,0
.byte 0,$9E,OAMProp_Palette0,-8
.byte 0,$9F,OAMProp_Palette0,0
.byte -14,$E8,OAMProp_YFlip|OAMProp_XFlip|OAMProp_Palette2,-12

;Ms Pac-Man got power pellet (2P Competitive)
EntityGFXData_PacManSad_A4D8:
.byte 4
.byte -8,$B4,OAMProp_Palette0,-8
.byte -8,$B5,OAMProp_Palette0,0
.byte 0,$B6,OAMProp_Palette0,-8
.byte 0,$B7,OAMProp_Palette0,0

EntityGFXData_MsPacManSad_A4E9:
.byte 4
.byte -8,$BC,OAMProp_Palette0,-8
.byte -8,$BD,OAMProp_Palette0,0
.byte 0,$B6,OAMProp_Palette0,-8
.byte 0,$B7,OAMProp_Palette0,0

EntityGFXData_MsPacManHorizontal1_A4FA:
.byte 4
.byte -8,$00,OAMProp_Palette0,-8
.byte -8,$01,OAMProp_Palette0,0
.byte 0,$02,OAMProp_Palette0,-8
.byte 0,$03,OAMProp_Palette0,0

EntityGFXData_MsPacManHorizontal2_A50B:
.byte 4
.byte -8,$04,OAMProp_Palette0,-8
.byte -8,$05,OAMProp_Palette0,0
.byte 0,$06,OAMProp_Palette0,-8
.byte 0,$07,OAMProp_Palette0,0

EntityGFXData_MsPacManHorizontal3_A51C:
.byte 4
.byte -8,$08,OAMProp_Palette0,-8
.byte -8,$09,OAMProp_Palette0,0
.byte 0,$0A,OAMProp_Palette0,-8
.byte 0,$0B,OAMProp_Palette0,0

EntityGFXData_MsPacManVertical1_A52D:
.byte 4
.byte -8,$10,OAMProp_Palette0,-8
.byte -8,$11,OAMProp_Palette0,0
.byte 0,$12,OAMProp_Palette0,-8
.byte 0,$13,OAMProp_Palette0,0

EntityGFXData_MsPacManVertical2_A53E:
.byte 4
.byte -8,$14,OAMProp_Palette0,-8
.byte -8,$15,OAMProp_Palette0,0
.byte 0,$16,OAMProp_Palette0,-8
.byte 0,$17,OAMProp_Palette0,0

EntityGFXData_MsPacManVertical3_A54F:
.byte 4
.byte -8,$18,OAMProp_Palette0,-8
.byte -8,$19,OAMProp_Palette0,0
.byte 0,$1A,OAMProp_Palette0,-8
.byte 0,$1B,OAMProp_Palette0,0

EntityGFXData_MsPacManHorizontal1WithPacBooster_A560:
.byte 4
.byte -8,$0C,OAMProp_Palette0,-8
.byte -8,$01,OAMProp_Palette0,0
.byte 0,$02,OAMProp_Palette0,-8
.byte 0,$03,OAMProp_Palette0,0

EntityGFXData_MsPacManHorizontal2WithPacBooster_A571:
.byte 4
.byte -8,$0D,OAMProp_Palette0,-8
.byte -8,$05,OAMProp_Palette0,0
.byte 0,$06,OAMProp_Palette0,-8
.byte 0,$07,OAMProp_Palette0,0

EntityGFXData_MsPacManHorizontal3WithPacBooster_A582:
.byte 4
.byte -8,$0E,OAMProp_Palette0,-8
.byte -8,$09,OAMProp_Palette0,0
.byte 0,$0A,OAMProp_Palette0,-8
.byte 0,$0B,OAMProp_Palette0,0

EntityGFXData_MsPacManVertical1WithPacBooster_A593:
.byte 4
.byte -8,$10,OAMProp_Palette0,-8
.byte -8,$1C,OAMProp_Palette0,0
.byte 0,$12,OAMProp_Palette0,-8
.byte 0,$13,OAMProp_Palette0,0

EntityGFXData_MsPacManVertical2WithPacBooster_A5A4:
.byte 4
.byte -8,$14,OAMProp_Palette0,-8
.byte -8,$1D,OAMProp_Palette0,0
.byte 0,$16,OAMProp_Palette0,-8
.byte 0,$17,OAMProp_Palette0,0

EntityGFXData_MsPacManVertical3WithPacBooster_A5B5:
.byte 4
.byte -8,$18,OAMProp_Palette0,-8
.byte -8,$1E,OAMProp_Palette0,0
.byte 0,$1A,OAMProp_Palette0,-8
.byte 0,$1B,OAMProp_Palette0,0

EntityGFXData_PacManHorizontal1_A5C6:
.byte 4
.byte -8,$A0,OAMProp_Palette0,-8
.byte -8,$A1,OAMProp_Palette0,0
.byte 0,$A2,OAMProp_Palette0,-8
.byte 0,$A3,OAMProp_Palette0,0

EntityGFXData_PacManHorizontal2_A5D7:
.byte 4
.byte -8,$A4,OAMProp_Palette0,-8
.byte -8,$A5,OAMProp_Palette0,0
.byte 0,$A6,OAMProp_Palette0,-8
.byte 0,$A7,OAMProp_Palette0,0

EntityGFXData_PacManHorizontalAndVertical3_A5E8:
.byte 4
.byte -8,$A8,OAMProp_Palette0,-8
.byte -8,$A9,OAMProp_Palette0,0
.byte 0,$AA,OAMProp_Palette0,-8
.byte 0,$AB,OAMProp_Palette0,0

EntityGFXData_PacManVertical1_A5F9:
.byte 4
.byte -8,$AC,OAMProp_Palette0,-8
.byte -8,$AD,OAMProp_Palette0,0
.byte 0,$AE,OAMProp_Palette0,-8
.byte 0,$AF,OAMProp_Palette0,0

EntityGFXData_PacManVertical2_A60A:
.byte 4
.byte -8,$B0,OAMProp_Palette0,-8
.byte -8,$B1,OAMProp_Palette0,0
.byte 0,$B2,OAMProp_Palette0,-8
.byte 0,$B3,OAMProp_Palette0,0

EntityGFXData_PacManHorizontal1WithPacBooster_A61B:
.byte 4
.byte -8,$B8,OAMProp_Palette0,-8
.byte -8,$A1,OAMProp_Palette0,0
.byte 0,$A2,OAMProp_Palette0,-8
.byte 0,$A3,OAMProp_Palette0,0

EntityGFXData_PacManHorizontal2WithPacBooster_A62C:
.byte 4
.byte -8,$B8,OAMProp_Palette0,-8
.byte -8,$A5,OAMProp_Palette0,0
.byte 0,$A6,OAMProp_Palette0,-8
.byte 0,$A7,OAMProp_Palette0,0

EntityGFXData_PacManHorizontal3WithPacBooster_A63D:
.byte 4
.byte -8,$B8,OAMProp_Palette0,-8
.byte -8,$A9,OAMProp_Palette0,0
.byte 0,$AA,OAMProp_Palette0,-8
.byte 0,$AB,OAMProp_Palette0,0

EntityGFXData_PacManVertical1WithPacBooster_A64E:
.byte 4
.byte -8,$AC,OAMProp_Palette0,-8
.byte -8,$B9,OAMProp_Palette0,0
.byte 0,$AE,OAMProp_Palette0,-8
.byte 0,$AF,OAMProp_Palette0,0

EntityGFXData_PacManVertical2WithPacBooster_A65F:
.byte 4
.byte -8,$B0,OAMProp_Palette0,-8
.byte -8,$BA,OAMProp_Palette0,0
.byte 0,$B2,OAMProp_Palette0,-8
.byte 0,$B3,OAMProp_Palette0,0

EntityGFXData_PacManVertical3WithPacBooster_A670:
.byte 4
.byte -8,$A8,OAMProp_Palette0,-8
.byte -8,$BA,OAMProp_Palette0,0
.byte 0,$AA,OAMProp_Palette0,-8
.byte 0,$AB,OAMProp_Palette0,0