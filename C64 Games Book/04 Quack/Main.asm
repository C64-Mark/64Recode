; 10 SYS2080
*=$0801
                        byte $0B, $08, $0A, $00, $9E, $32, $30, $38
                        byte $30, $00, $00, $00

*=$0820
.Start
        jsr Initialise_Game
        jsr Screen_Clear
        jsr Screen_DrawGameScreen

.GameLoop
        lda RASTER
        cmp #$F0
        bne .GameLoop                   ; wait for raster to reach line 240

        jsr Screen_UpdateStats
        jsr Objects_UpdateSprites
        jsr Objects_MoveBow
        jsr Objects_MoveArrow
        jsr Objects_MoveDucks
        jsr Objects_CheckCollision
        jsr Sound_PlaySound

        lda gameOver
        beq .GameLoop                   ; if game isn't over loop
        jsr Player_GameOver
        jmp .Start                      ; if game is over, jump back to start
