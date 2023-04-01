enum Gender {
  male,
  female,

}
extension GenderX on Gender{
  String convertToString(){
    switch(this){
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
      default:
        return 'male';
    }
  }
}
