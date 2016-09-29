![Unsupported](https://img.shields.io/badge/development_status-in_progress-green.svg) ![License GPLv3](https://img.shields.io/badge/license-GPLv3-green.svg)

yamms
====

[Y]et [A]nother [M]atrix [S]hell [S]cript

Usage
----

<pre><code>

NAME
    yamss.sh - matrix like shell script

SYNOPSIS
    yamss.sh [OPTION]...

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
            Default is 37 (white)
    -k
            This option sets kanji font.
            Default is disabled

    -m [number]
            This option sets the main color according to
            the color chart below.
            Default is 34 (blue)

    -s [number]
            This option sets drop speed.
            Range is from 1 (fastest ) to 10 ( slowest )
            Default is 1

COLOR CHART
    30      Black
    31      Red
    32      Green
    33      Yellow
    34      Blue
    35      Magenta
    36      Cyan
    37      White

</code></pre>

Requirements
----

- Bash (https://www.gnu.org/software/bash/)
- GNU Awk (https://www.gnu.org/software/gawk/)


License and Author
----

Author:: Cesar Bodden (cesar@pissedoffadmins.com)

Copyright:: 2016, Pissedoffadmins.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
