class ChatUser {
  ChatUser({
    required this.image,
    required this.poshToken,
    required this.name,
    required this.uid,
    required this.email,
    required this.about,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
  });
  late String image;
  late String poshToken;
  late String name;
  late String email;
  late String uid;
  late String about;
  late String createdAt;
  late String lastActive;
  late bool isOnline;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    poshToken = json['posh_token'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    about = json['about'] ?? '';
    uid = json['uid'] ?? '';
    createdAt = json['created_at'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['posh_token'] = poshToken;
    data['name'] = name;
    data['about'] = about;
    data['uid'] = uid;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    return data;
  }
}
