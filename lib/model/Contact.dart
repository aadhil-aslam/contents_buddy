class Contact{
  int? id;
  String? name;
  String? number;
  String? extranumber;
  String? email;
  String? photo;

  contactMap(){
    var mapping = Map<String,dynamic>();
    mapping['id'] = id??null;
    mapping['name'] = name!;
    mapping['number'] = number!;
    mapping['extranumber'] = extranumber!;
    mapping['email'] = email!;
    mapping['photo'] = photo!;
    return mapping;
  }
}