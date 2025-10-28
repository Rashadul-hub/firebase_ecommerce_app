
import 'package:cloud_firestore/cloud_firestore.dart';

class DbService{
  ///CATEGORIES
  /// Read categories from database
  //Stream all categories from firestore
  Stream<QuerySnapshot> readCategories(){
    return FirebaseFirestore.instance
        .collection("shop_categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }


  //Create new Category
  Future createCategories({required Map<String, dynamic> data})async{
    await FirebaseFirestore.instance.collection("shop_categories").add(data);
  }
  //Update category
  Future updateCategories({required String docId , required Map<String, dynamic> data})async{
    await FirebaseFirestore.instance.collection("shop_categories").doc(docId).update(data);
  }

  //Delete Category
  Future deleteCategories({required String docId })async{
    await FirebaseFirestore.instance.collection("shop_categories").doc(docId).delete();
  }



  ///PRODUCTS
  /// Read products from database
  //Stream all categories from firestore
  Stream<QuerySnapshot> readProducts(){
    return FirebaseFirestore.instance
        .collection("shop_products")
        .orderBy("category", descending: true)
        .snapshots();
  }

  //Create new products
  Future createProduct({required Map<String, dynamic> data})async{
    await FirebaseFirestore.instance.collection("shop_products").add(data);
  }

  //Update products
  Future updateProduct({required String docId , required Map<String, dynamic> data})async{
    await FirebaseFirestore.instance.collection("shop_products").doc(docId).update(data);
  }


  //Delete products
  Future deleteProducts({required String docId })async{
    await FirebaseFirestore.instance.collection("shop_products").doc(docId).delete();
  }

}