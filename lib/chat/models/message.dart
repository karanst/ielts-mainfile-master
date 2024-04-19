class Messages {
  Messages({
    required this.name,
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.sent,
    required this.fromid,
    required String fromId,
    required String toId,
  });
  late final String msg;
  late final String name;
  late final String read;
  late final String told;
  late final Type type;
  late final String sent;
  late final String fromid;

  Messages.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    name = json['name'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromid = json['fromid'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['name'] = name;
    data['read'] = read;
    data['told'] = told;
    data['type'] = type.name;
    data['sent'] = sent;
    data['fromid'] = fromid;
    return data;
  }
}

enum Type { text, image }
class GroupMessages {
 GroupMessages( {
   required this.name,
    required this.msg,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromid,
    required String toId,
  });
  late final String msg;
  late final String name;
  late final String read;
  late final Type type;
  late final String sent;
  late final String fromid;

  GroupMessages.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromid = json['fromid'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['sent'] = sent;
    data['fromid'] = fromid;
    data['name'] = name;
    return data;
  }
}

enum GroupType { text, image }

