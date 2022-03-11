import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter_project/Custom/TodoCard.dart';
import 'package:firebase_flutter_project/pages/AddTodo.dart';
import 'package:firebase_flutter_project/pages/Profile.dart';
import 'package:firebase_flutter_project/pages/ViewData.dart';
import 'package:flutter/material.dart';

import '../Service/AuthService.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance.collection("Todo").snapshots();

  List<Select> selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
        title: Text(
          "Today's schedule",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage(
              "assets/profile.jpg"
            ),
          ),
          SizedBox(
            width: 25,
          )
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Monday 21",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff8a32f1)
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      var instance =  FirebaseFirestore.instance.collection("Todo");
                          for(int i = 0; i < selected.length; i++){
                            if(selected[i].checkValue){
                              instance.doc(selected[i].id).delete()
                                  .then((value) => {});
                            }
                          }
                    },
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    iconSize: 28,
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
            label: ""
          ),
          BottomNavigationBarItem(
              icon: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => AddTodoPage()));
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigoAccent,
                        Colors.purple
                      ]
                    )
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              label: ""
          ),
          BottomNavigationBarItem(
              icon: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder) {
                    return ProfilePage();
                  }));
                },
                child: Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              label: ""
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              IconData iconData;
              Color iconColor;
              Map<String,dynamic> document =
                snapshot.data!.docs[index].data()
                as Map<String, dynamic>;
                switch(document["Category"]){
                  case "Work":
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.red;
                    break;
                  case "Design":
                    iconData = Icons.alarm;
                    iconColor = Colors.blue;
                    break;
                  case "Food":
                    iconData = Icons.history_edu_outlined;
                    iconColor = Colors.cyanAccent;
                    break;
                  case "WorkOut":
                    iconData = Icons.music_note_outlined;
                    iconColor = Colors.orangeAccent;
                    break;
                  default:
                    iconData = Icons.set_meal;
                    iconColor = Colors.green;
                }
                
                selected.add(Select(id: snapshot.data!.docs[index].id, checkValue: false));
            return InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (builder) {
                  return ViewDataPage(
                    document:document,
                    id: snapshot.data!.docs[index].id,
                  );
                }));
              },
              child: ToDoCard(
                title: document['title'] == null ? "Hey There" : document['title'],
                check: selected[index].checkValue,
                iconBigColor: Colors.white,
                iconData: iconData,
                color: iconColor,
                time: "",
                index: index,
                onChange: onChange,
              ),
            );
          });
        }
      ),
    );
  }

  void onChange(int index){
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select{
  String id;
  bool checkValue = false;
  Select({
    required this.id,
    required this.checkValue
  });
}