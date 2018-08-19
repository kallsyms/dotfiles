#!/bin/sh

B='#00000000'  # blank
D='#ffffffcc'  # default
T='#ffffffcc'  # text
W='#880000bb'  # wrong
V='#008800bb'  # verifying

i3lock                \
--ringvercolor=$V     \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--textcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--keyhlcolor=$V       \
--bshlcolor=$W        \
\
--screen 0            \
--blur 10             \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%a, %d %b %Y" \
