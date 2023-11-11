/*
 * Copyright 2023 Squircle CE contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.blacksquircle.ui.language.php.styler

import com.blacksquircle.ui.language.base.model.SyntaxHighlightResult
import com.blacksquircle.ui.language.base.model.TextStructure
import com.blacksquircle.ui.language.base.model.TokenType
import com.blacksquircle.ui.language.base.styler.LanguageStyler
import com.blacksquircle.ui.language.php.lexer.PhpLexer
import com.blacksquircle.ui.language.php.lexer.PhpToken
import java.io.StringReader
import java.util.regex.Pattern

class PhpStyler : LanguageStyler {

    companion object {

        private val METHOD = Pattern.compile("(?<=(function)) (\\w+)")

        private var phpStyler: PhpStyler? = null

        fun getInstance(): PhpStyler {
            return phpStyler ?: PhpStyler().also {
                phpStyler = it
            }
        }
    }

    override fun execute(structure: TextStructure): List<SyntaxHighlightResult> {
        val source = structure.text.toString()
        val syntaxHighlightResults = mutableListOf<SyntaxHighlightResult>()
        val sourceReader = StringReader(source)
        val lexer = PhpLexer(sourceReader)

        // FIXME flex doesn't support positive lookbehind
        val matcher = METHOD.matcher(source)
        matcher.region(0, source.length)
        while (matcher.find()) {
            val tokenType = TokenType.METHOD
            val syntaxHighlightResult = SyntaxHighlightResult(tokenType, matcher.start(), matcher.end())
            syntaxHighlightResults.add(syntaxHighlightResult)
        }

        while (true) {
            try {
                when (lexer.advance()) {
                    PhpToken.INTEGER_LITERAL,
                    PhpToken.FLOAT_LITERAL,
                    PhpToken.DOUBLE_LITERAL -> {
                        val tokenType = TokenType.NUMBER
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    PhpToken.VARIABLE_LITERAL -> {
                        val tokenType = TokenType.VARIABLE
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    PhpToken.PLUS,
                    PhpToken.MINUS,
                    PhpToken.LTEQ,
                    PhpToken.XOR,
                    PhpToken.PLUSPLUS,
                    PhpToken.LT,
                    PhpToken.MULT,
                    PhpToken.GTEQ,
                    PhpToken.MOD,
                    PhpToken.MINUSMINUS,
                    PhpToken.GT,
                    PhpToken.DIV,
                    PhpToken.NOTEQ,
                    PhpToken.QUEST,
                    PhpToken.GTGT,
                    PhpToken.NOT,
                    PhpToken.AND,
                    PhpToken.EQEQ,
                    PhpToken.COLON,
                    PhpToken.TILDA,
                    PhpToken.OROR,
                    PhpToken.ANDAND,
                    PhpToken.GTGTGT,
                    PhpToken.EQ,
                    PhpToken.MINUSEQ,
                    PhpToken.MULTEQ,
                    PhpToken.DIVEQ,
                    PhpToken.OREQ,
                    PhpToken.ANDEQ,
                    PhpToken.XOREQ,
                    PhpToken.PLUSEQ,
                    PhpToken.MODEQ,
                    PhpToken.LTLTEQ,
                    PhpToken.GTGTEQ,
                    PhpToken.GTGTGTEQ,
                    PhpToken.LPAREN,
                    PhpToken.RPAREN,
                    PhpToken.LBRACE,
                    PhpToken.RBRACE,
                    PhpToken.LBRACK,
                    PhpToken.RBRACK -> {
                        val tokenType = TokenType.OPERATOR
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    PhpToken.SEMICOLON,
                    PhpToken.COMMA,
                    PhpToken.DOT -> {
                        continue // skip
                    }
                    PhpToken.ABSTRACT,
                    PhpToken.AS,
                    PhpToken.BREAK,
                    PhpToken.CALLABLE,
                    PhpToken.CASE,
                    PhpToken.CATCH,
                    PhpToken.CONST,
                    PhpToken.CLASS,
                    PhpToken.CLONE,
                    PhpToken.CONTINUE,
                    PhpToken.DEBUGGER,
                    PhpToken.DEFAULT,
                    PhpToken.DELETE,
                    PhpToken.DO,
                    PhpToken.EACH,
                    PhpToken.ELSE,
                    PhpToken.ELSEIF,
                    PhpToken.ENUM,
                    PhpToken.EXPORT,
                    PhpToken.EXTENDS,
                    PhpToken.FINAL,
                    PhpToken.FINALLY,
                    PhpToken.FN,
                    PhpToken.FOR,
                    PhpToken.FOREACH,
                    PhpToken.FUNCTION,
                    PhpToken.GOTO,
                    PhpToken.GLOBAL,
                    PhpToken.IF,
                    PhpToken.IMPLEMENTS,
                    PhpToken.IMPORT,
                    PhpToken.IN,
                    PhpToken.INCLUDE,
                    PhpToken.INCLUDE_ONCE,
                    PhpToken.INSTANCEOF,
                    PhpToken.INSTEADOF,
                    PhpToken.INTERFACE,
                    PhpToken.LET,
                    PhpToken.NAMESPACE,
                    PhpToken.NATIVE,
                    PhpToken.NEW,
                    PhpToken.PACKAGE,
                    PhpToken.PARENT,
                    PhpToken.PRIVATE,
                    PhpToken.PROTECTED,
                    PhpToken.PUBLIC,
                    PhpToken.READONLY,
                    PhpToken.REQUIRE,
                    PhpToken.REQUIRE_ONCE,
                    PhpToken.RETURN,
                    PhpToken.SELF,
                    PhpToken.STATIC,
                    PhpToken.SUPER,
                    PhpToken.SWITCH,
                    PhpToken.SYNCHRONIZED,
                    PhpToken.THIS,
                    PhpToken.THROW,
                    PhpToken.THROWS,
                    PhpToken.TYPEOF,
                    PhpToken.TRAIT,
                    PhpToken.TRANSIENT,
                    PhpToken.TRY,
                    PhpToken.VAR,
                    PhpToken.VOID,
                    PhpToken.VOLATILE,
                    PhpToken.WHILE,
                    PhpToken.WITH -> {
                        syntaxHighlightResults.add(
                            SyntaxHighlightResult(
                                tokenType = TokenType.KEYWORD,
                                start = lexer.tokenStart,
                                end = lexer.tokenEnd
                            )
                        )
                    }
                    PhpToken.BOOLEAN,
                    PhpToken.BYTE,
                    PhpToken.CHAR,
                    PhpToken.DOUBLE,
                    PhpToken.FLOAT,
                    PhpToken.INT,
                    PhpToken.LONG,
                    PhpToken.SHORT -> {
                        val tokenType = TokenType.TYPE
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    PhpToken.TRUE,
                    PhpToken.FALSE,
                    PhpToken.NULL,
                    PhpToken.NAN,
                    PhpToken.INFINITY -> {
                        val tokenType = TokenType.LANG_CONST
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    PhpToken.ARRAY,
                    PhpToken.DIE,
                    PhpToken.EVAL,
                    PhpToken.EMPTY,
                    PhpToken.ESCAPE,
                    PhpToken.ECHO,
                    PhpToken.EXIT,
                    PhpToken.LIST,
                    PhpToken.PARSEINT,
                    PhpToken.PARSEFLOAT,
                    PhpToken.PRINT,
                    PhpToken.UNESCAPE,
                    PhpToken.UNSET,
                    PhpToken.ISSET,
                    PhpToken.ISNAN,
                    PhpToken.ISFINITE -> {
                        val tokenType = TokenType.METHOD
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    PhpToken.DOUBLE_QUOTED_STRING,
                    PhpToken.SINGLE_QUOTED_STRING -> {
                        val tokenType = TokenType.STRING
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    PhpToken.LINE_COMMENT,
                    PhpToken.BLOCK_COMMENT -> {
                        val tokenType = TokenType.COMMENT
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    PhpToken.IDENTIFIER,
                    PhpToken.WHITESPACE,
                    PhpToken.BAD_CHARACTER -> {
                        continue
                    }
                    PhpToken.EOF -> {
                        break
                    }
                }
            } catch (e: Throwable) {
                e.printStackTrace()
                break
            }
        }
        return syntaxHighlightResults
    }
}