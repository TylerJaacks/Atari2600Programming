	processor 6502
        include "vcs.h"
        include "macro.h"
        
        SEG
        ORG $F000
        
Reset
	lda #$64
        sta COLUPF
StartOfFrame
	
        ; Start of vertical blank processing.
        lda #0
        sta VBLANK
        
        lda #2
        sta VSYNC
        
        ldy #%00000000
        sty PF0
        
        ldy #%10010000
        sty PF1
        
        ldy #%00010001
        sty PF2
        
        ; 3 scanlines of VSYNCH signal.
        REPEAT 3
        	; WSYNC basically waits till the next scanline.
        	sta WSYNC
        REPEND
        
        lda #0
        sta VSYNC
        
        ; 37 scanlines of vertical blank.
        REPEAT 37
        	sta WSYNC
        REPEND
        
        ; 192 scanlines of picture.
        ldx #0
        
        REPEAT 192;
        	inx
                stx COLUBK
                sta WSYNC
        REPEND
        
        lda #%01000010
        
        ; End of screen blanking.
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