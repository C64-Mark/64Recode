; Game Variables
zpScnPtrLo              = $02
zpScnPtrHi              = $03
zpColPtrLo              = $04
zpColPtrHi              = $05

verticalVelocity        = $A3 ;to $A4
horizontalVelocity      = $A5 ;to $A6
gameOver                = $A7
verticalThrust          = $A8
horizontalThrust        = $A9
towerY                  = $AA
towerCounter            = $AB
laserEnabled            = $AC
laserX                  = $AD
laserStage              = $AE
soundInit               = $AF
soundDelay              = $B0
soundSelected           = $B1


; Game Text
*=$0334
txtHardLines            text 'hard lines'
txtPressSpace           text 'press space to restart'
txtWellDone             text 'well done!'
txtEscapedAlive         text 'you escaped alive'

tbl_TowerPosLo          byte $29, $51, $79, $A1, $C9, $F1, $19, $41
                        byte $69, $91, $B9, $E1, $09, $31, $59, $81
                        byte $A9, $D1, $F9, $21, $49, $71, $99

tbl_TowerPosHi          byte $04, $04, $04, $04, $04, $04, $05, $05
                        byte $05, $05, $05, $05, $06, $06, $06, $06
                        byte $06, $06, $06, $07, $07, $07, $07


; Sprites & Chars
*=$2000
                        incbin "chrLaserTower.cst", 0, 127

*=$2400
                        incbin "sptLaserTower.spt", 1, 2, true