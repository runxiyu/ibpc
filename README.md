# IBDP Computer Science Pseudocode Utilities

There is nothing real here yet, since the school year hasn't even started. You
could expect this repository to be populated within the next one or two years.

This is written for the syllabus assessed from 2014 to 2026. Assessments in
2027 and later are beyond the scope of this project.

[Linxuan Ma](https://github.com/linxuanm) previously created a [pseudocode IDE
in JavaScript](https://github.com/linxuanm/donkey). I see the need for a
IB Pseudocode compiler and debugging environment, but modern Web technology is
inaccessible in my usual workflow. Therefore, I've set out to create a
pseudocode compiler with much simpler technology, namely:

* [POSIX lex](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/lex.html)
  for lexing
* [POSIX yacc](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/yacc.html)
  for parsing
* Either [QBE](https://c9x.me/compile) as a compiler backend, or transpile to
  either [Hare](https://harelang.org) or POSIX-compliant C (or, if I'm really in
  a rush, [Lua](https://lua.org) or [CHICKEN Scheme](https://www.call-cc.org/))
* Preferrably, the ability to use standard debugging environments like
  [GDB](https://sourceware.org/gdb/) and [rr](https://rr-project.org/)

<!-- vim: tw=80
-->

