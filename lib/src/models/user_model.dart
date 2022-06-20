class UserModel {
  String? uid;
  String? email;
  String? name;
  String? myUBS;
  String? profileUrl;
  String? susCard;
  int? accesLevel;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.accesLevel,
    this.myUBS,
    this.susCard,
  });

  //receber dados do firbase
  factory UserModel.fromMap(doc) {
    return UserModel(
      uid: doc['uid'],
      email: doc['email'],
      name: doc['name'],
      accesLevel: doc['accessLevel'],
      myUBS: doc['myUBS'],
      susCard: doc['susCard'],
    );
  }

  //enviar dados ao firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'accessLevel': accesLevel,
      'myUBS': myUBS,
      'susCard': susCard,
    };
  }
}
