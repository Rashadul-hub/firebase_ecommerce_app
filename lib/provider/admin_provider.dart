import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_flutter/controllers/db_service.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier{
  List<QueryDocumentSnapshot>categories = [];
  StreamSubscription<QuerySnapshot>? _categorySubscriptions;


  List<QueryDocumentSnapshot>products = [];
  StreamSubscription<QuerySnapshot>? _productSubscriptions;

  int totalCategories = 0;
  int totalProducts = 0;

  AdminProvider(){
   getCategories();
   getProducts();
  }

  //Get All the Categories
  void getCategories(){
    _categorySubscriptions?.cancel();
    _categorySubscriptions = DbService().readCategories().listen((snapshot){
      categories = snapshot.docs;
      totalCategories = snapshot.docs.length;
      notifyListeners();
    });
  }

  //Get All the Products
  void getProducts(){
    _productSubscriptions?.cancel();
    _productSubscriptions = DbService().readProducts().listen((snapshot){
      products = snapshot.docs;
      totalProducts = snapshot.docs.length;
      notifyListeners();
    });
  }




}