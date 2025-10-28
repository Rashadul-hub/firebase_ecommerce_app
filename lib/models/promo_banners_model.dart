import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBannersModel{
  String title, image, category,id;

  PromoBannersModel({
    required this.title,
    required this.image,
    required this.category,
    required this.id,


  });

  /// convert to json to object model
  factory PromoBannersModel.fromJson(Map<String,dynamic> json, String id){

    return PromoBannersModel(
      id: id,
      title: json["title"]?? "",
      image: json["image"] ?? "" ,
      category: json["category"] ?? "" ,
    );
  }


  // Convert List<>QueryDocumentSnapshot> to List<CategoriesModel>
  static List<PromoBannersModel> fromJsonList(List<QueryDocumentSnapshot> list) =>
      list.map((e) => PromoBannersModel.fromJson(e.data() as Map<String, dynamic>, e.id)).toList();


}