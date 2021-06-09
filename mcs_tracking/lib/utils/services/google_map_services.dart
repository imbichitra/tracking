import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


const API_KEY = "AIzaSyAdWZcIlR6JQCxy3dwN83p385SMjAGsUTs";

class GoogleMapServices {
  Future<String> getRouteCoordinate(LatLng l1, LatLng l2) async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$API_KEY";
    http.Response response =await http.get(url);
    print(response.statusCode);
    Map values = jsonDecode(response.body);
    print(values);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}