import 'package:firebase_ecommerce_flutter/models/categories_model.dart';
import 'package:firebase_ecommerce_flutter/provider/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class CateoriesPage extends StatefulWidget {
  const CateoriesPage({super.key});

  @override
  State<CateoriesPage> createState() => _CateoriesPageState();
}

class _CateoriesPageState extends State<CateoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        centerTitle: true,
      ),
      body: Consumer<AdminProvider>(builder: (context , value , child){
        List<CategoriesModel>categories = CategoriesModel.fromJsonList(value.categories);

        if(value.categories.isEmpty){
          return Center(child: Text('No Categories Found'));
        }

        return ListView.builder(
          itemCount: value.categories.length,
          itemBuilder: (context, index){

            return ListTile(
              title: Text(
                categories[index].name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "Priority : ${categories[index].priority}"
              ),
            );

          });
      }),

      floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (context)=> ModifyCategory(isUpdating: false, categoryId: "", priority: 0));
          },
          child: Icon(Icons.add),
      ),
    );
  }
}

class ModifyCategory extends StatefulWidget {
  final bool isUpdating;
  final String? name;
  final String categoryId;
  final String? image;
  final int priority;
  const ModifyCategory({super.key, required this.isUpdating, this.name, required this.categoryId, this.image, required this.priority});

  @override
  State<ModifyCategory> createState() => _ModifyCategoryState();
}

class _ModifyCategoryState extends State<ModifyCategory> {

  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  late XFile? image = null;
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController priorityController = TextEditingController();

  @override
  void initState() {
    if(widget.isUpdating && widget.name != null){
      categoryController.text = widget.name!;
      imageController.text = widget.image!;
      priorityController.text = widget.priority.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isUpdating ? "Update Category" : "Add Category"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min,
            children: [
              Text("All will be converted to lowercase "),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Category Name",
                  label: Text("Category Name"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              SizedBox(height: 10),
              Text("This will be used in ordering categories"),
              SizedBox(height: 10),
              TextFormField(
                controller: priorityController,
                validator: (v) => v!.isEmpty ? "This can't be empty." : null,
                decoration: InputDecoration(
                  hintText: "Priority",
                  label: Text("Priority"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: (){}, child: Text("Pick Image")),

              TextFormField(
                controller: imageController,
                validator: (v) => v!.isEmpty ? "This can't be empty" : null,
                decoration: InputDecoration(
                  hintText: "Image Link",
                  label: Text("Image Link"),
                  fillColor: Colors.deepPurple.shade50,
                  filled: true,
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
