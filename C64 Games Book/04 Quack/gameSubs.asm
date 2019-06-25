;Subroutines

;initialisation
Initialisation
        lda #$10
        sta arrows
        lda #$00
        sta score
        lda #$0F
        sta SIDVOL
        lda #$F0
        sta SUREL1
        lda #$03
        sta VCREG1
        LIBSCREEN_SET1000_AV SCREENRAM, space
        LIBSCREEN_SETCOLOURS_VVVVV black, black, black, black, black
        LIBSPRITE_ENABLE_VV %00111111, True
        LIBSPRITE_SETPOINTER_VV 0, #192
        LIBSPRITE_SETPOINTER_VV 1, #193
        LIBSPRITE_SETPOINTER_VV 2, #194
        LIBSPRITE_SETPOINTER_VV 3, #194
        LIBSPRITE_SETPOINTER_VV 4, #194
        LIBSPRITE_SETPOINTER_VV 5, #194
        LIBSPRITE_SETCOLOUR_VV 0, orange
        LIBSPRITE_SETCOLOUR_VV 1, white
        LIBSPRITE_SETCOLOUR_VV 2, blue
        LIBSPRITE_SETCOLOUR_VV 3, green
        LIBSPRITE_SETCOLOUR_VV 4, purple
        LIBSPRITE_SETCOLOUR_VV 5, cyan
        LIBSPRITE_EXPAND_VV %00000001, #0
        lda #120
        sta bowX
        lda #220
        sta bowY
        lda #132
        sta arrowX
        lda #217
        sta arrowY
        ldy #$00
        lda #40
PosDucks
        sta ducksX,y
        tax
        lda #90
        sta ducksY,y
        txa
        clc
        adc #40
        iny
        cpy #$04
        bne PosDucks
        LIBSCREEN_VERTICALCHAR_VVVAA #160, #4, #23, $0450, $D850
        LIBSCREEN_VERTICALCHAR_VVVAA #160, #4, #23, $0470, $D870
        LIBSCREEN_WRITECHAR_VVA #33, #160, $0428
        LIBSCREEN_TEXTCOLOUR_VVA #$33, purple, $D828
        LIBSCREEN_WRITE_VAA #$27, title, $0400
        LIBSCREEN_TEXTCOLOUR_VVA #$27, red, $D800
        LIBSCREEN_TEXTCOLOUR_VVA #$05, green, $D811
        LIBSCREEN_WRITE_VAA #$04, timeTxt, $0472
        LIBSCREEN_WRITE_VAA #$05, scoreTxt, $0512
        LIBSCREEN_WRITE_VAA #$06, arrowsTxt, $05B2
        LIBSCREEN_TEXTCOLOUR_VVA #$04, white, $D872
        LIBSCREEN_TEXTCOLOUR_VVA #$05, white, $D912
        LIBSCREEN_TEXTCOLOUR_VVA #$06, white, $D9B2
        LIBGENERAL_INITTODCLOCK
        sta gameOver
        rts

;update time, score and arrows left on screen
Update_TimeScore
        LIBSCREEN_DISPLAY_BCD_VA $DC09, $049B
        LIBSCREEN_DISPLAY_BCD_VA arrows, $05DB
        LIBSCREEN_DISPLAY_BCD_VA score+1, $053B
        LIBSCREEN_DISPLAY_BCD_VA score, $053D
        lda TODM
        sta gameOver
        rts

;get user input
Get_Keys
        lda LASTKEY
        cmp charNone
        beq Exit_Get_Keys
        cmp charZ
        beq Left
        cmp charC
        beq Right
        cmp charM
        beq Fire
        rts
Left    
        lda bowX
        cmp #33
        bcc Exit_Get_Keys
        LIBMATHS_SUBTRACT_8BIT_AVA bowX, #$02, bowX
        lda arrowEnabled
        cmp #$00
        bne Exit_Get_Keys
        LIBMATHS_SUBTRACT_8BIT_AVA arrowX, #$02, arrowX
        rts
Right
        lda bowX
        cmp #236
        bcs Exit_Get_Keys
        LIBMATHS_ADD_8BIT_AVA bowX, #$02, bowX
        lda arrowEnabled
        cmp #$00
        bne Exit_Get_Keys
        LIBMATHS_ADD_8BIT_AVA arrowX, #$02, arrowX
        rts
Fire
        lda arrowEnabled
        cmp #$00
        bne Exit_Get_Keys
        lda arrows
        cmp #$00
        beq Exit_Get_Keys
        lda #$01
        sta arrowEnabled
        LIBMATHS_BCD_SUBTRACT_8BIT_AVA arrows, #$01, arrows
        ;300 poke 54276,0:poke 54276,129:for i=1 to 80 step 2:poke 54273,i:next:poke 54273,0
Exit_Get_Keys
        rts

;move the arrow if enabled
Move_Arrow
        lda arrowEnabled
        cmp #$00
        beq Exit_Move_Arrow
        dec arrowY
        lda arrowY
        cmp #65
        bcs Exit_Move_Arrow
        lda #217
        sta arrowY
        lda #$00
        sta arrowEnabled
        LIBMATHS_ADD_8BIT_AVA bowX, #12, arrowX
Exit_Move_Arrow
        rts

;update the ducks, bow and arrow on screen
Position_Sprites
        LIBSPRITE_SETPOSITION_VAA 0, bowX, bowY
        LIBSPRITE_SETPOSITION_VAA 1, arrowX, arrowY
        LIBSPRITE_SETPOSITION_VAA 2, ducksX, ducksY
        LIBSPRITE_SETPOSITION_VAA 3, ducksX+1, ducksY+1
        LIBSPRITE_SETPOSITION_VAA 4, ducksX+2, ducksY+2
        LIBSPRITE_SETPOSITION_VAA 5, ducksX+3, ducksY+3
        rts

;Collision detection
Check_Collision
        lda SPRCSP
        tax
        cmp #$04
        bcc Exit_Check_Collision
        lda arrowY
        cmp #95
        bne Exit_Check_Collision
        LIBMATHS_BCD_ADD_16BIT_AVA score, #10, score
        LIBMATHS_BCD_ADD_8BIT_AVA ducks, #01, ducks
        txa
        lsr
        lsr
        cmp #$01
        bne Duck2
        LIBSPRITE_SETPOINTER_VV 2, #195
        jmp RemoveArrow
Duck2
        cmp #$02
        bne Duck3
        LIBSPRITE_SETPOINTER_VV 3, #195
        jmp RemoveArrow
Duck3
        cmp #$04
        bne Duck4
        LIBSPRITE_SETPOINTER_VV 4, #195
        jmp RemoveArrow
Duck4
        cmp #$08
        bne RemoveArrow
        LIBSPRITE_SETPOINTER_VV 5, #195
RemoveArrow
        lda #$00
        sta arrowEnabled
        lda #218
        sta arrowY
        LIBMATHS_ADD_8BIT_AVA bowX, #12, arrowX
        ;120 poke 54276,0:poke 54276,33
        ;125 for i=15 to 1 step -.5:poke 54273,i*2:poke 54296,i:next:poke 54296,15:poke 54273,0
Exit_Check_Collision
        rts

;move ducks
Move_Ducks
        ldy #$04
DucksRight
        dey
        clc
        lda ducksX,y
        adc #$01
        cmp #255
        bcc UpdateDuck
        lda #194
        sta SPRPTR0+2,y
        lda #35
UpdateDuck
        sta ducksX,y
        cpy #$00
        bne DucksRight
        rts