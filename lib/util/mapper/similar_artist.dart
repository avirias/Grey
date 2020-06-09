class SimilarArtistModel {
  String id;
  String type;
  String href;
  Attributes attributes;

  SimilarArtistModel({this.id, this.type, this.href, this.attributes});

  SimilarArtistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    href = json['href'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['href'] = this.href;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    return data;
  }
}

class Attributes {
  Artwork artwork;
  String origin;
  String url;
  List<String> genreNames;
  String name;
  String artistBio;

  Attributes(
      {this.artwork,
      this.origin,
      this.url,
      this.genreNames,
      this.name,
      this.artistBio});

  Attributes.fromJson(Map<String, dynamic> json) {
    artwork = json['artwork'] != null
        ? new Artwork.fromJson(json['artwork'])
        : Artwork(url: "");
    origin = json['origin'];
    url = json['url'];
    genreNames = json['genreNames'].cast<String>();
    name = json['name'];
    artistBio = json['artistBio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.artwork != null) {
      data['artwork'] = this.artwork.toJson();
    }
    data['origin'] = this.origin;
    data['url'] = this.url;
    data['genreNames'] = this.genreNames;
    data['name'] = this.name;
    data['artistBio'] = this.artistBio;
    return data;
  }
}

class Artwork {
  int width;
  int height;
  String url;
  String bgColor;
  String textColor1;
  String textColor2;
  String textColor3;
  String textColor4;

  Artwork(
      {this.width,
      this.height,
      this.url,
      this.bgColor,
      this.textColor1,
      this.textColor2,
      this.textColor3,
      this.textColor4});

  Artwork.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    url = json['url'];
    bgColor = json['bgColor'];
    textColor1 = json['textColor1'];
    textColor2 = json['textColor2'];
    textColor3 = json['textColor3'];
    textColor4 = json['textColor4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    data['url'] = this.url;
    data['bgColor'] = this.bgColor;
    data['textColor1'] = this.textColor1;
    data['textColor2'] = this.textColor2;
    data['textColor3'] = this.textColor3;
    data['textColor4'] = this.textColor4;
    return data;
  }
}
