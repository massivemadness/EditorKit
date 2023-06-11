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

package com.blacksquircle.ui.language.rust.styler

import com.blacksquircle.ui.language.base.model.SyntaxHighlightResult
import com.blacksquircle.ui.language.base.model.TextStructure
import com.blacksquircle.ui.language.base.model.TokenType
import com.blacksquircle.ui.language.base.styler.LanguageStyler
import com.blacksquircle.ui.language.rust.lexer.RustLexer
import com.blacksquircle.ui.language.rust.lexer.RustToken
import java.io.StringReader
import java.util.regex.Pattern

class RustStyler private constructor() : LanguageStyler {

    companion object {

        private val METHOD = Pattern.compile("(?<=(fn)) (\\w+)")

        private var rustStyler: RustStyler? = null

        fun getInstance(): RustStyler {
            return rustStyler ?: RustStyler().also {
                rustStyler = it
            }
        }
    }

    override fun execute(structure: TextStructure): List<SyntaxHighlightResult> {
        val source = structure.text.toString()
        val syntaxHighlightResults = mutableListOf<SyntaxHighlightResult>()
        val sourceReader = StringReader(source)
        val lexer = RustLexer(sourceReader)

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
                    RustToken.NUMBER_LITERAL -> {
                        val tokenType = TokenType.NUMBER
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.LBRACE,
                    RustToken.RBRACE,
                    RustToken.LBRACK,
                    RustToken.RBRACK,
                    RustToken.LPAREN,
                    RustToken.RPAREN,
                    RustToken.DOUBLE_COLON,
                    RustToken.COLON,
                    RustToken.DOTDOT,
                    RustToken.DOTDOTDOT,
                    RustToken.DOTDOTEQ,
                    RustToken.EQ,
                    RustToken.EXCLEQ,
                    RustToken.EQEQ,
                    RustToken.EXCL,
                    RustToken.PLUSEQ,
                    RustToken.PLUS,
                    RustToken.MINUSEQ,
                    RustToken.MINUS,
                    RustToken.SHA,
                    RustToken.OREQ,
                    RustToken.ANDEQ,
                    RustToken.AND,
                    RustToken.OR,
                    RustToken.LT,
                    RustToken.XOREQ,
                    RustToken.XOR,
                    RustToken.MULEQ,
                    RustToken.MUL,
                    RustToken.DIVEQ,
                    RustToken.DIV,
                    RustToken.REMEQ,
                    RustToken.REM,
                    RustToken.GT,
                    RustToken.ARROW,
                    RustToken.FAT_ARROW,
                    RustToken.QUEST,
                    RustToken.TILDE,
                    RustToken.AT,
                    RustToken.DOLLAR -> {
                        val tokenType = TokenType.OPERATOR
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.SEMICOLON,
                    RustToken.COMMA,
                    RustToken.DOT -> {
                        continue // skip
                    }
                    RustToken.AS,
                    RustToken.BOX,
                    RustToken.BREAK,
                    RustToken.CONST,
                    RustToken.CONTINUE,
                    RustToken.CRATE,
                    RustToken.DYN,
                    RustToken.ELSE,
                    RustToken.ENUM,
                    RustToken.EXTERN,
                    RustToken.FN,
                    RustToken.FOR,
                    RustToken.IF,
                    RustToken.IMPL,
                    RustToken.IN,
                    RustToken.LET,
                    RustToken.LOOP,
                    RustToken.MACRO,
                    RustToken.MATCH,
                    RustToken.MOD,
                    RustToken.MOVE,
                    RustToken.MUT,
                    RustToken.PUB,
                    RustToken.REF,
                    RustToken.RETURN,
                    RustToken.CSELF,
                    RustToken.SELF,
                    RustToken.STATIC,
                    RustToken.STRUCT,
                    RustToken.SUPER,
                    RustToken.TRAIT,
                    RustToken.TYPE,
                    RustToken.UNSAFE,
                    RustToken.USE,
                    RustToken.WHERE,
                    RustToken.WHILE,
                    RustToken.YIELD -> {
                        val tokenType = TokenType.KEYWORD
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.U_SIZE,
                    RustToken.I_SIZE,
                    RustToken.U_8,
                    RustToken.U_16,
                    RustToken.U_32,
                    RustToken.U_64,
                    RustToken.U_128,
                    RustToken.I_8,
                    RustToken.I_16,
                    RustToken.I_32,
                    RustToken.I_64,
                    RustToken.I_128,
                    RustToken.F_32,
                    RustToken.F_64 -> {
                        val tokenType = TokenType.TYPE
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.TRUE,
                    RustToken.FALSE -> {
                        val tokenType = TokenType.LANG_CONST
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.ATTRIBUTE -> {
                        val tokenType = TokenType.PREPROCESSOR
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.QUOTE_IDENTIFIER,
                    RustToken.BYTE_LITERAL,
                    RustToken.CHAR_LITERAL,
                    RustToken.STRING_LITERAL,
                    RustToken.BYTE_STRING_LITERAL -> {
                        val tokenType = TokenType.STRING
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.RAW_STRING_LITERAL,
                    RustToken.RAW_BYTE_STRING_LITERAL -> {
                        val tokenType = TokenType.STRING
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.rawLiteralStart, lexer.rawLiteralEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.LINE_COMMENT,
                    RustToken.BLOCK_COMMENT -> {
                        val tokenType = TokenType.COMMENT
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    RustToken.IDENTIFIER,
                    RustToken.WHITESPACE,
                    RustToken.BAD_CHARACTER -> {
                        continue
                    }
                    RustToken.EOF -> {
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