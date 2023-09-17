import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

class Product {
  final String id;
  final String title;
  final String description;
  final int fixedPrice;
  final int salePrice;
  final DateTime manufactureDate;
  final DateTime expirationDate;
  final File? image;

  Product({
    this.id = "",
    required this.title,
    required this.description,
    required this.fixedPrice,
    required this.salePrice,
    required this.manufactureDate,
    required this.expirationDate,
    this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      fixedPrice: json['fixed_price'],
      salePrice: json['sale_price'],
      manufactureDate: json['manufacture_date'],
      expirationDate: json['expiration_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'fixedPrice': fixedPrice,
      'salePrice': salePrice,
      'manufactureDate': manufactureDate,
      'expirationDate': expirationDate
    };
  }
}
