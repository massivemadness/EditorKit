package com.blacksquircle.ui.language.rust.lexer;

@SuppressWarnings("all")
%%

%public
%class RustLexer
%type RustToken
%function advance
%unicode
%line
%column
%char

%{
  /**
    * '#+' stride demarking start/end of raw string/byte literal
    */
  private int zzShaStride = -1;

  /**
    * Dedicated storage for starting position of some previously successful
    * match
    */
  private int zzPostponedMarkedPos = -1;

  public final int getTokenStart() {
      return (int) yychar;
  }

  public final int getTokenEnd() {
      return getTokenStart() + yylength();
  }

  public final int getRawLiteralStart() {
      return zzPostponedMarkedPos;
  }

  public final int getRawLiteralEnd() {
      return zzStartRead;
  }

  private RustToken imbueRawLiteral() {
      yybegin(YYINITIAL);
      return yycharat(0) == 'b' ? RustToken.RAW_BYTE_STRING_LITERAL : RustToken.RAW_STRING_LITERAL;
  }
%}

IDENTIFIER = [:jletter:] [:jletterdigit:]*

EXPONENT = [eE] [-+]? [0-9_]+
NUMBER_LITERAL = ({DEC_LITERAL} | {HEX_LITERAL} | {OCT_LITERAL} | {BIN_LITERAL}) {EXPONENT}?
DEC_LITERAL = [0-9] [0-9_]*
HEX_LITERAL = "0x" [a-fA-F0-9_]*
OCT_LITERAL = "0o" [0-7_]*
BIN_LITERAL = "0b" [01_]*

ATTRIBUTE = #(\!|\[|\!\[)([^\]\r\n])*\]?

SUFFIX = ("r#")?[_\p{xidstart}][\p{xidcontinue}]*
CHAR_LITERAL = ( \' ( [^\\\'\r\n] | \\[^\r\n] | "\\x" [a-fA-F0-9]+ | "\\u{" [a-fA-F0-9][a-fA-F0-9_]* "}"? )? ( \' {SUFFIX}? | \\ )? )
               | ( \' [\p{xidcontinue}]* \' {SUFFIX}? )
STRING_LITERAL = \" ( [^\\\"] | \\[^] )* ( \" {SUFFIX}? | \\ )?

LINE_TERMINATOR = \r|\n|\r\n
WHITESPACE = {LINE_TERMINATOR} | [ \t\f]

LINE_COMMENT = "//".*
BLOCK_COMMENT = "/"\*([^*] | \*+[^*/])*(\*+"/")?

%s IN_RAW_LITERAL
%s IN_RAW_LITERAL_SUFFIX
%s IN_LIFETIME_OR_CHAR

%% 

<YYINITIAL> {
  {NUMBER_LITERAL} { return RustToken.NUMBER_LITERAL; }

  "as" { return RustToken.AS; }
  "box" { return RustToken.BOX; }
  "break" { return RustToken.BREAK; }
  "const" { return RustToken.CONST; }
  "continue" { return RustToken.CONTINUE; }
  "crate" { return RustToken.CRATE; }
  "dyn" { return RustToken.DYN; }
  "else" { return RustToken.ELSE; }
  "enum" { return RustToken.ENUM; }
  "extern" { return RustToken.EXTERN; }
  "fn" { return RustToken.FN; }
  "for" { return RustToken.FOR; }
  "if" { return RustToken.IF; }
  "impl" { return RustToken.IMPL; }
  "in" { return RustToken.IN; }
  "let" { return RustToken.LET; }
  "loop" { return RustToken.LOOP; }
  "macro" { return RustToken.MACRO; }
  "match" { return RustToken.MATCH; }
  "mod" { return RustToken.MOD; }
  "move" { return RustToken.MOVE; }
  "mut" { return RustToken.MUT; }
  "pub" { return RustToken.PUB; }
  "ref" { return RustToken.REF; }
  "return" { return RustToken.RETURN; }
  "Self" { return RustToken.CSELF; }
  "self" { return RustToken.SELF; }
  "static" { return RustToken.STATIC; }
  "struct" { return RustToken.STRUCT; }
  "super" { return RustToken.SUPER; }
  "trait" { return RustToken.TRAIT; }
  "type" { return RustToken.TYPE; }
  "unsafe" { return RustToken.UNSAFE; }
  "use" { return RustToken.USE; }
  "where" { return RustToken.WHERE; }
  "while" { return RustToken.WHILE; }
  "yield" { return RustToken.YIELD; }

  "usize" { return RustToken.U_SIZE; }
  "isize" { return RustToken.I_SIZE; }
  "u8" { return RustToken.U_8; }
  "u16" { return RustToken.U_16; }
  "u32" { return RustToken.U_32; }
  "u64" { return RustToken.U_64; }
  "u128" { return RustToken.U_128; }
  "i8" { return RustToken.I_8; }
  "i16" { return RustToken.I_16; }
  "i32" { return RustToken.I_32; }
  "i64" { return RustToken.I_64; }
  "i128" { return RustToken.I_128; }
  "f32" { return RustToken.F_32; }
  "f64" { return RustToken.F_64; }

  "true" { return RustToken.TRUE; }
  "false" { return RustToken.FALSE; }

  {ATTRIBUTE} { return RustToken.ATTRIBUTE; }

  \' { yybegin(IN_LIFETIME_OR_CHAR); yypushback(1); }

  "{" { return RustToken.LBRACE; }
  "}" { return RustToken.RBRACE; }
  "[" { return RustToken.LBRACK; }
  "]" { return RustToken.RBRACK; }
  "(" { return RustToken.LPAREN; }
  ")" { return RustToken.RPAREN; }

  "::" { return RustToken.DOUBLE_COLON; }
  ":" { return RustToken.COLON; }
  ".." { return RustToken.DOTDOT; }
  "..." { return RustToken.DOTDOTDOT; }
  "..=" { return RustToken.DOTDOTEQ; }
  "=" { return RustToken.EQ; }
  "!=" { return RustToken.EXCLEQ; }
  "==" { return RustToken.EQEQ; }
  "!" { return RustToken.EXCL; }
  "+=" { return RustToken.PLUSEQ; }
  "+" { return RustToken.PLUS; }
  "-=" { return RustToken.MINUSEQ; }
  "-" { return RustToken.MINUS; }
  "#" { return RustToken.SHA; }
  "|=" { return RustToken.OREQ; }
  "&=" { return RustToken.ANDEQ; }
  "&" { return RustToken.AND; }
  "|" { return RustToken.OR; }
  "<" { return RustToken.LT; }
  "^=" { return RustToken.XOREQ; }
  "^" { return RustToken.XOR; }
  "*=" { return RustToken.MULEQ; }
  "*" { return RustToken.MUL; }
  "/=" { return RustToken.DIVEQ; }
  "/" { return RustToken.DIV; }
  "%=" { return RustToken.REMEQ; }
  "%" { return RustToken.REM; }
  ">" { return RustToken.GT; }
  "->" { return RustToken.ARROW; }
  "=>" { return RustToken.FAT_ARROW; }
  "?" { return RustToken.QUEST; }
  "~" { return RustToken.TILDE; }
  "@" { return RustToken.AT; }
  "$" { return RustToken.DOLLAR; }
  ";" { return RustToken.SEMICOLON; }
  "," { return RustToken.COMMA; }
  "." { return RustToken.DOT; }

  {LINE_COMMENT} { return RustToken.LINE_COMMENT; }
  {BLOCK_COMMENT} { return RustToken.BLOCK_COMMENT; }

  "b" {CHAR_LITERAL} { return RustToken.BYTE_LITERAL; }

  "b" {STRING_LITERAL} { return RustToken.BYTE_STRING_LITERAL; }
  {STRING_LITERAL} { return RustToken.STRING_LITERAL; }

  "br" #* \" {
          yybegin(IN_RAW_LITERAL);
          zzPostponedMarkedPos = zzStartRead;
          zzShaStride = yylength() - 3;
      }

  "r" #* \" {
          yybegin(IN_RAW_LITERAL);
          zzPostponedMarkedPos = zzStartRead;
          zzShaStride = yylength() - 2;
      }

  "r"  #+ | "br" #+ { return RustToken.BAD_CHARACTER; }

  {IDENTIFIER} { return RustToken.IDENTIFIER; }
  {WHITESPACE} { return RustToken.WHITESPACE; }
}

<IN_RAW_LITERAL> {
  \" #* {
    int shaExcess = yylength() - 1 - zzShaStride;
    if (shaExcess >= 0) {
        yybegin(IN_RAW_LITERAL_SUFFIX);
        yypushback(shaExcess);
    }
  }

  [^] { }
  <<EOF>> { return imbueRawLiteral(); }
}

<IN_RAW_LITERAL_SUFFIX> {
  {SUFFIX} { return imbueRawLiteral(); }

  [^] { yypushback(1); return imbueRawLiteral(); }
  <<EOF>> { return imbueRawLiteral(); }
}

<IN_LIFETIME_OR_CHAR> {
  \'{SUFFIX} { yybegin(YYINITIAL); return RustToken.QUOTE_IDENTIFIER; }
  {CHAR_LITERAL} { yybegin(YYINITIAL); return RustToken.CHAR_LITERAL; }
  <<EOF>> { yybegin(YYINITIAL); return RustToken.BAD_CHARACTER; }
}

[^] { return RustToken.BAD_CHARACTER; }

<<EOF>> { return RustToken.EOF; }