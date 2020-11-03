String urlSchedule(String _city) {
  final String _address = 
    'http://grzybek.xyz:8081/timeTable/getLike?city=$_city&team=&problem=&age=&stage=';
  return  _address;
}
String urlInfo(String _city) {
  final String _address = 'http://grzybek.xyz:8081/info/getInfo?city=$_city';
  return  _address;
}