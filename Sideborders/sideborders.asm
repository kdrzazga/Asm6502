//for KickAssembler
BasicUpstart2(initProg)
.const screenControlRegister1 = $d011
.const rasterLineCell = $d012
.const screenControlRegister2 = $d016
.const pal = $02a6


	*=$825   
initProg:   sei
        
//Fix PAL, otherwise NTSC
        lda pal
        beq loop1
        lda #$49 // ie EOR #$xx (time 2 cycles)
        sta PALFIX


loop1:
        lda #$1b // Set y-scroll	to normal position (because we do FLD later on..)
        sta screenControlRegister1

        lda #$3d // Wait for position high up on the screen
        cmp rasterLineCell
        bne *-3

	lda rasterLineCell // Ugly way to get stable raster
	and #7
        ora #$18
        sta screenControlRegister1

        nop // Wait some cycles to make the loop work fine
        nop
        nop
        nop
	nop
	lda 0

	ldx #0 // Set 0 to counter
loop2:
        clc // Do FLD to avoid badlines
	lda rasterLineCell
	adc #4
	and #7
	ora #$18
	sta screenControlRegister1

	ldy #5 // Wait a	little
	dey
	bne *-1
PALFIX:  nop
	nop

        dec screenControlRegister2 // Set	38-chars width of screen -> remove sideborder
        inc screenControlRegister2 // Set	back to	40-chars

        inx // Increase counter
        cpx #$80
        bcc loop2 // Branch if counter less than	$80

        jmp loop1 // Next frame