import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationState with ChangeNotifier {
  Position? _currentPosition;
  String _currentAddress = "";

  String get currentAddress {
    return _currentAddress;
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true,
      );
      _currentPosition = position;

      getAddressFromCoords();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getAddressFromCoords() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];
      if (place.subLocality!.isNotEmpty) {
        _currentAddress = place.subLocality!;
      } else {
        _currentAddress = place.locality!;
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  double distanceBetweenCoords(
    endLatitude,
    endLongitude,
  ) {
    if (_currentPosition == null) {
      getCurrentLocation();
    }
    double distanceInMeters = Geolocator.distanceBetween(
      _currentPosition?.latitude ?? 0,
      _currentPosition?.longitude ?? 0,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters / 1000;
  }
}
