
class Users {
  late String firstname;
  late String lastName;
  late String streetAddress;
  late String city;
  late String province;
  late String contactNumber;

  Users({this.firstname='', this.lastName='', this.streetAddress='', this.city='', this.province='', this.contactNumber=''});

  Users.map(Map map){
    firstname = map['firstName']??'';
    lastName = map['lastName']??'';
    streetAddress = map['streetAddress']??'';
    city = map['city']??'';
    province = map['province']??'';
    contactNumber = map['contactNumber']??'';

  }
}

// Demo data for our cart


