; Game Variables
zpScnPtrLo              = $02
zpScnPtrHi              = $03
soundCounter            = $04
soundInit               = $05

ducksX                  = $A3 ;to $A6
ducks                   = $A7
bowX                    = $A8
arrowX                  = $A9
arrowY                  = $AA
arrows                  = $AB
arrowEnabled            = $AC
gameOver                = $AD
score                   = $AE ;to $AF
soundFreqHi             = $B0
soundSelected           = $B1


; Game Text
*=$0334
txtQuack                text 'quack!'
txtTime                 text 'time  '
txtScore                text 'score '
txtArrows               text 'arrows'
txtTimeUp               text 'your time is up     '
txtYouShot              text 'you shot 00 birds   '
txtHitSpace             text 'hit space to restart'
txtWellDone             text 'well done!'                       


; Game Sprites
*=$0E00
                        incbin "sprQuack.spt", 1, 4, true
