import 'city.dart';

class CitySet {
  static List<City> cities = new List<City>();

  CitySet({cities});

  factory CitySet.generate() {
    cities.clear();
      for (int i=0; i<City.hiveNames().length; i++) {
        cities.add(new City.generate(i));
      }
    return CitySet(cities: cities);
  }

}