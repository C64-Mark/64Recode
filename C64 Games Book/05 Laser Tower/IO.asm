SYSKEYPRESS             = $C5   ;Kernal keypress location

; SCREEN
SCREENRAM               = $0400 ;Start of screen ram
SCNROW23                = $0798 ;Screen row 23 start
SCNROW24                = $07C0 ;Screen row 24 start
SPRPTR0                 = $07F8 ;Sprite 0 pointer

; VIC REGISTERS
SPRX0                   = $D000 ;Sprite 0 x-position
SPRY0                   = $D001 ;Sprite 0 y-position
SPRXMSB                 = $D010 ;Sprite x most significant bit
RASTER                  = $D012 ;Current raster position
SPREN                   = $D015 ;Sprite enable
VCR2                    = $D016 ;VIC Control Register 2
VMCR                    = $D018 ;VIC Memory Control Register
SPRMCS                  = $D01C ;Sprite multi-colour select
SPRCBG                  = $D01F ;Sprite to background collision
BDCOL                   = $D020 ;Border colour
BGCOL0                  = $D021 ;Background colour
BGCOL1                  = $D022 ;Screen background colour 2
BGCOL2                  = $D023 ;Screen background colour 3
SPRMC0                  = $D025 ;Sprite multi-colour register 1
SPRMC1                  = $D026 ;Sprite multi-colour register 2
SPRCOL0                 = $D027 ;Sprite 0 colour

; SID REGISTERS
FREL1                   = $D400 ;V1 frequency low-byte
FREH1                   = $D401 ;V1 frequency high-byte
PWL1                    = $D402 ;V1 pulse width low-byte
PWH1                    = $D403 ;V1 pulse width high-byte
VCREG1                  = $D404 ;V1 control register
ATDCY1                  = $D405 ;V1 attack/decay
SUREL1                  = $D406 ;V1 sustain/release
FREL3                   = $D40E ;V3 frequency low-byte
FREH3                   = $D40F ;V3 frequency high-byte
VCREG3                  = $D412 ;V3 control register
SIDVOL                  = $D418 ;Volume
SIDRAND                 = $D41B ;Oscillator 3 random number generator

; COLOUR
COLOURRAM               = $D800 ;Start of colour ram
COLROW23                = $DB98 ;Colour row 23 start
COLROW24                = $DBC0 ;Colour row 24 start
