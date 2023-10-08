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

import com.blacksquircle.ui.BuildConst

plugins {
    id("com.android.library")
    id("kotlin-android")
    id("com.blacksquircle.publish")
}

publishModule {
    libraryGroup = "com.blacksquircle.ui"
    libraryArtifact = "editorkit"
    libraryVersion = "2.8.0"
}

android {
    compileSdk = BuildConst.COMPILE_SDK
    namespace = "com.blacksquircle.ui.editorkit"

    defaultConfig {
        minSdk = BuildConst.MIN_SDK

        consumerProguardFiles("consumer-rules.pro")
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    sourceSets {
        named("main") {
            java.srcDir("src/main/kotlin")
        }
    }
    publishing {
        singleVariant("release") {
            withSourcesJar()
            withJavadocJar()
        }
    }
}

dependencies {

    // Core
    implementation(libs.kotlin.stdlib)
    implementation(libs.androidx.core)
    implementation(libs.androidx.vectordrawable)

    // Modules
    api(project(":editorkit:language-base"))
}