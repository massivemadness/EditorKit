package com.blacksquircle.ui.language.css.lexer;

@SuppressWarnings("all")
%%

%public
%class CssLexer
%type CssToken
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

DIGIT = ([0-9])
LETTER = ([A-Za-z])
LETTER_OR_UNDERSCORE = ({LETTER}|[_])
LETTER_OR_UNDERSCORE_OR_DASH = ({LETTER_OR_UNDERSCORE}|[\-])
CSS_DIGITS = ([\-]?{DIGIT}+([0-9\.]+)?(pt|pc|in|mm|cm|em|ex|px|ms|s|deg|%)?)
CSS_HEX = ("#"[0-9a-fA-F]+)
CSS_NUMBER = ({CSS_DIGITS}|{CSS_HEX})

CSS_SELECTOR_PIECE = (("*"|"."|{LETTER_OR_UNDERSCORE_OR_DASH})({LETTER_OR_UNDERSCORE_OR_DASH}|"."|{DIGIT})*)
CSS_PSEUDO_CLASS = (":"("root"|"nth-child"|"nth-last-child"|"nth-of-type"|"nth-last-of-type"|"first-child"|"last-child"|"first-of-type"|"last-of-type"|"only-child"|"only-of-type"|"empty"|"link"|"visited"|"active"|"hover"|"focus"|"target"|"lang"|"enabled"|"disabled"|"checked"|":first-line"|":first-letter"|":before"|":after"|"not"))
CSS_AT_RULE = ("@"(charset|import|namespace|media|document|page|font-face|keyframes|viewport))
CSS_ID = ("#"{CSS_SELECTOR_PIECE})

CSS_PROPERTY_RULE = ([\*]?{LETTER_OR_UNDERSCORE_OR_DASH}({LETTER_OR_UNDERSCORE_OR_DASH}|{DIGIT})*(:[\w]+)?)
CSS_VALUE_CHAR = ({LETTER_OR_UNDERSCORE_OR_DASH}|{DIGIT}|[\\/|$])
CSS_VALUE_RULE = ({CSS_VALUE_CHAR}*)
CSS_FUNCTION = ({CSS_VALUE_RULE}\()

CRLF = [\ \t \f]* \R
DOUBLE_QUOTED_STRING = \"([^\\\"\r\n] | \\[^\r\n] | \\{CRLF})*\"?
SINGLE_QUOTED_STRING = '([^\\'\r\n] | \\[^\r\n] | \\{CRLF})*'?

LINE_TERMINATOR = \r|\n|\r\n
WHITESPACE = {LINE_TERMINATOR} | [ \t\f]

LINE_COMMENT = "//".*
BLOCK_COMMENT = "/"\*([^*] | \*+[^*/])*(\*+"/")?

%state CSS_PROPERTY
%state CSS_VALUE

%%

<YYINITIAL> {
  {CSS_NUMBER} { return CssToken.NUMBER; }
  {CSS_SELECTOR_PIECE} { return CssToken.DATA_TYPE; }
  {CSS_PSEUDO_CLASS} { return CssToken.CLASS; }
  {CSS_AT_RULE} { return CssToken.REGEX; }
  {CSS_ID} { return CssToken.ANNOTATION; }

  "+" { return CssToken.PLUS; }
  ">" { return CssToken.GT; }
  "~" { return CssToken.TILDE; }
  "^" { return CssToken.XOR; }
  "$" { return CssToken.DOLLAR; }
  "|" { return CssToken.OR; }
  "=" { return CssToken.EQ; }

  "(" { return CssToken.LPAREN; }
  ")" { return CssToken.RPAREN; }
  "{" { yybegin(CSS_PROPERTY); return CssToken.LBRACE; }
  "}" { return CssToken.RBRACE; }
  "[" { return CssToken.LBRACK; }
  "]" { return CssToken.RBRACK; }
  ":" { return CssToken.COLON; }
  ";" { return CssToken.SEMICOLON; }
  "," { return CssToken.COMMA; }

  {LINE_COMMENT} { return CssToken.LINE_COMMENT; }
  {BLOCK_COMMENT} { return CssToken.BLOCK_COMMENT; }

  {DOUBLE_QUOTED_STRING} { return CssToken.DOUBLE_QUOTED_STRING; }
  {SINGLE_QUOTED_STRING} { return CssToken.SINGLE_QUOTED_STRING; }

  {IDENTIFIER} { return CssToken.IDENTIFIER; }
  {WHITESPACE} { return CssToken.WHITESPACE; }
}

<CSS_PROPERTY> {
  {CSS_NUMBER} { return CssToken.NUMBER; }
  {CSS_PROPERTY_RULE} { return CssToken.PROPERTY; }

  "(" { return CssToken.LPAREN; }
  ")" { return CssToken.RPAREN; }
  "{" { return CssToken.LBRACE; }
  "}" { yybegin(YYINITIAL); return CssToken.RBRACE; }
  ":" { yybegin(CSS_VALUE); return CssToken.COLON; }

  {LINE_COMMENT} { return CssToken.LINE_COMMENT; }
  {BLOCK_COMMENT} { return CssToken.BLOCK_COMMENT; }

  {IDENTIFIER} { return CssToken.IDENTIFIER; }
  {WHITESPACE} { return CssToken.WHITESPACE; }
}

<CSS_VALUE> {
  {CSS_NUMBER} { return CssToken.NUMBER; }
  {CSS_VALUE_RULE} { return CssToken.VALUE; }
  {CSS_FUNCTION} { return CssToken.FUNCTION; }

  "(" { return CssToken.LPAREN; }
  ")" { return CssToken.RPAREN; }
  "}" { yybegin(YYINITIAL); return CssToken.RBRACE; }
  ";" { yybegin(CSS_PROPERTY); return CssToken.SEMICOLON; }
  "!important" { return CssToken.IMPORTANT; }

  {LINE_COMMENT} { return CssToken.LINE_COMMENT; }
  {BLOCK_COMMENT} { return CssToken.BLOCK_COMMENT; }

  {IDENTIFIER} { return CssToken.IDENTIFIER; }
  {WHITESPACE} { return CssToken.WHITESPACE; }
}

[^] { return CssToken.BAD_CHARACTER; }

<<EOF>> { return CssToken.EOF; }