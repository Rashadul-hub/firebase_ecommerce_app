import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_flutter/controllers/db_service.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier{
  List<QueryDocumentSnapshot>categories = [];
  StreamSubscription<QuerySnapshot>? _categorySubscriptions;

  int totalCategories = 0;

  AdminProvider(){
   getCategories();
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




}