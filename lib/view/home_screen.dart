// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finaltodoapp/config/colors.dart';
import 'package:finaltodoapp/view/Services/database_service.dart';
import 'package:firebase_core/firebase_core.dart';
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
    // todoStream = await DatabaseService().getTask(personal?"Personal":office?"Office");
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
                        border: Border.all(color: AppColors.dgrey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CheckboxListTile(
                        activeColor: AppColors.checkbox,
                        title: Text(docsSnap["Work"]),

                        value: docsSnap["Yes"],
                        onChanged: (value) async {
                          await DatabaseService().tickMethod(
                            docsSnap.id,
                            personal ? "Personal" : "Office",
                          );
                          setState(() {
                            Future.delayed(Duration(minutes: 2), () {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFD6D5D5),
              Colors.white,
              const Color.from(alpha: 1, red: 0.631, green: 0.631, blue: 0.631),
            ],
            begin: AlignmentGeometry.topRight,
            end: AlignmentGeometry.bottomLeft,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.all(15),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                color: AppColors.lgrey,
                borderRadius: BorderRadius.circular(15),
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
                  SizedBox(height: 10),
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

            // ────────────────────────────────
            // OLD CATEGORY BUTTONS (HOME SCREEN)
            // ────────────────────────────────
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
                          borderRadius: BorderRadiusGeometry.circular(20),
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
                            borderRadius: BorderRadiusGeometry.circular(20),
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: const Color.fromARGB(255, 204, 203, 203)),
            ),
            SizedBox(height: 15),
            getWork(),
            // SizedBox(height: 10),
          ],
        ),
      ),

      // ─────────────────────────────────────────────
      //  FAB — ADD TASK (MODIFIED WITH CATEGORY)
      // ─────────────────────────────────────────────
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
                            hint: Text("Enter the Text"),
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
                            if (!personal && !office) {
                              print("No category selected on Home Screen!");
                              return;
                            }

                            String id = randomAlpha(10);

                            Map<String, dynamic> usertodo = {
                              "Work": todoController.text,
                              "id": id,
                              "Yes": false,
                            };

                            if (personal) {
                              DatabaseService().personalTask(usertodo, id);
                              print("Saving PERSONAL task.");
                            } else {
                              DatabaseService().officeTask(usertodo, id);
                              print("Saving OFFICE task.");
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
