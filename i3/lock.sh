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
    --ringvercolor=$V     \
    --ringwrongcolor=$W   \
    \
    --insidecolor=$D      \
    --ringcolor=$D        \
    --linecolor=$B        \
    --separatorcolor=$D   \
    \
    --verifcolor=$T       \
    --wrongcolor=$T       \
    --layoutcolor=$T      \
    --timecolor=$T        \
    --datecolor=$T        \
    --keyhlcolor=$V       \
    --bshlcolor=$W        \
    \
    --clock               \
    --indicator           \
    --timestr="%H:%M:%S"  \
    --datestr="%a, %d %b %Y" \
    \
    --ignore-empty-password \
    --show-failed-attempts
