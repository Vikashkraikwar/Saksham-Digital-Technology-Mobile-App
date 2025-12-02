// BannersModel.dart

import 'dart:convert';

BannerResponse bannerResponseFromJson(String str) => BannerResponse.fromJson(json.decode(str));

class BannerResponse {
  final bool status;
  final String message;
  final List<BannerData> data;

  BannerResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BannerResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] != null
        ? List<BannerData>.from(json["data"].map((x) => BannerData.fromJson(x)))
        : <BannerData>[];

    return BannerResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      data: dataList,
    );
  }
}

class BannerData {
  final int id;
  final String? title;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;

  BannerData({
    required this.id,
    this.title,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  // =======================================================================
  // ## THIS FACTORY IS NOW SAFER AND PREVENTS THE CRASH ##
  // =======================================================================
  factory BannerData.fromJson(Map<String, dynamic> json) => BannerData(
    id: json["id"] ?? 0,
    title: json["title"], // This was already safe because it's nullable (String?)

    // FIX: If 'image' is null, default to an empty string.
    image: json["image"] ?? '',

    // FIX: If date is null, use the current time as a fallback.
    createdAt: json["created_at"] == null
        ? DateTime.now()
        : DateTime.parse(json["created_at"]),

    // FIX: If date is null, use the current time as a fallback.
    updatedAt: json["updated_at"] == null
        ? DateTime.now()
        : DateTime.parse(json["updated_at"]),
  );
}