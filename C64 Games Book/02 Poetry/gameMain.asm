*=$0801

        byte    $0E, $08, $0A, $00, $9E, $20, $28
        byte    $32, $30, $36, $34, $29, $00, $00, $00

Start
        jsr Initialise
        jsr InitialisePoem
NextLine
        LIBSCREEN_WAIT_V #$FF
        jsr ChooseWords
        jsr ChooseLines
        jsr PrintLines
        jsr GoAgain
        lda NewLine
        cmp #$00
        beq NextLine
        jsr AnotherPoem
        lda again
        beq Start
ExitGame
        lda #$00
        sta MODE ; enable shift+commodore
        LIBSCREEN_SET1000_AV SCREENRAM, space
        lda #$00
        sta CURRKEY
        rts