; Update the VIC sprite registers
Objects_UpdateSprites
        ldy #$03                        ; loop through 4 ducks
        ldx #$06                        
.UpdateDuckSpritesLoop
        lda ducksX,y
        sta SPRX2,x
        dex                             ; X decreases twice due to relative
        dex                             ; addresses of sprite X
        dey
        bpl .UpdateDuckSpritesLoop
        lda bowX                        ; update bow and arrow X/Y
        sta SPRX0
        lda arrowX
        sta SPRX1
        lda arrowY
        sta SPRY1
        rts


; Get user input and move the bow sprite
Objects_MoveBow
        lda SYSKEYPRESS                 ; get key press
        cmp #KEY_Z
        beq .MoveBowLeft                ; if Z move left
        cmp #KEY_C
        beq .MoveBowRight               ; if C move right
        cmp #KEY_M
        beq .FireArrow                  ; if M fire arrow
        rts
.MoveBowLeft
        lda bowX
        cmp #$21                        ; if bow is at left-most position
        bcc .ExitMoveBow                ; then don't move
        lda #$FE                        ; added to bow X to create -2
        jmp .UpdateBowX
.MoveBowRight
        lda bowX
        cmp #$EE                        ; if bow is at right-most position
        bcs .ExitMoveBow                ; then don't move
        lda #$02
.UpdateBowX
        clc
        adc bowX                        ; adding either +2 or -2 ($FE) to bow X
        sta bowX
        ldx arrowEnabled
        bne .ExitMoveBow                ; if arrow is active then skip
        sta arrowX                      ; arrow inactive, so modify X in line
        rts                             ; with bow
.FireArrow
        lda arrowEnabled
        bne .ExitMoveBow                ; if arrow active, then skip
        lda arrows
        beq .ExitMoveBow                ; if no arrows left, then skip
        lda #TRUE
        sta arrowEnabled                ; enable arrow
        dec arrows                      ; decrease number of arrows
        lda #SND_ARROW                  ; initialise arrow fire sound
        sta soundSelected
.ExitMoveBow
        rts


;move the arrow if enabled
Objects_MoveArrow
        lda arrowEnabled
        beq .ExitMoveArrow              ; if the arrow isn't active then exit
        dec arrowY                      ; move arrow up the screen
        lda arrowY                      
        cmp #$41                        ; check to see if the arrow has reached
        bcs .ExitMoveArrow              ; the top border
        lda #$D9                        ; if it has then reset the arrow Y
        sta arrowY
        lda #FALSE                      ; and deactivate the arrow
        sta arrowEnabled
        lda bowX                        ; and set the arrow X to be the same as
        sta arrowX                      ; the bow
.ExitMoveArrow
        rts


; Move the ducks
Objects_MoveDucks
        ldx #$03                        ; loop through the four ducks
.MoveDucksLoop
        inc ducksX,x                    ; increment the duck X position
        lda ducksX,x
        bne .NextDuck
        lda #$20                        ; if the duck X=0 (i.e. right border)
        sta ducksX,x                    ; then set X to 32 (i.e. left border)
        lda #SPRITE_DUCK                ; reset the duck sprite pointer so that
        sta SPRPTR0+2,x                 ; if a duck has been shot, it flips
.NextDuck                               ; back over
        dex
        bpl .MoveDucksLoop
        rts


; Check collision between the arrow and ducks
Objects_CheckCollision
        lda arrowY
        cmp #$5F                        ; if the arrow is past the ducks
        bcc .ExitCheckCollision         ; i.e. Y<95, then no collision
        cmp #$69                        ; if the arrow hasn't reached the ducks
        bcs .ExitCheckCollision         ; i.e. Y>=105 then no collision
        lda SPRCSP                      ; check sprite collision for any of the
        and #%00111100                  ; four ducks
        beq .ExitCheckCollision         ; if no collision then exit
        lsr
        lsr                             ; shift the collision bits right twice
        ror                             ; then roll right so we can test the carry
        bcc .CheckDuck2                 ; not duck 1, so check next duck        
        ldx #$00                        ; it is duck 1, so set X = 0
.CheckDuck2
        ror                             ; roll and test carry for next duck
        bcc .CheckDuck3
        ldx #$01                        ; we hit duck 2, so X = 1
.CheckDuck3
        ror                             ; roll and test carry for next duck
        bcc .CheckDuck4
        ldx #$02                        ; we hit ducks 3, so X = 2
.CheckDuck4
        ror                             ; roll and test carry for next duck
        bcc .ChangeDuckSprite
        ldx #$03                        ; we hit duck 4, so X = 3
.ChangeDuckSprite
        lda #SPRITE_DUCK_DEAD           ; store the dead duck sprite in the
        sta SPRPTR2,x                   ; relevant sprite pointer using X
        lda #FALSE
        sta arrowEnabled                ; disable the arrow
        lda #$DA
        sta arrowY                      ; and reset it's X and Y position so
        lda bowX                        ; it is back with the bow
        sta arrowX
        inc ducks                       ; increment the duck hit counter
        sed                             ; set decimal mode on
        lda score                       ; and add 10 to the score
        clc
        adc #$10                        ; the is BCD
        sta score
        lda score+1                     ; carry over into next score digit
        adc #$00
        sta score+1
        cld
        lda #SND_DUCKHIT                ; initialise the duck hit sound
        sta soundSelected
.ExitCheckCollision
        lda SPRCSP                      ; clear the sprite collision register
        rts


