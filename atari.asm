	processor 6502
        
        include "vcs.h"
        include "macro.h"
        
        SEG
        ORG $F000
        
Reset
	lda #$40
        sta COLUBK
        
        lda #$60
        sta COLUPF
StartOfFrame
	; Start of vertical blanking.
        lda #0
        sta VBLANK
        
        lda #2
        sta VSYNC
        
        ; 3 scanlines of VSYNCH singal.
        REPEAT 3
        	sta WSYNC
        REPEND
        
        lda #0
        sta VSYNC
        
        ; 37 scanlines of vertical blank.
        REPEAT 37
        	sta WSYNC
        REPEND
        
        ; 192 scanlines of picture.
        REPEAT 15
        	ldx #%10101111
                stx PF0
                ldx #%11010111
                stx PF1
               	ldx #%10101110
                stx PF2
                
                SLEEP 13
                ldx #0
                stx PF0
                
                SLEEP 6
                ldx #%00101101
                stx PF1
                
                SLEEP 6
               	ldx #%01111011
                stx PF2
        	stx WSYNC
                
                
                ldx #%01011101
                stx PF0
                ldx #%01111011
                stx PF1
               	ldx #%11000110
                stx PF2
                
                SLEEP 13
                ldx #$4D
                stx PF0
                
                SLEEP 6
                ldx #%11001100
                stx PF1
                
                SLEEP 6
               	ldx #%11100101
                stx PF2
                
        	stx WSYNC
        REPEND
        
        ldx #0
        stx PF0
        stx PF1
        stx PF2
        REPEAT 150
        	sta WSYNC
        REPEND
        ;---------------------------
        
        ; End of screen entering blanking.
        lda #%01000010
        sta VBLANK

	; 30 scanlines of overscan.
	REPEAT 30
        	sta WSYNC
        REPEND
        
        jmp StartOfFrame
        
        ORG $FFF0

THREE: 
	.byte %11111111
        .byte %11111111
        .byte %00000111
        .byte %00000111
        .byte %11111111
        .byte %11111111
        .byte %00000111
        .byte %00000111
        .byte %11111111
        .byte %11111111

        ORG $FFFA
        
        .word Reset ; NMI
        .word Reset ; RESET
        .word Reset ; IRQ
END