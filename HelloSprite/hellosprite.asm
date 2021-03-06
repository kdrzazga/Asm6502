Incasm "runner_from_basic.asm"

main
*= 2069
          jsr            set_colors
          jsr            CLRSCR_ROUTINE_PTR          
          jsr            print_message     
          jsr            enable_sprite  
          jsr            set_mine                                

mainloop
          jsr            exit_if_key_X
          jsr            check_sprite1_collision
          jsr            read_joy1_state
          jsr            take_action_according_to_joy1_state

on_joy_up
on_joy_down
on_joy_left
on_joy_right
on_no_joy_operation
          lda            CLOSED_MOUTH_SPRITE_BLOCK_NUMBER
          jmp            set_sprite

on_joy_fire
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


Incasm "joystick_lib.asm"
Incasm "print_at.asm"
Incasm "sprite.asm"
Incasm "colors_lib.asm" 

on_sprite1_bkgd_coll
          lda            OPEN_MOUTH_SPRITE_BLOCK_NUMBER
          jmp            set_sprite

set_mine
          lda           MINE
          ldx           MINE_OFFSET
          sta           TXT_SCREEN_BLOCK3,x
          rts

exit_if_key_X
          jsr            READKEY_ROUTINE_PTR
          cmp            EXIT_KEY  
          beq            exit      
          rts
exit
          brk


DOWN_RIGHT_DIR = #$00
UP_LEFT_DIR = #$01
CLRSCR_ROUTINE_PTR = $e544
READKEY_ROUTINE_PTR = $ffe4

RASTER_BEAM_PTR = $d012

MAX_COORD = #$40
MIN_COORD = #$e0

MINE     text "_"
MINE_OFFSET     byte 16

COORD
          byte           $40             ; current x and y coordinate
DIR
          byte           0               ; direction:0 = down-right, 1 =up-left

Incasm "sprite_data.asm"
