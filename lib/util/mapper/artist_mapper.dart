class ArtistAttributes {
  String bornOrFormed;
  List<String> genreNames;
  String name;
  String url;
  String artistBio;
  String origin;
  Artwork artwork;

  ArtistAttributes(
      {this.bornOrFormed,
        this.genreNames,
        this.name,
        this.url,
        this.artistBio,
        this.origin,
        this.artwork});

  ArtistAttributes.fromJson(Map<String, dynamic> json) {
    bornOrFormed = json['bornOrFormed'];
    genreNames = json['genreNames'].cast<String>();
    name = json['name'];
    url = json['url'];
    artistBio = json['artistBio'];
    origin = json['origin'];
    artwork =
    json['artwork'] != null ? new Artwork.fromJson(json['artwork']) : null;
  }

  @override
  String toString() {
    return 'ArtistAttributes{bornOrFormed: $bornOrFormed, genreNames: $genreNames, name: $name, url: $url, artistBio: $artistBio, origin: $origin, artwork: $artwork}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bornOrFormed'] = this.bornOrFormed;
    data['genreNames'] = this.genreNames;
    data['name'] = this.name;
    data['url'] = this.url;
    data['artistBio'] = this.artistBio;
    data['origin'] = this.origin;
    if (this.artwork != null) {
      data['artwork'] = this.artwork.toJson();
    }
    return data;
  }


}

class AlbumAttr {
  String id;
  String type;
  String href;
  Attributes attributes;

  AlbumAttr({this.id, this.type, this.href, this.attributes});

  AlbumAttr.fromJson(Map<String, dynamic> json) {
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

  @override
  String toString() {
    return 'AlbumAttr{id: $id, type: $type, href: $href, attributes: $attributes}';
  }
}

class Attributes {
  Artwork artwork;
  String artistName;
  bool isSingle;
  String url;
  bool isComplete;
  List<String> genreNames;
  int trackCount;
  bool isMasteredForItunes;
  String releaseDate;
  String name;
  String recordLabel;
  String copyright;
  EditorialNotes editorialNotes;
  bool isCompilation;
  String contentRating;

  Attributes(
      {this.artwork,
        this.artistName,
        this.isSingle,
        this.url,
        this.isComplete,
        this.genreNames,
        this.trackCount,
        this.isMasteredForItunes,
        this.releaseDate,
        this.name,
        this.recordLabel,
        this.copyright,
        this.editorialNotes,
        this.isCompilation,
        this.contentRating});

  Attributes.fromJson(Map<String, dynamic> json) {
    artwork =
    json['artwork'] != null ? new Artwork.fromJson(json['artwork']) : null;
    artistName = json['artistName'];
    isSingle = json['isSingle'];
    url = json['url'];
    isComplete = json['isComplete'];
    genreNames = json['genreNames'].cast<String>();
    trackCount = json['trackCount'];
    isMasteredForItunes = json['isMasteredForItunes'];
    releaseDate = json['releaseDate'];
    name = json['name'];
    recordLabel = json['recordLabel'];
    copyright = json['copyright'];
    editorialNotes = json['editorialNotes'] != null
        ? new EditorialNotes.fromJson(json['editorialNotes'])
        : null;
    isCompilation = json['isCompilation'];
    contentRating = json['contentRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.artwork != null) {
      data['artwork'] = this.artwork.toJson();
    }
    data['artistName'] = this.artistName;
    data['isSingle'] = this.isSingle;
    data['url'] = this.url;
    data['isComplete'] = isComplete;
    data['genreNames'] = this.genreNames;
    data['trackCount'] = this.trackCount;
    data['isMasteredForItunes'] = this.isMasteredForItunes;
    data['releaseDate'] = this.releaseDate;
    data['name'] = this.name;
    data['recordLabel'] = this.recordLabel;
    data['copyright'] = this.copyright;
    if (this.editorialNotes != null) {
      data['editorialNotes'] = this.editorialNotes.toJson();
    }
    data['isCompilation'] = this.isCompilation;
    data['contentRating'] = this.contentRating;
    return data;
  }

  @override
  String toString() {
    return 'Attributes{artwork: $artwork, artistName: $artistName, isSingle: $isSingle, url: $url, isComplete: $isComplete, genreNames: $genreNames, trackCount: $trackCount, isMasteredForItunes: $isMasteredForItunes, releaseDate: $releaseDate, name: $name, recordLabel: $recordLabel, copyright: $copyright, editorialNotes: $editorialNotes, isCompilation: $isCompilation, contentRating: $contentRating}';
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

  @override
  String toString() {
    return 'Artwork{width: $width, height: $height, url: $url, bgColor: $bgColor, textColor1: $textColor1, textColor2: $textColor2, textColor3: $textColor3, textColor4: $textColor4}';
  }
}

class EditorialNotes {
  String standard;
  String short;

  EditorialNotes({this.standard, this.short});

  EditorialNotes.fromJson(Map<String, dynamic> json) {
    standard = json['standard'];
    short = json['short'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['standard'] = this.standard;
    data['short'] = this.short;
    return data;
  }

  @override
  String toString() {
    return 'EditorialNotes{standard: $standard, short: $short}';
  }

}
