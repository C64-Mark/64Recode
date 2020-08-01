; In-game sound play routine
Sound_PlaySound
        lda soundSelected               ; check if a sound has been selected
        cmp #$01
        beq Sound_FireArrow             ; arrow fire sound selected
        cmp #$02
        beq Sound_DuckHit               ; duck hit sound selected
.ExitPlaySound
        rts


; Play arrow fire sound
Sound_FireArrow
        lda soundInit                   ; check the sound init flag
        bne .PlayArrowSound             ; already initialised, play sound
        inc soundInit                   ; set the init flag
        lda #$81                        ; voice 1 noise waveform, gate on
        sta VCREG1
        lda #$00                        ; initialise V1 High Freq variable
        sta soundFreqHi
.PlayArrowSound
        lda soundFreqHi
        clc
        adc #$04                        ; add four to V1 high frequency value
        sta soundFreqHi
        sta FREH1                       ; store in the SID register
        cmp #$50
        bcc .ExitFireArrow              ; check if we've reached 50
        lda #$00                        ; we have so switch V1 off
        sta VCREG1
        sta soundSelected               ; no sound selected
        sta soundInit                   ; sound init flag reset
.ExitFireArrow
        rts


; Play the duck hit sound
Sound_DuckHit
        lda soundInit                   ; check sound init flag
        bne .PlayDuckHitSound           ; if already init then skip
        inc soundInit                   ; set the sound init flag
        lda #$21                        ; saw waveform, gate on
        sta VCREG1
        lda #$1E                        ; set V1 high freq to 30
        sta soundFreqHi
.PlayDuckHitSound
        lda soundFreqHi
        sec
        sbc #$01                        ; decrease high frequency by 1
        sta soundFreqHi
        sta FREH1                       ; store in SID register
        lsr                             ; divide the value by 2
        sta SIDVOL                      ; and store this in the SID volume reg
        bne .ExitDuckHit                ; check if we've reached zero
        lda #$00                        ; we have so switch off V1
        sta VCREG1
        sta soundSelected               ; no sound selected
        sta soundInit                   ; init flag reset
        lda #$0F                        ; volume set back to full
        sta SIDVOL
.ExitDuckHit
        rts


; Play the game over sound
Sound_GameOver
        lda #$11
        sta VCREG1                      ; triangle waveform, gate on
        lda #$F0
        sta soundFreqHi                 ; set V1 high freq to 240
.RasterDelay
        lda RASTER
        cmp #$F0
        bne .RasterDelay                ; delay one raster cycle
        lda soundFreqHi
        sec
        sbc #$03                        ; decrease high freq by three
        sta soundFreqHi
        sta FREH1                       ; update the SID register
        bne .RasterDelay                ; loop until freq = 0
        lda #$00
        sta VCREG1                      ; switch off voice 1
        rts

