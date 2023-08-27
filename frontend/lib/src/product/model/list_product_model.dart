import 'dart:convert';
import 'dart:io';

class ListProduct {
  final String id;
  final String title;
  final String description;
  final String? image;
  final String createdAt;
  final int capacity;
  final int fixedPrice;
  final int salePrice;
  final int storeId;
  final String storeName;

  ListProduct({
    this.id = "",
    required this.title,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.capacity,
    required this.fixedPrice,
    required this.salePrice,
    required this.storeId,
    required this.storeName,
  });

  factory ListProduct.fromJson(Map<String, dynamic> json) {
    return ListProduct(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      createdAt: json['created_at'],
      capacity: json['product']['capacity'],
      fixedPrice: json['product']['fixed_price'],
      salePrice: json['product']['sale_price'],
      storeId: json['store']['id'],
      storeName: json['store']['store_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'description': description,
      'image': image,
      'created_at': createdAt,
      'capacity': capacity,
      'fixedPrice': fixedPrice,
      'salePrice': salePrice,
      'storeId': storeId,
      'storeName': storeName,
    };
  }
}
