import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter_project/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewDataPage extends StatefulWidget {
  const ViewDataPage({Key? key,required this.document,required this.id}) : super(key: key);
  final Map<String, dynamic> document;
  final String id;
  @override
  State<ViewDataPage> createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  TextEditingController? _titleController;
  TextEditingController? _descController;
  String? type;
  String? category;
  bool edit = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String title = widget.document['title'] == null ? "Hey there" : widget.document['title'];
    String description = widget.document['description'] == null ? "Hey there" : widget.document['description'];
    _titleController = TextEditingController(text: title);
    _descController = TextEditingController(text: description);
    type = widget.document['task'];
    category = widget.document['Category'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xff1d1e26),
                Color(0xff252041),
              ]
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => HomePage()));
                    },
                    icon: Icon(CupertinoIcons.arrow_left),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                  Row(
                    children: [
                      edit ? Container() : IconButton(
                        onPressed: (){
                          FirebaseFirestore.instance.collection("Todo")
                              .doc(widget.id).delete()
                              .then((value) => {
                                Navigator.pop(context)
                          });
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        iconSize: 28,
                      ),
                      IconButton(
                        onPressed: (){
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(Icons.edit),
                        color: edit ? Colors.red :  Colors.white,
                        iconSize: 28,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? "Editing" : "View",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Your Todo",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2
                      ),
                    ),
                    SizedBox(height: 20,),
                    label("Task Title"),
                    SizedBox(height: 12,),
                    title(),
                    SizedBox(height: 20,),
                    label("Task Type"),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect("Imporatant",0xff2664fa),
                        SizedBox(width: 20,),
                        taskSelect("Planned",0xff2bc8d9),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    label("Description"),
                    SizedBox(
                      height: 12,
                    ),
                    description(),
                    SizedBox(
                      height: 20,
                    ),
                    label("Category"),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      children: [
                        categorySelect("Food",0xffff6d6e),
                        SizedBox(width: 20,),
                        categorySelect("WorkOut",0xfff29732),
                        SizedBox(width: 20,),
                        categorySelect("Work",0xff6557ff),
                        SizedBox(width: 20,),
                        categorySelect("Design",0xff234ebd),
                        SizedBox(width: 20,),
                        categorySelect("Run",0xff2bc8d9),
                      ],
                    ),
                    SizedBox(height: 20,),
                    edit ? button() : Container(),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button(){
    return InkWell(
      onTap: (){
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
          "title" : _titleController!.text,
          "description": _descController!.text,
          "task" : type,
          "Category" : category
        });

        Navigator.push(context, MaterialPageRoute(builder: (builder) => HomePage()));

      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                colors: [
                  Color(0xff8a32f1),
                  Color(0xffad32f9)
                ]
            )
        ),
        child: Center(
          child: Text(
            "Update Todo",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600
            ),
          ),
        ),
      ),
    );
  }

  Widget description(){
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        enabled: edit,
        controller: _descController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )
        ),
      ),
    );
  }

  Widget taskSelect(String label,int color){
    return InkWell(
      onTap: edit ? (){
        setState(() {
          type = label;
        });
      } : null,
      child: Chip(
        backgroundColor: type == label ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
              color: type == label ? Colors.black : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600
          ),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 17,vertical: 3.8),
      ),
    );
  }

  Widget categorySelect(String label,int color){
    return InkWell(
      onTap: edit ? (){
        category = label;
      } : null,
      child: Chip(
        backgroundColor: category == label ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          label,
          style: TextStyle(
              color: category == label ? Colors.black : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600
          ),
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 17,vertical: 3.8),
      ),
    );
  }

  Widget title(){
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: InputDecoration(
            border: InputBorder.none,
            enabled: edit,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )
        ),
      ),
    );
  }

  Widget label(String label){
    return Text(
      label,
      style: TextStyle(
        fontSize: 16.5,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
