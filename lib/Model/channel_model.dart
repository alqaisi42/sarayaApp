class ChannelResponse {
  bool? error;
  String? message;
  Data? data;

  ChannelResponse({this.error, this.message, this.data});

  ChannelResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isChannelFollow;
  List<Channels>? channels;

  Data({this.isChannelFollow, this.channels});

  Data.fromJson(Map<String, dynamic> json) {
    isChannelFollow = json['isChannelFollow'];
    if (json['channels'] != null) {
      channels = <Channels>[];
      json['channels'].forEach((v) {
        channels!.add(Channels.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isChannelFollow'] = isChannelFollow;
    if (channels != null) {
      data['channels'] = channels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Channels {
  int? id;
  String? name;
  String? logo;
  String? slug;
  int? isFollow;

  Channels({this.id, this.name, this.logo, this.slug, this.isFollow});

  Channels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    slug = json['slug'];
    isFollow = json['isFollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['slug'] = slug;
    data['isFollow'] = isFollow;
    return data;
  }
}
