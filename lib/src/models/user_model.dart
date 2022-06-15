class UserModel {
  String? uid;
  String? email;
  String? name;

  UserModel({this.uid, this.email, this.name});

  //receber dados do firbase
  factory UserModel.fromMap(map){
    return UserModel(
      uid : map['uid'],
      email: map['email'],
      name: map['name']
    );
  }

  //enviar dados ao firebase
  Map<String, dynamic> toMap(){
    return {
      'uid':uid,
      'email':email,
      'name':name
    };
  }
}