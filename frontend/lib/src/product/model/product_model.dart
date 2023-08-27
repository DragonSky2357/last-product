import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

class Product {
  final String id;
  final String title;
  final String description;
  final int price;
  final File? image;
  final String address;
  final double? latitude;
  final double? longitude;

  Product({
    this.id = "",
    required this.title,
    required this.description,
    required this.price,
    this.image,
    this.address = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        image: json['image'],
        address: json['address'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'address': address,
      'latitude': latitude,
      'longitude': longitude
    };
  }
}
