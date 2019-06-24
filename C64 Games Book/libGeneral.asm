;-------------------------------------------------------------------------------
;LIBGENERAL: General Libraries
;-------------------------------------------------------------------------------

;Initialise the SID random number generator
defm 	LIBGENERAL_INITRAND

        lda #$FF
        sta FREL3
        sta FREH3
        lda #$80
        sta VCREG3

        endm

;Create an 8-bit random number between upper and lower
defm 	LIBGENERAL_GENERATE_8BIT_RAND_VVA ;Lower, Upper, Target

        sec
        lda #/2
        sbc #/1
        clc
        adc #$01
        sta /3
@loop   lda SIDRAND
        cmp /3
        bcs @loop
        adc #/1
        sta /3

        endm

;Create a random number between -1 and 1
defm 	LIBGENERAL_CREATE_DELTA_A ;Target

@redo   lda SIDRAND
        and #$03
        cmp #$03
        beq @redo
        sec
        sbc #$01
        sta /1
    
        endm

;Copy two bytes from one location to another
defm 	LIBGENERAL_COPY_WORD_AA ;Source, Target

        lda /1
        sta /2
        lda /1 + 1
        sta /2 + 1

        endm

defm 	LIBGENERAL_STORE_ADDRESS_AA ;Address, Target

        lda #</1
        sta /2
        lda #>/1
        sta /2 + 1

        endm