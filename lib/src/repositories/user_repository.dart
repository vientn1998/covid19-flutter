import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:template_flutter/src/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final userCollection = Firestore.instance.collection("Users");
  final storageReference = FirebaseStorage.instance.ref();
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : this._firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<bool> addAccount(UserObj userObj) async {
    await userCollection.document(userObj.id).setData(userObj.toJson()).then(
        (value) {
      return true;
    }, onError: (error) {
      return false;
    });
  }

  Future<String> uploadFileToServer(String folder, File file) async {
    storageReference.child('$folder/${DateTime.now()}');
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      return fileURL;
    });
  }

  Future<bool> checkExist(String uuid) async {
    bool isExists = false;
    await userCollection.document(uuid).get().then((value) {
      if (value.exists) {
        isExists = true;
      } else {
        isExists = false;
      }
    });
    return isExists;
  }

  Stream<List<UserObj>> getListUser() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => UserObj.fromSnapshot(doc))
          .toList();
    });
  }

  Future<Stream<UserObj>> getUser(String id) async {
    return userCollection.document(id).snapshots().map((document) {
      return UserObj.fromSnapshot(document);
    });
  }

  Future<FirebaseUser> signWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(authCredential);
    return authResult.user;
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    print('isSignedIn');
    print(currentUser != null);
    return currentUser != null;
  }
}
