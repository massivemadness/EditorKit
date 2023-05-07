package com.blacksquircle.ui.language.go.lexer;

@SuppressWarnings("all")
%%

%public
%class GoLexer
%type GoToken
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

DIGIT = [0-9]
HEX_DIGIT = {DIGIT}|[A-Fa-f]
OCTAL_DIGIT = [0-7]
EXPONENT = [eE][+-]?{DIGIT}+

TRIGRAPH = ("??="|"??("|"??)"|"??/"|"??'"|"??<"|"??>"|"??!"|"??-")

DECIMAL_LIT  = ([1-9]{DIGIT}*)
OCTAL_LIT = ("0"{OCTAL_DIGIT}*)
INTEGER_LIT  = ({DECIMAL_LIT}|{OCTAL_LIT})
HEX_LIT = ("0"[xX]{HEX_DIGIT}+)
FLOAT_LIT = ((({DIGIT}*[\.]{DIGIT}+)|({DIGIT}+[\.]{DIGIT}*)){EXPONENT}?)
IMAGINARY_LIT = (({DIGIT}+|{FLOAT_LIT})"i")

CRLF = [\ \t \f]* \R
DOUBLE_QUOTED_STRING = \"([^\\\"\r\n] | \\[^\r\n] | \\{CRLF})*\"?
SINGLE_QUOTED_STRING = '([^\\'\r\n] | \\[^\r\n] | \\{CRLF})*'?

LINE_TERMINATOR = \r|\n|\r\n
WHITESPACE = {LINE_TERMINATOR} | [ \t\f]

LINE_COMMENT = "//".*
BLOCK_COMMENT = "/"\*([^*] | \*+[^*/])*(\*+"/")?

%%

<YYINITIAL> {
  {INTEGER_LIT} { return GoToken.LITERAL_NUMBER_DECIMAL_INT; }
  {HEX_LIT} { return GoToken.LITERAL_NUMBER_HEXADECIMAL; }
  {FLOAT_LIT} { return GoToken.LITERAL_NUMBER_FLOAT; }
  {IMAGINARY_LIT} { return GoToken.LITERAL_NUMBER_FLOAT; }

  "break" { return GoToken.BREAK; }
  "case" { return GoToken.CASE; }
  "chan" { return GoToken.CHAN; }
  "const" { return GoToken.CONST; }
  "continue" { return GoToken.CONTINUE; }
  "default" { return GoToken.DEFAULT; }
  "defer" { return GoToken.DEFER; }
  "else" { return GoToken.ELSE; }
  "fallthrough" { return GoToken.FALLTHROUGH; }
  "for" { return GoToken.FOR; }
  "func" { return GoToken.FUNC; }
  "go" { return GoToken.GO; }
  "goto" { return GoToken.GOTO; }
  "if" { return GoToken.IF; }
  "import" { return GoToken.IMPORT; }
  "interface" { return GoToken.INTERFACE; }
  "map" { return GoToken.MAP; }
  "package" { return GoToken.PACKAGE; }
  "range" { return GoToken.RANGE; }
  "select" { return GoToken.SELECT; }
  "struct" { return GoToken.STRUCT; }
  "switch" { return GoToken.SWITCH; }
  "type" { return GoToken.TYPE; }
  "var" { return GoToken.VAR; }
  "return" { return GoToken.RETURN; }

  "bool" { return GoToken.BOOL; }
  "string" { return GoToken.STRING; }
  "int" { return GoToken.INT; }
  "int8" { return GoToken.INT_8; }
  "int16" { return GoToken.INT_16; }
  "int32" { return GoToken.INT_32; }
  "int64" { return GoToken.INT_64; }
  "uint" { return GoToken.UINT; }
  "uint8" { return GoToken.UINT_8; }
  "uint16" { return GoToken.UINT_16; }
  "uint32" { return GoToken.UINT_32; }
  "uint64" { return GoToken.UINT_64; }
  "uintptr" { return GoToken.UINTPTR; }
  "byte" { return GoToken.BYTE; }
  "rune" { return GoToken.RUNE; }
  "float32" { return GoToken.FLOAT_32; }
  "float64" { return GoToken.FLOAT_64; }
  "complex64" { return GoToken.COMPLEX_64; }
  "complex128" { return GoToken.COMPLEX_128; }

  "append" { return GoToken.APPEND; }
  "cap" { return GoToken.CAP; }
  "close" { return GoToken.CLOSE; }
  "complex" { return GoToken.COMPLEX; }
  "copy" { return GoToken.COPY; }
  "delete" { return GoToken.DELETE; }
  "imag" { return GoToken.IMAG; }
  "len" { return GoToken.LEN; }
  "make" { return GoToken.MAKE; }
  "new" { return GoToken.NEW; }
  "panic" { return GoToken.PANIC; }
  "print" { return GoToken.PRINT; }
  "println" { return GoToken.PRINTLN; }
  "real" { return GoToken.REAL; }
  "recover" { return GoToken.RECOVER; }

  "Compare" { return GoToken.COMPARE; }
  "Contains" { return GoToken.CONTAINS; }
  "ContainsAny" { return GoToken.CONTAINS_ANY; }
  "ContainsRune" { return GoToken.CONTAINS_RUNE; }
  "Count" { return GoToken.COUNT; }
  "EqualsFold" { return GoToken.EQUALS_FOLD; }
  "Fields" { return GoToken.FIELDS; }
  "FieldsFunc" { return GoToken.FIELDS_FUNC; }
  "HasPrefix" { return GoToken.HAS_PREFIX; }
  "HasSuffix" { return GoToken.HAS_SUFFIX; }
  "Index" { return GoToken.INDEX; }
  "IndexAny" { return GoToken.INDEX_ANY; }
  "IndexByte" { return GoToken.INDEX_BYTE; }
  "IndexFunc" { return GoToken.INDEX_FUNC; }
  "IndexRune" { return GoToken.INDEX_RUNE; }
  "Join" { return GoToken.JOIN; }
  "LastIndex" { return GoToken.LAST_INDEX; }
  "LastIndexAny" { return GoToken.LAST_INDEX_ANY; }
  "LastIndexByte" { return GoToken.LAST_INDEX_BYTE; }
  "LastIndexFunc" { return GoToken.LAST_INDEX_FUNC; }
  "Map" { return GoToken.MAP; }
  "Repeat" { return GoToken.REPEAT; }
  "Replace" { return GoToken.REPLACE; }
  "ReplaceAll" { return GoToken.REPLACE_ALL; }
  "Split" { return GoToken.SPLIT; }
  "SplitAfter" { return GoToken.SPLIT_AFTER; }
  "SplitAfterN" { return GoToken.SPLIT_AFTER_N; }
  "SplitN" { return GoToken.SPLIT_N; }
  "Title" { return GoToken.TITLE; }
  "ToLower" { return GoToken.TO_LOWER; }
  "ToLowerSpecial" { return GoToken.TO_LOWER_SPECIAL; }
  "ToTitle" { return GoToken.TO_TITLE; }
  "ToTitleSpecial" { return GoToken.TO_TITLE_SPECIAL; }
  "ToUpper" { return GoToken.TO_UPPER; }
  "ToUppserSpecial" { return GoToken.TO_UPPSER_SPECIAL; }
  "Trim" { return GoToken.TRIM; }
  "TrimFunc" { return GoToken.TRIM_FUNC; }
  "TrimLeft" { return GoToken.TRIM_LEFT; }
  "TrimLeftFunc" { return GoToken.TRIM_LEFT_FUNC; }
  "TrimPrefix" { return GoToken.TRIM_PREFIX; }
  "TrimRight" { return GoToken.TRIM_RIGHT; }
  "TrimRightFunc" { return GoToken.TRIM_RIGHT_FUNC; }
  "TrimSpace" { return GoToken.TRIM_SPACE; }
  "TrimSuffix" { return GoToken.TRIM_SUFFIX; }

  "true" { return GoToken.TRUE; }
  "false" { return GoToken.FALSE; }
  "nil" { return GoToken.NIL; }

  "(" { return GoToken.LPAREN; }
  ")" { return GoToken.RPAREN; }
  "{" { return GoToken.LBRACE; }
  "}" { return GoToken.RBRACE; }
  "[" { return GoToken.LBRACK; }
  "]" { return GoToken.RBRACK; }

  {TRIGRAPH} { return GoToken.TRIGRAPH; }
  "=" { return GoToken.EQ; }
  ":=" { return GoToken.COLONEQ; }
  "+" { return GoToken.PLUS; }
  "-" { return GoToken.MINUS; }
  "*" { return GoToken.MULT; }
  "/" { return GoToken.DIV; }
  "%" { return GoToken.MOD; }
  "~" { return GoToken.TILDE; }
  "<" { return GoToken.LT; }
  "<-" { return GoToken.ARROW; }
  ">" { return GoToken.GT; }
  "<<" { return GoToken.GTGT; }
  ">>" { return GoToken.LTLT; }
  "==" { return GoToken.EQEQ; }
  "+=" { return GoToken.PLUSEQ; }
  "-=" { return GoToken.MINUSEQ; }
  "*=" { return GoToken.MULTEQ; }
  "/=" { return GoToken.DIVEQ; }
  "%=" { return GoToken.MODEQ; }
  "&=" { return GoToken.ANDEQ; }
  "|=" { return GoToken.OREQ; }
  "^=" { return GoToken.XOREQ; }
  ">=" { return GoToken.GTEQ; }
  "<=" { return GoToken.LTEQ; }
  "!=" { return GoToken.NOTEQ; }
  ">>=" { return GoToken.GTGTEQ; }
  "<<=" { return GoToken.LTLTEQ; }
  "^" { return GoToken.XOR; }
  "&" { return GoToken.AND; }
  "&&" { return GoToken.ANDAND; }
  "&^" { return GoToken.ANDXOR; }
  "&^=" { return GoToken.ANDXOREQ; }
  "..." { return GoToken.ELLIPSIS; }
  "|" { return GoToken.OR; }
  "||" { return GoToken.OROR; }
  "?" { return GoToken.QUEST; }
  "!" { return GoToken.NOT; }
  "++" { return GoToken.PLUSPLUS; }
  "--" { return GoToken.MINUSMINUS; }
  ":" { return GoToken.COLON; }
  ";" { return GoToken.SEMICOLON; }
  "," { return GoToken.COMMA; }
  "." { return GoToken.DOT; }

  {LINE_COMMENT} { return GoToken.LINE_COMMENT; }
  {BLOCK_COMMENT} { return GoToken.BLOCK_COMMENT; }

  {DOUBLE_QUOTED_STRING} { return GoToken.DOUBLE_QUOTED_STRING; }
  {SINGLE_QUOTED_STRING} { return GoToken.SINGLE_QUOTED_STRING; }

  {IDENTIFIER} { return GoToken.IDENTIFIER; }
  {WHITESPACE} { return GoToken.WHITESPACE; }
}

[^] { return GoToken.BAD_CHARACTER; }

<<EOF>> { return GoToken.EOF; }