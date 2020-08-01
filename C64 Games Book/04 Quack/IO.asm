SYSKEYPRESS             = $C5

SCREENRAM               = $0400
SPRPTR0                 = $07F8 ;Sprite 0 pointer
SPRPTR1                 = $07F9 ;Sprite 1 pointer
SPRPTR2                 = $07FA ;Sprite 1 pointer

; VIC REGISTERS
SPRX0                   = $D000 ;Sprite 0 x-position
SPRY0                   = $D001 ;Sprite 0 y-position
SPRX1                   = $D002 ;Sprite 1 x-position
SPRY1                   = $D003 ;Sprite 1 y-position
SPRX2                   = $D004 ;Sprite 2 x-position
SPRY2                   = $D005 ;Sprite 2 y-position
RASTER                  = $D012 ;Current raster position
SPREN                   = $D015 ;Sprite enable
SPRXEX                  = $D01D ;Sprite X horizontal expand
SPRCSP                  = $D01E ;Sprite to sprite collision register
BDCOL                   = $D020 ;Border colour
BGCOL0                  = $D021 ;Background colour
SPRCOL0                 = $D027 ;Sprite 0 colour

; SID REGISTERS
FREH1                   = $D401 ;V1 frequency high-byte
VCREG1                  = $D404 ;V1 control register
SUREL1                  = $D406 ;V1 sustain/release
SIDVOL                  = $D418 ;Volume

COLOURRAM               = $D800

TODS                    = $DC09 ;time of day: seconds
TODM                    = $DC0A ;time of day: minutes