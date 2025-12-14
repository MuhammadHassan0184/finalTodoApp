// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finaltodoapp/config/colors.dart';
import 'package:finaltodoapp/Services/database_service.dart';
import 'package:finaltodoapp/view/claender_screen.dart';
import 'package:finaltodoapp/view/note_pad_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController todoController = TextEditingController();

  bool personal = false, office = false;
  bool check = false;

  Stream? todoStream;
  getontheload() async {
    todoStream = await DatabaseService().getTask(
      personal ? "Personal" : "Office",
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getWork() {
    return StreamBuilder(
      stream: todoStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot docsSnap = snapshot.data.docs[index];
                    return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.dgrey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CheckboxListTile(
                        activeColor: AppColors.dgrey,
                        title: Text(
                          docsSnap["Work"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        value: docsSnap["Yes"],
                        onChanged: (value) async {
                          await DatabaseService().tickMethod(
                            docsSnap.id,
                            personal ? "Personal" : "Office",
                          );
                          setState(() {
                            Future.delayed(Duration(minutes: 1), () {
                              DatabaseService().removeMethod(
                                docsSnap.id,
                                personal ? "Personal" : "Office",
                              );
                            });
                          });
                        },
                      ),
                    );
                  },
                ),
              )
            : CircularProgressIndicator();
      },
    );
  }

  // ─────────────────────────────────────────────
  // LOGOUT FUNCTION
  // ─────────────────────────────────────────────
  void logout() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Logout",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pop(context); // close dialog
          },
          child: Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.black,
              ),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: logout,
            ),
          ],
        ),
      ),

      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu, size: 35),
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> NotePadScreen()));
              }, icon: Icon(Icons.note_alt, size: 40, color: AppColors.black,)),
              SizedBox(width: 10,),
              InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CalendarScreen()));
            },
            child: Container(
              margin: EdgeInsets.all(6),
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.transparent
              ),
              child: Image(image: AssetImage("assets/calendar.png")),
            ),
          ),
            ],
          )
        ],
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bookbg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE8E7E7),
                    Colors.white,
                  ],
                  begin: AlignmentGeometry.topLeft,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hii,",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Welcome",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Let's the work begins !",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.dgrey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                personal
                    ? Chip(
                        label: Text(
                          "Personal",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: AppColors.black,
                      )
                    : InkWell(
                        onTap: () async {
                          personal = true;
                          office = false;
                          await getontheload();
                          setState(() {});
                        },
                        child: Chip(
                          label: Text(
                            "Personal",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                SizedBox(width: 20),
                office
                    ? Chip(
                        label: Text(
                          "Office",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: AppColors.black,
                      )
                    : InkWell(
                        onTap: () async {
                          personal = false;
                          office = true;
                          await getontheload();
                          setState(() {});
                        },
                        child: Chip(
                          label: Text(
                            "Office",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Color.fromARGB(255, 204, 203, 203),
              ),
            ),
            SizedBox(height: 15),
            getWork(),
            SizedBox(height: 85),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.black,
        child: Icon(Icons.add, size: 30, color: AppColors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.cancel, size: 35),
                            ),
                            SizedBox(width: 25),
                            Text(
                              "Add Todo Task",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Add Text",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: todoController,
                          decoration: InputDecoration(
                            hint: Text("Enter the Text", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.black,
                          ),
                          onPressed: () {
                            if (!personal && !office) return;

                            String id = randomAlpha(10);

                            Map<String, dynamic> usertodo = {
                              "Work": todoController.text,
                              "id": id,
                              "Yes": false,
                            };

                            if (personal) {
                              DatabaseService().personalTask(usertodo, id);
                            } else {
                              DatabaseService().officeTask(usertodo, id);
                            }

                            todoController.clear();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Add",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
