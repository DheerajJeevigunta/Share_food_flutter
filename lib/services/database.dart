// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:share_food/fsUsers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:share_food/Firestore_Const.dart';

// class Database {
  
//   final String uid;
//   Database({required this.uid});

//   final CollectionReference   fsCollection =FirebaseFirestore.instance.collection('foodShareUsers');
//   Future <void>createUserData(String name,String city,String mobile,String log ,String uid ) async{
//     return await fsCollection.doc(uid).set({
//       'name' :name,
//         'city':city,
//         'mobile':mobile,
//         'log':log,
//         FirestoreConstants.chattingWith:null
 
        

//     });
    
//   }
//   Future getUsersList()async{
//     List itemsList =[];
//     try{
//       await fsCollection .get().then((querySnapshot){
//           querySnapshot.docs.forEach((element) {
//             itemsList.add(element.data);
//           });
//       });
//       return itemsList;
//     }catch(e){
//       print(e.toString());
//       return null;
//     } 
//   }
//   Future updateUserdata(String name,String city,String mobile,String log) async{
//     return await fsCollection.doc(uid).set({
//         'name' :name,
//         'city':city,
//         'mobile':mobile,
//         'log':log,
//     });
//   }



//   List<fsUsers> _fsUsersListFromSnapshot(QuerySnapshot snapshot){
//     return snapshot.docs.map((doc) {
//       return fsUsers(
//          name: doc.get('name') ?? '',
//          mobile: doc.get('mobile') ?? '0',
//          city: doc.get('city') ?? '',
//          log: doc.get('log') ?? '',
//        );
//      }).toList();
//   }

    
//   Stream<List<fsUsers>> get foodShareUsers{
//      return fsCollection.snapshots()
//      .map(_fsUsersListFromSnapshot);
//   }
// }
