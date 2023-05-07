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

package com.blacksquircle.ui.language.go.styler

import com.blacksquircle.ui.language.base.model.SyntaxHighlightResult
import com.blacksquircle.ui.language.base.model.TextStructure
import com.blacksquircle.ui.language.base.model.TokenType
import com.blacksquircle.ui.language.base.styler.LanguageStyler
import com.blacksquircle.ui.language.go.lexer.GoLexer
import com.blacksquircle.ui.language.go.lexer.GoToken
import java.io.StringReader
import java.util.regex.Pattern

class GoStyler private constructor() : LanguageStyler {

    companion object {

        private val METHOD = Pattern.compile("(?<=(func)) (\\w+)")

        private var goStyler: GoStyler? = null

        fun getInstance(): GoStyler {
            return goStyler ?: GoStyler().also {
                goStyler = it
            }
        }
    }

    override fun execute(structure: TextStructure): List<SyntaxHighlightResult> {
        val source = structure.text.toString()
        val syntaxHighlightResults = mutableListOf<SyntaxHighlightResult>()
        val sourceReader = StringReader(source)
        val lexer = GoLexer(sourceReader)

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
                    GoToken.LITERAL_NUMBER_DECIMAL_INT,
                    GoToken.LITERAL_NUMBER_HEXADECIMAL,
                    GoToken.LITERAL_NUMBER_FLOAT -> {
                        val tokenType = TokenType.NUMBER
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    GoToken.BREAK,
                    GoToken.CASE,
                    GoToken.CHAN,
                    GoToken.CONST,
                    GoToken.CONTINUE,
                    GoToken.DEFAULT,
                    GoToken.DEFER,
                    GoToken.ELSE,
                    GoToken.FALLTHROUGH,
                    GoToken.FOR,
                    GoToken.FUNC,
                    GoToken.GO,
                    GoToken.GOTO,
                    GoToken.IF,
                    GoToken.IMPORT,
                    GoToken.INTERFACE,
                    GoToken.MAP,
                    GoToken.PACKAGE,
                    GoToken.RANGE,
                    GoToken.SELECT,
                    GoToken.STRUCT,
                    GoToken.SWITCH,
                    GoToken.TYPE,
                    GoToken.VAR,
                    GoToken.RETURN -> {
                        val tokenType = TokenType.KEYWORD
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    GoToken.BOOL,
                    GoToken.STRING,
                    GoToken.INT,
                    GoToken.INT_8,
                    GoToken.INT_16,
                    GoToken.INT_32,
                    GoToken.INT_64,
                    GoToken.UINT,
                    GoToken.UINT_8,
                    GoToken.UINT_16,
                    GoToken.UINT_32,
                    GoToken.UINT_64,
                    GoToken.UINTPTR,
                    GoToken.BYTE,
                    GoToken.RUNE,
                    GoToken.FLOAT_32,
                    GoToken.FLOAT_64,
                    GoToken.COMPLEX_64,
                    GoToken.COMPLEX_128 -> {
                        val tokenType = TokenType.TYPE
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    GoToken.APPEND,
                    GoToken.CAP,
                    GoToken.CLOSE,
                    GoToken.COMPLEX,
                    GoToken.COPY,
                    GoToken.DELETE,
                    GoToken.IMAG,
                    GoToken.LEN,
                    GoToken.MAKE,
                    GoToken.NEW,
                    GoToken.PANIC,
                    GoToken.PRINT,
                    GoToken.PRINTLN,
                    GoToken.REAL,
                    GoToken.RECOVER,
                    GoToken.COMPARE,
                    GoToken.CONTAINS,
                    GoToken.CONTAINS_ANY,
                    GoToken.CONTAINS_RUNE,
                    GoToken.COUNT,
                    GoToken.EQUALS_FOLD,
                    GoToken.FIELDS,
                    GoToken.FIELDS_FUNC,
                    GoToken.HAS_PREFIX,
                    GoToken.HAS_SUFFIX,
                    GoToken.INDEX,
                    GoToken.INDEX_ANY,
                    GoToken.INDEX_BYTE,
                    GoToken.INDEX_FUNC,
                    GoToken.INDEX_RUNE,
                    GoToken.JOIN,
                    GoToken.LAST_INDEX,
                    GoToken.LAST_INDEX_ANY,
                    GoToken.LAST_INDEX_BYTE,
                    GoToken.LAST_INDEX_FUNC,
                    GoToken.REPEAT,
                    GoToken.REPLACE,
                    GoToken.REPLACE_ALL,
                    GoToken.SPLIT,
                    GoToken.SPLIT_AFTER,
                    GoToken.SPLIT_AFTER_N,
                    GoToken.SPLIT_N,
                    GoToken.TITLE,
                    GoToken.TO_LOWER,
                    GoToken.TO_LOWER_SPECIAL,
                    GoToken.TO_TITLE,
                    GoToken.TO_TITLE_SPECIAL,
                    GoToken.TO_UPPER,
                    GoToken.TO_UPPSER_SPECIAL,
                    GoToken.TRIM,
                    GoToken.TRIM_FUNC,
                    GoToken.TRIM_LEFT,
                    GoToken.TRIM_LEFT_FUNC,
                    GoToken.TRIM_PREFIX,
                    GoToken.TRIM_RIGHT,
                    GoToken.TRIM_RIGHT_FUNC,
                    GoToken.TRIM_SPACE,
                    GoToken.TRIM_SUFFIX -> {
                        val tokenType = TokenType.METHOD
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    GoToken.TRUE,
                    GoToken.FALSE,
                    GoToken.NIL -> {
                        val tokenType = TokenType.LANG_CONST
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    GoToken.LPAREN,
                    GoToken.RPAREN,
                    GoToken.LBRACE,
                    GoToken.RBRACE,
                    GoToken.LBRACK,
                    GoToken.RBRACK,
                    GoToken.TRIGRAPH,
                    GoToken.EQ,
                    GoToken.COLONEQ,
                    GoToken.PLUS,
                    GoToken.MINUS,
                    GoToken.MULT,
                    GoToken.DIV,
                    GoToken.MOD,
                    GoToken.TILDE,
                    GoToken.LT,
                    GoToken.ARROW,
                    GoToken.GT,
                    GoToken.GTGT,
                    GoToken.LTLT,
                    GoToken.EQEQ,
                    GoToken.PLUSEQ,
                    GoToken.MINUSEQ,
                    GoToken.MULTEQ,
                    GoToken.DIVEQ,
                    GoToken.MODEQ,
                    GoToken.ANDEQ,
                    GoToken.OREQ,
                    GoToken.XOREQ,
                    GoToken.GTEQ,
                    GoToken.LTEQ,
                    GoToken.NOTEQ,
                    GoToken.GTGTEQ,
                    GoToken.LTLTEQ,
                    GoToken.XOR,
                    GoToken.AND,
                    GoToken.ANDAND,
                    GoToken.ANDXOR,
                    GoToken.ANDXOREQ,
                    GoToken.ELLIPSIS,
                    GoToken.OR,
                    GoToken.OROR,
                    GoToken.QUEST,
                    GoToken.NOT,
                    GoToken.PLUSPLUS,
                    GoToken.MINUSMINUS,
                    GoToken.COLON -> {
                        val tokenType = TokenType.OPERATOR
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    GoToken.SEMICOLON,
                    GoToken.COMMA,
                    GoToken.DOT -> {
                        continue // skip
                    }
                    GoToken.DOUBLE_QUOTED_STRING,
                    GoToken.SINGLE_QUOTED_STRING -> {
                        val tokenType = TokenType.STRING
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    GoToken.LINE_COMMENT,
                    GoToken.BLOCK_COMMENT -> {
                        val tokenType = TokenType.COMMENT
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    GoToken.IDENTIFIER,
                    GoToken.WHITESPACE,
                    GoToken.BAD_CHARACTER -> {
                        continue
                    }
                    GoToken.EOF -> {
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