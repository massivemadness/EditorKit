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

package com.blacksquircle.ui.language.rust.lexer

enum class RustToken {
    NUMBER_LITERAL,

    AS,
    BOX,
    BREAK,
    CONST,
    CONTINUE,
    CRATE,
    DYN,
    ELSE,
    ENUM,
    EXTERN,
    FN,
    FOR,
    IF,
    IMPL,
    IN,
    LET,
    LOOP,
    MACRO,
    MATCH,
    MOD,
    MOVE,
    MUT,
    PUB,
    REF,
    RETURN,
    CSELF,
    SELF,
    STATIC,
    STRUCT,
    SUPER,
    TRAIT,
    TYPE,
    UNSAFE,
    USE,
    WHERE,
    WHILE,
    YIELD,

    U_SIZE,
    I_SIZE,
    U_8,
    U_16,
    U_32,
    U_64,
    U_128,
    I_8,
    I_16,
    I_32,
    I_64,
    I_128,
    F_32,
    F_64,

    TRUE,
    FALSE,

    LBRACE,
    RBRACE,
    LBRACK,
    RBRACK,
    LPAREN,
    RPAREN,

    SEMICOLON,
    COMMA,
    DOT,
    DOUBLE_COLON,
    COLON,
    DOTDOT,
    DOTDOTDOT,
    DOTDOTEQ,
    EQ,
    EXCLEQ,
    EQEQ,
    EXCL,
    PLUSEQ,
    PLUS,
    MINUSEQ,
    MINUS,
    SHA,
    OREQ,
    ANDEQ,
    AND,
    OR,
    LT,
    XOREQ,
    XOR,
    MULEQ,
    MUL,
    DIVEQ,
    DIV,
    REMEQ,
    REM,
    GT,
    ARROW,
    FAT_ARROW,
    QUEST,
    TILDE,
    AT,
    DOLLAR,

    ATTRIBUTE,

    QUOTE_IDENTIFIER,
    BYTE_LITERAL,
    CHAR_LITERAL,

    STRING_LITERAL,
    BYTE_STRING_LITERAL,
    RAW_STRING_LITERAL,
    RAW_BYTE_STRING_LITERAL,

    LINE_COMMENT,
    BLOCK_COMMENT,

    IDENTIFIER,
    WHITESPACE,
    BAD_CHARACTER,
    EOF
}