// // ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'dart:convert';

// import 'package:data_base_project/SourceDesign/Category.dart';
// import 'package:data_base_project/SourceDesign/Item.dart';
// import 'package:postgres/postgres.dart';

// class ItemCategory {
//   Category category;
//   Item item;
//   ItemCategory({
//     required this.category,
//     required this.item,
//   });



//   factory ItemCategory.fromMap(Map<String, dynamic> map) {
//     // Parse the item and category from the map
//     return ItemCategory(
//       item: Item.fromMap(map['item']),
//       category: Category(
//         categoryId: map['categoryid'],
//         name: map['category_name'],
//       ),
//     );
//   }

//   // Function to parse the response into a list of ItemCategory
//   static List<ItemCategory> fromJsonList(String source) {
//     final List<dynamic> jsonList = json.decode(source);
//     return jsonList.map((jsonItem) => ItemCategory.fromMap(jsonItem)).toList();
//   }
// }
