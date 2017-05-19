runner_from_basic

*=$0801

          WORD           $0a08 ;signature
          WORD           $cafe ;line number 51966
          BYTE           $9e ;SYS command
          BYTE           $32, $30, $36, $32;ASCII FOR "2062" ( =$080e)
          BYTE           $00

main
*=$080e
          jsr            set_colors
          jsr            CLRSCR_ROUTINE_PTR
          jsr            print     
          jsr            enable_sprite                                

mainloop
          jsr            exit_if_key_X
          jsr            read_joy1_fire

          lda            #$00      
          cmp            FIRE_PRESSED
          beq            open_mouth

          lda            CLOSED_MOUTH_SPRITE_BLOCK_NUMBER
          jmp            set_sprite
open_mouth
          lda            OPEN_MOUTH_SPRITE_BLOCK_NUMBER
set_sprite
          sta            SPRITE1_PTR; set pointer: sprite data at $2000

          lda            RASTER_BEAM_PTR
          cmp            #$ff      ; is raster beam at line $ff?
          bne            mainloop  ; no: go to mainloop
          lda            DIR       
          beq            down      ; if 0, down
up
          ldx            COORD     
          dex
          stx            COORD     
          stx            SPRITE_X_PTR
          stx            SPRITE_Y_PTR
          cpx            MAX_COORD 
          bne            mainloop  
          lda            DOWN_RIGHT_DIR
          sta            DIR       
          jmp            mainloop  
down
          ldx            COORD     
          inx
          stx            COORD     
          stx            SPRITE_X_PTR
          stx            SPRITE_Y_PTR
          cpx            MIN_COORD 
          bne            mainloop  
          lda            UP_LEFT_DIR
          sta            DIR       
          jmp            mainloop  

MESSAGE
          text           "Hold Joy1 fire to open mouth            "
          text           "Press "

EXIT_KEY
          text           "x"          
          text           " to exit                         "

STRING_TERMINATION
          text           "$";don't repeat this char within the message

print
          ldx            #$00      
loop      lda            MESSAGE,x
          cmp            STRING_TERMINATION
          beq            end_print 
          and            #$3f      
          sta            TXT_SCREEN_PTR,x
          inx
          jmp            loop      
end_print
          rts

enable_sprite
          lda            ENABLED   
          sta            SPRITE_ENABLING_PTR; Turn sprite  on
          lda            LIGHT_GRAY
          sta            SPRITE_COLOR_PTR
          lda            COORD     
          sta            SPRITE_X_PTR
          sta            SPRITE_Y_PTR
          rts

set_colors
          lda            BLACK     
          sta            BORDER_COLOR_PTR
          sta            BACKGROUND_COLOR_PTR

          lda            YELLOW    
          sta            TXT_COLOR_PTR

          rts

read_joy1_fire
          lda            JOY1_PTR  
          ora            FIRE_PRESSED_MASK
          cmp            #$ff      
          beq            set_fire_pressed
clr_fire_pressed
          lda            #00       
          sta            FIRE_PRESSED
          rts
set_fire_pressed
          lda            #01       
          sta            FIRE_PRESSED
          rts

exit_if_key_X
          jsr            READKEY_ROUTINE_PTR
          cmp            EXIT_KEY  
          beq            exit      
          rts
exit
          brk


BLACK     = #$00
WHITE     = #$01
GRAY      = #$02
LIGHT_GRAY = #$0F
YELLOW    = #$07
ENABLED   = #$01
DOWN_RIGHT_DIR = #$00
UP_LEFT_DIR = #$01
CLRSCR_ROUTINE_PTR = $e544
READKEY_ROUTINE_PTR = $ffe4
BORDER_COLOR_PTR = $d020
BACKGROUND_COLOR_PTR = $d021
TXT_COLOR_PTR = $0286
TXT_SCREEN_PTR = $0400
JOY2_PTR  = $dc00
JOY1_PTR  = $dc01
FIRE_PRESSED_MASK = #$ef                   ;bit 5 of JOY1_PTR is fire -> mask=11101111
RASTER_BEAM_PTR = $d012
SPRITE_ENABLING_PTR = $d015
SPRITE_COLOR_PTR = $d027
SPRITE_X_PTR = $d000
SPRITE_Y_PTR = SPRITE_X_PTR +1
SPRITE1_PTR= $07f8
MAX_COORD = #$40
MIN_COORD = #$e0



COORD
          byte           $40             ; current x and y coordinate
DIR
          byte           0               ; direction: 0 = down-right, 1 = up-left
FIRE_PRESSED
          byte           0               ; 0 - recently not pressed, 1 = recently pressed

OPEN_MOUTH_SPRITE_BLOCK_NUMBER = #$80                   ; block size = $40   $2000/$40 = $80
*=$2000
SPRITE_OPEN_MOUTH_DATA
          BYTE           $00,$00,$00
          BYTE           $00,$3F,$80
          BYTE           $00,$C0,$60
          BYTE           $01,$00,$10
          BYTE           $02,$00,$10
          BYTE           $04,$70,$20
          BYTE           $08,$E0,$40
          BYTE           $08,$01,$80
          BYTE           $10,$02,$00
          BYTE           $30,$04,$00
          BYTE           $20,$08,$00
          BYTE           $20,$18,$00
          BYTE           $20,$07,$00
          BYTE           $20,$00,$C0
          BYTE           $10,$00,$20
          BYTE           $10,$00,$10
          BYTE           $08,$00,$08
          BYTE           $04,$00,$04
          BYTE           $02,$00,$18
          BYTE           $01,$01,$E0
          BYTE           $00,$FE,$00

CLOSED_MOUTH_SPRITE_BLOCK_NUMBER = #$81                   ; block size = $40   $2040/$40 = $81
*=$2040
SPRITE_CLOSED_MOUTH_DATA
          BYTE           $00,$00,$00
          BYTE           $00,$3F,$80
          BYTE           $00,$C0,$60
          BYTE           $01,$00,$10
          BYTE           $02,$00,$10
          BYTE           $04,$70,$08
          BYTE           $08,$E0,$08
          BYTE           $08,$00,$0C
          BYTE           $10,$00,$04
          BYTE           $30,$00,$04
          BYTE           $20,$07,$84
          BYTE           $20,$18,$78
          BYTE           $20,$0F,$00
          BYTE           $20,$01,$F8
          BYTE           $10,$00,$08
          BYTE           $10,$00,$08
          BYTE           $08,$00,$10
          BYTE           $04,$00,$20
          BYTE           $02,$00,$C0
          BYTE           $01,$01,$00
          BYTE           $00,$FE,$00


