*=$0801

        byte    $0E, $08, $0A, $00, $9E, $20, $28
        byte    $32, $30, $36, $34, $29, $00, $00, $00

Start
        jsr Initialisation

GameLoop
        LIBSCREEN_WAIT_V #$FF

        jsr Update_TimeScore
        jsr Get_Keys
        jsr Move_Arrow
        jsr Position_Sprites
        jsr Check_Collision
        jsr Move_Ducks
        lda gameOver
        bne EndGame
        jmp GameLoop
EndGame
        ;200 poke 54276,0:poke 54276,17:for i=240 to 1step-3:poke 54273,i:next:poke 54273,0
        LIBSPRITE_ENABLE_VV %00111111, False
        LIBSCREEN_SET1000_AV SCREENRAM, space
        LIBSCREEN_WRITE_VAA #16, endgame1, $0400
        LIBSCREEN_TEXTCOLOUR_VVA #16, green, $D800
        LIBSCREEN_WRITE_VAA #17, endgame2, $0450
        LIBSCREEN_DISPLAY_BCD_VA ducks, $045A
        LIBSCREEN_TEXTCOLOUR_VVA #17, red, $D850
        lda score
        cmp #$50
        bcc AnotherGo
        LIBSCREEN_WRITE_VAA #12, endgame3, $0478
        LIBSCREEN_TEXTCOLOUR_VVA #12, white, $D878
AnotherGo
        LIBSCREEN_WRITE_VAA #23, endgame4, $04F0
        LIBSCREEN_TEXTCOLOUR_VVA #23, purple, $D8F0
GetKey
        lda LASTKEY
        cmp charY
        beq Y
        cmp charN
        beq N
        jmp GetKey
Y
        jmp Start
N
        LIBSCREEN_SET1000_AV SCREENRAM, space
        lda #$00
        sta CURRKEY
        rts
