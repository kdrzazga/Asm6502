enable_sprite
          lda            ENABLED   
          sta            SPRITE_ENABLING_PTR; Turn sprite  on
          lda            LIGHT_GRAY
          sta            SPRITE_COLOR_PTR
          lda            COORD     
          sta            SPRITE_X_PTR
          sta            SPRITE_Y_PTR
          rts

check_sprite1_collision
          lda SPRITE_BACKGRND_COLLISION_PTR     
          ora SPRITE1_BACKGRND_COLLISION_MASK
          cmp #$fe
          beq on_sprite1_bkgd_coll
          rts
          

ENABLED = #$01
SPRITE_ENABLING_PTR = $d015
SPRITE_COLOR_PTR = $d027
SPRITE_X_PTR = $d000
SPRITE_Y_PTR = SPRITE_X_PTR +1

SPRITE1_PTR= $07f8

SPRITE_BACKGRND_COLLISION_PTR = $d01f
SPRITE1_BACKGRND_COLLISION_MASK = %11111110
SPRITE_1_COLOR_PTR = $d027

