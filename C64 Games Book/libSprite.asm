;-------------------------------------------------------------------------------
;LIBSPRITE: Sprite Libraries
;-------------------------------------------------------------------------------

;Sprite enable/disable
defm    LIBSPRITE_ENABLE_VV ;SpriteNumber, True/False

        lda #/1
        ldy #/2
        beq @disable
@enable
        ora SPREN
        sta SPREN
        jmp @done 
@disable
        eor #$FF
        and SPREN
        sta SPREN
@done
        endm

;Sprite multi-colour set
defm    LIBSPRITE_SETMULTICOLORS_VV ;Colour0, Colour1

        lda #/1
        sta SPRMC0
        lda #/2
        sta SPRMC1

        endm

defm    LIBSPRITE_SETPOINTER_VV ;SpriteNumber, Value

        lda #/2
        sta SPRPTR0 + /1
        
        endm

defm    LIBSPRITE_SETCOLOUR_VV ;SpriteNumber, Value

        lda #/2
        sta SPRCOL0 + /1
        
        endm

defm    LIBSPRITE_EXPAND_VV ;X-expand, Y-expand

        lda #/1
        sta SPRXEX
        lda #/2
        sta SPRYEX
        
        endm
        
defm    LIBSPRITE_SETPOSITION_VAA ;SpriteNumber, X Source, Y Source

        lda #/1
        asl
        tay
        lda /2
        sta SPRX0,y
        lda /3
        sta SPRY0,y
        
        endm