import 'package:firebase_ecommerce_flutter/containers/dashboard_text.dart';
import 'package:firebase_ecommerce_flutter/containers/home_button.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_service.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(onPressed: ()async{
            // Provider.of<AdminProvider>(context,listen: false).cancelProvider();
            await AuthService().logout();
            Navigator.pushNamedAndRemoveUntil(context, "/login",  (route)=> false);
          }, icon: Icon(Icons.logout))
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 235,
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardText(keyword: "Total products", value: "100"),
                  DashboardText(keyword: "Total products", value: "100"),
                  DashboardText(keyword: "Total products", value: "100"),
                  DashboardText(keyword: "Total products", value: "100"),
                  DashboardText(keyword: "Total products", value: "100"),
                ],
              ),
            ),
        
            // Buttons for Admins
            Row(
              children: [
                HomeButton(onTap: () {}, name: "Orders"),
                HomeButton(onTap: () {
                  Navigator.pushNamed(context, "/products");
                }, name: "Products"),
              ],
            ),
            Row(
              children: [
                HomeButton(onTap: () {}, name: "Promos"),
                HomeButton(onTap: () {}, name: "Banners"),
              ],
            ),
            Row(
              children: [
                HomeButton(onTap: () {
                  Navigator.pushNamed(context, "/category");
                }, name: "Categories"),
                HomeButton(onTap: () {}, name: "Coupons"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
