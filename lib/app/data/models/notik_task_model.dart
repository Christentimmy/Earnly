class NotikTaskModel {
  final String? offerId;
  final String? name;
  final String? imageUrl;
  final String? clickUrl;
  final List<String>? categories;
  final List<String>? countryCode;
  final List<String>? devices;
  final List<String>? platforms;
  final List<String>? os;
  // final dynamic androidOsVersionMin;
  // final dynamic androidOsVersionMax;
  // final dynamic iosOsVersionMin;
  // final dynamic iosOsVersionMax;
  final String? description1;
  final String? description2;
  final String? description3;
  final num? payout;
  final List<Event>? events;

  NotikTaskModel({
    required this.offerId,
    required this.name,
    required this.imageUrl,
    required this.clickUrl,
    required this.categories,
    required this.countryCode,
    required this.devices,
    required this.platforms,
    required this.os,
    // required this.androidOsVersionMin,
    // required this.androidOsVersionMax,
    // required this.iosOsVersionMin,
    // required this.iosOsVersionMax,
    required this.description1,
    required this.description2,
    required this.description3,
    required this.payout,
    required this.events,
  });

  factory NotikTaskModel.fromJson(Map<String, dynamic> json) {
    return NotikTaskModel(
      offerId: json["offer_id"] ?? "",
      name: json["name"] ?? "",
      imageUrl: json["image_url"] ?? "",
      clickUrl: json["click_url"] ?? "",
      categories:
          json["categories"] == null
              ? []
              : List<String>.from(json["categories"]!.map((x) => x)),
      countryCode:
          json["country_code"] == null
              ? []
              : List<String>.from(json["country_code"]!.map((x) => x)),
      devices:
          json["devices"] == null
              ? []
              : List<String>.from(json["devices"]!.map((x) => x)),
      platforms:
          json["platforms"] == null
              ? []
              : List<String>.from(json["platforms"]!.map((x) => x)),
      os:
          json["os"] == null
              ? []
              : List<String>.from(json["os"]!.map((x) => x)),
      // androidOsVersionMin: json["android_os_version_min"],
      // androidOsVersionMax: json["android_os_version_max"],
      // iosOsVersionMin: json["ios_os_version_min"],
      // iosOsVersionMax: json["ios_os_version_max"],
      description1: json["description1"] ?? "",
      description2: json["description2"] ?? "",
      description3: json["description3"] ?? "",
      payout: num.tryParse(json["payout"].toString()) ?? 0.0,
      events:
          json["events"] == null
              ? []
              : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
    );
  }
}

class Event {
  Event({required this.id, required this.name, required this.payout});

  final String? id;
  final String? name;
  final num? payout;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(id: json["id"], name: json["name"], payout: json["payout"]);
  }
}
