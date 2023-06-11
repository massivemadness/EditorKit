package com.blacksquircle.ui.language.fortran.lexer;

@SuppressWarnings("all")
%%

%public
%class FortranLexer
%type FortranToken
%function advance
%unicode
%ignorecase
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
DIGIT_OR_UNDERSCORE = [_0-9]
DIGITS = {DIGIT} | {DIGIT} {DIGIT_OR_UNDERSCORE}*

NUMBER_LITERAL = {DEC_FP_LITERAL} | {DIGITS}

DEC_FP_LITERAL = {DIGITS} {DEC_EXPONENT} | {DEC_SIGNIFICAND} {DEC_EXPONENT}?
DEC_SIGNIFICAND = "." {DIGITS} | {DIGITS} "." {DIGIT_OR_UNDERSCORE}*
DEC_EXPONENT = [Ee] [+-]? {DIGIT_OR_UNDERSCORE}*

CRLF = [\ \t \f]* \R
DOUBLE_QUOTED_STRING = \"([^\\\"\r\n] | \\[^\r\n] | \\{CRLF})*\"?
SINGLE_QUOTED_STRING = '([^\\'\r\n] | \\[^\r\n] | \\{CRLF})*'?

LINE_TERMINATOR = \r|\n|\r\n
WHITESPACE = {LINE_TERMINATOR} | [ \t\f]

LINE_COMMENT = "!".*

%%

<YYINITIAL> {
  {NUMBER_LITERAL} { return FortranToken.NUMBER_LITERAL; }

  "INCLUDE" { return FortranToken.INCLUDE; }
  "PROGRAM" { return FortranToken.PROGRAM; }
  "MODULE" { return FortranToken.MODULE; }
  "SUBROUTINE" { return FortranToken.SUBROUTINE; }
  "INTERFACE" { return FortranToken.INTERFACE; }
  "FUNCTION" { return FortranToken.FUNCTION; }
  "CONTAINS" { return FortranToken.CONTAINS; }
  "RECURSIVE" { return FortranToken.RECURSIVE; }
  "USE" { return FortranToken.USE; }
  "CALL" { return FortranToken.CALL; }
  "RETURN" { return FortranToken.RETURN; }
  "IMPLICIT" { return FortranToken.IMPLICIT; }
  "EXPLICIT" { return FortranToken.EXPLICIT; }
  "NONE" { return FortranToken.NONE; }
  "DATA" { return FortranToken.DATA; }
  "TYPE" { return FortranToken.TYPE; }
  "PARAMETER" { return FortranToken.PARAMETER; }
  "ALLOCATE" { return FortranToken.ALLOCATE; }
  "ALLOCATABLE" { return FortranToken.ALLOCATABLE; }
  "ALLOCATED" { return FortranToken.ALLOCATED; }
  "DEALLOCATE" { return FortranToken.DEALLOCATE; }
  "INTEGER" { return FortranToken.INTEGER; }
  "DOUBLE" { return FortranToken.DOUBLE; }
  "PRECISION" { return FortranToken.PRECISION; }
  "COMPLEX" { return FortranToken.COMPLEX; }
  "CHARACTER" { return FortranToken.CHARACTER; }
  "DIMENSION" { return FortranToken.DIMENSION; }
  "KIND" { return FortranToken.KIND; }
  "CASE" { return FortranToken.CASE; }
  "ERROR" { return FortranToken.ERROR; }
  "SELECT" { return FortranToken.SELECT; }
  "DEFAULT" { return FortranToken.DEFAULT; }
  "CONTINUE" { return FortranToken.CONTINUE; }
  "CYCLE" { return FortranToken.CYCLE; }
  "DO" { return FortranToken.DO; }
  "WHILE" { return FortranToken.WHILE; }
  "ELSE" { return FortranToken.ELSE; }
  "IF" { return FortranToken.IF; }
  "ELSEIF" { return FortranToken.ELSEIF; }
  "THEN" { return FortranToken.THEN; }
  "ELSEWHERE" { return FortranToken.ELSEWHERE; }
  "END" { return FortranToken.END; }
  "ENDIF" { return FortranToken.ENDIF; }
  "ENDDO" { return FortranToken.ENDDO; }
  "FORALL" { return FortranToken.FORALL; }
  "WHERE" { return FortranToken.WHERE; }
  "EXIT" { return FortranToken.EXIT; }
  "GOTO" { return FortranToken.GOTO; }
  "PAUSE" { return FortranToken.PAUSE; }
  "STOP" { return FortranToken.STOP; }
  "BACKSPACE" { return FortranToken.BACKSPACE; }
  "CLOSE" { return FortranToken.CLOSE; }
  "ENDFILE" { return FortranToken.ENDFILE; }
  "INQUIRE" { return FortranToken.INQUIRE; }
  "OPEN" { return FortranToken.OPEN; }
  "PRINT" { return FortranToken.PRINT; }
  "READ" { return FortranToken.READ; }
  "REWIND" { return FortranToken.REWIND; }
  "WRITE" { return FortranToken.WRITE; }
  "FORMAT" { return FortranToken.FORMAT; }
  "AMAX0" { return FortranToken.AMAX0; }
  "AMIN0" { return FortranToken.AMIN0; }
  "ANINT" { return FortranToken.ANINT; }
  "CEILING" { return FortranToken.CEILING; }
  "CMPLX" { return FortranToken.CMPLX; }
  "CONJG" { return FortranToken.CONJG; }
  "DBLE" { return FortranToken.DBLE; }
  "DCMPLX" { return FortranToken.DCMPLX; }
  "DFLOAT" { return FortranToken.DFLOAT; }
  "DIM" { return FortranToken.DIM; }
  "DPROD" { return FortranToken.DPROD; }
  "FLOAT" { return FortranToken.FLOAT; }
  "FLOOR" { return FortranToken.FLOOR; }
  "IFIX" { return FortranToken.IFIX; }
  "IMAG" { return FortranToken.IMAG; }
  "INT" { return FortranToken.INT; }
  "LOGICAL" { return FortranToken.LOGICAL; }
  "MODULO" { return FortranToken.MODULO; }
  "NINT" { return FortranToken.NINT; }
  "REAL" { return FortranToken.REAL; }
  "TRANSFER" { return FortranToken.TRANSFER; }
  "ZEXT" { return FortranToken.ZEXT; }
  "ABS" { return FortranToken.ABS; }
  "ACOS" { return FortranToken.ACOS; }
  "AIMAG" { return FortranToken.AIMAG; }
  "AINT" { return FortranToken.AINT; }
  "ALOG" { return FortranToken.ALOG; }
  "ALOG10" { return FortranToken.ALOG10; }
  "AMAX1" { return FortranToken.AMAX1; }
  "AMIN1" { return FortranToken.AMIN1; }
  "AMOD" { return FortranToken.AMOD; }
  "ASIN" { return FortranToken.ASIN; }
  "ATAN" { return FortranToken.ATAN; }
  "ATAN2" { return FortranToken.ATAN2; }
  "CABS" { return FortranToken.CABS; }
  "CCOS" { return FortranToken.CCOS; }
  "CHAR" { return FortranToken.CHAR; }
  "CLOG" { return FortranToken.CLOG; }
  "COS" { return FortranToken.COS; }
  "COSH" { return FortranToken.COSH; }
  "CSIN" { return FortranToken.CSIN; }
  "CSQRT" { return FortranToken.CSQRT; }
  "DABS" { return FortranToken.DABS; }
  "DACOS" { return FortranToken.DACOS; }
  "DASIN" { return FortranToken.DASIN; }
  "DATAN" { return FortranToken.DATAN; }
  "DATAN2" { return FortranToken.DATAN2; }
  "DCOS" { return FortranToken.DCOS; }
  "DCOSH" { return FortranToken.DCOSH; }
  "DDIM" { return FortranToken.DDIM; }
  "DEXP" { return FortranToken.DEXP; }
  "DINT" { return FortranToken.DINT; }
  "DLOG" { return FortranToken.DLOG; }
  "DLOG10" { return FortranToken.DLOG10; }
  "DMAX1" { return FortranToken.DMAX1; }
  "DMIN1" { return FortranToken.DMIN1; }
  "DMOD" { return FortranToken.DMOD; }
  "DNINT" { return FortranToken.DNINT; }
  "DREAL" { return FortranToken.DREAL; }
  "DSIGN" { return FortranToken.DSIGN; }
  "DSIN" { return FortranToken.DSIN; }
  "DSINH" { return FortranToken.DSINH; }
  "DSQRT" { return FortranToken.DSQRT; }
  "DTAN" { return FortranToken.DTAN; }
  "DTANH" { return FortranToken.DTANH; }
  "EXP" { return FortranToken.EXP; }
  "IABS" { return FortranToken.IABS; }
  "ICHAR" { return FortranToken.ICHAR; }
  "IDIM" { return FortranToken.IDIM; }
  "IDINT" { return FortranToken.IDINT; }
  "IDNINT" { return FortranToken.IDNINT; }
  "INDEX" { return FortranToken.INDEX; }
  "ISIGN" { return FortranToken.ISIGN; }
  "LEN" { return FortranToken.LEN; }
  "LGE" { return FortranToken.LGE; }
  "LGT" { return FortranToken.LGT; }
  "LLE" { return FortranToken.LLE; }
  "LLT" { return FortranToken.LLT; }
  "LOG" { return FortranToken.LOG; }
  "LOG10" { return FortranToken.LOG10; }
  "MAX" { return FortranToken.MAX; }
  "MAX0" { return FortranToken.MAX0; }
  "MAX1" { return FortranToken.MAX1; }
  "MIN" { return FortranToken.MIN; }
  "MIN0" { return FortranToken.MIN0; }
  "MIN1" { return FortranToken.MIN1; }
  "MOD" { return FortranToken.MOD; }
  "SIGN" { return FortranToken.SIGN; }
  "SIN" { return FortranToken.SIN; }
  "SINH" { return FortranToken.SINH; }
  "SNGL" { return FortranToken.SNGL; }
  "SQRT" { return FortranToken.SQRT; }
  "TAN" { return FortranToken.TAN; }
  "TANH" { return FortranToken.TANH; }
      
  ".true." { return FortranToken.TRUE; }
  ".false." { return FortranToken.FALSE; }

  "(" { return FortranToken.LPAREN; }
  ")" { return FortranToken.RPAREN; }
  "{" { return FortranToken.LBRACE; }
  "}" { return FortranToken.RBRACE; }
  "[" { return FortranToken.LBRACK; }
  "]" { return FortranToken.RBRACK; }
  "<" { return FortranToken.LT_OPERATOR; }
  ">" { return FortranToken.GT_OPERATOR; }
  "<=" { return FortranToken.LTEQ; }
  ">=" { return FortranToken.GTEQ; }
  "&" { return FortranToken.AND_OPERATOR; }
  "/=" { return FortranToken.DIVEQ; }
  "==" { return FortranToken.EQEQ; }
  "=" { return FortranToken.EQ_OPERATOR; }
  "::" { return FortranToken.DOUBLE_COLON; }
  ".lt." { return FortranToken.LT; }
  ".gt." { return FortranToken.GT; }
  ".eq." { return FortranToken.EQ; }
  ".ne." { return FortranToken.NE; }
  ".le." { return FortranToken.LE; }
  ".ge." { return FortranToken.GE; }
  ".and." { return FortranToken.AND; }
  ".or." { return FortranToken.OR; }

  {LINE_COMMENT} { return FortranToken.LINE_COMMENT; }

  {DOUBLE_QUOTED_STRING} { return FortranToken.DOUBLE_QUOTED_STRING; }
  {SINGLE_QUOTED_STRING} { return FortranToken.SINGLE_QUOTED_STRING; }

  {IDENTIFIER} { return FortranToken.IDENTIFIER; }
  {WHITESPACE} { return FortranToken.WHITESPACE; }
}

[^] { return FortranToken.BAD_CHARACTER; }

<<EOF>> { return FortranToken.EOF; }