SYSKEYPRESS             = $C5

SCREENRAM               = $0400
SPRPTR0                 = $07F8 ;Sprite 0 pointer
SPRPTR1                 = $07F9 ;Sprite 1 pointer

; VIC REGISTERS
SPRX0                   = $D000 ;Sprite 0 x-position
SPRY0                   = $D001 ;Sprite 0 y-position
SPRX1                   = $D002 ;Sprite 1 x-position
SPRY1                   = $D003 ;Sprite 1 y-position
RASTER                  = $D012 ;Current raster position
SPREN                   = $D015 ;Sprite enable
BDCOL                   = $D020 ;Border colour
BGCOL0                  = $D021 ;Background colour
SPRCOL0                 = $D027 ;Sprite 0 colour
SPRCOL1                 = $D028 ;Sprite 1 colour

; SID REGISTERS
FREL3                   = $D40E ;V3 frequency low-byte
FREH3                   = $D40F ;V3 frequency high-byte
VCREG3                  = $D412 ;V3 control register
SIDRAND                 = $D41B ;Oscillator 3 random number generator

COLOURRAM               = $D800