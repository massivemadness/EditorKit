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

package com.blacksquircle.ui.language.latex.styler

import com.blacksquircle.ui.language.base.model.SyntaxHighlightResult
import com.blacksquircle.ui.language.base.model.TextStructure
import com.blacksquircle.ui.language.base.model.TokenType
import com.blacksquircle.ui.language.base.styler.LanguageStyler
import com.blacksquircle.ui.language.latex.lexer.LatexLexer
import com.blacksquircle.ui.language.latex.lexer.LatexToken
import java.io.StringReader

class LatexStyler private constructor() : LanguageStyler {

    companion object {

        private var latexStyler: LatexStyler? = null

        fun getInstance(): LatexStyler {
            return latexStyler ?: LatexStyler().also {
                latexStyler = it
            }
        }
    }

    override fun execute(structure: TextStructure): List<SyntaxHighlightResult> {
        val source = structure.text.toString()
        val syntaxHighlightResults = mutableListOf<SyntaxHighlightResult>()
        val sourceReader = StringReader(source)
        val lexer = LatexLexer(sourceReader)

        while (true) {
            try {
                when (lexer.advance()) {
                    LatexToken.RESERVED_WORD -> {
                        val tokenType = TokenType.KEYWORD
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    LatexToken.FUNCTION -> {
                        val tokenType = TokenType.ATTR_VALUE
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    LatexToken.LENGTH,
                    LatexToken.NUMBER -> {
                        val tokenType = TokenType.NUMBER
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    LatexToken.BEGIN_BLOCK -> {
                        for (token in lexer.beginTokens) {
                            val tokenType = when (token.token) {
                                LatexToken.RESERVED_WORD -> TokenType.KEYWORD
                                LatexToken.SEPARATOR -> TokenType.TAG_NAME
                                else -> throw IllegalArgumentException()
                            }
                            val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                            syntaxHighlightResults.add(syntaxHighlightResult)
                        }
                    }
                    LatexToken.END_BLOCK -> {
                        for (token in lexer.endTokens) {
                            val tokenType = when (token.token) {
                                LatexToken.RESERVED_WORD -> TokenType.KEYWORD
                                LatexToken.SEPARATOR -> TokenType.TAG_NAME
                                else -> throw IllegalArgumentException()
                            }
                            val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                            syntaxHighlightResults.add(syntaxHighlightResult)
                        }
                    }
                    LatexToken.LPAREN,
                    LatexToken.RPAREN,
                    LatexToken.LBRACE,
                    LatexToken.RBRACE,
                    LatexToken.LBRACK,
                    LatexToken.RBRACK,
                    LatexToken.SEPARATOR -> {
                        val tokenType = TokenType.OPERATOR
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    LatexToken.LINE_COMMENT -> {
                        val tokenType = TokenType.COMMENT
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    LatexToken.IDENTIFIER,
                    LatexToken.WHITESPACE,
                    LatexToken.BAD_CHARACTER -> {
                        continue
                    }
                    LatexToken.EOF -> {
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