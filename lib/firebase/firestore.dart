import 'package:book_juk/Login.dart';
import 'package:book_juk/utilities/utilities.dart';
import 'package:book_juk/models/BookModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FireStoreService {
  Future<User> getUser() async {
    final pref = await SharedPreferences.getInstance();
    if(toEnum(pref.getString("login_platform")) != LoginPlatform.none){
      return FirebaseAuth.instance.currentUser!;
    }
    else {
      throw Exception('this cannot be happen!');
    }
  }

  void initOrUpdateFireStore() async {
    final firestore = FirebaseFirestore.instance;
    try{
      final user = await getUser();
      await firestore.collection("users").doc(user.uid).set(
        {
          "name": user.displayName,
          "email": user.email
        },
        SetOptions(merge: true)
      );
    } catch(e) {
      print('Error: $e');
    }
  }

  void storeBook(StoredBook book) async {
    final firestore = FirebaseFirestore.instance;
    try{
      final user = await getUser();
      //firebase에 책 저장
      await firestore.collection("users").doc(user.uid)
        .collection("books").doc(book.isbn13).set(book.toJson());
      //순서 정렬을 위한 추가시간 업데이트
      await firestore.collection("users").doc(user.uid)
        .collection("books").doc(book.isbn13).update({"addDate": Timestamp.now()});
    } catch(e) {
      print('Error: $e');
    }
  }

  Future<List<StoredBook>> loadBooks() async {
    final firestore = FirebaseFirestore.instance;
    try{
      final user = await getUser();
      QuerySnapshot<Map<String, dynamic>> _snapshot = 
        await firestore.collection("users").doc(user.uid)
          .collection("books").orderBy("addDate").get();
      List<StoredBook> _result = _snapshot.docs.map((e) => StoredBook.fromJson(e.data())).toList();
      return _result;
    } catch(e) {
      print('Error: $e');
    }
    throw Exception('loading book failed');
  }

  Future<bool> deleteBook(StoredBook book) async {
    final firestore = FirebaseFirestore.instance;
    try{
      final user = await getUser();
      //firebase에서 책 찾아 삭제
      await firestore.collection("users").doc(user.uid)
        .collection("books").doc(book.isbn13).delete();
      return true;
    } catch(e) {
      print('Error: $e');
    }
    return false;
  }

  Future<bool> deleteUser() async {
    final firestore = FirebaseFirestore.instance;
    try{
      final user = await getUser();
      firestore.collection('users').doc(user.uid)
        .collection("books").get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs){
          ds.reference.delete();
        };
      });
      await firestore.collection("users").doc(user.uid).delete();
      return true;
    } catch(e) {
      print('Error: $e');
    }
    return false;
  }
}