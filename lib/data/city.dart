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

class City {
  String apiName;
  String fullName;
  List<String> shortName;
  String hiveName;
  DateTime eventDate;

  City({this.apiName, this.fullName, this.shortName, this.hiveName, this.eventDate});

  factory City.generate(int idx) { 
    return City(
      apiName: apiNames()[idx],
      fullName: fullNames()[idx],
      shortName: shortNames()[idx],
      hiveName: hiveNames()[idx],
      eventDate: eventDates()[idx],
    );
  }
  static List<String> apiNames() {
    const List<String> _events = [
      "wroclaw",
      "poznań",
      "katowice",
      "warszawa",
      "lodz",
      "gdańsk",
      "gdynia",
    ];
    return _events;
  }
  static List<String> fullNames() {
    const List<String> _events = [
      "Eliminacje Regionalne - Wrocław",
      "Eliminacje Regionalne - Poznań",
      "Eliminacje Regionalne - Katowice",
      "Eliminacje Regionalne - Warszawa",
      "Eliminacje Regionalne - Łódź",
      "Eliminacje Regionalne - Gdańsk",
      "Finał Ogólnopolski - Gdynia",
    ];
    return _events;
  }
  static List<List<String>> shortNames() {
    const List<List<String>> _events = [
      ["WRO", "CŁAW"],
      ["POZ", "NAŃ"],
      ["KATO", "WICE"],
      ["WA", "WA"],
      ["ŁÓ", "DŹ"],
      ["GDA", "ŃSK"],
      ["GDY", "NIA"],
      ];
    return _events;
  }
  static List<String> hiveNames() {
    const List<String> _events = [
      "wroclaw",
      "poznan",
      "katowice",
      "warszawa",
      "lodz",
      "gdansk",
      "gdynia",
      ];
    return _events;
  }
  static List<DateTime> eventDates() {
    List<DateTime> _dates = [
      DateTime(2020,02,29),
      DateTime(2020,03,01),
      DateTime(2020,03,07),
      DateTime(2020,03,08),
      DateTime(2020,03,14),
      DateTime(2020,03,15),
      DateTime(2020,04,04),
      ];
    return _dates;
  }
}