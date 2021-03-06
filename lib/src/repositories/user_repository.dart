import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_hud/loading_hud.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:template_flutter/src/models/key_value_model.dart';
import 'package:template_flutter/src/models/user_model.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final userCollection = Firestore.instance.collection("Users");
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : this._firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signWithGoogle() async {
    print('signWithGoogle');
    try{
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
    } catch (error) {
      return null;
    }

  }


  Future<void> signOut() async {
    print('signOut');
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    print(currentUser != null);
    return currentUser != null;
  }


  Future<bool> addAccount(UserObj userObj) async {
    bool isSuccess = false;
    print(userObj.toString());
    final data = userObj.toJson();
    print('addAccount $data');
    await userCollection.document(userObj.id).setData(data).then(
        (value) {
          isSuccess = true;
    }, onError: (error) {
          print(error.toString());
      return false;
    });
    return isSuccess;
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

  Future<bool> checkPhoneExists(String phone) async {
    bool isExists = false;
    try {
      await userCollection.where("phone", isEqualTo: phone).getDocuments().then((querySnapshot) {
        if (querySnapshot != null && querySnapshot.documents != null && querySnapshot.documents.length > 0) {
          print('count data ${querySnapshot.documents.length}');
          isExists = true;
        } else {
          isExists = false;
        }
      });
    } catch (error) {
      isExists = false;
    }

    return isExists;
  }

  Future<UserObj> getUser(String id) async {
    UserObj userObj;
    await userCollection.document(id).get().then((documentSnapshot) {
      print('documentSnapshot ${documentSnapshot.data}');
      userObj = UserObj.fromSnapshot(documentSnapshot);
    });
    return userObj;
  }

  Future<UserObj> getUserByPhone(String phone) async {
    UserObj userObj;
    await userCollection.where('phone', isEqualTo: phone).getDocuments().then((querySnapshot) {
      if (querySnapshot != null && querySnapshot.documents != null && querySnapshot.documents.length > 0) {
        userObj = UserObj.fromSnapshot(querySnapshot.documents[0]);
      }
    });
    return userObj;
  }

  //get list doctor
  Future<List<UserObj>> getListDoctor() async{
    List<UserObj> list = [];
    try{
      await userCollection.where("isDoctor", isEqualTo: true).getDocuments().then((querySnapshot){
        print('querySnapshot : ${querySnapshot.documents.length}');
        querySnapshot.documents.forEach((documentSnapshot) {
          list.add(UserObj.fromSnapshot(documentSnapshot));
        });
      });
    } catch (error) {
      print('error getListDoctor : $error');
    }
    return list;
  }

  Stream<List<UserObj>> getListUser() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => UserObj.fromSnapshot(doc))
          .toList();
    });
  }

  Future<String> uploadFileToServer(String folder, File file) async {
    print('folder: $folder');
    String urlAvatar = "";
    try{
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      StorageReference storageReferenceProfilePic = firebaseStorage.ref();
      StorageReference imageRef = storageReferenceProfilePic.child(
          folder + "/" + DateTime.now().toString() + ".jpg");
      StorageUploadTask uploadTask = imageRef.putFile(file);
      await uploadTask.onComplete;

      await imageRef.getDownloadURL().then((fileURL) {
        print('File Uploaded $folder: $fileURL');
        urlAvatar = fileURL;
      });
      return urlAvatar;
    } catch (error) {
      print('exception upload');
      print(error);
      return "";
    }
  }


  Future<String> postImageAsset(Asset imageFile) async {
    String fileName = "certificate/" + DateTime.now().toString() + ".jpg";
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    String url = "";
    await storageTaskSnapshot.ref.getDownloadURL().then((fileURL) {
      print('File Uploaded $fileURL');
      url = fileURL;
    });
    return url;
  }

  Future<List<String>> uploadMuliImagesAsset(List<Asset> images) async {
    List<String> imageUrls = [];
    for (var imageFile in images) {
      await postImageAsset(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          print('uploadMuliImagesAsset $imageUrls');

        }
      }).catchError((err) {
        print(err);
        return "";
      });
    }
    return imageUrls;
  }

  Future<List<DocumentSnapshot>> getDoctorLoadMore(List<DocumentSnapshot> list, KeyValueObj major,) async {
    print('getDoctorLoadMore $major - ${list.length}');
    if (list.length == 0) {
      if (major != null && major.key != null && major.key.isNotEmpty) {
        return (await userCollection
            .where("isDoctor", isEqualTo: true).where("majors",arrayContains: {"key" : major.key, "value" : major.value})
            .orderBy("name").limit(10)
            .getDocuments()).documents;
      } else {
        return (await userCollection
            .where("isDoctor", isEqualTo: true).orderBy("name").limit(10)
            .getDocuments()).documents;
      }
    }
    try {

    } catch (error) {
      print('error getScheduleByUser : $error');
    }
    return list;
  }
}
