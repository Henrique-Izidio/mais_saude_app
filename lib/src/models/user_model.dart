class UserModel {
  String? uid;
  String? email;
  String? name;
  String? myUBS;
  int? accesLevel;

  UserModel({this.uid, this.email, this.name, this.accesLevel, this.myUBS});

  //receber dados do firbase
  factory UserModel.fromMap(map){
    return UserModel(
      uid : map['uid'],
      email: map['email'],
      name: map['name'],
      accesLevel: map['accessLevel'],
      myUBS: map['myUBS'],
    );
  }

  //enviar dados ao firebase
  Map<String, dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
      'name':name,
      'accessLevel':accesLevel,
      'myUBS':myUBS,
    };
  }
}