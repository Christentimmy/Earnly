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
    this.offerId,
    this.name,
    this.imageUrl,
    this.clickUrl,
    this.categories,
    this.countryCode,
    this.devices,
    this.platforms,
    this.os,
    // required this.androidOsVersionMin,
    // required this.androidOsVersionMax,
    // required this.iosOsVersionMin,
    // required this.iosOsVersionMax,
    this.description1,
    this.description2,
    this.description3,
    this.payout,
    this.events,
  });

  factory NotikTaskModel.fromJson(Map<String, dynamic> json) {
    return NotikTaskModel(
      offerId: json["offer_id"] != null ? json["offer_id"].toString() : "",
      name: json["name"] != null ? json["name"].toString() : "",
      imageUrl: json["image_url"] ?? "",
      clickUrl: json["click_url"] ?? "",
      categories:
          json["categories"] == null
              ? []
              : List<String>.from(json["categories"]!.map((x) => x.toString())),
      countryCode:
          json["country_code"] == null
              ? []
              : List<String>.from(
                json["country_code"]!.map((x) => x.toString()),
              ),
      devices:
          json["devices"] == null
              ? []
              : List<String>.from(json["devices"]!.map((x) => x.toString())),
      platforms:
          json["platforms"] == null
              ? []
              : List<String>.from(json["platforms"]!.map((x) => x.toString())),
      os:
          json["os"] == null
              ? []
              : List<String>.from(json["os"]!.map((x) => x.toString())),
      // androidOsVersionMin: json["android_os_version_min"],
      // androidOsVersionMax: json["android_os_version_max"],
      // iosOsVersionMin: json["ios_os_version_min"],
      // iosOsVersionMax: json["ios_os_version_max"],
      description1: json["description1"] ?? "",
      description2: json["description2"] ?? "",
      description3: json["description3"] ?? "",
      payout: num.tryParse(json["payout"]?.toString() ?? "0") ?? 0.0,
      events:
          json["events"] == null
              ? []
              : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
    );
  }
}

class Event {
  final String? id;
  final String? name;
  final num? payout;

  Event({this.id, this.name, this.payout});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"] != null ? json["id"].toString() : "",
      name: json["name"] != null ? json["name"].toString() : "",
      payout:
          json["payout"] != null
              ? num.tryParse(json["payout"].toString())
              : 0.0,
    );
  }
}
