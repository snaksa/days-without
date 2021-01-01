import 'package:days_without/data/models/category.dart';
import 'package:flutter/material.dart';

List<Category> categories = [
  Category(0, 'Junk Food', Icons.fastfood, Colors.red),
  Category(1, 'Fizzy Drinks', Icons.bubble_chart_outlined, Colors.blue),
  Category(2, 'Alcohol', Icons.wine_bar, Colors.yellow),
  Category(3, 'Smoking', Icons.smoking_rooms, Colors.orange),
  Category(4, 'Coffee', Icons.emoji_food_beverage, Colors.brown),
  Category(5, 'Medicines', Icons.medical_services, Colors.red),
  Category(6, 'Pills', Icons.medical_services_outlined, Colors.yellow),
  Category(7, 'Drugs', Icons.fiber_manual_record, Colors.red),
  Category(8, 'Sweets', Icons.cake, Colors.purple),
  Category(9, 'Gaming', Icons.games_outlined, Colors.orange),
  Category(10, 'TV', Icons.tv, Colors.green),
  Category(11, 'Shopping', Icons.shopping_bag_rounded, Colors.blue),
  Category(12, 'Social Networks', Icons.phone_android, Colors.amber),
  Category(13, 'Other', Icons.autorenew, Colors.cyan),
];

Category findCategory(int id) {
  return categories.firstWhere((category) => category.id == id);
}
