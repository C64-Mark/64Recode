; Clear the screen
Screen_Clear
        lda #CHAR_SPACE
        ldx #$fa
.ClearScreenLoop
        dex
        sta SCREENRAM,x                 ; set 4 x 250 chars to the space
        sta SCREENRAM+250,x             ; char
        sta SCREENRAM+500,x
        sta SCREENRAM+750,x
        bne .ClearScreenLoop
        rts


; Set up the game screen
Screen_DrawGameScreen
        ldx #$21                        ; print the game title at the top
.DisplayTitleLoop                       ; of the screen in white
        lda txtTitle,x
        sta SCREENRAM,x
        lda #WHITE
        sta COLOURRAM,x
        dex
        bpl .DisplayTitleLoop

        lda #BLUE                       ; set score and lives text to blue
        ldx #$05
.DisplayTitleColourLoop
        sta COLOURRAM+$00F,x
        sta COLOURRAM+$01B,x
        dex
        bpl .DisplayTitleColourLoop

        ldx #24                         ; display top border with X char
.DisplayTopBorderLoop                   ; and set colour to green
        lda #CHAR_CROSS
        sta SCREENRAM+$055,x
        lda #GREEN
        sta COLOURRAM+$055,x
        dex
        bpl .DisplayTopBorderLoop

        lda #<SCREENRAM+$07D            ; set the screen pointer to the top
        sta zpScnPtrLo                  ; of the left border
        lda #>SCREENRAM+$07D
        sta zpScnPtrHi

        ldx #$12                        ; do 19 rows of the side border
.DisplaySideBordersLoop
        lda #CHAR_CROSS
        ldy #$00
        sta (zpScnPtrLo),y              ; display the left border

        lda zpScnPtrHi                  ; $04 + $D4 = $D8
        clc                             ; i.e. colour ram
        adc #$D4
        sta zpScnPtrHi
        lda #GREEN                      ; set left border to green
        sta (zpScnPtrLo),y

        ldy #$18                        ; offset by 24 chars for the
        sta (zpScnPtrLo),y              ; right border, and set colour

        lda zpScnPtrHi                  ; $D8 - $D4 = $04 
        sec                             ; i.e. back to screen ram
        sbc #$D4
        sta zpScnPtrHi
        lda #CHAR_CROSS                 ; store the cross char on the
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


; add points to the score and update the screen
Screen_UpdateScore
        sed                             ; switch to decimal mode
        lda score+1                     ; add 1 to score for hitting
        clc                             ; a boundary
        adc points
        sta score+1
        lda score                       ; score is 16 bit BCD so we make sure
        adc #$00                        ; we carry over to second two digits
        sta score
        cld

        lda #$00                        ; reset points not they've been
        sta points                      ; added to the score

        lda score                       ; convert BCD value to decimal
        pha                             ; and then to ASCII
        and #$0F                        ; and store on the screen
        ora #$30
        sta SCREENRAM+$016              ; and with #%00001111 to isolate
        pla                             ; lower 4 bits
        lsr
        lsr                             ; then shift right x 4
        lsr                             ; to get upper 4 bits
        lsr
        ora #$30                        ; or with $30 to turn to ASCII
        sta SCREENRAM+$015

        lda score+1                     ; then repeat with the next 2
        pha                             ; BCD score digits
        and #$0F
        ora #$30
        sta SCREENRAM+$018
        pla
        lsr
        lsr
        lsr
        lsr
        ora #$30
        sta SCREENRAM+$017

        rts

