import 'package:http/http.dart' as http;

class DataService {

  Future<String> downloadData(String url) async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body;
      }
      return "";
    } catch (e) {
      throw Exception("Pobranie danych nie powiodło się\n($url)");
    }
  }
}