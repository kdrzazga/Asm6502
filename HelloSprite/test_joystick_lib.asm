Incasm "runner_from_basic.asm"

main
*=2069
loop
          jsr            read_joy1_state
          jsr            take_action_according_to_joy1_state          

on_no_joy_operation
          lda #$20
          sta $0400

          jmp loop

on_joy_up
          lda U
          sta $0400
          jmp loop

on_joy_down
          lda D
          sta $0400
          jmp loop

on_joy_left
          lda L
          sta $0400
          jmp loop

on_joy_right
          lda R
          sta $0400   
          jmp loop

on_joy_fire
          lda F
          sta $0400   
          jmp loop

U       text "u"
D       text "d"
L       text "l"
R       text "r"
F       text "f"

Incasm "joystick_lib.asm"
Incasm "colors_lib.asm"
