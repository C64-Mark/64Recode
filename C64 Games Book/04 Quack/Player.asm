; Game over routine
Player_GameOver
        jsr Sound_GameOver              ; play the game over sound
        lda #$00
        sta SPREN                       ; switch off all sprites
        jsr Screen_Clear                ; clear the screen
        ldx #$13
.DisplayGameOverTextLoop
        lda txtTimeUp,x                 ; display time up message in green
        sta SCREENRAM,x
        lda #GREEN
        sta COLOURRAM,x
        lda txtYouShot,x                ; display you shot 00 ducks in red
        sta SCREENRAM+$050,x
        lda #RED
        sta COLOURRAM+$050,x
        lda txtHitSpace,x               ; display hit space to restart in purple
        sta SCREENRAM+$0F0,x
        lda #PURPLE
        sta COLOURRAM+$0F0,x
        dex
        bpl .DisplayGameOverTextLoop

        ldx ducks
        beq .GetKey                     ; if no ducks were hit skip this bit
        cpx #$06
        bcc .CountDucksLoop             ; if less than 6 ducks hit, skip to
        ldy #$09                        ; duck count
.DisplayWellDoneLoop
        lda txtWellDone,y               ; display well done in white
        sta SCREENRAM+$078,y
        lda #WHITE
        sta COLOURRAM+$078,y
        dey
        bpl .DisplayWellDoneLoop

.CountDucksLoop
        inc SCREENRAM+$05A              ; increment the lower digit of the duck
        lda SCREENRAM+$05A              ; hot count
        cmp #$3A                        ; check if we've gone over 9
        bne .CountNextDuck
        lda #$30                        ; we have to set back to zero
        sta SCREENRAM+$05A
        inc SCREENRAM+$059              ; and increment the upper digit
.CountNextDuck
        dex
        bne .CountDucksLoop             ; loop until all ducks have been counted
.GetKey
        lda SYSKEYPRESS
        cmp #$3C                        ; wait until space bar is pressed
        bne .GetKey
        rts
