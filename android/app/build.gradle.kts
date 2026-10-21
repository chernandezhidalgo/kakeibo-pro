import java.util.Properties
import java.io.FileInputStream
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Google Services Ã¢â‚¬â€ necesario para FCM. Requiere google-services.json en android/app/.
    // Ã¢Å¡Â Ã¯Â¸Â Paso manual: descarga google-services.json desde Firebase Console y colÃƒÂ³calo aquÃƒÂ­.
    id("com.google.gms.google-services")
}

// key.properties solo hace falta para firmar release. Debug no lo usa.
val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
val hasReleaseKeystore = keyPropertiesFile.exists()
if (hasReleaseKeystore) {
    keyProperties.load(FileInputStream(keyPropertiesFile))
    val requiredKeys = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
    val blankKeys = requiredKeys.filter { keyProperties.getProperty(it).isNullOrBlank() }
    if (blankKeys.isNotEmpty()) {
        throw GradleException(
            "android/key.properties esta incompleto. Faltan: ${blankKeys.joinToString(", ")}. " +
                "Hacen falta storeFile, storePassword, keyAlias y keyPassword.",
        )
    }
}

android {
    namespace = "com.hernandezromero.kakeibo_pro"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.hernandezromero.kakeibo_pro"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Release exige android/key.properties. No se reutiliza la firma de debug.
        if (hasReleaseKeystore) {
            create("release") {
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
                storeFile = file(keyProperties.getProperty("storeFile")!!)
                storePassword = keyProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseKeystore) {
                signingConfig = signingConfigs.getByName("release")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.material:material:1.12.0")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

// Falla bundleRelease y assembleRelease antes de compilar si no hay keystore.
// Las tareas de debug no contienen "Release" y no dependen de esta comprobación.
val checkReleaseKeystore = tasks.register("checkReleaseKeystore") {
    doLast {
        if (!keyPropertiesFile.exists()) {
            throw GradleException(
                """
                No se puede firmar el release: falta android/key.properties.
                El build de release no usa la firma de debug.
                Crea android/key.properties con storeFile, storePassword, keyAlias y keyPassword
                (puedes copiar android/key.properties.template) y vuelve a lanzar
                bundleRelease o assembleRelease.
                Los builds de debug no necesitan ese archivo.
                """.trimIndent(),
            )
        }
    }
}

tasks.configureEach {
    if (name != "checkReleaseKeystore" && name.contains("Release")) {
        dependsOn(checkReleaseKeystore)
    }
}
