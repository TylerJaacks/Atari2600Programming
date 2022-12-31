	processor 6502
        
        include "vcs.h"
        include "macro.h"
        
        SEG
        ORG $F000
        
Reset
	lda #$64
        sta COLUPF
        
        ldx #$30
        stx COLUBK
        
        ldy #1
        sty CTRLPF

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
        REPEAT 2
        	sta WSYNC
        REPEND
        
        ldx #$40
        stx COLUBK

	ldx #%11101111
        stx PF0
        ldx #%11111111
        stx PF1
        stx PF2
        
        REPEAT 3
        	sta WSYNC
        REPEND
        
        ldx #$50
        stx COLUBK
        
        ldx #%00101111
        stx PF0
        ldx #0
        stx PF1
        stx PF2
        
        REPEAT 182
        	sta WSYNC
        REPEND
        
        ldx #$60
        stx COLUBK
        
        ldx #%11101111
        stx PF0
        
        ldx #%11111111
        stx PF1        
        stx PF2
        
        REPEAT 3
        	sta WSYNC
        REPEND
        
       	ldx #0
        stx PF0
        stx PF1        
        stx PF2
        
        
        REPEAT 2
        	sta WSYNC
        REPEND
        
        ; End of screen entering blanking.
        lda #%01000010
        sta VBLANK

	; 30 scanlines of overscan.
	REPEAT 30
        	sta WSYNC
        REPEND
        
        jmp StartOfFrame
        
        ORG $FFFA
        
        .word Reset ; NMI
        .word Reset ; RESET
        .word Reset ; IRQ
END