import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meproject/models/editprofile.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference markdownCollection =
      FirebaseFirestore.instance.collection("markdowns");

  Future updateUserData(List me, String name, String profession) async {
    return await markdownCollection
        .doc(uid)
        .set({'me': me, 'name': name,'profession': profession});
  }


  // Stream<QuerySnapshot> get userInfo {
  //   return markdownCollection.snapshots();
  // }

  // Future getCurrentUserData() async {
  //   try {
  //     String uid=FirebaseAuth.instance.currentUser!.uid;
  //     DocumentSnapshot dc = await markdownCollection.doc(uid).get();
  //     String name = dc.get("name");
  //     int mb = dc.get("mb");
  //     String profession = dc.get("profession");
  //     return [name, mb, profession];
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  //}
}
