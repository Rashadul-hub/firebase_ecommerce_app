import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart'as http;


/// CLOUDINARY STORAGE
class CloudinaryStorageService{

  /// TO UPLOAD IMAGE TO CLOUDINARY STORAGE
  Future<String?> uploadImageToCloudinary(String path, BuildContext context)async{

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Uploading image...")));
    print("Uploading image...");

    File file = File(path);
    String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';

    try{

      // Cloudinary upload endpoint
      final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');


      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // read the file content as bytes
      var fileBytes = await file.readAsBytes();
      var multipartFile= http.MultipartFile.fromBytes('file', fileBytes, filename:  file.path.split("/").last);

      // Add the file part to the request
      request.files.add(multipartFile);

      // Add Cloudinary preset
      request.fields['upload_preset'] = "store-image";
      // request.fields['resource_type'] = "raw";

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("Cloudinary ::Future<String?> uploadImage > responseBody: ${responseBody}");

      // Decode response
      final data = json.decode(responseBody);

      if (response.statusCode == 200 && data['secure_url'] != null) {
        print("✅ File Upload Successful!");
        return data['secure_url'];
      }
      else{
        print("❌ Upload failed: ${data['error'] ?? response.statusCode}");
        return null;
      }


    }catch(e){
      print("Error at  Future<String?>0 uploadImage \n$e");
      return null;
    }

  }


}

/// FIREBASE STORAGE
class FirebaseStorageService{

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// TO UPLOAD IMAGE TO FIREBASE STORAGE
  Future<String?> uploadImageToFirebase(String path, BuildContext context)async{

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Uploading image...")));
    print("Uploading image...");

    File file = File(path);

    try{

      /// Create a unique file name based on the current time
      String fileName = DateTime.now().toString();

      /// Create a reference to Firebase storage
      Reference ref = _storage.ref().child("shop_images/$fileName");

      /// Upload the file
      UploadTask uploadTask = ref.putFile(file);

      /// Wait for the upload to complete
      await uploadTask;

      /// Get the download URL
      String downloadURL = await ref.getDownloadURL();
      print("Download URL: $downloadURL");
      return downloadURL;

    }catch(e){
      print("Error at  Future<String?>0 uploadImage \n$e");
      return null;
    }

  }

}
