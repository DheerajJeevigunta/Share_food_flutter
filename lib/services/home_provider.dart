import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_food/Firestore_Const.dart';


class HomeProvider{
  final FirebaseFirestore firebaseFirestore;
  HomeProvider({
    required this.firebaseFirestore
  });
  Future<void> updateDataFirestore(String collectionPath,String path,Map<String ,String> dataNeedUpdate){
    return firebaseFirestore.collection(collectionPath).doc(path).update(dataNeedUpdate);
  }
  Stream<QuerySnapshot> getStreamFireStore(String pathCollection, int limit,String? textSearch){
    if(textSearch?.isNotEmpty==true){
      return firebaseFirestore.collection(pathCollection).limit(limit).where(FirestoreConstants.aboutMe,isEqualTo: textSearch).snapshots();
    }else{
      return firebaseFirestore.collection(pathCollection).limit(limit).snapshots();
    }
  }
    Stream<QuerySnapshot> getStreamFireStore1(String pathCollection1, int limit1,String? textSearch1){
    if(textSearch1?.isNotEmpty==true){
      return firebaseFirestore.collection(pathCollection1).limit(limit1).where(FirestoreConstants.nickname,isEqualTo: textSearch1).snapshots();
    }else{
      return firebaseFirestore.collection(pathCollection1).limit(limit1).snapshots();
    }
  }
}