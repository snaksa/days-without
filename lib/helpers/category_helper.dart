import 'package:days_without/data/models/category.dart';
import 'package:flutter/material.dart';

class CategoryHelper {
  static final List<Category> categories = [
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
    Category(14, 'Adult Entertainment', Icons.live_tv, Colors.orange),
    Category(15, 'Intimacy', Icons.favorite, Colors.red),
    Category(16, 'OCD', Icons.track_changes, Colors.indigo),
    Category(17, 'Procrastination', Icons.schedule, Colors.purple),
    Category(18, 'Meat', Icons.food_bank, Colors.redAccent),
    Category(19, 'Dairy', Icons.opacity, Colors.blueAccent),
    Category(20, 'Swearing', Icons.record_voice_over, Colors.teal),
    Category(21, 'Sinning', Icons.self_improvement, Colors.orangeAccent),
    Category(22, 'Abuse', Icons.shield, Colors.deepOrange),
    Category(23, 'Anger', Icons.sentiment_dissatisfied, Colors.red),
    Category(13, 'Other', Icons.autorenew, Colors.cyan),
  ];

  static Category findCategory(int id) {
    return categories.firstWhere((category) => category.id == id);
  }
}
