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

        jsr Objects_MoveWaiter
        jsr Objects_MoveTurkey
        jsr Objects_CheckCollision

        lda lifeLostFlag                ; if no lives lost, loop
        beq .GameLoop
        jsr Player_LoseLife

        jmp .GameLoop


