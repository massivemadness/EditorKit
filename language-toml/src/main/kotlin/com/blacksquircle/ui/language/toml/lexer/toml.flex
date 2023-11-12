package com.blacksquircle.ui.language.toml.lexer;

@SuppressWarnings("all")
%%

%public
%class TomlLexer
%type TomlToken
%function advance
%unicode
%line
%column
%char

%{
  public final int getTokenStart() {
      return (int) yychar;
  }

  public final int getTokenEnd() {
      return getTokenStart() + yylength();
  }
%}

IDENTIFIER = [:jletter:] [:jletterdigit:]*
LINE_TERMINATOR = \r|\n|\r\n
WHITESPACE = {LINE_TERMINATOR} | [ \t\f]

DEC_INT = [-+]?(0|[1-9](_?[0-9])*) // no leading zeros
HEX_INT = 0x[0-9a-fA-F](_?[0-9a-fA-F])*
OCT_INT = 0o[0-7](_?[0-7])*
BIN_INT = 0b[01](_?[01])*
INTEGER = {DEC_INT}|{HEX_INT}|{OCT_INT}|{BIN_INT}

EXP = [eE]{DEC_INT}
FRAC = \.[0-9](_?[0-9])*
SPECIAL_FLOAT = [-+]?(inf|nan)
FLOAT = {DEC_INT}({EXP}|{FRAC}{EXP}?)|{SPECIAL_FLOAT}
NUMBER = {FLOAT}|{INTEGER}

DATE = [0-9]{4}-[0-9]{2}-[0-9]{2}
TIME = [0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]+)?
OFFSET = [Zz]|[+-][0-9]{2}:[0-9]{2}
DATE_TIME = ({DATE} ([Tt]{TIME})? | {TIME}) {OFFSET}?

BOOLEAN = true|false
COMMENT = #[^\n\r]*

KEY = [_\-a-zA-Z]+

ESCAPE = \\[^]
BASIC_STRING = \"
  ([^\r\n\"] | {ESCAPE})*
(\")?
MULTILINE_BASIC_STRING = (\"\"\")
  ([^\"] | {ESCAPE} | \"[^\"] | \"\"[^\"])*
(\"\"\")?
LITERAL_STRING = \'
  ([^\r\n\'] | {ESCAPE})*
(\')?
MULTILINE_LITERAL_STRING = (\'\'\')
  ([^\'] | {ESCAPE} | \'[^\'] | \'\'[^\'])*
(\'\'\')?

%%

<YYINITIAL> {

  {NUMBER} { return TomlToken.NUMBER; }
  {DATE_TIME} { return TomlToken.DATE_TIME; }
  {BOOLEAN} { return TomlToken.BOOLEAN; }
  {COMMENT} { return TomlToken.COMMENT; }
  {KEY} { return TomlToken.KEY; }

  {BASIC_STRING} { return TomlToken.BASIC_STRING; }
  {LITERAL_STRING} { return TomlToken.LITERAL_STRING; }
  {MULTILINE_BASIC_STRING} { return TomlToken.MULTILINE_BASIC_STRING; }
  {MULTILINE_LITERAL_STRING} { return TomlToken.MULTILINE_LITERAL_STRING; }

  "=" { return TomlToken.EQ; }
  "," { return TomlToken.COMMA; }
  "." { return TomlToken.DOT; }
  "[" { return TomlToken.LBRACK; }
  "]" { return TomlToken.RBRACK; }
  "{" { return TomlToken.LBRACE; }
  "}" { return TomlToken.RBRACE; }

  {IDENTIFIER} { return TomlToken.IDENTIFIER; }
  {WHITESPACE} { return TomlToken.WHITESPACE; }
}

[^] { return TomlToken.BAD_CHARACTER; }

<<EOF>> { return TomlToken.EOF; }