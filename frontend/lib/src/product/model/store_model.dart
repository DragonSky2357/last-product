import 'dart:ffi';
import 'dart:io';

class Store {
  final int id;
  final String businessRegistrationNumber;
  final String? image;
  final String storeName;
  final String description;
  final String address;
  final double? latitude;
  final double? longitude;
  final String openTime;
  final String closeTime;
  final String startBreakTime;
  final String endBreakTime;

  Store(
      {required this.id,
      required this.businessRegistrationNumber,
      required this.image,
      required this.storeName,
      required this.description,
      required this.address,
      required this.latitude,
      required this.longitude,
      required this.openTime,
      required this.closeTime,
      required this.startBreakTime,
      required this.endBreakTime});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      businessRegistrationNumber: json['business_registration_number'],
      image: json['image'],
      storeName: json['store_name'],
      description: json['description'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      startBreakTime: json['start_break_time'],
      endBreakTime: json['end_break_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'businessRegistrationNumber': businessRegistrationNumber,
      'image': image,
      'storeName': storeName,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'openTime': openTime,
      'closeTime': closeTime,
      'startBreakTime': startBreakTime,
      'endBreakTime': endBreakTime,
    };
  }
}
