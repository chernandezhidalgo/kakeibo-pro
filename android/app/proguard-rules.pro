# ML Kit text recognition — modelos de idioma opcionales (chino, japonés, coreano, devanagari)
# Solo se necesita el modelo Latin para OCR de recibos en español/inglés.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# FindBugs — anotaciones solo de tiempo de compilación usadas por MSAL
-dontwarn edu.umd.cs.findbugs.annotations.**

# BouncyCastle — dependencia opcional de nimbus-jose (MSAL)
# La implementación usa javax.crypto (disponible en Android) como fallback.
-dontwarn org.bouncycastle.**
