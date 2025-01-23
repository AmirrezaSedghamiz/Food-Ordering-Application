// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:data_base_project/SourceDesign/Item.dart';
import 'package:postgres/postgres.dart';

class Category {
  String name;
  List<Item> items;

  Category({
    required this.name,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'items': items.map((item) {
        final data = item.toJson();
        return data;
      }).toList(),
    };
  }

  static Future<void> insertCategories(
      {required int restaurantId, required List<Category> categories}) async {
    final connection = await Connection.open(
        Endpoint(
          host: '163.5.94.58',
          port: 5432,
          database: 'mashmammad',
          username: 'postgres',
          password: 'Erfank2004@',
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.disable,
        ));
    String categoriesJson =
        jsonEncode(categories.map((category) => category.toJson()).toList());
    print(categoriesJson);
    try {
      connection;
      var result = await connection.execute(
          Sql.named(
              'SELECT update_categories_with_items(@restaurant_id ,@categories)'),
          parameters: {
            'restaurant_id': restaurantId,
            'categories': categoriesJson
          });
      print('Success');
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
    return;
  }

  static Future<List<Category>?> getCategoriesByRestaurantId(
      {required int restaurantId,
      required int page,
      required int pageSize}) async {
    final connection = await Connection.open(
        Endpoint(
          host: '163.5.94.58',
          port: 5432,
          database: 'mashmammad',
          username: 'postgres',
          password: 'Erfank2004@',
        ),
        settings: const ConnectionSettings(
          sslMode: SslMode.disable,
        ));

    try {
      connection;
      var result = await connection.execute(
          Sql.named(
              'SELECT get_items_by_restaurant(@input_restaurant_id , @page , @page_size)'),
          parameters: {
            'input_restaurant_id': restaurantId,
            'page': page,
            'page_size': pageSize,
          });
      dynamic finalRes = result[0][0];
      print(finalRes);
      final value = Category.fromJson(finalRes);
      print('afdafsdfsdsdf');
      return value;
    } catch (e) {
      print('Error: $e');
    } finally {
      await connection.close();
    }
    return null;
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['category_name'] as String,
      items: (map['items'] as List<dynamic>).map((itemMap) => Item.fromMap(itemMap as Map<String, dynamic>)).toList(),
    );
  }

  static List<Category> fromJson(List<dynamic> source) {
    return source
        .map((jsonCategory) => Category.fromMap(jsonCategory))
        .toList();
  }
}

// [
//   {
//     "name": "Starters",
//     "items": [
//       {
//         "name": "Soup",
//         "recipe": "Soup Recipe",
//         "cost": 4.99,
//         "isDeleted": false,
//         "image": null
//       },
//       {
//         "name": "Salad",
//         "recipe": "Salad Recipe",
//         "cost": 5.99,
//         "isDeleted": false,
//         "image": null
//       }
//     ]
//   },
//   {
//     "name": "Main Course",
//     "items": [
//       {
//         "name": "Steak",
//         "recipe": "Steak Recipe",
//         "cost": 19.99,
//         "isDeleted": false,
//         "image": null
//       }
//     ]
//   }
// ]
