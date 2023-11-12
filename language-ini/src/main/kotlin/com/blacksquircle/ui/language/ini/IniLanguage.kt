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

package com.blacksquircle.ui.language.ini

import com.blacksquircle.ui.language.base.Language
import com.blacksquircle.ui.language.base.parser.LanguageParser
import com.blacksquircle.ui.language.base.provider.SuggestionProvider
import com.blacksquircle.ui.language.base.styler.LanguageStyler
import com.blacksquircle.ui.language.ini.parser.IniParser
import com.blacksquircle.ui.language.ini.provider.IniProvider
import com.blacksquircle.ui.language.ini.styler.IniStyler

class IniLanguage : Language {

    companion object {
        const val LANGUAGE_NAME = "ini"
    }

    override val languageName = LANGUAGE_NAME

    override fun getParser(): LanguageParser {
        return IniParser.getInstance()
    }

    override fun getProvider(): SuggestionProvider {
        return IniProvider.getInstance()
    }

    override fun getStyler(): LanguageStyler {
        return IniStyler.getInstance()
    }
}