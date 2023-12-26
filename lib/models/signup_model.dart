
class SignUpModel{
  late String name;
  late String image;

  SignUpModel({
    required this.name,
    required this.image,
  });

  SignUpModel.fromJson(Map<String,dynamic> json){
    name=json['name'];
    image=json['image']??"";
  }

  Map<String,dynamic> toMap(){
    return
      {
        'name':name,
        'image':image,
      };
  }

}