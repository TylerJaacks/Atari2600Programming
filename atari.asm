	processor 6502
        
        include "vcs.h"
        include "macro.h"
        
        SEG
        ORG $F000
        
Reset
	lda #$40
        sta COLUBK
        
        lda #$60
        sta COLUP0
        
        ldx #$20
        stx COLUP1
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
        
        ; ---------------------------
        ; 192 scanlines of picture.
        ; ---------------------------
        REPEAT 12
        	sta WSYNC
        REPEND
        
        ldx #0
        
       	REPEAT 5
        	lda PLAYER,X
                sta GRP1
                inx
                
                lda #0
        	sta WSYNC
        REPEND
        
        ldx #0
        stx ENAM1
        
        REPEAT 175
        	sta WSYNC
        REPEND
        ; ---------------------------
        ; End of picture scanlines.
        ;----------------------------
        
        ; End of screen entering blanking.
        lda #%01000010
        sta VBLANK

	; 30 scanlines of overscan.
	REPEAT 30
        	sta WSYNC
        REPEND
        
        jmp StartOfFrame
        
PLAYER:
	.byte %00011000
        .byte %00111100	
        .byte %01111110
        .byte %11111111
        .byte #0

        ORG $FFFA
        
        .word Reset ; NMI
        .word Reset ; RESET
        .word Reset ; IRQ
END