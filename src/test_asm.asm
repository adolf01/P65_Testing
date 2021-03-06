;
; File generated by cc65 v 2.19 - Git a861d84
;
	.fopt		compiler,"cc65 v 2.19 - Git a861d84"
	.setcpu		"65C02"
	.smart		on
	.autoimport	on
	.case		on
	.debuginfo	off
	.importzp	sp, sreg, regsave, regbank
	.importzp	tmp1, tmp2, tmp3, tmp4, ptr1, ptr2, ptr3, ptr4
	.macpack	longbranch
	.import		_CHROUT
	.import		_PRNTLN
	.import		_PRNL
	.import		_KBINPUT
	.export		_main

	DUART        = $CF30
	DUARTMRA     = DUART
	DUARTSRA     = DUART+$1
	DUARTCSRA    = DUART+$1
	DUARTCRA     = DUART+$2
	DUARTRXA     = DUART+$3
	DUARTTXA     = DUART+$3
	DUARTIPCR    = DUART+$4
	DUARTACR     = DUART+$4
	DUARTISR     = DUART+$5
	DUARTIMR     = DUART+$5
	DUARTCTU     = DUART+$6
	DUARTCTPU    = DUART+$6
	DUARTCTL     = DUART+$7
	DUARTCTPL    = DUART+$7
	DUARTMRB     = DUART+$8
	DUARTSRB     = DUART+$9
	DUARTCSRB    = DUART+$9
	DUARTCRB     = DUART+$A
	DUARTRXB     = DUART+$B
	DUARTTXB     = DUART+$B
	DUARTIVEC    = DUART+$C
	DUARTIPR     = DUART+$D
	DUARTSOPR    = DUART+$E
	DUARTROPR    = DUART+$F

.segment	"RODATA"

S0001:
	.byte	"Ahoj zdravi Vas P65 a test klavesnice!!"
S0002:
	.byte	"Ted muzes zacit psat"


.segment	"CODE"
_main:
	lda     #<(S0001)
	ldx     #>(S0001)
	jsr     _PRNTLN
	lda     #<(S0002)
	ldx     #>(S0002)
	jsr     _PRNTLN
	jsr     _PRNL
	JSR DUARTINIT

print:	JSR _CHRIN
				JSR DUARTTX
				JSR _CHROUT
				JMP print


	DUARTINIT:  LDA #$B0          ; Reset MRA Pointer to $00
	            STA DUARTCRA
	            LDA #$C9          ; Enable RX Watchdog, RX Interrupt level 16 bytes, 16 byte FIFO, Baud Extended mode I
	            STA DUARTMRA
	            LDA #$D3          ; Enable RX controlled RTS, RX Interrupt level 16 bytes, No parity, 8 Bits per character
	            STA DUARTMRA
	            LDA #$01
	            STA DUARTSOPR
	            ;LDA #$07          ; Enable TX CTS Control, 1 Stop Bit
	            ;STA DUARTMRA
	            LDA #$60          ; Set timer mode external clock x1
	            STA DUARTACR
	            LDA #$CC          ; Set TX/RX Baud to 250 000
	            STA DUARTCSRA
	            ;LDA #$0A          ; Enable Timer/RxRDYA Interrupts
	            ;STA DUARTIMR
	            ;LDA #$24          ; 100hz interval for Timer
	            ;STA DUARTCTPU
	            ;STZ DUARTCTL
	            ;LDA DUARTSOPR     ; Start timer
	            LDA #$05
	            STA DUARTCRA      ; Enable TX/RX on Channel A
	            LDA #$0A
	            STA DUARTCRB      ; Disable TX/RX on Channel B
							RTS

DUARTTX:    PHA
            LDA DUARTSRA
            AND #$04
            BEQ DUARTTX+1
            PLA
            STA DUARTTXA
						RTS
