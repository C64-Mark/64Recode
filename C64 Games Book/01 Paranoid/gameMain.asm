*=$0801

        byte    $0E, $08, $0A, $00, $9E, $20, $28
        byte    $32, $30, $36, $34, $29, $00, $00, $00

Start
        jsr Initialise

GameLoop

        jsr PlotPointsXY
        jsr CheckXYBoundaries
        jsr CalculateDXDY

        jmp GameLoop

