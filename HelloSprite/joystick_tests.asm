Incasm "runner_from_basic.asm"

main
*=2062
loop
          jsr            read_joy1_state
          jsr            take_action_according_to_joy1_state          

on_no_joy_operation
          lda #$20
          sta $0400

          jmp loop

on_joy_up
          lda #$d5
          sta $0400
          jmp loop

on_joy_down
          lda #$c4
          sta $0400
          jmp loop

on_joy_left
          lda #$cc
          sta $0400
          jmp loop

on_joy_right
          lda #$d2
          sta $0400   
          jmp loop

on_joy_fire
          lda #$d3
          sta $0400   
          jmp loop


Incasm "joystick.asm"
Incasm "colors_lib.asm"