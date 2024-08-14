---
title: Informal Pseudocode Specification
toc: true
---

The language we use is a variant of the [Donkey
project](https://github.com/linxuanm/donkey)'s, which, in turn, is a
well-defined subset of IB Pseudocode.

## General information

* Tokens are separated via operators or whitespace. Unnecessary whitespace is
  ignored. In this context, whitespaces are tabs (U+0009) or spaces (U+0020).
* Statements are separated by line feeds (U+000A).
* On this page, regular expressions are [POSIX extended regular
  expressions](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap09.html).
  (We might switch to [ABNF](https://www.rfc-editor.org/rfc/rfc5234.txt) in the
  future.)

## Comments
* Block comments begin with `/*` and end with `*/`.
* Inline comments begin with `//` until a line feed.
* Comment characters, as specified above, are ignored in string literals.

## Data representation and types

Since IB Pseudocode is dynamically typed, all values are basically a tagged
union. See `types.h` for details.

Variables are not declared; they are automatically "declared" when assigned to.

All variables *should* be capitalized, but this is not enforced.

### Simple types

All simple types are passed by value (even strings).

| Type    | Description             | Implementation                                | Literal form         |
| ----    | -----------             | --------------                                | ------------         |
| Integer | a whole number          | `long long`                                   | `-?[0-9]+` in base 10|
| Real    | a floating point number | `double`                                      | `-?[0-9]+\.[0-9]+`   |
| String  | an array of bytes       | a struct with a cap, a size, and `char *data` | `"[^"\n]*"`          |
| Boolean | a boolean               | `bool`                                        | <code>(true&vert;false)</code> |

Note that:
* There are limits to the size of integers and the precision of reals.
  We could have used [GNU MP](https://gmplib.org/) or similar libraries to
  support arbitrary precision integers and reals, but that's a bit too much of a
  hassle due to the amount of temporary variables needed to make GMP arithmetic
  functions work. Patches welcome, though!
  * `long long` is `int64_t` on many systems.
  * `double` is IEEE 754 binary64 on virtually all systems.

### Compound types

All compound types are passed by reference.

| Type  | Description                                | Implementation        | Literal form                              |
| ----  | -----------                                | --------------        | ------------                              |
| List  | an ordered container for a group of values | a linked list         | `\[\v\s*(,\s*\v\s*)*\]` where `\v` is any value |
| Stack | a FILO                                     |                       |                                           |
| Queue | a FIFO                                     |                       |                                           |

Stacks and queues are a distant target to implement.

## Type conversion functions

* **`int(X)`** converts `X` to an integer.
  * If `X` is a boolean, `0` or `1` is returned.
  * If `X` is an integer, it is returned.
  * If `X` is a real, it is floored and an integer is returned.
  * If `X` is a string, `strtoll` is used to convert the string to an integer.
    Base-10 is assumed.
* **`real(X)`** converts `X` to a real.
  * If `X` is a boolean, `0.0` or `1.0` is returned.
  * If `X` is an integer, it is cast to a real and returned.
  * If `X` is a real, it is returned.
  * If `X` is a string, `strtod` is used to convert it into a real. Base-10 is
    assumed.
* **`str(X)`** converts `X` to a string.
  * If `X` is a boolean, `"false"` or `"true"` is returned.
  * If `X` is an integer or real, it is converted to a string with `sprintf`.
  * If `X` is a list, the list is traversed and each item is recursively
    converted to a string, and the result is concatenated with `, ` between each
    item, `{ ` is prepended, and ` }` is appended. Specially, any items that are
    strings are wrapped in `"`.
  * If `X` is a string, it is returned.

## Input and output

* **`input X`** reads one line of standard input, terminated by a line feed, and
  stores the results as a string in `X`. `X` may or may not be previously
  defined.
* **`output`** could take one or more arguments:
  * **`output X`** causes X to be converted to a string and written to standard
    output.
  * **`output \v\s*(,\s*\v\s*)*`**, where `\v` represents any value, causes all
    of the arguments to be converted to strings, concatenated, and written to
    standard output.

## Arithmetic operations

* **`A + B`** evaluates to the sum of `A` and `B`, where `A` and `B` are
  integers or reals.
  * If both are of the same type, their original type is returned.
  * If one is an integer but another is a real, the return type is a real.
* **`A - B`** evaluates to difference between `A` and `B` by subtracting `B`
  from `A`, where `A` and `B` are integers or reals.
  * If both are of the same type, their original type is returned.
  * If one is an integer but another is a real, the return type is a real.
  * This may also be used as an unary operator that simply negates B.
* **`A * B`** evaluates to the product of `A` and `B`, where `A` and `B` are
  integers or reals.
  * If both are of the same type, their original type is returned.
  * If one is an integer but another is a real, the return type is a real.
* **`A / B`** evaluates to the quotient of `A` divided by `B`, where `A` and `B`
  are integers or reals. A real is returned.
* **`A div B`** evaluates to the quotient of `A` divided by `B`, where `A` and
  `B` are integers or reals. A floored integer is returned.
* **`A mod B`** or **`A % B`** evaluates to the modulus of `A` divided by `B`,
  where `A` and `B` are integers or reals. An integer is returned.

The behavior of division functions (`/`, `div`, and `mod`) is undefined when the
divisor is zero. (Generally speaking, they cause SIGFPE on amd64 and evaluate to
0 on aarch64, though the underlying C compiler may have optimizations that
change this. Divison by zero is not recommended as doing so might create
[nasal demons](http://www.catb.org/jargon/html/N/nasal-demons.html).)

## Comparison operators

All comparison operators evaluate to booleans.

| Form | Description |
| -------- | ----------- |
|`A == B`|A is equal to B|
|`A != B`|A is not equal to B|
|`A < B`|A is strictly less than B|
|`A <= B`|A is less than or equal to B|
|`A > B`|A is strictly greater than B|
|`A >= B`|A is greater than or equal to B|

* `==` and `!=` work on simple types.
* `<`, `<=`, `>`, and `>=` only work on integers and reals. Integers and reals
  may be compared with each other.

## Operator precedence

<!-- vim: tw=80 nowrap
     Copyright (c) 2024 Runxi Yu
     Copyright (c) 2024 Runxi Yu
-->
