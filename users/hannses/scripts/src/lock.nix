{ theme, ... }: ''
    swaylock \
  --screenshots \
  --clock \
  --indicator \
  --indicator-radius 100 \
  --indicator-thickness 7 \
  --effect-blur 7x10 \
  --effect-vignette 0.5:0.5 \
  --ring-color ${theme.color_second} \
  --key-hl-color ${theme.color_second} \
  --text-color ${theme.color_first} \
  --line-color 00000000 \
  --inside-color 00000088 \
  --separator-color 00000000 \
  --text-ver "..." \
  --fade-in 0.3
  # key-hl-color = indicator-color on clicked
''

