class StoryResponse {
  bool? error;
  String? message;
  List<Data>? data;

  StoryResponse({this.error, this.message, this.data});

  StoryResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? slug;
  List<Stories>? stories;

  Data({this.id, this.name, this.slug, this.stories});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    if (stories != null) {
      data['stories'] = stories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stories {
  int? id;
  String? title;
  String? slug;
  int? topicId;
  String? topicName;
  List<StorySlides>? storySlides;

  Stories({this.id, this.title, this.slug, this.topicId, this.storySlides,this.topicName});

  Stories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    topicId = json['topic_id'];
    topicName = json['topic_name'];
    if (json['story_slides'] != null) {
      storySlides = <StorySlides>[];
      json['story_slides'].forEach((v) {
        storySlides!.add(StorySlides.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['topic_id'] = topicId;
    data['topic_name'] = topicName;
    if (storySlides != null) {
      data['story_slides'] = storySlides!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StorySlides {
  int? id;
  int? storyId;
  String? title;
  String? image;
  String? description;
  int? order;
  AnimationDetails? animationDetails;

  StorySlides(
      {this.id,
        this.storyId,
        this.title,
        this.image,
        this.description,
        this.order,
        this.animationDetails});

  StorySlides.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storyId = json['story_id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    order = json['order'];
    animationDetails = json['animation_details'] != null
        ?  AnimationDetails.fromJson(json['animation_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['story_id'] = storyId;
    data['title'] = title;
    data['image'] = image;
    data['description'] = description;
    data['order'] = order;
    if (animationDetails != null) {
      data['animation_details'] = animationDetails!.toJson();
    }
    return data;
  }
}

class AnimationDetails {
  Title? title;
  Title? description;
  Title? image;

  AnimationDetails({this.title, this.description, this.image});

  AnimationDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? Title.fromJson(json['title']) : null;
    description = json['description'] != null
        ? Title.fromJson(json['description'])
        : null;
    image = json['image'] != null ? Title.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title!.toJson();
    }
    if (description != null) {
      data['description'] = description!.toJson();
    }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Title {
  String? type;
  String? delay;
  String? duration;

  Title({this.type, this.delay, this.duration});

  Title.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    delay = json['delay'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['delay'] = delay;
    data['duration'] = duration;
    return data;
  }
}
