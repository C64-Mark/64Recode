Initialise_Game
        lda #BLACK                      ; set background and border to black
        sta BDCOL
        sta BGCOL0

        lda #$0F                        ; initialise SID volume, & voice 1
        sta SIDVOL                      ; lower frequency. Switch voice off
        lda #$F0
        sta SUREL1
        lda #$00
        sta VCREG1

        lda #$0A                        ; start with 10 arrows
        sta arrows              
        lda #$00                        ; init game variables
        sta score
        sta score+1
        sta arrowEnabled
        sta soundInit
        sta soundSelected
        sta gameOver
        sta ducks
        sta TODM                        ; system time of day minutes & seconds
        sta TODS
        
        ldx #120                        ; initialise sprite positions
        ldy #220                        ; bow has a fixed Y so no variable
        stx bowX                        ; required
        stx arrowX
        sty SPRY0
        ldy #217
        sty arrowY

        lda #$5A                        ; ducks have fixed Y positions so
        sta SPRY2                       ; no variable required
        sta SPRY2+2
        sta SPRY2+4
        sta SPRY2+6

        lda #$28                        ; loop to set duck X positions
        ldy #$03
.SetDucksXYLoop
        sta ducksX,y
        clc
        adc #$28                        ; ducks are 40 pixels apart
        dey
        bpl .SetDucksXYLoop

        ldy #SPRITE_BOW                 ; set sprite pointers
        sty SPRPTR0
        iny                             ; bow, arrow, duck
        sty SPRPTR0+1
        iny
        sty SPRPTR0+2
        sty SPRPTR0+3
        sty SPRPTR0+4
        sty SPRPTR0+5

        lda #ORANGE                     ; bow is orange
        sta SPRCOL0
        lda #WHITE                      ; arrow is white
        sta SPRCOL0+1
        lda #BLUE                       ; ducks are blue, green, purple, cyan
        sta SPRCOL0+2
        lda #GREEN
        sta SPRCOL0+3
        lda #PURPLE
        sta SPRCOL0+4
        lda #CYAN
        sta SPRCOL0+5
        lda #%00000001                  ; expand the bow in the X direction
        sta SPRXEX
        lda #%00111111                  ; enable sprite 0 to sprite 5
        sta SPREN
        lda SPRCSP                      ; clear the sprite to sprite collision
        rts                             ; register

