import 'package:flutter/material.dart';
import 'package:open_location_picker/open_location_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<FormattedLocation> reverseLocation({
  required Locale locale,
  required LatLng location,
}) async {
  var url = Uri.parse("https://nominatim.openstreetmap.org/reverse");

  url = url.replace(
    queryParameters: {
      "lat": location.latitude.toString(),
      "lon": location.longitude.toString(),
      "format": "jsonv2",
      "namedetails": "1",
      "accept-language": locale.languageCode,
      "addressdetails": "1",
      "polygon_geojson": "1",
      "extratags": "1",
    },
  );
  var response = await http.get(url);

  var parsed = jsonDecode(response.body);
  return FormattedLocation.fromJson(parsed);
}
