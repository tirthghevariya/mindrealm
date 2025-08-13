class CommunityModel {
  final String? title;
  final List<CommunityData>? data;

  CommunityModel({
    this.title,
    this.data,
  });

  factory CommunityModel.fromMap(Map<String, dynamic> map) {
    return CommunityModel(
      title: map['title'],
      data: map['data'] != null
          ? List<CommunityData>.from(
              map['data'].map((x) => CommunityData.fromMap(x)),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }
}

class CommunityData {
  final String? email;
  final String? name;
  final String? phone;
  final String? type;

  CommunityData({
    this.email,
    this.name,
    this.phone,
    this.type,
  });

  factory CommunityData.fromMap(Map<String, dynamic> map) {
    return CommunityData(
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'type': type,
    };
  }
}
