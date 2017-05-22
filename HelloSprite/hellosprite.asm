Incasm "runner_from_basic.asm"

main
*= 2062
          jsr            set_colors
          jsr            CLRSCR_ROUTINE_PTR
          jsr            print_message     
          jsr            enable_sprite                                

mainloop
          jsr            exit_if_key_X
          jsr            read_joy1_state
          jsr            take_action_according_to_joy1_state

on_joy_up
on_joy_down
on_joy_left
on_joy_right
on_no_joy_operation
          lda            OPEN_MOUTH_SPRITE_BLOCK_NUMBER
          jmp            set_sprite

on_joy_fire
          lda            CLOSED_MOUTH_SPRITE_BLOCK_NUMBER

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
  
Incasm "joystick.asm"

MESSAGE
          text           "Hold Joy1 fire to open mouth            "
          text           "Press "

EXIT_KEY
          text           "x"          
          text           " to exit                         "

STRING_TERMINATION
          text           "$";don't repeat this char within the message



print_message
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

Incasm "colors_lib.asm" 

exit_if_key_X
          jsr            READKEY_ROUTINE_PTR
          cmp            EXIT_KEY  
          beq            exit      
          rts
exit
          brk

ENABLED   = #$01
DOWN_RIGHT_DIR = #$00
UP_LEFT_DIR = #$01
CLRSCR_ROUTINE_PTR = $e544
READKEY_ROUTINE_PTR = $ffe4

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
          byte           0               ; direction:0 = down-right, 1 =up-left



Incasm "sprite_data.asm"