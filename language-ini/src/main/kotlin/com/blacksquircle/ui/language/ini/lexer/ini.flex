package com.blacksquircle.ui.language.ini.lexer;

@SuppressWarnings("all")
%%

%public
%class IniLexer
%type IniToken
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

%state VALUE

EQUALS = ([=])
COMMENT = ([#;].*)
SECTION = ([\[][^\]]*[\]]?)
INDENTIFIER = ([^ \t\n#;\[=]*)
WHITESPACE = ([ \t]+)

%%

<YYINITIAL> {
  {EQUALS}      { yybegin(VALUE); return IniToken.EQUALS; }
  {COMMENT}     { return IniToken.COMMENT; }
  {SECTION}     { return IniToken.SECTION; }
  {INDENTIFIER} { return IniToken.KEY; }
  {WHITESPACE}  { return IniToken.WHITESPACE; }
}

<VALUE> {
  {COMMENT}     { yybegin(YYINITIAL); return IniToken.COMMENT; }

  [^] { return IniToken.VALUE; }
}

[^] { return IniToken.BAD_CHARACTER; }

<<EOF>> { return IniToken.EOF; }