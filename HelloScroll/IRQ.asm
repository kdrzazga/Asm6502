//for KickAssembler
BasicUpstart2(setupResident)

.const STANDARD_IRQ = $ea31
.const GETIN  =  $ffe4
.const SCNKEY =  $ff9f
.const SPACE = 32
.const SOFT_RESET = $fce2
.const BACKGROUND_DELAY = 30

	*=$950
setupResident: 	{
	sei
	lda #<irq2
	sta $0314
	lda #>irq2
	sta $0315
	cli
	rts
irq2:

	ldx #$00
loop:
	lda tekst,x
	cmp endTekst
	beq excuteStandardIrq
	sta $0400,x
	inx	
	jmp loop
		
excuteStandardIrq:
	jmp STANDARD_IRQ

changeBackground:
	//ldy #BACKGROUND_DELAY
	inc $d020
	jmp loop	
quit:
	jmp SOFT_RESET		
	
tekst: .text "krzychu was here"
endTekst: .byte $fe
}