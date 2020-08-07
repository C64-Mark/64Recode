; 10 SYS2080
*=$0801
                        byte $0B, $08, $0A, $00, $9E, $32, $30, $38
                        byte $30, $00, $00, $00

*=$0820
.Start
        jsr Initialise_Game
        jsr Initialise_Rand
        jsr Screen_Clear
        jsr Screen_DrawGameScreen

.GameLoop
        lda RASTER
        cmp #$F0
        bne .GameLoop                   ; wait for raster to reach line 240

        jsr Objects_MoveShip
        jsr Objects_AddFriction
        jsr Objects_AddGravity
        jsr Objects_UpdateSprites
        jsr Objects_MoveTurret
        jsr Objects_FireLaser
        jsr Objects_CheckCollision
        jsr Sound_PlaySound

        lda gameOver
        beq .GameLoop                   ; if not game over then loop back
        jsr Player_GameOver
        jmp .Start                      ; reset game after game over
