package com.blacksquircle.ui.language.latex.lexer;

import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("all")
%%

%public
%class LatexLexer
%type LatexToken
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

  public final List<TokenData> getBeginTokens() {
      ArrayList<TokenData> tokenList = new ArrayList<>();
      tokenList.add(new TokenData(zzStartRead, zzStartRead + 5, LatexToken.RESERVED_WORD));
      tokenList.add(new TokenData(zzStartRead + 6, zzStartRead + 6, LatexToken.SEPARATOR));
      tokenList.add(new TokenData(zzStartRead + 7, zzMarkedPos - 2, LatexToken.RESERVED_WORD));
      tokenList.add(new TokenData(zzMarkedPos - 1, zzMarkedPos - 1, LatexToken.SEPARATOR));
      return tokenList;
  }

  public final List<TokenData> getEndTokens() {
      ArrayList<TokenData> tokenList = new ArrayList<>();
      tokenList.add(new TokenData(zzStartRead, zzStartRead + 3, LatexToken.RESERVED_WORD));
      tokenList.add(new TokenData(zzStartRead + 4, zzStartRead + 4, LatexToken.SEPARATOR));
      tokenList.add(new TokenData(zzStartRead + 5, zzMarkedPos - 2, LatexToken.RESERVED_WORD));
      tokenList.add(new TokenData(zzMarkedPos - 1, zzMarkedPos - 1, LatexToken.SEPARATOR));
      return tokenList;
  }
%}

IDENTIFIER = [:jletter:] [:jletterdigit:]*

LETTER = ([A-Za-z])
LETTER_OR_UNDERSCORE = ({LETTER}|[_])

DIGIT = [0-9]
DIGIT_OR_UNDERSCORE = [_0-9]
DIGITS = {DIGIT} | {DIGIT} {DIGIT_OR_UNDERSCORE}*

NUMBER_LITERAL = {DEC_FP_LITERAL} | {DIGITS}
LENGTH_LITERAL = ({NUMBER_LITERAL}+(pt|mm|cm|in|ex|em|mu|sp)?)

DEC_FP_LITERAL = {DIGITS} {DEC_EXPONENT} | {DEC_SIGNIFICAND} {DEC_EXPONENT}?
DEC_SIGNIFICAND = "." {DIGITS} | {DIGITS} "." {DIGIT_OR_UNDERSCORE}*
DEC_EXPONENT = [Ee] [+-]? {DIGIT_OR_UNDERSCORE}*

ANY_CHAR = ({LETTER_OR_UNDERSCORE}|{DIGIT}|[\-\+\*\@])
WHITESPACE = ([ \t\f])
LINE_COMMENT = "%".*

%%

<YYINITIAL> {
  {NUMBER_LITERAL} { return LatexToken.NUMBER; }
  {LENGTH_LITERAL} { return LatexToken.LENGTH; }
  ([\\]{ANY_CHAR}+) { return LatexToken.FUNCTION; }
  ([\\]%) { return LatexToken.SEPARATOR; }

  "(" { return LatexToken.LPAREN; }
  ")" { return LatexToken.RPAREN; }
  "{" { return LatexToken.LBRACE; }
  "}" { return LatexToken.RBRACE; }
  "[" { return LatexToken.LBRACK; }
  "]" { return LatexToken.RBRACK; }

  ("\\begin{"{ANY_CHAR}+"}") { return LatexToken.BEGIN_BLOCK; }
  ("\\end{"{ANY_CHAR}+"}") { return LatexToken.END_BLOCK; }

  {LINE_COMMENT} { return LatexToken.LINE_COMMENT; }
  {IDENTIFIER} { return LatexToken.IDENTIFIER; }
  {WHITESPACE} { return LatexToken.WHITESPACE; }
}

[^] { return LatexToken.BAD_CHARACTER; }

<<EOF>> { return LatexToken.EOF; }