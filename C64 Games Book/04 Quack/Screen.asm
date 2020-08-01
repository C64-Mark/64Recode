; Clear the screen
Screen_Clear
        lda #CHAR_SPACE
        ldx #$FA
.ClearScreenLoop
        dex
        sta SCREENRAM,x                 ; set 4 x 250 chars to the space
        sta SCREENRAM+$0FA,x            ; char
        sta SCREENRAM+$1F4,x
        sta SCREENRAM+$2EE,x
        bne .ClearScreenLoop
        rts


; Initialise the game screen
Screen_DrawGameScreen
        ldx #$27
.DisplayTitleLoop
        lda #CHAR_ASTERISK              ; print a row of asterisks in red
        sta SCREENRAM,x                 ; at the top of the screen
        lda #RED
        sta COLOURRAM,x
        dex
        bpl .DisplayTitleLoop
                            
        ldx #$05                        ; display text for time, score and
.DisplayStatsTextLoop                   ; arrows and set the colour to white
        lda txtTime,x
        sta SCREENRAM+$072,x
        lda txtScore,x
        sta SCREENRAM+$112,x
        lda txtArrows,x
        sta SCREENRAM+$1B2,x
        lda txtQuack,x
        sta SCREENRAM+$011,x
        lda #GREEN
        sta COLOURRAM+$011,x
        lda #WHITE
        sta COLOURRAM+$072,x
        sta COLOURRAM+$112,x
        sta COLOURRAM+$1B2,x
        dex
        bpl .DisplayStatsTextLoop

        ldx #32                         ; display top border with inv space
.DisplayTopBorderLoop                   ; and set colour to purple
        lda #CHAR_INV_SPACE
        sta SCREENRAM+$028,x
        lda #PURPLE
        sta COLOURRAM+$028,x
        dex
        bpl .DisplayTopBorderLoop

        lda #<SCREENRAM+$050            ; set the screen pointer to the top
        sta zpScnPtrLo                  ; of the left border
        lda #>SCREENRAM+$050
        sta zpScnPtrHi

        ldx #$17                        ; do 23 rows of the side border
.DisplaySideBordersLoop
        lda #CHAR_INV_SPACE
        ldy #$00
        sta (zpScnPtrLo),y              ; display the left border

        lda zpScnPtrHi                  ; $04 + $D4 = $D8
        clc                             ; i.e. colour ram
        adc #$D4
        sta zpScnPtrHi
        lda #PURPLE                     ; set left border to purple
        sta (zpScnPtrLo),y

        ldy #$20                        ; offset by 32 chars for the
        sta (zpScnPtrLo),y              ; right border, and set colour

        lda zpScnPtrHi                  ; $D8 - $D4 = $04 
        sec                             ; i.e. back to screen ram
        sbc #$D4
        sta zpScnPtrHi
        lda #CHAR_INV_SPACE             ; store the inverted space on the
        sta (zpScnPtrLo),y              ; right border

        lda zpScnPtrLo                  ; add 40 chars to screen pointer
        clc                             ; i.e. go to next row
        adc #$28
        sta zpScnPtrLo
        bcc .NextBorderRow              ; we only increment the high byte
        inc zpScnPtrHi                  ; if we've looped past zero
.NextBorderRow                          ; e.g. $04FF + 1 = $0500
        dex
        bpl .DisplaySideBordersLoop
        rts


; Update the player stats on screen
Screen_UpdateStats
        lda TODS                        ; read the system time of day seconds
        jsr Screen_ConvertBCD           ; register and convert from BCD
        stx SCREENRAM+$09A              ; display the converted value
        sty SCREENRAM+$09B              ; on the screen
        lda score+1                     ; convert the upper score digits
        jsr Screen_ConvertBCD           ; from BCD and display on the screen
        stx SCREENRAM+$13A
        sty SCREENRAM+$13B
        lda score                       ; then do the same with the lower
        jsr Screen_ConvertBCD           ; score digits
        stx SCREENRAM+$13C
        sty SCREENRAM+$13D

        ldx #$30
        lda arrows                      ; check number of arrows
        cmp #$0A
        bcc .LessThan10Arrows
        inx                             ; if 10 or more set upper digit to 1
        sec
        sbc #$0A                        ; and subtract 10 from total
.LessThan10Arrows
        ora #$30                        ; convert to ASCII
        sta SCREENRAM+$1DB              ; store lower arrow digit
        stx SCREENRAM+$1DA              ; store upper arrow digit

        lda TODM                        ; sets gameOver flag to time of day
        sta gameOver                    ; minutes register i.e. when we reach
        rts                             ; 1 minute, it's game over


; Routine to convert BCD digits to ASCII
Screen_ConvertBCD
        pha                             ; save the value to the stack
        sed                             ; decimal mode on
        and #$0F                        ; mask off lower four bits
        ora #$30                        ; convert to ASCII
        tay                             ; save in Y register
        pla                             ; retrieve original value
        lsr                             ; shift right four bits
        lsr
        lsr
        lsr
        and #$0F                        ; mask off shifted bits
        ora #$30                        ; convert to ASCII
        tax                             ; save in X register
        cld                             ; decimal mode off
        rts


