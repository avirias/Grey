
class ArtistInformation {
  ArtistInformationArtist artist;

  ArtistInformation({
    this.artist,
  });

  factory ArtistInformation.fromJson(Map<String, dynamic> json) => ArtistInformation(
    artist: ArtistInformationArtist.fromJson(json["artist"]),
  );

  Map<String, dynamic> toJson() => {
    "artist": artist.toJson(),
  };
}

class ArtistInformationArtist {
  String name;
  String mbid;
  String url;
  List<Image> image;
  String streamable;
  String ontour;
  Stats stats;
  Similar similar;
  Tags tags;
  Bio bio;

  ArtistInformationArtist({
    this.name,
    this.mbid,
    this.url,
    this.image,
    this.streamable,
    this.ontour,
    this.stats,
    this.similar,
    this.tags,
    this.bio,
  });

  factory ArtistInformationArtist.fromJson(Map<String, dynamic> json) => ArtistInformationArtist(
    name: json["name"],
    mbid: json["mbid"],
    url: json["url"],
    image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
    streamable: json["streamable"],
    ontour: json["ontour"],
    stats: Stats.fromJson(json["stats"]),
    similar: Similar.fromJson(json["similar"]),
    tags: Tags.fromJson(json["tags"]),
    bio: Bio.fromJson(json["bio"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "mbid": mbid,
    "url": url,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
    "streamable": streamable,
    "ontour": ontour,
    "stats": stats.toJson(),
    "similar": similar.toJson(),
    "tags": tags.toJson(),
    "bio": bio.toJson(),
  };
}

class Bio {
  Links links;
  String published;
  String summary;
  String content;

  Bio({
    this.links,
    this.published,
    this.summary,
    this.content,
  });

  factory Bio.fromJson(Map<String, dynamic> json) => Bio(
    links: Links.fromJson(json["links"]),
    published: json["published"],
    summary: json["summary"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "links": links.toJson(),
    "published": published,
    "summary": summary,
    "content": content,
  };
}

class Links {
  Link link;

  Links({
    this.link,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    link: Link.fromJson(json["link"]),
  );

  Map<String, dynamic> toJson() => {
    "link": link.toJson(),
  };
}

class Link {
  String text;
  String rel;
  String href;

  Link({
    this.text,
    this.rel,
    this.href,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    text: json["#text"],
    rel: json["rel"],
    href: json["href"],
  );

  Map<String, dynamic> toJson() => {
    "#text": text,
    "rel": rel,
    "href": href,
  };
}

class Image {
  String text;
  String size;

  Image({
    this.text,
    this.size,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    text: json["#text"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "#text": text,
    "size": size,
  };
}

class Similar {
  List<ArtistElement> artist;

  Similar({
    this.artist,
  });

  factory Similar.fromJson(Map<String, dynamic> json) => Similar(
    artist: List<ArtistElement>.from(json["artist"].map((x) => ArtistElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "artist": List<dynamic>.from(artist.map((x) => x.toJson())),
  };
}

class ArtistElement {
  String name;
  String url;
  List<Image> image;

  ArtistElement({
    this.name,
    this.url,
    this.image,
  });

  factory ArtistElement.fromJson(Map<String, dynamic> json) => ArtistElement(
    name: json["name"],
    url: json["url"],
    image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
    "image": List<dynamic>.from(image.map((x) => x.toJson())),
  };
}

class Stats {
  String listeners;
  String playcount;

  Stats({
    this.listeners,
    this.playcount,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    listeners: json["listeners"],
    playcount: json["playcount"],
  );

  Map<String, dynamic> toJson() => {
    "listeners": listeners,
    "playcount": playcount,
  };
}

class Tags {
  List<Tag> tag;

  Tags({
    this.tag,
  });

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
    tag: List<Tag>.from(json["tag"].map((x) => Tag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tag": List<dynamic>.from(tag.map((x) => x.toJson())),
  };
}

class Tag {
  String name;
  String url;

  Tag({
    this.name,
    this.url,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };
}
