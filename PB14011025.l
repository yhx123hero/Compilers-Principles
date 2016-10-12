%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>

#define CREATOR 258
#define STRING  259
#define GRAPH   260
#define NODE    261
#define ID      262
#define NUMBER  263
#define LABEL   264
#define EDGE    265
#define SOURCE  266
#define TARGET  267
#define VALUE   268
#define Endinput 0


char Str[100][20];
char str_lex_val[64];
int num_lex_val;
int lines =0;
int snytax_error = 0;
int lookhead ;

%}
digit  [0-9]

number {digit}+

letter [a-zA-Z]

string  {letter}({letter}|{digit}|" "|":")*

%%
Creator {return CREATOR;}

[ \t\n]  {   }

graph  {return GRAPH;}

label  {return LABEL;}

edge   {return EDGE;}

source {return SOURCE;}

node   {return NODE;}

id    {return ID;}

target {return TARGET;}

value  {return VALUE;}


{number} { num_lex_val = atoi(yytext);	return NUMBER; }

\"{string}\"   {strcpy(str_lex_val,yytext); return STRING;}

. return yytext[0];
%%
/*

D-> CREATOR STRING GRAGH [ EF ]
E-> E'
E'-> NODE [ ID  number  LABEL STRING]E' |
F-> F'
F'->EDGE [ SOURCE number TARGET number VALUE number]F' | 
	
*/
void E_();
void E();
void F_();
void F();
void D();

int next_token()
{
    return yylex();
}


void error(char *msg)
{
     snytax_error=1;
     printf(msg);
}

void match (int t)
{
     if(snytax_error)  return ;
     if(lookhead == t)
     {
         lookhead=next_token();
     }
     else
     {
         error("\nmatch error\n");
     }
}



void D()
{
    if(lookhead == CREATOR)
    {      
         match(CREATOR);
         match(STRING);
		 match(GRAPH);
		 match('[');
         E();
		 F();
		 match(']');
    }
    else error("\ninput error\n");
}

void E()
{
    if(snytax_error)  return ;
    if (lookhead==NODE) 
      E_();
    
    
}

void E_()
{
    if(snytax_error)  return ;
    if(lookhead == NODE)
     {
          match(NODE);match('[');
          match(ID);match(NUMBER);
          match(LABEL);
          match(STRING);
          match(']');
          strcpy(Str[num_lex_val],str_lex_val);
          E_();
     }
  else if((lookhead==EDGE))
    {
    	return ;
    }
	else error("\n T needs NODE \n");
}

void F()
{
    if(snytax_error)  return ;
    if (lookhead==EDGE) 
      F_();
    
    
}

void F_()
{
     if(snytax_error) return ;
     if(lookhead == EDGE)
     {
	     int a,b,c;
         match(EDGE);match('[');
         match(SOURCE);match(NUMBER);
		 a=num_lex_val;
         match(TARGET);match(NUMBER);
		 b=num_lex_val;
         match(VALUE);match(NUMBER);
		 c=num_lex_val;
         match(']');
		 printf("Source:%s---->Target:%s\tValue:%d\n",Str[a],Str[b],c);
         F_();
} 
      else if(lookhead==']')
    {
    	return ;
    }
    else error("\n F needs EDGE \n"); 
}

int main()
{
	lookhead = next_token();
	D();
	return 0;
}
int yywrap()
{ return 1;}


