
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  Future personalTask (Map<String, dynamic> userpersonalMap, String id)async{
    return await FirebaseFirestore.instance.collection("Personal").doc(id).set(userpersonalMap);
  }
  Future officeTask (Map<String, dynamic> userpersonalMap, String id)async{
    return await FirebaseFirestore.instance.collection("Office").doc(id).set(userpersonalMap);
  }
  Future <Stream<QuerySnapshot>>getTask (String task)async {
    // ignore: await_only_futures
    return await FirebaseFirestore.instance.collection(task).snapshots();
  }

  Future removeMethod(String id, String task) async {
    return await FirebaseFirestore.instance
        .collection(task)
        .doc(id)
        .delete();
  }

  Future tickMethod(String id, String task) async {
    return await FirebaseFirestore.instance
        .collection(task)
        .doc(id)
        .update({"Yes": true});
    
  }
}