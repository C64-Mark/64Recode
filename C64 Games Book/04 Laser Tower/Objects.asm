; Get user input and alter ship vertical and horizontal velocity
Objects_MoveShip
        lda #$00
        sta verticalThrust
        sta horizontalThrust            ; reset vertical and horizontal thrust
        lda SYSKEYPRESS
        cmp #KEY_LEFTRIGHT              ; check left/right cursor key press
        bne .CheckKeyUpDown
        lda #SND_THRUST
        sta soundSelected               ; select ship thrust sound effect
        lda horizontalVelocity+1
        clc
        adc #HTHRUST                    ; add horizontal thrust constant to
        sta horizontalVelocity+1        ; horizontal velocity fraction
        lda horizontalVelocity
        adc #$00
        sta horizontalVelocity          ; add carry to horizontal velocity
        rts
.CheckKeyUpDown
        cmp #KEY_UPDOWN                 ; check up/down cursor key press
        bne .ExitMoveShip
        lda #SND_THRUST
        sta soundSelected               ; select ship thrust sound effect
        lda verticalVelocity+1
        sec
        sbc #VTHRUST                    ; subtract vertical thrust constant from
        sta verticalVelocity+1          ; vertical velocity fraction
        lda verticalVelocity
        sbc #$00
        sta verticalVelocity            ; subtract carry from vertical velocity
.ExitMoveShip
        rts


; Subtract friction from the ship horizontal velocity
Objects_AddFriction
        lda horizontalVelocity+1
        sec
        sbc #FRICTION                   ; subtract friction constant from
        sta horizontalVelocity+1        ; horizontal velocity fraction
        lda horizontalVelocity
        sbc #$00                        ; subtract carry from horizontal velocity

        beq .ExitAddFriction            ; if 0, exit
        bpl .PositiveHV
        lda #$FF                        ; if -ve, limited to $FF (i.e. -1)
        jmp .ExitAddFriction
.PositiveHV
        lda #$01                        ; if +ve limited to $01
.ExitAddFriction
        sta horizontalVelocity
        rts        


; Add gracity to ship vertical velocity
Objects_AddGravity
        lda verticalVelocity+1
        clc
        adc #GRAVITY                    ; add gravity fraction to
        sta verticalVelocity+1          ; vertical velocity fraction
        lda verticalVelocity
        adc #$00                        ; add carry to vertical velocity

        beq .ExitAddGravity             ; if 0, exit
        bpl .PositiveVV
        lda #$FF                        ; if -ve, limit to $FF (i.e. -1)
        jmp .ExitAddGravity
.PositiveVV
        lda #$01                        ; if +ve, limited to $01
.ExitAddGravity
        sta verticalVelocity
        rts 


; Update ship X/Y
Objects_UpdateSprites
        lda SPRX0
        clc
        adc horizontalVelocity          ; add the horizontal velocity value
        sta SPRX0                       ; to the sprite X register
        cmp #$FA
        bcs .ClearMSB                   ; if X>=250 then clear MSB
        cmp #$05
        bcs .SetShipY                   ; if X>=5 then skip MSB
        lda #$01
        sta SPRXMSB                     ; set X MSB
        jmp .SetShipY
.ClearMSB
        lda #$00
        sta SPRXMSB                     ; clear X MSB
.SetShipY
        lda SPRY0
        clc
        adc verticalVelocity            ; add vertical velocity to sprite Y
        
        cmp #$30
        bcs .CheckLanded                ; if y>=48 then check landing
        lda #$30                        ; set Y to 48, if lower
.CheckLanded
        cmp #$EA                        
        bcc .SetY                       ; if Y<234 then uppdate register
        ldx #$01                
        stx gameOver                    ; ship has landed, set game over flag to 1
.SetY
        sta SPRY0                       ; set sprite Y register

        lda SPRXMSB
        beq .CheckXLower                ; check if X MSB is set
        lda SPRX0
        cmp #$37                        ; if it is, see if X>55
        bcc .ExitUpdateSprites
        lda #$37                        ; limit ship X to 55, if higher
        sta SPRX0
        jmp .ExitUpdateSprites
.CheckXLower
        lda SPRX0
        cmp #$20                        ; check sprite lower position
        bcs .ExitUpdateSprites
        lda #$02                        ; if x<32 then ship has crashed
        sta gameOver                    ; game over flag = 2
.ExitUpdateSprites
        rts


; Move the turret
Objects_MoveTurret
        lda laserEnabled
        beq .TowerDelayCount            ; if the laser is firing the turrey
        rts                             ; doesn't move
.TowerDelayCount
        dec towerCounter                ; decrement the tower delay counter
        lda towerCounter
        beq .MoveTurret                 ; if counter=0 then move the turret
        rts
.MoveTurret
        lda #TOWER_DELAY
        sta towerCounter                ; reset the tower move counter
        lda SIDRAND                     ; get a pseudo random number
        and #$03                        ; limit it to 0-3
        cmp #$01
        beq .FireLaser                  ; if 1 then fire the laser
        cmp #$02
        beq .MoveTurretUp               ; if 2 then move the turret up
        cmp #$03
        beq .MoveTurretDown             ; if 3 then move the turret down
        jmp .MoveTurret                 ; if 0, then get another number
.FireLaser
        lda SIDRAND                     ; generate a pseudo random number
        cmp #$F0
        bcc .ExitMoveTurret             ; if less than 240 then exit
        lda #TRUE
        sta laserEnabled                ; enable the laser
        lda #$01
        sta laserX                      ; set laser X position to 1
        sta laserStage                  ; initialise laser stage
        lda #SND_LASER
        sta soundSelected               ; select the laser sound effect
        lda #$00
        sta soundInit                   ; initialise the sound
.ExitMoveTurret
        rts
.MoveTurretUp
        jsr Screen_FetchTowerPosition   ; get the turret screen position
        ldy #$00
        lda #CHAR_TOWER
        sta (zpScnPtrLo),y              ; print tower char at current position
        lda #LIGHTRED
        sta (zpColPtrLo),y              ; set colour to light red
        dec towerY                      ; decrease the tower Y position
        lda towerY                      ; i.e. move up
        bpl .DrawTurret
        lda #$00                        ; if tower Y<0 then set to 0
        sta towerY
.DrawTurret
        jsr Screen_FetchTowerPosition   ; get the new turret screen position
        ldy #$00
        lda #CHAR_TURRET
        sta (zpScnPtrLo),y              ; print turret char at current position
        lda #RED
        sta (zpColPtrLo),y              ; set colour to red
        rts
.MoveTurretDown
        jsr Screen_FetchTowerPosition   ; get the turret screen position
        ldy #$00
        lda #CHAR_SPACE                 
        sta (zpScnPtrLo),y              ; print space at current position
        lda #BLACK
        sta (zpColPtrLo),y              ; set colour to black
        inc towerY                      ; increase tower Y
        lda towerY                      ; i.e. move down
        cmp #$17
        bne .DrawTurret
        lda #$16
        sta towerY                      ; if tower y=23, then y=22
        jmp .DrawTurret                 ; draw turret at new positon


; Draw the laser on the screen
Objects_FireLaser
        lda laserEnabled
        beq .ExitFireLaser              ; if the laser isn't active then exit
        lda #CHAR_LASER
        ldx laserStage                  ; laser stage = 1 = draw laser
        bne .DrawLaser                  ; laser stage = 0 = clear laser
        lda #CHAR_SPACE
.DrawLaser
        ldy laserX                      ; draw laser char ot space char at
        sta (zpScnPtrLo),y              ; at current laser X position
        lda #PURPLE
        sta (zpColPtrLo),y              ; set the char colour to purple
        iny
        sty laserX                      ; increment laser X position
        cpy #$26
        bne .ExitFireLaser
        ldy #$01                        ; if laser X = 38, then laser X=1
        sty laserX
        dec laserStage                  ; decrease laser stage
        lda laserStage
        bpl .ExitFireLaser
        lda #FALSE                      ; if laser stage not 0 or 1, then
        sta laserEnabled                ; disable the laser
.ExitFireLaser
        rts


; Check collision between the ship and background
Objects_CheckCollision
        lda SPRCBG
        beq .ExitCheckCollision         ; no collision so exit
        lda #$02
        sta gameOver                    ; game over=2 if collision (i.e. death)
.ExitCheckCollision
        rts
