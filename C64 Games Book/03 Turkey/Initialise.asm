Initialise_Game
        lda #BLACK                      ; set background and border to colour
        sta BDCOL                       ; to black
        sta BGCOL0

        lda #$FF                        ; initialise oscillator to use as
        sta FREL3                       ; simple pseudo-random number
        sta FREH3                       ; generator
        lda #$80
        sta VCREG3

        lda #$96                        ; init sprite start X & Y
        sta waiterX
        sta turkeyX
        sta SPRX0
        sta SPRX1
        lda #$B9
        sta turkeyY
        sta SPRY1
        lda #WAITER_YPOS
        sta SPRY0                       ; the waiter has a fixed Y position

        lda #$00                        ; init score and lives
        sta score                       ; score is BCD
        sta score+1
        sta points
        sta lifeLostFlag
        lda #$03
        sta lives

        jsr Objects_RandomiseXDelta     ; set turkey direction deltas
        lda #$FE                        ; +ve = down, right
        sta yDelta                      ; -ve = up, left
        
        lda #$0D                        ; sprite 0 @ $0340
        sta SPRPTR0                     ; BASE ($0000) + $0D x 64 = $0340
        lda #$0E                        ; sprite 1 @ $0380
        sta SPRPTR1

        lda #YELLOW                     ; set waiter colour to yellow
        sta SPRCOL0                     ; and turkey colour to brown
        lda #BROWN
        sta SPRCOL1

        lda #%00000011                  ; switch sprite 0 & 1 on
        sta SPREN
        rts
