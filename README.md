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
  for lexing.
* [POSIX yacc](https://pubs.opengroup.org/onlinepubs/9799919799/utilities/yacc.html)
  for parsing.
* Transpile to or POSIX-compliant C.
  a rush, [Lua](https://lua.org) or [CHICKEN Scheme](https://www.call-cc.org/))
* ~~Preferrably, the ability to use standard debugging environments like
  [GDB](https://sourceware.org/gdb/) and [rr](https://rr-project.org/)~~   
  This is likely impossible as I'm transpiling to C rather than to QBE/LLVM IL.
  Some debugging primitives must then be added, such as the ability to print
  every line of code as they are executed.
* It should be able to run on musl Linux, glibc Linux, OpenBSD, and FreeBSD.
  macOS does not implement POSIX.1-2007 or later, but it should not be that hard
  to port to.

<!-- vim: tw=80
-->

