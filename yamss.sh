#!/usr/bin/env bash
#===============================================================================
#
#          FILE: yamss.sh
#
#         USAGE: ./yamss.sh
#
#   DESCRIPTION: [Y]et [A]nother [M]atrix [S]hell [S]cript.
#                This script shows a matrix like display in terminal.
#       OPTIONS: -d, -h [num], -k, -m [num], -s [num]
#  REQUIREMENTS: bash, gnu awk, gnu bc
#          BUGS: they will be discovered at random times
#         NOTES: https://en.wikipedia.org/wiki/ANSI_escape_code
#        AUTHOR: Cesar Bodden (), cesar@pissedoffadmins.com
#  ORGANIZATION: pissedoffadmins.com
#       CREATED: 09/29/2016 05:14:34 PM EDT
#      REVISION: 5
#===============================================================================

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
## on ctrl c - reset term and clear screen
trap 'reset ; exit' 1 2 3 9 15

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
    if [[ ${KANJI} == "true" ]]
    then
        ## kanji
        declare -g _LET=($(\
            awk 'BEGIN{for(i=12032;i<12246;i++)printf "%c\n",i}'))
    else
        ## not kanji
        declare -g _LET=($(\
            awk 'BEGIN{for(i=128;i<600;i++)printf "%c\n",i}'))
    fi
}

function loop()
{

    local _RND_COL=$(($RANDOM%$COL)) ## random tput col
    local _RND_ROW=$(($RANDOM%$ROW)) ## random tput line

    ## count 1 - tput lines
    for _LINE in $(seq 1 ${ROW})
    do
        local INDEX=$(($RANDOM%${#_LET[*]})) ## random letter index
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
        sleep ${SLEEP}

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
    # for _RND_LINE in $(eval echo {$(($_RND_LINE-$_RND_ROW))..$ROW})
    for _RND_LINE in $(eval echo {$(($_RND_LINE-$_RND_ROW))..$ROW})
    do
        ## Moves the cursor to row n, column m
        ## HVP – Horizontal and Vertical Position
        printf "%b" \
            "\033[${_RND_LINE};${_RND_COL}f "
        sleep ${SLEEP}
    done
}

function usage()
{
    clear
    ## full description
echo -e "
NAME
    ${PROGNAME} - matrix like shell script

SYNOPSIS
    ${PROGNAME} [OPTION]...

DESCRIPTION
    [Y]et [A]nother [M]atrix [S]hell [S]cript.
    This script shows a matrix like display in terminal.

OPTIONS
    -d
            This option runs everything in default settings.
            This should be run by itself.

    -h [number]
            This option sets the highlite color according to
            the color chart below.
            Default is \033[37m37 (white)\033[0m
    -k
            This option sets kanji font.
            Default is disabled

    -m [number]
            This option sets the main color according to
            the color chart below.
            Default is \033[34m34 (blue)\033[0m

    -s [number]
            This option sets drop speed.
            Range is from 1 (fastest ) to 10 ( slowest )
            Default is 1

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

## vars below can be changed
KANJI="false"
MN_CLR="34"
HL_CLR="37"
SLEEP="0.1"

## option selection
while getopts "dh:km:s:" OPT
do
    case "${OPT}" in
        'd')
            true
            ;;
        'h')
            HL_CLR=${OPTARG}
            ;;
        'k')
            KANJI="true"
            ;;
        'm')
            MN_CLR=${OPTARG}
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
    {
        loop
    } & sleep ${SLEEP}
    read -t ${SLEEP} -s -n 1 KILL
    if [[ ${KILL} == "q" ]]
    then
        pkill -o -f "bash.*${PROGNAME}"
    fi
done
