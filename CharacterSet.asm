;converts standard utf-8 charset into the one used by this game

;dash
.CHARMAP $2D,$5C

;apostrophe
.CHARMAP $27,$3B

;exclamation mark!
.CHARMAP $21,$3D

CopyrightSymbol = $90                                       ;can't use this character as part of the string, because it's two bytes instead of one for some reason???