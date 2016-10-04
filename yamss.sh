#!/usr/bin/env bash
#===============================================================================
#
#          FILE: yamss.sh
#
#         USAGE: ./yamss.sh
#
#   DESCRIPTION: [Y]et [A]nother [M]atrix [S]hell [S]cript.
#                This script shows a matrix like display in terminal.
#       OPTIONS: -c [num], -d, -h [num], -m [num], -q [let], -r, -s [num]
#  REQUIREMENTS: bash, gnu awk, gnu bc
#          BUGS: they will be discovered at random times
#         NOTES: https://en.wikipedia.org/wiki/ANSI_escape_code
#        AUTHOR: Cesar Bodden (), cesar@pissedoffadmins.com
#  ORGANIZATION: pissedoffadmins.com
#       CREATED: 09/29/2016 05:14:34 PM EDT
#      REVISION: 9
#===============================================================================

## globals that can be changed
CHARS="1"               ## default characters to use
MN_CLR="34"             ## default main color
HL_CLR="37"             ## default highlight color
SLEEP="0.1"             ## default sleep interval
QUIT_LET="q"            ## default quit / kill letter
RNBW_MODE="false"       ## default rainbow mode
## end of globals

##########################################
## below this nothing should be changed ##
##########################################

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))

## on ctrl c - reset term and clear screen
trap 'echo -e "\033[2J" ; exit' 1 2 3 9 15

function main()
{
    ROW=$(tput lines)   ## total number of lines in term
    COL=$(tput cols)    ## total number of columnes in term

    ## \033 clear entire screen (ED)
    ## \033 hides the cursor (DECTCEM)
    printf "%b" \
        "\033[2J" \
        "\033[?25l"

    ## set character type
    case "${CHARS}" in
        '1')
            ## regular characters
            declare -g _LET=($(\
                awk 'BEGIN{for(i=49;i<126;i++)printf "%c\n",i}'))
            ;;
        '2')
            ## kanji
            declare -g _LET=($(\
                awk 'BEGIN{for(i=12032;i<12246;i++)printf "%c\n",i}'))
            ;;
        '3')
            ## not kanji
            declare -g _LET=($(\
                awk 'BEGIN{for(i=128;i<600;i++)printf "%c\n",i}'))
            ;;
        '4')
            ## blocks
            declare -g _LET=($(\
                awk 'BEGIN{for(i=9617;i<9620;i++)printf "%c\n",i}'))
    esac

    ## sleep time array
    declare -g _SLP=($(\
        seq .01 .01 ${SLEEP}))

    ## color array for rainbow mode
    declare -g _RNBW=($(\
        seq 30 1 37))
}

function loop()
{
    local _RND_COL=$(($RANDOM%$COL))                    ## random tput col
    local _RND_ROW=$(($RANDOM%$ROW))                    ## random tput line
    local _RND_SLP=${_SLP[RANDOM%${#_SLP[@]}]}          ## random sleep

    if [[ ${RNBW_MODE} == "true" ]]
    then
        MN_CLR=${_RNBW[RANDOM%${#_RNBW[@]}]}
        HL_CLR=${_RNBW[RANDOM%${#_RNBW[@]}]}
    fi

    ## count 1 - tput lines
    for _LINE in $(seq 1 ${ROW})
    do
        local INDEX=$(($RANDOM%${#_LET[*]}))            ## random letter index
        local _PRN_LET=$(printf "%s" "${_LET[$INDEX]}") ## print letter
        ## \033 CUP
        ## \033 SGR (color blue (34m)) letter
        ## \033 CUP
        ## \033 SGR (color white (37m)) letter
        printf "%b" \
            "\033[$(($_LINE-1));${_RND_COL}H" \
            "\033[${MN_CLR}m${_PRN_LET}" \
            "\033[${_LINE};${_RND_COL}H" \
            "\033[${HL_CLR}m"${_PRN_LET}
        sleep ${_RND_SLP}

        ## if i is >= random tput line
        if [[ ${_LINE} -ge ${_RND_ROW} ]]
        then
            ## Moves the cursor to row n, column m
            ## CUP – Cursor Position
            printf "%b" \
                "\033[$(($_LINE-$_RND_ROW));${_RND_COL}H "
        fi
    done

    ## count 1-(random tput line) - tput line
    for _RND_LINE in $(eval echo {$(($_RND_LINE-$_RND_ROW))..$ROW})
    do
        ## Moves the cursor to row n, column m
        ## HVP – Horizontal and Vertical Position
        printf "%b" \
            "\033[${_RND_LINE};${_RND_COL}f "
        sleep ${_RND_SLP}
    done
}

function run()
{
    {
        loop
    } & sleep ${SLEEP}
    read -t $(\
        echo "${SLEEP}/10" \
        | bc -l) -s -n 1 KILL
    if [[ ${KILL} == ${QUIT_LET} ]]
    then
        kill $(jobs -p)
        reset
        pkill -o -f "bash.*${PROGNAME}"
    fi
}

function usage()
{
    ## usage / description function
    clear
echo -e "
NAME
    ${PROGNAME} - matrix like shell script

SYNOPSIS
    ${PROGNAME} [OPTION]...

DESCRIPTION
    [Y]et [A]nother [M]atrix [S]hell [S]cript.
    This script shows a matrix like display in terminal.

OPTIONS
    -c [number]
            This option sets the characters used for display.
            Different characters listed in chart below.
            Default is standard (1).

    -d
            This option runs everything in default settings.
            This should be run by itself.

    -h [number]
            This option sets the highlite color according to
            the color chart below.
            Default is \033[37m37 (white)\033[0m

    -m [number]
            This option sets the main color according to
            the color chart below.
            Default is \033[34m34 (blue)\033[0m

    -q [letter]
            This option specifies what letter to use to quit
            out of this script instead of using ctrl + c.
            Default is q

    -r
            This option specifies rainbow road mode.
            All main and highlite colors will be random from
            the color chart below.
            Default is disabled

    -s [number]
            This option sets drop speed.
            Range is from 1 (fastest ) to 10 ( slowest )
            Default is 1

CHARACTER CHART
    Option [1]:
        Standard: 123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]
                  ^_abcdefghijklmnopqrstuvwxyz{|}

    Option [2]:
           Kanji: ⼀⼁⼂⼃⼄⼅⼆⼇⼈⼉⼊⼋⼌⼍⼎⼏⼐⼑⼒⼓⼔⼕
                  ⼖⼗⼘⼙⼚⼛⼜⼝⼞⼟⼠⼡⼢⼣⼤⼥⼦⼧⼨⼩⼪⼫
                  ⼬⼭⼮⼯⼰⼱⼲⼳⼴⼵⼶⼷⼸⼹⼺⼻⼼⼽⼾⼿⽀⽁
                  ⽂⽃⽄⽅⽆⽇⽈⽉⽊⽋⽌⽍⽎⽏⽐⽑⽒⽓⽔⽕⽖⽗
                  ⽘⽙⽚⽛⽜⽝⽞⽟⽠⽡⽢⽣⽤⽥⽦⽧⽨⽩⽪⽫⽬⽭
                  ⽮⽯⽰⽱⽲⽳⽴⽵⽶⽷⽸⽹⽺⽻⽼⽽⽾⽿⾀⾁⾂⾃
                  ⾄⾅⾆⾇⾈⾉⾊⾋⾌⾍⾎⾏⾐⾑⾒⾓⾔⾕⾖⾗⾘⾙
                  ⾚⾛⾜⾝⾞⾟⾠⾡⾢⾣⾤⾥⾦⾧⾨⾩⾪⾫⾬⾭⾮⾯
                  ⾰⾱⾲⾳⾴⾵⾶⾷⾸⾹⾺⾻⾼⾽⾾⾿⿀⿁⿂⿃⿄⿅
                  ⿆⿇⿈⿉⿊⿋⿌⿍⿎⿏⿐⿑⿒⿓⿔⿕

    Option [3]:
            Misc: ¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍ
                  ÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øù
                  úûüýþÿĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥ
                  ĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐő
                  ŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽ
                  žſƀƁƂƃƄƅƆƇƈƉƊƋƌƍƎƏƐƑƒƓƔƕƖƗƘƙƚƛƜƝƞƟƠơƢƣƤƥƦƧƨƩ
                  ƪƫƬƭƮƯưƱƲƳƴƵƶƷƸƹƺƻƼƽƾƿǀǁǂǃǄǅǆǇǈǉǊǋǌǍǎǏǐǑǒǓǔǕ
                  ǖǗǘǙǚǛǜǝǞǟǠǡǢǣǤǥǦǧǨǩǪǫǬǭǮǯǰǱǲǳǴǵǶǷǸǹǺǻǼǽǾǿȀȁ
                  ȂȃȄȅȆȇȈȉȊȋȌȍȎȏȐȑȒȓȔȕȖȗȘșȚțȜȝȞȟȠȡȢȣȤȥȦȧȨȩȪȫȬȭ
                  ȮȯȰȱȲȳȴȵȶȷȸȹȺȻȼȽȾȿɀɁɂɃɄɅɆɇɈɉɊɋɌɍɎɏɐɑɒɓɔɕɖɗ%

    Option [4]:
          Blocks: ░▒▓


COLOR CHART
    30      Black    \033[30mBlack\033[0m
    31      Red      \033[31mRed\033[0m
    32      Green    \033[32mGreen\033[0m
    33      Yellow   \033[33mYellow\033[0m
    34      Blue     \033[34mBlue\033[0m
    35      Magenta  \033[35mMagenta\033[0m
    36      Cyan     \033[36mCyan\033[0m
    37      White    \033[37mWhite\033[0m

    "
exit 0
}

## option selection
while getopts "c:dh:m:q:rs:" OPT
do
    case "${OPT}" in
        'c')
            CHARS=${OPTARG}
            ;;
        'd')
            true
            ;;
        'h')
            HL_CLR=${OPTARG}
            ;;
        'm')
            MN_CLR=${OPTARG}
            ;;
        'q')
            QUIT_LET=${OPTARG}
            ;;
        'r')
            RNBW_MODE="true"
            ;;
        's')
            SLEEP=$(echo "${OPTARG} / 10" | bc -l)
            ;;
        *)
            usage
            ;;
    esac
done
[ ${OPTIND} -eq 1 ] && { usage ; }
shift $((OPTIND-1))

main
while true
do
    run
done
