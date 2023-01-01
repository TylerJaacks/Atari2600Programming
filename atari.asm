	processor 6502
        
        include "vcs.h"
        include "macro.h"
        
        SEG.U var
        ORG $80
        
Counter ds.bs 1,0
        
        SEG
        ORG $F000
Reset
	lda #$40
        sta COLUBK
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
        
	sec
        sta WSYNC
        lda Counter
        ldx #4
DivideLoop:
	sbc #15
        bcs DivideLoop
        
        eor #7
        asl
        asl
        asl
        asl
        
        sta.wx HMP0,X
        sta RESP0,X
        
        sta WSYNC
        sta HMOVE
        
        ldx #$FF
        stx ENABL
        sta WSYNC
        lda #0
        sta ENABL
        
        ; ---------------------------
        ; 192 scanlines of picture.
        ; ---------------------------       
        REPEAT 189
        	sta WSYNC
        REPEND
        ; ---------------------------
        ; End of picture scanlines.
        ;----------------------------
        
        ; End of screen entering blanking.
        lda #%01000010
        sta VBLANK
        inc Counter

	; 30 scanlines of overscan.
	REPEAT 30
        	sta WSYNC
        REPEND
                
        jmp StartOfFrame
        
PLAYER:
	.byte #%11100000
        .byte #%01111000
        .byte #%01111110
        .byte #%01111111
        .byte #%01111111
        .byte #%01111110
        .byte #%01111000
        .byte #%11110000

        ORG $FFFA
        
        .word Reset ; NMI
        .word Reset ; RESET
        .word Reset ; IRQ
END