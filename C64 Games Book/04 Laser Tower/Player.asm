; Game over routine for landed and died
Player_GameOver
        lda gameOver
        cmp #$01
        bne .Death                      ; if game over = 2 then death routine
        jsr Screen_Clear                ; clear the screen
        ldx #$09
.WellDoneLoop
        lda txtWellDone,x               ; display well done message
        sta SCREENRAM+$0AF,x
        lda #PURPLE                     ; in purple
        sta COLOURRAM+$0AF,x
        dex
        bpl .WellDoneLoop

        ldx #$10
.EscapedAliveLoop
        lda txtEscapedAlive,x           ; display 'you escaped alive'
        sta SCREENRAM+$121,x            ; message in purple
        lda #PURPLE
        sta COLOURRAM+$121,x
        dex
        bpl .EscapedAliveLoop
        jmp .PressSpaceToRestart
.Death
        lda #SPRITE_EXPLOSION           ; death routine, switch sprite 0
        sta SPRPTR0                     ; to the explosion sprite
        lda #$01                        ; and switch on multicolour mode
        sta SPRMCS
        jsr Sound_Explosion             ; make explosion sound
        
        ldx #$00
        ldy #$00
.WaitLoop
        dey
        bne .WaitLoop
        dex
        bne .WaitLoop                   ; delay
        
        jsr Screen_Clear                ; clear screen
        ldx #$09
.HardLinesLoop
        lda txtHardLines,x              ; display 'hard lines' text     
        sta SCREENRAM+$0A6,x
        lda #PURPLE                     ; in purple
        sta COLOURRAM+$0A6,x
        dex
        bpl .HardLinesLoop

.PressSpaceToRestart
        lda #$00
        sta SPREN                       ; switch off sprites
        sta VCREG1                      ; switch off voice 1

        ldx #$15
.PressSpaceLoop
        lda txtPressSpace,x             ; display 'press space to restart'
        sta SCREENRAM+$190,x
        lda #PURPLE                     ; text in purple
        sta COLOURRAM+$190,x
        dex
        bpl .PressSpaceLoop

.WaitKey
        lda SYSKEYPRESS
        cmp #KEY_SPACE                  ; wait until space is pressed
        bne .WaitKey
        rts
