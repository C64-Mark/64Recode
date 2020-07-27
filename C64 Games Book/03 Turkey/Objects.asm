; Get user input and update the waiter X accordingly
Objects_MoveWaiter
        lda SYSKEYPRESS                 ; the system address that holds the
        cmp #KEY_Z                      ; last key press
        beq .LeftSelected
        cmp #KEY_M                      ; Z for left, M for right
        beq .RightSelected
        rts
.LeftSelected
        lda waiterX                     ; if the waiter is at the left-most
        cmp #68                         ; position then we don't move them
        beq .ExitGetKeys
        sec
        sbc #$02                        ; move the waiter 2 pixels left
        sta waiterX
        jmp .UpdateWaiterSprite
.RightSelected
        lda waiterX                     ; if the waiter is at the right-most
        cmp #236                        ; position then we don't move them
        beq .ExitGetKeys
        clc
        adc #$02                        ; move the waiter 2 pixels right
        sta waiterX
.UpdateWaiterSprite
        lda waiterX                     ; update the VIC register for sprite 0
        sta SPRX0
.ExitGetKeys
        rts


; Move the turkey left/right and up/down and check boundaries
Objects_MoveTurkey
        lda turkeyY                     ; if we add $FE to an 8-bit number
        clc                             ; then it causes it to roll over
        adc yDelta                      ; so it is effectively the same
        sta turkeyY                     ; as subtracting 2

        lda turkeyX                     ; so the same applies to X and Y
        clc                             ; and the delta can hold a +ve or -ve
        adc xDelta                      ; value
        sta turkeyX

        lda turkeyX                     ; update X & Y VIC registers
        sta SPRX1                       ; for sprite 1
        lda turkeyY
        sta SPRY1

        lda turkeyY                     ; check if the turkey has reached
        cmp #TOP_BOUNDARY               ; the top border
        bcs .CheckLowerBoundary
        lda #$01
        sta yDelta                      ; set turkey Y direction to down
        jsr Objects_RandomiseXDelta     ; create new X delta
        inc points                      ; add 1 to score
        jsr Screen_UpdateScore          
        rts
.CheckLowerBoundary
        cmp #WAITER_YPOS                ; if the turkey has gone past the
        bcc .CheckLeftBoundary          ; waiter then we lose a life
        inc lifeLostFlag                ; we flag it here, and pick it up
        rts                             ; in another routine
.CheckLeftBoundary
        lda turkeyX
        cmp #LEFT_BOUNDARY
        bcs .CheckRightBoundary
        lda #LEFT_BOUNDARY              ; if we're beyond the left boundary
        sta turkeyX                     ; then set turkey X to be within
        jmp .ChangeTurkeyXDirection     ; boundary & change X direction
.CheckRightBoundary
        cmp #RIGHT_BOUNDARY
        bcc .ExitMoveTurkey
        lda #RIGHT_BOUNDARY             ; if we're beyond the right boundary
        sta turkeyX                     ; then set turkey X to be within
.ChangeTurkeyXDirection                 ; boundary and change X direction
        lda xDelta
        eor #$FF                        ; switches the turkey X direction
        clc                             ; between positive and negative
        adc #$01
        sta xDelta
        inc points                      ; add 1 to score
        jsr Screen_UpdateScore          
.ExitMoveTurkey
        rts


; Create a random Xdelta for the turkey between -4 and +4
Objects_RandomiseXDelta
        lda SIDRAND                     ; load a pseudo random number from the
        and #$0F                        ; oscillator and AND with 15
        cmp #$09                        ; if the number is greater than 8
        bcs Objects_RandomiseXDelta     ; then get another random number
        sec
        sbc #$04                        ; subtract 4 so our number is now in
        sta xDelta                      ; the range -4 to +4
        rts


; Check for a collision between the waiter and the turkey
Objects_CheckCollision
        lda yDelta                      ; turkey is moving upwards so
        cmp #$FE                        ; we don't need to test the
        bne .CheckCollision             ; collision
        rts
.CheckCollision
        lda turkeyY                     ; create hit boxes for the turkey
        clc                             ; and the waiter
        adc #$14
        sta turkeyYLowerBound           ; this makes an allowance for the
        lda turkeyX                     ; fact that the sprite doesn't take
        clc                             ; up the whole sprite grid, so
        adc #$02                        ; we offset the empty sprite
        sta turkeyXLowerBound           ; space
        clc
        adc #$14
        sta turkeyXUpperBound           ; the waiter has a fixed Y so we
        lda waiterX                     ; only need to check the turkey Y
        clc                             ; against a lower bound
        adc #$05
        sta waiterXLowerBound
        clc
        adc #$0F
        sta waiterXUpperBound

        lda turkeyY                     ; if the turkey is higher on the
        cmp #WAITER_YPOS-10             ; screen than the waiter then
        bcc .ExitCheckCollision         ; no collision

        lda turkeyXUpperBound           ; if the right bound of the turkey
        cmp waiterXLowerBound           ; is less than the left bound of the
        bcc .ExitCheckCollision         ; waiter, then no collision

        lda turkeyXLowerBound           ; if the left bound of the turkey
        cmp waiterXUpperBound           ; is greater than the right bound of the
        bcs .ExitCheckCollision         ; waiter, then no collision

        lda #$FE                        ; if we drop through to here then
        sta yDelta                      ; the turkey and the waiter have
        jsr Objects_RandomiseXDelta     ; collided. So change to -ve Y direction,
        lda #$02                        ; re-rand the X direction and add 2
        sta points                      ; points to the score
        jsr Screen_UpdateScore
.ExitCheckCollision
        rts
