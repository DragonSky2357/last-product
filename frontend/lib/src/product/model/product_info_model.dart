import 'dart:ffi';
import 'dart:io';

class PostInfo {
  final String id;
  final String title;
  final String description;
  final String? image;
  final String createdAt;
  final int capacity;
  final int fixedPrice;
  final int salePrice;
  final String manufactureDate;
  final String expirationDate;
  final int storeId;
  final String storeName;
  final String storeAddress;
  final double storeLatitude;
  final double storeLongitude;

  PostInfo({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.createdAt,
    required this.capacity,
    required this.fixedPrice,
    required this.salePrice,
    required this.manufactureDate,
    required this.expirationDate,
    required this.storeId,
    required this.storeName,
    required this.storeAddress,
    required this.storeLatitude,
    required this.storeLongitude,
  });

  factory PostInfo.fromJson(Map<String, dynamic> json) {
    return PostInfo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      createdAt: json['created_at'],
      capacity: json['product']['capacity'],
      fixedPrice: json['product']['fixed_price'],
      salePrice: json['product']['sale_price'],
      manufactureDate: json['product']['manufacture_date'],
      expirationDate: json['product']['expiration_date'],
      storeId: json['store']['id'],
      storeName: json['store']['store_name'],
      storeAddress: json['store']['address'],
      storeLatitude: json['store']['latitude'],
      storeLongitude: json['store']['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'createdAt': createdAt,
      'capacity': capacity,
      'fixedPrice': fixedPrice,
      'salePrice': salePrice,
      'manufactureDate': manufactureDate,
      'expirationDate': expirationDate,
      'storeId': storeId,
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storeLatitude': storeLatitude,
      'storeLongitude': storeLongitude,
    };
  }
}
