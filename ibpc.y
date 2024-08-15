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

extern int yylex();
void yyerror(const char *s);
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

%%

program:
	program statement
	| statement
	;

statement:
	expression NEWLINE
	| assignment NEWLINE
	| control_flow NEWLINE
	| io_statement NEWLINE
	| function_definition
	;

assignment:
	IDENTIFIER ASSIGN expression
	;

expression:
	INTEGER_LIT
	| REAL_LIT
	| STRING_LIT
	| TRUE
	| FALSE
	| NULL_LIT
	| IDENTIFIER
	| expression PLUS expression
	| expression MINUS expression
	| expression TIMES expression
	| expression DIV expression
	| expression INTEGER_DIV expression
	| expression MOD expression
	| expression MOD_OP expression
	| expression EQ expression
	| expression NEQ expression
	| expression LT expression
	| expression LEQ expression
	| expression GT expression
	| expression GEQ expression
	| expression AND expression
	| expression OR expression
	| NOT_OP expression
	| LPAREN expression RPAREN
	;

control_flow:
	if_statement
	| loop_statement
	;

if_statement:
	IF expression THEN statement_list END IF
	| IF expression THEN statement_list ELSE statement_list END IF
	;

loop_statement:
	LOOP WHILE expression statement_list END LOOP
	| LOOP UNTIL expression statement_list END LOOP
	| LOOP IDENTIFIER FROM expression TO expression statement_list END LOOP
	;

statement_list:
	statement_list statement
	| statement
	;

io_statement:
	INPUT IDENTIFIER
	| OUTPUT expression
	;

function_definition:
	FUNC IDENTIFIER LPAREN parameter_list RPAREN statement_list END IDENTIFIER
	;

parameter_list:
	IDENTIFIER
	| parameter_list COMMA IDENTIFIER
	;

%%

void yyerror(const char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
	return yyparse();
}
