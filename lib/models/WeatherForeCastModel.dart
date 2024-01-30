import 'dart:core';

class WeatherForeCastModel {
  String latitude = '';
  String longitude = '';
  String generationtime_ms = '';
  String timezone = '';
  List<WeatherItem> items = [];
}

class WeatherItem{
  String time = '';
  String weather = '';
}
