// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'PulseNow';

  @override
  String get retry => 'Reintentar';

  @override
  String get refresh => 'Actualizar';

  @override
  String get noMarketDataAvailable => 'No hay datos de mercado disponibles';

  @override
  String get hours24 => '24h';

  @override
  String get noInternetConnection => 'Sin Conexión a Internet';

  @override
  String get noInternetMessage =>
      'No hay conexión a internet. Por favor verifica tu red e intenta de nuevo.';

  @override
  String get serverError => 'Error del Servidor';

  @override
  String get serverErrorMessage =>
      'Error del servidor. Por favor intenta más tarde.';

  @override
  String get connectionTimeout => 'Tiempo de Conexión Agotado';

  @override
  String get timeoutMessage =>
      'Tiempo de espera agotado. Por favor verifica tu conexión e intenta de nuevo.';

  @override
  String get error => 'Error';

  @override
  String get unexpectedError =>
      'Ocurrió un error inesperado. Por favor intenta de nuevo.';

  @override
  String get sortBy => 'Ordenar por:';

  @override
  String get sortBySymbol => 'Símbolo';

  @override
  String get sortByPrice => 'Precio';

  @override
  String get sortByChange => 'Cambio';

  @override
  String get ascending => 'Ascendente';

  @override
  String get descending => 'Descendente';

  @override
  String get searchMarketData => 'Buscar por símbolo (ej., BTC/USD)';

  @override
  String get noResultsFound => 'No se encontraron resultados';

  @override
  String showingOf(int count, int total) {
    return 'Mostrando $count de $total';
  }

  @override
  String get currentPrice => 'Precio Actual';

  @override
  String get description => 'Descripción';

  @override
  String get about => 'Acerca de';

  @override
  String get marketStatistics => 'Estadísticas del Mercado';

  @override
  String get volume24h => 'Volumen (24h)';

  @override
  String get marketCap => 'Capitalización de Mercado';

  @override
  String get high24h => 'Máximo 24h';

  @override
  String get low24h => 'Mínimo 24h';

  @override
  String get lastUpdated => 'Última actualización';

  @override
  String get analytics => 'Análisis';

  @override
  String get errorLoadingAnalytics => 'Error al cargar análisis';

  @override
  String get marketOverview => 'Resumen del Mercado';

  @override
  String get totalMarketCap => 'Capitalización Total del Mercado';

  @override
  String get totalVolume24h => 'Volumen 24h';

  @override
  String get activeMarkets => 'Mercados Activos';

  @override
  String get marketSentiment => 'Sentimiento del Mercado';

  @override
  String get overallSentiment => 'General';

  @override
  String get bullish => 'Alcista';

  @override
  String get neutral => 'Neutral';

  @override
  String get bearish => 'Bajista';

  @override
  String get fearGreedIndex => 'Índice de Miedo y Codicia';

  @override
  String get socialSentiment => 'Sentimiento Social';

  @override
  String get technicalAnalysis => 'Análisis Técnico';

  @override
  String get onChainMetrics => 'Métricas On-Chain';

  @override
  String get noAnalyticsDataAvailable => 'No hay datos de análisis disponibles';

  @override
  String get loadAnalytics => 'Cargar Análisis';

  @override
  String get portfolio => 'Cartera';

  @override
  String get errorLoadingPortfolio => 'Error al cargar cartera';

  @override
  String get portfolioSummary => 'Resumen de Cartera';

  @override
  String get totalValue => 'Valor Total';

  @override
  String get totalPnL => 'Ganancia/Pérdida Total';

  @override
  String get totalPnLPercent => 'Ganancia/Pérdida Total %';

  @override
  String get holdings => 'Tenencias';

  @override
  String get quantity => 'Cantidad';

  @override
  String get noHoldings => 'Sin tenencias';

  @override
  String get portfolioHoldingsAppearHere =>
      'Tus tenencias de cartera aparecerán aquí';

  @override
  String get noPortfolioDataAvailable => 'No hay datos de cartera disponibles';

  @override
  String get loadPortfolio => 'Cargar Cartera';

  @override
  String get marketData => 'Datos de Mercado';

  @override
  String get switchToLightMode => 'Cambiar a modo claro';

  @override
  String get switchToDarkMode => 'Cambiar a modo oscuro';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get offlineModeShowingCachedData =>
      'Modo sin conexión - Mostrando datos en caché';

  @override
  String get updated => 'Actualizado';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String minutesAgo(int count) {
    return 'hace ${count}m';
  }

  @override
  String hoursAgo(int count) {
    return 'hace ${count}h';
  }

  @override
  String daysAgo(int count) {
    return 'hace ${count}d';
  }

  @override
  String get pageNotFound => 'Página no encontrada';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get goHome => 'Ir al Inicio';

  @override
  String get marketDataNotFound => 'Datos de mercado no encontrados';

  @override
  String get unknown => 'Desconocido';

  @override
  String get live => 'En Vivo';
}
