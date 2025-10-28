import 'dart:io';

import 'package:firebase_ecommerce_flutter/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../containers/additional_confirm.dart';
import '../controllers/db_service.dart';
import '../controllers/storage_service.dart';
import '../provider/admin_provider.dart';
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
      body: Consumer<AdminProvider>(builder: (context , value , child){
        List<ProductsModel>products = ProductsModel.fromJsonList(value.products) as List<ProductsModel>;

        if(products.isEmpty){
          return Center(child: Text('No Products Found'));
        }

        return ListView.builder(
            itemCount: value.products.length,
            itemBuilder: (context, index){
              return ListTile(
                onTap: (){
                 Navigator.pushNamed(context, "/view_product", arguments:  products[index]);
                },
                onLongPress: (){
                  showDialog(context: context, builder: (context) =>
                      AlertDialog(
                        title: Text("What you want to do"),
                        content: Text("Delete action cannot be undone"),
                        actions: [
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                            showDialog(context: context, builder: (context)=>
                                AdditionalConfirm(
                                  contentText: "Are you sure you want to delete this item ?",
                                  onYes: (){
                                    DbService().deleteProducts(docId: products[index].id);
                                    Navigator.pop(context);
                                  },
                                  onNo: (){Navigator.pop(context);},
                                ));
                          }, child: Text("Delete Product")),
                          // TextButton(onPressed: (){
                          //   Navigator.pop(context);
                          //   Navigator.pushNamed(context, "/add_product", arguments: products[index]);
                          // }, child: Text("Edit Product"))
                        ],
                      ));
                },
                leading: Container(
                  height: 54,width: 50,
                  child: Image.network(
                      products[index].image == null || products[index].image == ""
                          ? "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg" : products[index].image),
                ) ,
                title: Text(
                  products[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${products[index].new_price.toString()}"),
                    Container(
                        padding: EdgeInsets.all(4),
                        color: Theme.of(context).primaryColor,
                        child: Text(products[index].category.toUpperCase(),
                        style: TextStyle(color: Colors.white)))
                  ],
                ),
                trailing: IconButton(
                    onPressed:(){
                      Navigator.pushNamed(context, "/add_product", arguments: products[index]);
                      }, icon: Icon(Icons.edit_outlined)),

              );

            });
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/add_product");
         },
        child: Icon(Icons.add),
      ),
    );
  }
}


class ModifyProduct extends StatefulWidget {

  const ModifyProduct({super.key});

  @override
  State<ModifyProduct> createState() => _ModifyProductState();
}

class _ModifyProductState extends State<ModifyProduct> {
  late String productId="";
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPriceController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController imageController = TextEditingController();


  ///Function to Pick image using image picker
  Future<void> pickImage() async{
    image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      String? res = await CloudinaryStorageService().uploadImageToCloudinary(image!.path, context);
      setState(() {
        if(res != null){
          imageController.text = res;
          print("Set image url ${res} : ${imageController.text}");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image Uploaded Successfully'))
          );
        }
      });
    }
  }

  /// Set the Data from arguments
  setData(ProductsModel data){
    productId = data.id;
    nameController.text = data.name;
    oldPriceController.text = data.old_price.toString();
    newPriceController.text = data.new_price.toString();
    quantityController.text = data.maxQuantity.toString();
    categoryController.text = data.category;
    descController.text = data.description;
    imageController.text = data.image;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    final arguments = ModalRoute.of(context)!.settings.arguments;
    if(arguments != null && arguments is ProductsModel){
      setData(arguments);
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(productId.isNotEmpty ? " Update Product" : "Add Product")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFormField(
                  controller: nameController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Product Name",
                    label: Text("Product Name"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: oldPriceController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Original Price",
                    label: Text("Original Price"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: newPriceController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Sell Price",
                    label: Text("Sell Price"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),

                TextFormField(
                  controller: quantityController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  decoration: InputDecoration(
                    hintText: "Quantity Left",
                    label: Text("Quantity Left"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                ),

                SizedBox(height: 10),

                TextFormField(
                  controller: categoryController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Category",
                    label: Text("Category"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                  onTap: (){
                    showDialog(context: context, builder: (context) =>
                    AlertDialog(
                      title: Text('Select Category :'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Consumer<AdminProvider>(builder: (context, value , child)=>
                          SingleChildScrollView(
                            child: Column(
                            
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: value.categories.map((e) => TextButton(
                            
                                onPressed: () {
                                  categoryController.text =  e["name"];
                                  setState(() {
                            
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(e["name"]))).toList()),
                          ))
                        ],
                      ),
                    ));
                  },
                ),

                SizedBox(height: 10),
                TextFormField(
                  textAlign: TextAlign.start,
                  textAlignVertical: TextAlignVertical.top,
                  controller: descController,
                  validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: "Description",
                    label: Text("Description"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                ),

                SizedBox(height: 10),

                image == null
                    ? imageController.text.isNotEmpty
                    ? Container(
                  margin: EdgeInsets.all(20),
                  height: 100,
                  color: Colors.deepPurple.shade50,
                  child: Image.network(imageController.text,fit: BoxFit.contain),
                ) : SizedBox()
                    : Container(
                  margin: EdgeInsets.all(20),
                  height: 200,
                  color: Colors.deepPurple.shade50,
                  child: Image.file(File(image!.path),  fit: BoxFit.contain),
                ),

                ElevatedButton(onPressed: (){
                  pickImage();
                }, child: Text("Upload Image")),
                SizedBox(height: 5),

                TextFormField(
                  controller: imageController,
                  validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                  decoration: InputDecoration(
                    hintText: "Image Link",
                    label: Text("Image Link"),
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                )            ,
                SizedBox(height: 10),

                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                        if(formKey.currentState!.validate()){
                          Map<String, dynamic> data = {
                            "name" : nameController.text,
                            "desc" : descController.text,
                            "image" : imageController.text,
                            "new_price" : int.parse(newPriceController.text),
                            "old_price" : int.parse(oldPriceController.text),
                            "category" : categoryController.text,
                            "quantity" : int.parse(quantityController.text),
                          };
                          if(productId.isNotEmpty){
                             DbService().updateProduct(
                                docId: productId,
                                data: data);
                             Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Product Updated'))
                            );
                          }else{
                             DbService().createProduct(data: data);
                             Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Product Added'))
                            );
                          }
                        }
                        // Navigator.pop(context);
                  }, child: Text(productId.isNotEmpty ? "Update product" : "Add Product")),
                ),

                SizedBox(height: 30),

              ],
            ),
          ),
        ),
      ),


    );
  }
}

