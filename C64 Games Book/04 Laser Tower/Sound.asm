; Sound routine that is called ever raster interrupt
Sound_PlaySound
        lda soundSelected
        cmp #SND_THRUST
        beq Sound_Thrust                ; if thrust sound selected go to routine
        cmp #SND_LASER
        beq Sound_Laser                 ; if laser sound selected go to routine
.ExitPlaySound
        rts


; Ship thrust sound effect
Sound_Thrust
        lda soundInit
        bne .PlayThrustSound            ; check if sound already triggered
        lda #$00
        sta VCREG1                      ; switch off voice 1
        lda #$02
        sta FREH1                       ; V1 frequency Hi = 2
        lda #$25
        sta FREL1                       ; V1 frequency lo = 37
        lda #$2F
        sta ATDCY1                      ; V1 attack/decay = 2 / 15
        lda #$00
        sta SUREL1                      ; V1 sustain/release = 0/0
        lda #$81
        sta VCREG1                      ; V1 waveform = noise, gate on
        lda #$01
        sta soundInit                   ; flag sound init
        lda #$03
        sta soundDelay                  ; set the sound delay counter to 3
.PlayThrustSound
        dec soundDelay
        lda soundDelay
        bne .ExitThrustSound            ; if counter >0 then keep playing
        lda #$00
        sta soundSelected               ; no sound selected
        sta soundInit                   ; reset init flag
        sta VCREG1                      ; V1 = off
.ExitThrustSound
        rts


; Laser fire sound effect
Sound_Laser
        lda soundInit
        bne .PlayLaserSound             ; check if sound already player
        lda #$00
        sta VCREG1                      ; switch off voice 1
        lda #$48
        sta FREH1                       ; v1 frequency hi=72
        lda #$A9
        sta FREL1                       ; v1 frequency lo=169
        lda #$2C
        sta ATDCY1                      ; v1 attack/decay = 2 / 12                
        lda #$07
        sta PWH1                        ; v1 pulse width high = 7
        lda #$00
        sta PWL1                        ; v1 pulse width low = 0
        lda #$41
        sta VCREG1                      ; v1 waveform = pulse gate on
        lda #$01
        sta soundInit                   ; flag sound as initialised
.PlayLaserSound
        lda laserEnabled
        bne .AlterPulseWidth            ; check if laser is still active
        lda #$00
        sta VCREG1                      ; it isn't so switch of voice 1
        sta soundSelected               ; no sound selected
        sta soundInit                   ; reset sound init flag
        rts
.AlterPulseWidth
        lda laserX                      ; get laser X position
        asl
        asl                             ; multiply by 4
        clc
        adc laserX
        adc laserX                      ; add laser X twice (i.e. we are now x6)
        sta PWL1                        ; store in v1 pulse width low byte
        rts


; Ship explosion sound effect
Sound_Explosion
        lda #$22
        sta FREH1                       ; v1 frequency high byte = 34
        lda #$4B
        sta FREL1                       ; v1 frquency low byte = 75
        lda #$8F
        sta ATDCY1                      ; v1 attack/decay = 8 / 15
        lda #$81
        sta VCREG1                      ; v1 waveform = noise, gate on
        rts

