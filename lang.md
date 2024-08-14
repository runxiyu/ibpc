# Informal Pseudocode Specification

The language we use is a variant of the [Donkey
project](https://github.com/linxuanm/donkey)'s, which, in turn, is a
well-defined subset of IB Pseudocode.

## General information

* Tokens are separated via operators or whitespace. Unnecessary whitespace is
  ignored. In this context, whitespaces are tabs (U+0009) or spaces (U+0020).
* Statements are separated by line feeds (U+000A).

## Data representation and types

Since IB Pseudocode is dynamically typed, all values are basically a tagged
union:
```c
struct ibpc_value {
	enum ibpc_type_id type;
	union ibpc_type value;
};
```

### Simple types

| Type    | Description             | Implementation                                | Literal form       |
| ----    | -----------             | --------------                                | ------------       |
| Integer | a whole number          | [GNU GMP](https://gmplib.org) `mpz_t`         | `-?[0-9]+`         |
| Real    | a floating point number | GNU GMP `mpq_t`                               | `-?[0-9]+\.[0-9]+` |
| String  | an array of bytes       | a struct with a cap, a size, and `char *data` | `"[^"]*"`          |
| Boolean | a boolean               | `bool`                                        | <code>(true&vert;false)</code> |

### Compound types

| Type  | Description                                | Implementation        | Literal form                              |
| ----  | -----------                                | --------------        | ------------                              |
| List  | an ordered container for a group of values | a linked list         | `\[\v(,\s*\v)*\]` where `\v` is any value |
| Stack | a FILO                                     | a linked list         |                                           |
| Queue | a FIFO                                     | a linked list         |                                           |

<!-- vim: tw=80 nowrap
-->
