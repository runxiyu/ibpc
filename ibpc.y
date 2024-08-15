/*
 * IB Pseudocode Parser
 *
 * Copyright (C) 2024  Runxi Yu <https://runxiyu.org>
 * SPDX-License-Identifier: AGPL-3.0-or-later
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

%{
#include "types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

extern int yylex();
void yyerror(const char *s);
void emit(const char *fmt, ...);

%}

%union {
	long long integer;
	double real;
	char *string;
	char *id;
}

%token <integer> INTEGER_LIT
%token <real> REAL_LIT
%token <string> STRING_LIT
%token <id> IDENTIFIER
%token NULL_LIT TRUE FALSE FUNC RETURN END IF ELSE THEN LOOP WHILE UNTIL FROM TO BREAK CONTINUE INPUT OUTPUT AND OR NOT NEWLINE ASSIGN LPAREN RPAREN COMMA

%left AND OR
%left EQ NEQ LT GT LEQ GEQ
%left PLUS MINUS
%left TIMES DIV INTEGER_DIV MOD MOD_OP
%right NOT_OP

%type <string> expression assignment_statement if_statement loop_statement statement_list io_statement function_definition parameter_list statement

%%

program:
	program statement
	| statement
	;

statement:
	expression_statement
	| assignment_statement
	| control_flow_statement
	| io_statement
	| function_definition
	;

expression_statement:
	expression NEWLINE { }
	;

assignment_statement:
	IDENTIFIER ASSIGN expression NEWLINE {
		emit("%s = %s;\n", $1, $3);
		free($1);
		free($3);
	}
	;

expression:
	INTEGER_LIT {
		char buffer[32];
		snprintf(buffer, sizeof(buffer), "%lld", $1);
		$$ = strdup(buffer);
	}
	| REAL_LIT {
		char buffer[32];
		snprintf(buffer, sizeof(buffer), "%lf", $1);
		$$ = strdup(buffer);
	}
	| STRING_LIT {
		$$ = strdup($1);
		free($1);
	}
	| TRUE {
		$$ = strdup("1");
	}
	| FALSE {
		$$ = strdup("0");
	}
	| NULL_LIT {
		$$ = strdup("NULL");
	}
	| IDENTIFIER {
		$$ = strdup($1);
	}
	| expression PLUS expression {
		asprintf(&$$, "%s + %s", $1, $3);
		free($1);
		free($3);
	}
	| expression MINUS expression {
		asprintf(&$$, "%s - %s", $1, $3);
		free($1);
		free($3);
	}
	| expression TIMES expression {
		asprintf(&$$, "%s * %s", $1, $3);
		free($1);
		free($3);
	}
	| expression DIV expression {
		asprintf(&$$, "%s / %s", $1, $3);
		free($1);
		free($3);
	}
	| LPAREN expression RPAREN {
		asprintf(&$$, "(%s)", $2);
		free($2);
	}
	;

control_flow_statement:
	if_statement
	| loop_statement
	;

if_statement:
	IF expression THEN statement_list END IF {
		emit("if (%s) {\n%s}\n", $2, $4);
		free($2);
		free($4);
	}
	| IF expression THEN statement_list ELSE statement_list END IF {
		emit("if (%s) {\n%s} else {\n%s}\n", $2, $4, $6);
		free($2);
		free($4);
		free($6);
	}
	;

loop_statement:
	LOOP WHILE expression statement_list END LOOP {
		emit("while (%s) {\n%s}\n", $3, $4);
		free($3);
		free($4);
	}
	| LOOP UNTIL expression statement_list END LOOP {
		emit("while (!(%s)) {\n%s}\n", $3, $4);
		free($3);
		free($4);
	}
	| LOOP IDENTIFIER FROM expression TO expression statement_list END LOOP {
		emit("for (long long %s = %s; %s <= %s; ++%s) {\n%s}\n",
			 $2, $4, $2, $6, $2, $7);
		free($2);
		free($4);
		free($6);
		free($7);
	}
	;

statement_list:
	statement_list statement {
		asprintf(&$$, "%s%s", $1, $2);
		free($1);
		free($2);
	}
	| statement {
		$$ = strdup($1);
		free($1);
	}
	;

io_statement:
	INPUT IDENTIFIER NEWLINE {
		emit("char buffer[1024];\nfgets(buffer, sizeof(buffer), stdin);\n%s = strdup(buffer);\n", $2);
		free($2);
	}
	| OUTPUT expression NEWLINE {
		emit("printf(\"%%s\", %s);\n", $2);
		free($2);
	}
	;

function_definition:
	FUNC IDENTIFIER LPAREN parameter_list RPAREN statement_list END IDENTIFIER {
		emit("void %s(%s) {\n%s}\n", $2, $4, $6);
		free($2);
		free($4);
		free($6);
	}
	;

parameter_list:
	IDENTIFIER {
		$$ = strdup($1);
	}
	| parameter_list COMMA IDENTIFIER {
		asprintf(&$$, "%s, %s", $1, $3);
		free($1);
		free($3);
	}
	;

%%

void yyerror(const char *s) {
	fprintf(stderr, "Error: %s\n", s);
}

void emit(const char *fmt, ...) {
	va_list args;
	va_start(args, fmt);
	vprintf(fmt, args);
	va_end(args);
}

int main(int argc, char **argv) {

	printf("#include <stdio.h>\n#include <stdlib.h>\n#include \"types.h\"\n\n");
	yyparse();
	
	return 0;
}
