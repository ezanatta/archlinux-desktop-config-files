#!/bin/bash

## dzen stuff
FG='#E8E8E8'
BG='#000000'
FONT="-*-terminus-normal-*-*-*-14-*-*-*-*-*-*-*"

function uniq_linebuffered() {
   awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

{
   conky -c ~/.conky/statusbar | while read -r; do
      echo -e "conky $REPLY";
      #break
   done > >(uniq_linebuffered) &
   childpid=$!
   herbstclient --idle
   kill $childpid
} | {
   TAGS=( $(herbstclient tag_status mainext) )
      conky=""

      while true; do
         for i in "${TAGS[@]}" ; do
            echo -n "^ca(1,herbstclient use ${i:1})"
            case ${i:0:1} in
                                        '%')
             #echo -n "  ^bg(#178FD1) ^bg(#c3c3cc)^fg(#0A0A0A)  ➜ ${i:1}  ^bg(#178FD1) ^bg(#0A0A0A)"
               ;;
                          '-')
             #echo -n "  ^bg(#178FD1) ^bg(#c3c3cc)^fg(#0A0A0A)  ➜ ${i:1}  ^bg(#178FD1) ^bg(#0A0A0A)"
               ;;
'#')
   echo -n "  ^bg(#000000) ^bg(#000000)^fg(#E8E8E8)  ➜ ${i:1}  ^bg(#000000) ^bg(#000000)"
   ;;
':')
   echo -n "  ^bg(#000000) ^bg(#000000)^fg(#E8E8E8)  ${i:1}  ^bg(#000000) ^bg(#000000)"
   ;;
'!')
   echo -n "  ^bg(#000000) ^bg(#000000)^fg(#E8E8E8)  • ${i:1}  ^bg(#000000) ^bg(#000000)"
   ;;
*)
     echo -n "  ^bg(#000000) ^bg(#000000)^fg(#E8E8E8)  ${i:1}  ^bg(#000000) ^bg(#000000)"
   ;;


            esac
            echo -n "^ca()"
        done
        echo
        read line || break
        cmd=( $line )
   case "$cmd[0]" in
               tag*)
                  TAGS=( $(herbstclient tag_status mainext) )
                  ;;
               esac
     done
} 2> /dev/null | dzen2 -ta c -x 1920 -y 743 -h 25 -w 1368 -fg $FG -bg $BG -fn $FONT -title-name dzenext -e 'button2=;' &
