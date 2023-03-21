import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const dev = 'http://10.0.2.2:3000/';
const prod = 'https://k6kk3hg2r6.execute-api.ap-south-1.amazonaws.com/dev/';

class Bookings with ChangeNotifier {
  final String token;
  final String username;
  final String userId;
  Bookings(this.token, this.username, this.userId);

  List<dynamic> mybookings = [];

  List<dynamic> get bookings {
    return mybookings;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  List<String> _timeslots = [];

  List<String> _selectedServices = [];

  List<String> get timeslots {
    return _timeslots;
  }

  int _serviceAmount = 0;

  int _serviceTime = 0;

  String _selectedTiming = "";

  String _selectedSalonId = "";

  String _selectedSalon = "";

  String _selectedSalonToken = "";

  String _latitude = "0.0";
  String _longitude = "0.0";

  void setcoordinates({
    required String latitude,
    required String longitude,
  }) {
    _latitude = latitude;
    _longitude = longitude;
  }

  void addSalonToken(String val) {
    _selectedSalonToken = val;
  }

  void addSalonId(String val) {
    _selectedSalonId = val;
    notifyListeners();
  }

  void addSalonName(String val) {
    _selectedSalon = val;
    notifyListeners();
  }

  String get selectedTiming {
    return _selectedTiming;
  }

  void addSelectedTiming(String val) {
    _selectedTiming = val;
    notifyListeners();
  }

  int get serviceAmount {
    return _serviceAmount;
  }

  int get serviceTime {
    return _serviceTime;
  }

  List<String> get selectedServices {
    return _selectedServices;
  }

  List<String> salonBookings = [];

  List<String> get bookedSlots {
    return salonBookings;
  }

  void addSalonBooking(List<dynamic> data) {
    // code to push the booking data to salonBookings
    List<String> bookedSlots = [];
    for (int i = 0; i < data.length; i++) {
      bookedSlots.add(data[i]['selectedTiming']);
    }
    salonBookings = bookedSlots;
  }

  void addService(String val) {
    _selectedServices.add(val);
    notifyListeners();
  }

  void removeService(String val) {
    _selectedServices.remove(val);
    notifyListeners();
  }

  void addServiceTime(int val) {
    _serviceTime += val;
    notifyListeners();
  }

  void removeServiceTime(int val) {
    _serviceTime -= val;
    notifyListeners();
  }

  void addServiceAmount(int val) {
    _serviceAmount += val;
    notifyListeners();
  }

  void removeServiceAmount(int val) {
    _serviceAmount -= val;
    notifyListeners();
  }

  void resetServiceContent() {
    _serviceAmount = 0;
    _serviceTime = 0;
    _selectedTiming = "";
    _selectedServices = [];
    notifyListeners();
  }

  TimeOfDay dateConverter(String val) {
    // procedures for converting a date from string to milliseconds
    // 1. regex and extract the things
    RegExp regExp = RegExp(r'(\w+)');
    var matches = regExp.allMatches(val).map((z) => z[0]).toList();

    int hours = matches[2] == 'AM'
        ? int.parse(matches[0]!)
        : int.parse(matches[0]!) + 12;

    int minutes = int.parse(matches[1]!);

    return TimeOfDay(hour: hours, minute: minutes);
  }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  void slotMaker(String start, String end, BuildContext context) {
    final startTime = dateConverter(start);
    final endTime = dateConverter(end);
    const step = Duration(minutes: 30);

    final times = getTimes(startTime, endTime, step)
        .where(
          (ele) => ele.hour > TimeOfDay.now().hour,
        )
        .map((tod) => tod.format(context))
        .toList();

    _timeslots = times;
  }

  Future<void> getbookings() async {
    _isLoading = true;
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${prod}api/customer/bookings');

    try {
      final response = await http.get(
        url,
        headers: requestHeaders,
      );
      final responseData = jsonDecode(response.body);
      _isLoading = false;
      mybookings = responseData['bookings'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> booksalon() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${prod}api/customer/booksalon');

    try {
      final response = await http.post(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          'userId': userId,
          "salonId": _selectedSalonId,
          "salonName": _selectedSalon,
          'username': username,
          'services': _selectedServices,
          'serviceTime': _serviceTime,
          'serviceAmount': _serviceAmount,
          'selectedTiming': _selectedTiming,
          'regToken': _selectedSalonToken,
          'latitude': _latitude,
          'longitude': _longitude,
        }),
      );

      final responseData = jsonDecode(response.body);
      mybookings = responseData["bookings"];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancelBooking({
    required String salonName,
    required String bookingtime,
    required String salonId,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final url = Uri.parse('${prod}api/customer/bookings');

    try {
      final response = await http.patch(
        url,
        headers: requestHeaders,
        body: jsonEncode({
          "salonId": salonId,
          "salonName": salonName,
          "bookingtime": bookingtime,
        }),
      );

      final responseData = jsonDecode(response.body);
      mybookings = responseData["bookings"];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
