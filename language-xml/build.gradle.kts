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

import com.blacksquircle.gradle.Gradle

plugins {
    id("java-library")
    id("kotlin")
}

Gradle.Maven.libraryGroupId = "com.blacksquircle.ui"
Gradle.Maven.libraryArtifactId = "language-xml"

apply(from = "../../gradle/publish.gradle")

group = Gradle.Maven.libraryGroupId
version = Gradle.Maven.libraryVersionName

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

sourceSets {
    named("main") {
        java.srcDir("src/main/kotlin")
    }
}

dependencies {

    // Core
    implementation(libs.kotlin)

    // Modules
    api(project(":editorkit:language-base"))
}