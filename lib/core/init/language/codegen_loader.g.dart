// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _tr_TR = {
  "title": "Altur Yakın Duraklar",
  "transport_type": {
    "metrobus": "Metrobüs",
    "bus": "Otobüs",
    "tram": "Tramvay"
  },
  "nearby_stops": "Duraklar (Mesafeye Göre)",
  "location_permission": {
    "title": "Konum İzni Gerekli",
    "description": "Yakındaki durakları gösterebilmek için konum izninize ihtiyacımız var. Lütfen ayarlardan konum iznini etkinleştirin.",
    "go_to_settings": "Ayarlara Git",
    "dismiss": "Kapat"
  }
};
static const Map<String,dynamic> _en_US = {
  "title": "Altur Nearby Stops",
  "transport_type": {
    "metrobus": "Metrobus",
    "bus": "Bus",
    "tram": "Tram"
  },
  "nearby_stops": "Stops (By Distance)",
  "location_permission": {
    "title": "Location Permission Required",
    "description": "We need your location permission to show nearby stops. Please enable location permission from settings.",
    "go_to_settings": "Go to Settings",
    "dismiss": "Dismiss"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"tr_TR": _tr_TR, "en_US": _en_US};
}
