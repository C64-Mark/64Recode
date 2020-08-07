; Initialise game variables and settings
Initialise_Game
        lda #$18
        sta VMCR                        ; chars @2000, screen @0400
        lda VCR2
        ora #$10
        sta VCR2                        ; switch on character multicolour mode

        lda #RED
        sta BGCOL1                      ; char multicolour 1 = red
        lda #YELLOW
        sta BGCOL2                      ; char multicolour 2 = yellow
        lda #BLACK
        sta BGCOL0
        sta BDCOL                       ; background and border = black

        lda #RED
        sta SPRMC0                      ; sprite multicolour 0 = red
        lda #YELLOW
        sta SPRMC1                      ; sprite multicolour 1 = yellow

        lda #$4B
        sta SPRX0                       ; set ship starting X to 75
        lda #$00
        sta SPRXMSB                     ; clear sprite MSB
        sta SPRMCS                      ; switch off sprite multicolour mode
        lda #$64
        sta SPRY0                       ; set ship starting Y to 100
        lda #PURPLE
        sta SPRCOL0                     ; set ship colour to purple
        lda #$0F
        sta SIDVOL                      ; set volume to 15

        lda #$00
        sta verticalVelocity            ; reset vertical and horizontal
        sta horizontalVelocity          ; velocity variables. Both are 2 byte
        sta verticalVelocity+1          ; fields representing fraction and
        sta horizontalVelocity+1        ; whole number

        lda #SPRITE_SHIP
        sta SPRPTR0                     ; sprite 0 pointer = ship sprite
        lda #$01
        sta SPREN                       ; enable sprite 0
        lda #$0E
        sta towerY                      ; initialise tower Y position
        lda #TOWER_DELAY
        sta towerCounter                ; set the tower change delay
        lda #FALSE
        sta laserEnabled                ; switch off the laster
        sta soundInit                   ; clear sound initialise flag
        sta gameOver                    ; clear the game over flag

        lda SPRCBG                      ; clear the sprite to background
        rts                             ; collision register


; Initialise voice 3 oscillator to act at pseudo random generator
Initialise_Rand
        lda #$FF
        sta FREL3
        sta FREH3                       ; voice 3 frequency hi/lo = 255
        lda #$80
        sta VCREG3                      ; voice 3 waveform = noise
        rts
