Player_LoseLife
        dec lifeLostFlag                ; set the live lost flag back to zero
        lda #$96                        ; reset the tukey and waiter X & Y
        sta waiterX                     ; positions
        sta turkeyX
        sta SPRX0
        sta SPRX1
        lda #$B9
        sta turkeyY
        sta SPRY1
        lda #$FE                        ; turkey direction set back to 'up'
        sta yDelta
        jsr Objects_RandomiseXDelta     ; re-randomise the X delta
        dec lives
        lda lives                       ; remove a life and if no lives left
        beq .GameOver                   ; go to the game over routine
        ora #$30
        sta SCREENRAM+$021              ; update lives on screen and return
        rts
.GameOver
        lda #$00                        ; switch the sprites off
        sta SPREN
        lda #$30                        ; set lives to 0 on screen
        sta SCREENRAM+$021              
        ldx #22
.DisplayGameOverTextLoop                ; display the game over message
        lda txtGameOver,x
        sta SCREENRAM+$0146,x
        lda txtTryAgain,x
        sta SCREENRAM+$0196,x
        lda #GREEN
        sta COLOURRAM+$0146,x
        sta COLOURRAM+$0196,x
        dex
        bpl .DisplayGameOverTextLoop

.WaitKey
        lda SYSKEYPRESS                 ; wait until the user presses the 
        cmp #KEY_SPACE                  ; space bar
        bne .WaitKey

        jsr Screen_Clear                ; set up the game again by redrawing
        jsr Screen_DrawGameScreen       ; the screen
        lda #%00000011
        sta SPREN                       ; switch sprite 0 and 1 back on
        lda #$00                        ; reset score
        sta points
        sta score
        sta score+1
        lda #$03                        ; set lives back to 3 
        sta lives                       
        rts

