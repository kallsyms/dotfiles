#!/bin/sh

TMPBG='/tmp/screen.png'
scrot ${TMPBG}
convert ${TMPBG} -scale 5% -scale 2000% ${TMPBG}

B='00000000'  # blank
V='008800bb'  # verifying
W='880000bb'  # wrong

D='00000088'  # default ring
T='ffffffff'  # text

i3lock                    \
    -i ${TMPBG}           \
    --ringver-color=$V     \
    --ringwrong-color=$W   \
    \
    --inside-color=$D      \
    --ring-color=$D        \
    --line-color=$B        \
    --separator-color=$D   \
    \
    --verif-color=$T       \
    --wrong-color=$T       \
    --layout-color=$T      \
    --time-color=$T        \
    --date-color=$T        \
    --keyhl-color=$V       \
    --bshl-color=$W        \
    \
    --clock               \
    --indicator           \
    --time-str="%H:%M:%S"  \
    --date-str="%a, %d %b %Y" \
    \
    --ignore-empty-password \
    --show-failed-attempts
