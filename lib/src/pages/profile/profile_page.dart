import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mais_saude_app/src/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final imageSize = 170.0;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserModel userModel = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();
  bool uploading = false;
  double total = 0;
  String? ref;
  String? profileURL;
  String? ubsName;

  profileLabel(IconData icon, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(icon),
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )
      ],
    );
  }

  profileField(String? label) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text((label == null) ? 'Carregando...' : label),
        ],
      ),
    );
  }

  getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      ref = 'Users/${loggedUser.uid}/profileImages/img-profile.png';
      return _storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('erro no upload ${e.code}');
    }
  }

  pickAndUploadImage() async {
    File? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        switch (snapshot.state) {
          case TaskState.running:
            setState(() {
              uploading = true;
              total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
            });
            break;
          case TaskState.success:
            await loadProfile();
            setState(() {
              uploading = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Upload concluido')),
              );
            });
            break;
          default:
        }
      });
    }
  }

  loadProfile() async {
    var reference =
        (_storage.ref('Users/${loggedUser.uid}/profileImages/img-profile.png'));
    try {
      profileURL = await reference.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint(e.code);
    }
  }

  getUBS() async {
    final snapshot =
        await _firestore.collection('Centers').doc(loggedUser.myUBS).get();
    ubsName = await snapshot.get('name');
  }


  @override
  void initState() {
    super.initState();
    var uid = user?.uid;
    _firestore
        .collection("Users")
        .doc(uid)
        .get()
        .then((doc) async {
      loggedUser = UserModel.fromMap(doc.data());
      getUBS();
      loadProfile();
      setState(() {});
    });
  }
  void startScreen() {
    var uid = user?.uid;
    _firestore.collection("Users").doc(uid).get().then((doc) {
      loggedUser = UserModel.fromMap(doc.data());
      getUBS();
      loadProfile();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // startScreen();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipOval(
                          child: SizedBox(
                              width: imageSize,
                              height: imageSize,
                              child: (profileURL != null)
                                  ? Image(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(profileURL!),
                                    )
                                  : const CircleAvatar()),
                        ),
                        FloatingActionButton(
                          child: const Icon(Icons.add_a_photo),
                          onPressed: () {
                            pickAndUploadImage();
                          },
                        ),
                      ],
                    ),
                  ),
                  profileLabel(Icons.person, 'Nome'),
                  profileField(loggedUser.name),
                  Divider(height: 30, thickness: 2, color: Colors.blue[200]),
                  profileLabel(Icons.email, 'E-Mail'),
                  profileField(loggedUser.email),
                  Divider(height: 30, thickness: 2, color: Colors.blue[200]),
                  profileLabel(Icons.emergency, 'UBS'),
                  profileField(ubsName),
                  Divider(height: 30, thickness: 2, color: Colors.blue[200]),
                  OutlinedButton(
                    onPressed: () {
                      user?.delete();
                    },
                    child: const Text('Deletar conta'),
                  ),
                ],
              ),
              if (uploading)
                Card(
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Enviando... ${total.round()}%',
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
