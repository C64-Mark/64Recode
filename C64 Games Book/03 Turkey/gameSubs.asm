;*** SUBROUTINES ***
Initialise
        ;clear screen, set background & border colour
        LIBSCREEN_SET1000_AV SCREENRAM, space
        LIBGENERAL_INITRAND
        LIBSCREEN_SETCOLOURS_VVVVV brown, black, black, black, black

        ;initialise position of waiter and turkey
        lda #150
        sta waiterX
        sta turkeyX
        lda #185
        sta turkeyY
        lda #200
        sta waiterY

        ;zero score and set lives to 3
        lda #$00
        sta score
        sta score+1
        lda #$03
        sta lives

        ;set direction deltas (+ve=right,down;-ve=left,up)
        jsr Create_X_Delta
        lda #$FE
        sta yDelta

        ;enable sprites and set pointers
        LIBSPRITE_ENABLE_VV %00000011, true
        LIBSPRITE_SETPOINTER_VV 0, #13
        LIBSPRITE_SETPOINTER_VV 1, #14

        ;set sprite positions
        LIBSPRITE_SETPOSITION_VAA 0, waiterX, waiterY
        LIBSPRITE_SETPOSITION_VAA 1, turkeyX, turkeyY

        ;set title at top of screen
        LIBSCREEN_WRITE_VAA #34, title, SCREENRAM
        LIBSCREEN_TEXTCOLOUR_VVA #34, white, COLOURRAM
        LIBSCREEN_TEXTCOLOUR_VVA #06, blue, COLOURRAM+15
        LIBSCREEN_TEXTCOLOUR_VVA #06, blue, COLOURRAM+27

        ;set the game border on the screen
        LIBSCREEN_WRITECHAR_VVA #25, #86, $0455
        LIBSCREEN_TEXTCOLOUR_VVA #25, green, $D855
        LIBSCREEN_VERTICALCHAR_VVVAA #86, green, #20, $0455, $D855
        LIBSCREEN_VERTICALCHAR_VVVAA #86, green, #20, $046E, $D86E
        rts

Create_X_Delta
        lda SIDRAND
        cmp #$09
        bcs Create_X_Delta
        sec
        sbc #$04
        sta xDelta
        eor #$FF
        clc
        adc #$01
        sta xChange
        rts

Score_Update
        LIBSCREEN_DISPLAY_BCD_VA Score, $0418
        LIBSCREEN_DISPLAY_BCD_VA Score+1, $0416
        LIBMATHS_ADD_8BIT_AVA lives, #$30, $0421
        rts

Get_Keys
        lda LASTKEY
        cmp charZ
        beq Left
        cmp charM
        beq Right
        rts
Left    
        LIBMATHS_SUBTRACT_8BIT_AVA waiterX, #$02, waiterX
        jmp Exit_Get_Keys
Right   
        LIBMATHS_ADD_8BIT_AVA waiterX, #$02, waiterX
Exit_Get_Keys
        rts

Update_Waiter
        lda waiterX
        cmp #70
        bcs ChkRght
        lda #70
        sta waiterX
ChkRght cmp #240
        bcc MoveW
        lda #240
        sta waiterX
MoveW   sta SPRX0
        rts

Update_Turkey
        lda yDelta
        bmi TurkeyUp
        LIBMATHS_ADD_8BIT_AVA turkeyY, #$01, turkeyY
        jmp CheckX
TurkeyUp
        LIBMATHS_SUBTRACT_8BIT_AVA turkeyY, #$01, turkeyY
CheckX
        lda xDelta
        bmi TurkeyLeft
        LIBMATHS_ADD_8BIT_AAA turkeyX, xChange, turkeyX
        jmp CheckCeiling
TurkeyLeft
        LIBMATHS_SUBTRACT_8BIT_AAA turkeyx, xChange, turkeyX
CheckCeiling
        lda turkeyY
        cmp #70
        bcs CheckFloor
        lda #$01
        sta yDelta
        jsr Create_X_Delta
        BCD_ADD_8BIT_AVA Score, #$01, Score
        jmp MoveT
CheckFloor
        lda turkeyY
        cmp #220
        bcc CheckLeft
        lda waiterX
        sta turkeyX
        lda #185
        sta turkeyY
        lda #$FE
        sta yDelta
        dec lives
        jsr Create_X_Delta
        jmp MoveT
CheckLeft
        lda turkeyX
        cmp #70
        bcs CheckRight
        lda #70
        sta turkeyX
        jmp ChangeXd
CheckRight
        cmp #240
        bcc MoveT
        lda #240
        sta turkeyX
ChangeXd
        LIBMATHS_TWOS_COMPLEMENT_AA xDelta, xDelta
MoveT
        LIBSPRITE_SETPOSITION_VAA 1, turkeyX, turkeyY
        rts

Collision_Detection
        LIBMATHS_ADD_8BIT_AVA turkeyY, #20, turkeyYLB
        LIBMATHS_ADD_8BIT_AVA turkeyX, #2, turkeyXLB
        LIBMATHS_ADD_8BIT_AVA turkeyXLB, #20, turkeyXUB
        LIBMATHS_ADD_8BIT_AVA waiterX, #5, waiterXLB
        LIBMATHS_ADD_8BIT_AVA waiterxLB, #15, waiterXUB
        lda turkeyYLB
        cmp #207
        bne Exit_Collision
        lda turkeyXUB
        cmp waiterXLB
        bcc Exit_Collision
        lda turkeyXLB
        cmp waiterXUB
        bcs Exit_Collision
        lda #$FE
        sta yDelta
        jsr Create_X_Delta
        BCD_ADD_8BIT_AVA Score, #$02, Score
Exit_Collision
        rts
