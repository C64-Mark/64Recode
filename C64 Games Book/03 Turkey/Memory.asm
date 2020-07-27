zpScnPtrLo              = $02
zpScnPtrHi              = $03
zpColPtrLo              = $04
zpColPtrHi              = $05


*=$0340 ; this is in the datasette buffer
                        incbin "sprTurkey.spt", 1, 2, true

*=$0A00 ;after code
waiterX                 byte $00
turkeyX                 byte $00
waiterY                 byte $00
turkeyY                 byte $00

waiterXLowerBound       byte $00
waiterXUpperBound       byte $00
turkeyYLowerBound       byte $00
turkeyXLowerBound       byte $00
turkeyXUpperBound       byte $00

score                   byte $00, $00
lives                   byte $00
xDelta                  byte $00
yDelta                  byte $00
lifeLostFlag            byte $00
points                  byte $00

txtTitle                text 'super waiter!  score:0000  lives:3'
txtGameOver             text 'the turkey is inedible!'
txtTryAgain             text 'press space to re-start'
