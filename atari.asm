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
        
        lda #$60
        sta COLUP0
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
     	
        ldy Counter
Loop:
	dey
        bne Loop
        sta RESP0
        
        lda #0
        sta VSYNC
        
        ; 37 scanlines of vertical blank.
        REPEAT 37
        	sta WSYNC
        REPEND
        
        inc Counter
        
        ; ---------------------------
        ; 192 scanlines of picture.
        ; ---------------------------
        
        ; ---------------------------
        ; Start of sprite rendering.
        ; ---------------------------
        ldx #0
        
        REPEAT 8
        	lda PLAYER,X
                sta GRP0
                inx
        	sta WSYNC
        REPEND
        
        ldx #0
        stx GRP0
        
        ; ---------------------------
        ; End of sprite rendering.
        ; ---------------------------
        
        REPEAT 186
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