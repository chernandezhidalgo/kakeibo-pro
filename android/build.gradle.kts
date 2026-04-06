allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)
subprojects {
    configurations.all {
        resolutionStrategy {
            force("com.google.android.material:material:1.12.0")
        }
    }
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
subprojects {
    configurations.all {
        resolutionStrategy {
            force("com.google.android.material:material:1.12.0")
        }
    }
    val skipAll = listOf("sqlcipher_flutter_libs")
    plugins.withId("com.android.library") {
        configure<com.android.build.gradle.LibraryExtension> {
            if (namespace == null) {
                namespace = project.group.toString()
            }
        }
    }
    afterEvaluate {
        // compileSdk = 36 se aplica a TODOS los plugins (incluido sqlcipher_flutter_libs)
        // para que AAPT encuentre android:attr/lStar (introducido en API 31)
        plugins.withId("com.android.library") {
            configure<com.android.build.gradle.LibraryExtension> {
                compileSdk = 36
            }
        }
        // JVM 17 solo para plugins que lo soportan (sqlcipher usa su propia toolchain nativa)
        if (project.name !in skipAll) {
            plugins.withId("com.android.library") {
                configure<com.android.build.gradle.LibraryExtension> {
                    compileOptions {
                        sourceCompatibility = JavaVersion.VERSION_17
                        targetCompatibility = JavaVersion.VERSION_17
                    }
                }
            }
            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
                    languageVersion.set(org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_1_9)
                    apiVersion.set(org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_1_9)
                }
            }
            tasks.withType<JavaCompile>().configureEach {
                sourceCompatibility = JavaVersion.VERSION_17.toString()
                targetCompatibility = JavaVersion.VERSION_17.toString()
            }
        }
    }
}

