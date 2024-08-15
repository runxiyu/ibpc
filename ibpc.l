%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%

[ \t\r]+                               ;
\n                                     return NEWLINE;

"//".*                                 ;
"/*"([^*]*\*+([^/*][^*]*\*+)*)*"*/"    ;

"func"                                 return FUNC;
"return"                               return RETURN;
"end"                                  return END;
"if"                                   return IF;
"else"                                 return ELSE;
"then"                                 return THEN;
"loop"                                 return LOOP;
"while"                                return WHILE;
"until"                                return UNTIL;
"from"                                 return FROM;
"to"                                   return TO;
"break"                                return BREAK;
"continue"                             return CONTINUE;
"input"                                return INPUT;
"output"                               return OUTPUT;
"and"                                  return AND;
"or"                                   return OR;
"not"                                  return NOT;
"null"                                 return NULL_LIT;
"true"                                 return TRUE;
"false"                                return FALSE;

"=="                                   return EQ;
"!="                                   return NEQ;
"<="                                   return LEQ;
">="                                   return GEQ;
"<"                                    return LT;
">"                                    return GT;
"!"                                    return NOT_OP;
"="                                    return ASSIGN;
"\\+"                                  return PLUS;
"-"                                    return MINUS;
"\\*"                                  return TIMES;
"/"                                    return DIV;
"div"                                  return INTEGER_DIV;
"mod"                                  return MOD;
"%"                                    return MOD_OP;

"\\("                                  return LPAREN;
"\\)"                                  return RPAREN;

"-?[0-9]+"            { yylval.integer = atoll(yytext); return INTEGER_LIT; }
"-?[0-9]+\\.[0-9]+"   { yylval.real = atof(yytext); return REAL_LIT; }
"\"[^\"\n]*\""        { yylval.string = strdup(yytext); return STRING_LIT; }

[A-Z][A-Z0-9_]*       { yylval.id = strdup(yytext); return IDENTIFIER; }

%%

int yywrap() {
	return 1;
}
