class InviteModel {
  String? myInviteCode;
  String? totalInvites;
  String? premiumCredits;
  DateTime? premiumExpiresAt;
  List<RecentInvites>? recentInvites;

  InviteModel({
    this.myInviteCode,
    this.totalInvites,
    this.premiumCredits,
    this.premiumExpiresAt,
    this.recentInvites,
  });

  factory InviteModel.fromJson(Map<String, dynamic> json) => InviteModel(
    myInviteCode: json['inviteCode'] ?? "",
    totalInvites: json['totalInvites'].toString(),
    premiumCredits: json['premiumCredits'].toString(),
    premiumExpiresAt:
        DateTime.tryParse(json['premiumExpiresAt'].toString()) ??
        DateTime.now(),
    recentInvites:
        (json['recentInvites'] as List<dynamic>?)
            ?.map((e) => RecentInvites.fromJson(e))
            .toList(),
  );
}

class RecentInvites {
  final String? displayName;
  final DateTime? redeemedAt;
  final String? rewardGiven;

  RecentInvites({
    required this.displayName,
    required this.redeemedAt,
    required this.rewardGiven,
  });

  factory RecentInvites.fromJson(Map<String, dynamic> json) => RecentInvites(
    displayName: json['displayName'] ?? "",
    redeemedAt:
        DateTime.tryParse(json['redeemedAt'].toString()) ?? DateTime.now(),
    rewardGiven: json['rewardGiven']?['amount'].toString(),
  );
}
