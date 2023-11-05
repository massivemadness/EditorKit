package com.blacksquircle.ui.language.xml.lexer;

@SuppressWarnings("all")
%%

%public
%class XmlLexer
%type XmlToken
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

%state DOC_TYPE
%state COMMENT
%state START_TAG_NAME
%state END_TAG_NAME
%state BEFORE_TAG_ATTRIBUTES
%state TAG_ATTRIBUTES
%state ATTRIBUTE_VALUE
%state PROCESSING_INSTRUCTION
%state TAG_CHARACTERS
%xstate CDATA

ALPHA = [:letter:]
DIGIT = [0-9]
WHITESPACE = [ \n\r\t\f\u2028\u2029\u0085]+

TAG_NAME = ({ALPHA}|"_"|":")({ALPHA}|{DIGIT}|"_"|":"|"."|"-")*
ATTRIBUTE_NAME = ([^ \n\r\t\f\"\'<>/])+

DTD_REF = "\"" [^\"]* "\"" | "'" [^']* "'"
DOCTYPE = "<!" (D|d)(O|o)(C|c)(T|t)(Y|y)(P|p)(E|e)
HTML = (H|h)(T|t)(M|m)(L|l)
PUBLIC = (P|p)(U|u)(B|b)(L|l)(I|i)(C|c)
SYSTEM = (S|s)(Y|y)(S|s)(T|t)(E|e)(M|m)

CRLF = [\ \t \f]* \R
DOUBLE_QUOTED_STRING = \"([^\\\"\r\n] | \\[^\r\n] | \\{CRLF})*\"?
SINGLE_QUOTED_STRING = '([^\\'\r\n] | \\[^\r\n] | \\{CRLF})*'?

START_COMMENT = "<!--"
END_COMMENT = "-->"

%%

<YYINITIAL> {
    {DOCTYPE} { yybegin(DOC_TYPE); return XmlToken.XML_DOCTYPE_START; }

    "<?" { yybegin(PROCESSING_INSTRUCTION); return XmlToken.XML_PI_START; }
    "<" {TAG_NAME} { yybegin(START_TAG_NAME); yypushback(yylength()); }
    "</" {TAG_NAME} { yybegin(END_TAG_NAME); yypushback(yylength()); }

    "<![CDATA[" { yybegin(CDATA); return XmlToken.XML_CDATA_START; }
    "</" { return XmlToken.XML_END_TAG_START; }

    \\\$ { return XmlToken.XML_DATA_CHARACTERS; }
    ([^<&\$# \n\r\t\f]|(\\\$)|(\\#))* { return XmlToken.XML_DATA_CHARACTERS; }

    {START_COMMENT} { yybegin(COMMENT); yypushback(yylength()); }

    {WHITESPACE} { return XmlToken.WHITESPACE; }

    [^] { return XmlToken.XML_DATA_CHARACTERS; }
}

<DOC_TYPE> {
    ">" { yybegin(YYINITIAL); return XmlToken.XML_DOCTYPE_END; }

    {HTML} { return XmlToken.XML_TAG_NAME; }
    {PUBLIC} { return XmlToken.XML_DOCTYPE_PUBLIC; }
    {SYSTEM} { return XmlToken.XML_DOCTYPE_SYSTEM; }
    {DTD_REF} { return XmlToken.XML_ATTRIBUTE_VALUE;}
    {WHITESPACE} { return XmlToken.WHITESPACE; }
}

<PROCESSING_INSTRUCTION> {
    "?"? ">" { yybegin(YYINITIAL); return XmlToken.XML_PI_END; }
    ([^\?\>] | (\?[^\>]))* { return XmlToken.XML_PI_TARGET; }

    {WHITESPACE} { return XmlToken.WHITESPACE; }
}

<TAG_ATTRIBUTES> {
    ">" { yybegin(YYINITIAL); return XmlToken.XML_TAG_END; }
    "/>" { yybegin(YYINITIAL); return XmlToken.XML_EMPTY_ELEMENT_END; }
    \" { yybegin(ATTRIBUTE_VALUE); yypushback(1); }
    \' { yybegin(ATTRIBUTE_VALUE); yypushback(1); }

    {ATTRIBUTE_NAME} { return XmlToken.XML_ATTR_NAME; }
    {WHITESPACE} { return XmlToken.WHITESPACE; }

    [^] { yybegin(YYINITIAL); yypushback(1); break; }
}

<START_TAG_NAME> {
    "<" { return XmlToken.XML_START_TAG_START; }

    {TAG_NAME} { yybegin(BEFORE_TAG_ATTRIBUTES); return XmlToken.XML_TAG_NAME; }
    {WHITESPACE} { return XmlToken.WHITESPACE; }

    [^] { yybegin(YYINITIAL); yypushback(1); break; }
}

<END_TAG_NAME> {
    "</" { return XmlToken.XML_END_TAG_START; }

     {TAG_NAME} { yybegin(BEFORE_TAG_ATTRIBUTES); return XmlToken.XML_TAG_NAME; }
     {WHITESPACE} { return XmlToken.WHITESPACE; }

    [^] { yybegin(YYINITIAL); yypushback(1); break; }
}

<BEFORE_TAG_ATTRIBUTES> {
    ">" { yybegin(YYINITIAL); return XmlToken.XML_TAG_END; }
    "/>" { yybegin(YYINITIAL); return XmlToken.XML_EMPTY_ELEMENT_END; }

    {WHITESPACE} { yybegin(TAG_ATTRIBUTES); return XmlToken.WHITESPACE; }

    [^] { yybegin(YYINITIAL); yypushback(1); break; }
}

<TAG_CHARACTERS> {
    "<" { return XmlToken.XML_START_TAG_START; }
    ">" { yybegin(YYINITIAL); return XmlToken.XML_TAG_END; }
    "/>" { yybegin(YYINITIAL); return XmlToken.XML_EMPTY_ELEMENT_END; }

    {WHITESPACE} { return XmlToken.WHITESPACE; }

    [^] { return XmlToken.XML_TAG_CHARACTERS; }
}

<ATTRIBUTE_VALUE> {
    ">" { yybegin(YYINITIAL); return XmlToken.XML_TAG_END; }
    "/>" { yybegin(YYINITIAL); return XmlToken.XML_EMPTY_ELEMENT_END; }

    {DOUBLE_QUOTED_STRING} { yybegin(TAG_ATTRIBUTES); return XmlToken.XML_ATTRIBUTE_VALUE; }
    {SINGLE_QUOTED_STRING} { yybegin(TAG_ATTRIBUTES); return XmlToken.XML_ATTRIBUTE_VALUE; }

    {WHITESPACE} { return XmlToken.WHITESPACE; }
}

<COMMENT> {
    {END_COMMENT} | "<!-->" { yybegin(YYINITIAL); return XmlToken.XML_COMMENT_CHARACTERS; }

    [^] { return XmlToken.XML_COMMENT_CHARACTERS; }
}

<CDATA>{
    "]]>" { yybegin(YYINITIAL); return XmlToken.XML_CDATA_END; }

    [^] {return XmlToken.XML_DATA_CHARACTERS; }
}

"&lt;" { return XmlToken.XML_CHAR_ENTITY_REF; }
"&gt;" { return XmlToken.XML_CHAR_ENTITY_REF; }
"&apos;" { return XmlToken.XML_CHAR_ENTITY_REF; }
"&quot;" { return XmlToken.XML_CHAR_ENTITY_REF; }
"&nbsp;" { return XmlToken.XML_CHAR_ENTITY_REF; }
"&amp;" { return XmlToken.XML_CHAR_ENTITY_REF; }
"&#"{DIGIT}+";" { return XmlToken.XML_CHAR_ENTITY_REF; }
"&#"[xX]({DIGIT}|[a-fA-F])+";" { return XmlToken.XML_CHAR_ENTITY_REF; }

"&"{TAG_NAME}";" { return XmlToken.XML_ENTITY_REF_TOKEN; }

[^] { return XmlToken.BAD_CHARACTER; }

<<EOF>> { return XmlToken.EOF; }