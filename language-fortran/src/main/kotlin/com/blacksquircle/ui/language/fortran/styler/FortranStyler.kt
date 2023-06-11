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

package com.blacksquircle.ui.language.fortran.styler

import com.blacksquircle.ui.language.base.model.SyntaxHighlightResult
import com.blacksquircle.ui.language.base.model.TextStructure
import com.blacksquircle.ui.language.base.model.TokenType
import com.blacksquircle.ui.language.base.styler.LanguageStyler
import com.blacksquircle.ui.language.fortran.lexer.FortranLexer
import com.blacksquircle.ui.language.fortran.lexer.FortranToken
import java.io.StringReader
import java.util.regex.Pattern

class FortranStyler private constructor() : LanguageStyler {

    companion object {

        private val METHOD = Pattern.compile("(?<=(function|subroutine)) (\\w+)", Pattern.CASE_INSENSITIVE)

        private var fortranStyler: FortranStyler? = null

        fun getInstance(): FortranStyler {
            return fortranStyler ?: FortranStyler().also {
                fortranStyler = it
            }
        }
    }

    override fun execute(structure: TextStructure): List<SyntaxHighlightResult> {
        val source = structure.text.toString()
        val syntaxHighlightResults = mutableListOf<SyntaxHighlightResult>()
        val sourceReader = StringReader(source)
        val lexer = FortranLexer(sourceReader)

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
                    FortranToken.NUMBER_LITERAL -> {
                        val tokenType = TokenType.NUMBER
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    FortranToken.INCLUDE,
                    FortranToken.PROGRAM,
                    FortranToken.MODULE,
                    FortranToken.SUBROUTINE,
                    FortranToken.INTERFACE,
                    FortranToken.FUNCTION,
                    FortranToken.CONTAINS,
                    FortranToken.RECURSIVE,
                    FortranToken.USE,
                    FortranToken.CALL,
                    FortranToken.RETURN,
                    FortranToken.IMPLICIT,
                    FortranToken.EXPLICIT,
                    FortranToken.NONE,
                    FortranToken.DATA,
                    FortranToken.TYPE,
                    FortranToken.PARAMETER,
                    FortranToken.ALLOCATE,
                    FortranToken.ALLOCATABLE,
                    FortranToken.ALLOCATED,
                    FortranToken.DEALLOCATE,
                    FortranToken.INTEGER,
                    FortranToken.DOUBLE,
                    FortranToken.PRECISION,
                    FortranToken.COMPLEX,
                    FortranToken.CHARACTER,
                    FortranToken.DIMENSION,
                    FortranToken.KIND,
                    FortranToken.CASE,
                    FortranToken.ERROR,
                    FortranToken.SELECT,
                    FortranToken.DEFAULT,
                    FortranToken.CONTINUE,
                    FortranToken.CYCLE,
                    FortranToken.DO,
                    FortranToken.WHILE,
                    FortranToken.ELSE,
                    FortranToken.IF,
                    FortranToken.ELSEIF,
                    FortranToken.THEN,
                    FortranToken.ELSEWHERE,
                    FortranToken.END,
                    FortranToken.ENDIF,
                    FortranToken.ENDDO,
                    FortranToken.FORALL,
                    FortranToken.WHERE,
                    FortranToken.EXIT,
                    FortranToken.GOTO,
                    FortranToken.PAUSE,
                    FortranToken.STOP,
                    FortranToken.BACKSPACE,
                    FortranToken.CLOSE,
                    FortranToken.ENDFILE,
                    FortranToken.INQUIRE,
                    FortranToken.OPEN,
                    FortranToken.PRINT,
                    FortranToken.READ,
                    FortranToken.REWIND,
                    FortranToken.WRITE,
                    FortranToken.FORMAT,
                    FortranToken.AINT,
                    FortranToken.AMAX0,
                    FortranToken.AMIN0,
                    FortranToken.CEILING,
                    FortranToken.CMPLX,
                    FortranToken.DCMPLX,
                    FortranToken.DFLOAT,
                    FortranToken.DPROD,
                    FortranToken.FLOAT,
                    FortranToken.FLOOR,
                    FortranToken.IFIX,
                    FortranToken.IMAG,
                    FortranToken.INT,
                    FortranToken.LOGICAL,
                    FortranToken.MODULO,
                    FortranToken.REAL,
                    FortranToken.TRANSFER,
                    FortranToken.ZEXT,
                    FortranToken.ABS,
                    FortranToken.ACOS,
                    FortranToken.AIMAG,
                    FortranToken.ALOG,
                    FortranToken.ALOG10,
                    FortranToken.AMAX1,
                    FortranToken.AMIN1,
                    FortranToken.AMOD,
                    FortranToken.ANINT,
                    FortranToken.ASIN,
                    FortranToken.ATAN,
                    FortranToken.ATAN2,
                    FortranToken.CABS,
                    FortranToken.CCOS,
                    FortranToken.CHAR,
                    FortranToken.CLOG,
                    FortranToken.CONJG,
                    FortranToken.COS,
                    FortranToken.COSH,
                    FortranToken.CSIN,
                    FortranToken.CSQRT,
                    FortranToken.DABS,
                    FortranToken.DACOS,
                    FortranToken.DASIN,
                    FortranToken.DATAN,
                    FortranToken.DATAN2,
                    FortranToken.DBLE,
                    FortranToken.DCOS,
                    FortranToken.DCOSH,
                    FortranToken.DDIM,
                    FortranToken.DEXP,
                    FortranToken.DIM,
                    FortranToken.DINT,
                    FortranToken.DLOG,
                    FortranToken.DLOG10,
                    FortranToken.DMAX1,
                    FortranToken.DMIN1,
                    FortranToken.DMOD,
                    FortranToken.DNINT,
                    FortranToken.DREAL,
                    FortranToken.DSIGN,
                    FortranToken.DSIN,
                    FortranToken.DSINH,
                    FortranToken.DSQRT,
                    FortranToken.DTAN,
                    FortranToken.DTANH,
                    FortranToken.EXP,
                    FortranToken.IABS,
                    FortranToken.ICHAR,
                    FortranToken.IDIM,
                    FortranToken.IDINT,
                    FortranToken.IDNINT,
                    FortranToken.INDEX,
                    FortranToken.ISIGN,
                    FortranToken.LEN,
                    FortranToken.LGE,
                    FortranToken.LGT,
                    FortranToken.LLE,
                    FortranToken.LLT,
                    FortranToken.LOG,
                    FortranToken.LOG10,
                    FortranToken.MAX,
                    FortranToken.MAX0,
                    FortranToken.MAX1,
                    FortranToken.MIN,
                    FortranToken.MIN0,
                    FortranToken.MIN1,
                    FortranToken.MOD,
                    FortranToken.NINT,
                    FortranToken.SIGN,
                    FortranToken.SIN,
                    FortranToken.SINH,
                    FortranToken.SNGL,
                    FortranToken.SQRT,
                    FortranToken.TAN,
                    FortranToken.TANH -> {
                        syntaxHighlightResults.add(
                            SyntaxHighlightResult(
                                tokenType = TokenType.KEYWORD,
                                start = lexer.tokenStart,
                                end = lexer.tokenEnd
                            )
                        )
                    }
                    FortranToken.TRUE,
                    FortranToken.FALSE -> {
                        val tokenType = TokenType.LANG_CONST
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    FortranToken.LPAREN,
                    FortranToken.RPAREN,
                    FortranToken.LBRACE,
                    FortranToken.RBRACE,
                    FortranToken.LBRACK,
                    FortranToken.RBRACK,
                    FortranToken.LT_OPERATOR,
                    FortranToken.GT_OPERATOR,
                    FortranToken.LTEQ,
                    FortranToken.GTEQ,
                    FortranToken.AND_OPERATOR,
                    FortranToken.DIVEQ,
                    FortranToken.EQEQ,
                    FortranToken.EQ_OPERATOR,
                    FortranToken.DOUBLE_COLON,
                    FortranToken.LT,
                    FortranToken.GT,
                    FortranToken.EQ,
                    FortranToken.NE,
                    FortranToken.LE,
                    FortranToken.GE,
                    FortranToken.AND,
                    FortranToken.OR -> {
                        val tokenType = TokenType.OPERATOR
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    FortranToken.DOUBLE_QUOTED_STRING,
                    FortranToken.SINGLE_QUOTED_STRING -> {
                        val tokenType = TokenType.STRING
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    FortranToken.LINE_COMMENT -> {
                        val tokenType = TokenType.COMMENT
                        val syntaxHighlightResult = SyntaxHighlightResult(tokenType, lexer.tokenStart, lexer.tokenEnd)
                        syntaxHighlightResults.add(syntaxHighlightResult)
                    }
                    FortranToken.IDENTIFIER,
                    FortranToken.WHITESPACE,
                    FortranToken.BAD_CHARACTER -> {
                        continue
                    }
                    FortranToken.EOF -> {
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