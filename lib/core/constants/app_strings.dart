/// Cadenas de texto estáticas de KakeiboPro.
///
/// Centraliza todos los literales de la UI para facilitar futuras
/// traducciones y evitar "magic strings" dispersos en el código.
class AppStrings {
  AppStrings._(); // Clase no instanciable

  // ── General ──────────────────────────────────────────────────────────────
  static const String appName = 'KakeiboPro';

  // ── Categorías Kakeibo ───────────────────────────────────────────────────
  static const String kakeiboCategorySupervivencia = 'Supervivencia';
  static const String kakeiboCategorycultura = 'Cultura';
  static const String kakeiboCategoryOcio = 'Ocio';
  static const String kakeiboCategoryExtras = 'Extras';
  static const String kakeiboCategoryMesada = 'Mesada';
  static const String kakeiboCategoryInversion = 'Inversión';

  // ── Nombres de sobres ────────────────────────────────────────────────────
  // Supervivencia (6)
  static const String envelopeSupermercado = 'Supermercado y carnes';
  static const String envelopeGasolina = 'Gasolina y peajes';
  static const String envelopeServicios = 'Servicios del hogar';
  static const String envelopeSeguros = 'Seguros';
  static const String envelopeSalud = 'Salud y farmacia';
  static const String envelopeTarjetas = 'Tarjetas de crédito';

  // Cultura (3)
  static const String envelopeEducacionHijos = 'Educación hijos (colegio)';
  static const String envelopeUniversidad = 'Universidad Sofía';
  static const String envelopeEntretenimientoDigital = 'Entretenimiento digital';

  // Ocio (3)
  static const String envelopeRestaurantes = 'Restaurantes y sodas';
  static const String envelopeActividades = 'Actividades y salidas';
  static const String envelopeRopa = 'Ropa y accesorios';

  // Extras (4)
  static const String envelopeApoyoSobrina = 'Apoyo a sobrina';
  static const String envelopeApoyoSuegra = 'Apoyo a suegra';
  static const String envelopeApoyoCunada = 'Apoyo a cuñada';
  static const String envelopeImprevistos = 'Imprevistos y préstamos';

  // Mesada (2)
  static const String envelopeMesadaAndres = 'Mesada Andrés';
  static const String envelopeMesadaEmiliano = 'Mesada Emiliano';

  // Inversión (2)
  static const String envelopeBnfondos = 'BNFONDOS / Inversiones';
  static const String envelopeFondoEmergencia = 'Fondo de emergencia';

  // ── Navegación ───────────────────────────────────────────────────────────
  static const String navSobres = 'Sobres';
  static const String navResumen = 'Resumen';
  static const String navKakeibo = 'Kakeibo';
  static const String navPerfil = 'Perfil';

  // ── Sobres ───────────────────────────────────────────────────────────────
  static const String sobresTitle = 'Mis sobres';
  static const String sobresVacioTitle = 'Sin sobres aún';
  static const String sobresVacioSubtitle =
      'Crea tu primer sobre para empezar a organizar tus gastos familiares.';
  static const String sobresCrearCta = 'Crear primer sobre';
  static const String sobresPresupuesto = 'Presupuesto';
  static const String sobresGastado = 'Gastado';
  static const String sobreDisponible = 'Disponible';
  static const String sobreSobrepasado = 'Sobrepasado';
}
