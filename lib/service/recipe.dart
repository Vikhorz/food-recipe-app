import 'package:flutter/material.dart';

class Recipe {
  final String name;
  final String images;
  final double rating;
  final String totalTime;
  final String description;
  final String prepStep1;
  final String prepStep2;
  final String prepStep3;
  final String prepStep4;

  // final String proteins;
  // final String carbohydrates;
  // final String fats;

  Recipe({
    required this.name,
    required this.images,
    required this.rating,
    required this.totalTime,
    required this.description,
    required this.prepStep1,
    required this.prepStep2,
    required this.prepStep3,
    required this.prepStep4,
    // required this.proteins,
    // required this.carbohydrates,
    // required this.fats
  });

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
      name: json['details']['name'] as String,
      images: json['details']['images'][0]['resizableImageUrl'] as String,
      rating: json['details']['rating'] as double,
      totalTime: json['details']['totalTime'] as String,
      description: json['description']['text'] as String,
      prepStep1: json['preparationSteps'][0] as String,
      prepStep2: json['preparationSteps'][1] as String,
      prepStep3: json['preparationSteps'][2] as String,
      prepStep4: json['preparationSteps'][3] as String,

      // proteins: json['proteins'] as String,
      // carbohydrates: json['carbohydrates'] as String,
      // fats: json['fats'] as String
    );
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe {name: $name, image: $images, rating: $rating, totalTime: $totalTime, description: $description, prepStep1: $prepStep1, prepStep2: $prepStep2, prepStep3: $prepStep3, prepStep4: $prepStep4,}';
  }
}
