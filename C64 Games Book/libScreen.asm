;-------------------------------------------------------------------------------
;LIBSCREEN: Screen Libraries
;-------------------------------------------------------------------------------

;Sets 1000 bytes of memory from start address with a value
defm 	LIBSCREEN_SET1000_AV ;Address, Character

        lda #/2
        ldx #250
@loop   dex
        sta /1,x
        sta /1+250,x
        sta /1+500,x
        sta /1+750,x
        bne @loop

        endm

;Set border and background colours
defm 	LIBSCREEN_SETCOLOURS_VVVVV ;Border, Background0, Background1, Backgroung2, Background3

        lda #/1
        sta BDCOL
        lda #/2
        sta BGCOL0
        lda #/3
        sta BGCOL1
        lda #/4
        sta BGCOL2
        lda #/5
        sta BGCOL3

        endm

;Set video modes
defm 	LIBSCREEN_SETVIC_AV ;VICRegister, Mode

        lda /1
        ora #/2
        sta /1

        endm

;Write text to a location on the screen
defm 	LIBSCREEN_WRITE_VAA ;Length, Text, Target

        ldy #/1
@loop   dey
        lda /2,y
        sta /3,y
        cpy #$00
        bne @loop

        endm

;Write a single char repeatedly to the screen
defm 	LIBSCREEN_WRITECHAR_VVA ;Length, Character, Target

        ldy #/1
@loop   dey
        lda #/2
        sta /3,y
        cpy #$00
        bne @loop

        endm

;Set the colour of text on the screen
defm 	LIBSCREEN_TEXTCOLOUR_VVA ;Length, Colour, Target

        ldy #/1
@loop   dey
        lda #/2
        sta /3,y
        cpy #$00
        bne @loop

        endm

;Wait for given raster line
defm 	LIBSCREEN_WAIT_V ;Line

@loop   lda #/1
        cmp RASTER
        bne @loop

        endm

;Convert a BCD value to consecutive screen code values
defm 	LIBSCREEN_DISPLAY_BCD_VA ;Value, Target

        ;low bytes
        lda /1
        sed
        and #$0F
        cld
        clc
        adc #$30
        sta /2
        ;high bytes
        lda /1
        sed
        lsr
        lsr
        lsr
        lsr
        and #$0F
        cld
        clc
        adc #$30
        sta /2-1

        endm
        
defm    LIBSCREEN_VERTICALCHAR_VVVAA ;character, colour, length, screen address, colour address

        lda #</4
        sta zpLow
        lda #>/4
        sta zpHigh
        lda #</5
        sta zpLow2
        lda #>/5
        sta zpHigh2
        ldx #/3
@loop   ldy #$00
        lda #/1
        sta (zpLow),y
        lda #/2
        sta (zpLow2),y
        clc
        lda zpLow
        adc #40
        sta zpLow
        lda zpHigh
        adc #0
        sta zpHigh
        clc
        lda zpLow2
        adc #40
        sta zpLow2
        lda zpHigh2
        adc #0
        sta zpHigh2
        dex
        bne @loop

        endm