; Clear the screen
Screen_Clear
        lda #CHAR_SPACE
        ldx #$FA
.ClearScreenLoop
        dex
        sta SCREENRAM,x                 ; set 4 x 250 chars to the space
        sta SCREENRAM+$0FA,x            ; char
        sta SCREENRAM+$1F4,x
        sta SCREENRAM+$2EE,x
        bne .ClearScreenLoop
        rts


; Draw the initial game screen
Screen_DrawGameScreen
        ldy #$27
.DrawGroundLoop
        lda #CHAR_GROUND
        sta SCNROW24,y                  ; draw ground on row 24
        lda #CHAR_GRASS
        sta SCNROW23,y                  ; draw grass on row 23
        lda #GREEN
        sta COLROW24,y                  ; set colour to green
        sta COLROW23,y
        dey
        bpl .DrawGroundLoop

        ldy #$03
.DrawBaseLoop
        lda #CHAR_SPACE
        sta SCNROW23+26,y               ; clear space and
        lda #CHAR_BASE  
        sta SCNROW24+26,y               ; and draw chase char
        dey
        bpl .DrawBaseLoop

        lda #<SCREENRAM+$399            ; set screen and colour pointers
        sta zpScnPtrLo                  ; for base of tower
        sta zpColPtrLo
        lda #>SCREENRAM+$399
        sta zpScnPtrHi
        lda #>COLOURRAM+$399
        sta zpColPtrHi

        ldx #$07                        ; 8 chars high
        ldy #$00
.DrawTowerLoop
        lda #CHAR_TOWER
        sta (zpScnPtrLo),y              ; draw tower char
        lda #LIGHTRED
        sta (zpColPtrLo),y              ; and colour it light red

        lda zpScnPtrLo
        sec
        sbc #$28                        ; subtract 40 chars (i.e. 1 row)
        sta zpScnPtrLo                  ; from screen and colour pointers
        sta zpColPtrLo
        bcs .NextTowerRow
        dec zpScnPtrHi                  ; decrease high byte if carry clear
        dec zpColPtrHi
.NextTowerRow
        dex                             ; do next row of tower
        bpl .DrawTowerLoop

        lda #CHAR_TURRET                
        sta (zpScnPtrLo),y              ; at top of tower draw the turret
        lda #RED                        ; char and colour it red
        sta (zpColPtrLo),y
        rts


; Routine to fetch screen position of tower based on Y variable
Screen_FetchTowerPosition
        ldy towerY
        lda tbl_TowerPosLo,y            ; lookup low byte from table
        sta zpScnPtrLo                  ; and store in pointer low
        sta zpColPtrLo                  ; also for colour pointer
        lda tbl_TowerPosHi,y            ; lookup high byte from table
        sta zpScnPtrHi                  ; and store in screen pointer high
        clc
        adc #$D4                        ; add $D4 to high byte and store in
        sta zpColPtrHi                  ; colour high byte (so, e.g. $04 -> $D8)
        rts

