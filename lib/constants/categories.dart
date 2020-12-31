import 'package:days_without/data/models/category.dart';
import 'package:flutter/material.dart';

List<Category> categories = [
  Category(0, 'Food', Icons.food_bank, Colors.red),
  Category(1, 'Alcohol', Icons.wine_bar, Colors.yellow),
  Category(2, 'Smoking', Icons.smoking_rooms, Colors.orange),
];

Category findCategory(int id) {
  try {
  return categories.firstWhere((category) => category.id == id);
  }
  catch(err) {
    return Category(0, 'No name', Icons.call, Colors.red);
  }
}