class Artist {
  int id;
  String name;
  String bio;
  String bornOrFormed;
  String image;
  List<String> genres;
  List<Album> albums;
  List<SimilarArtist> similarArtist;

  Artist(
      {this.id,
      this.name,
      this.bio,
      this.bornOrFormed,
      this.image,
      this.genres,
      this.albums,
      this.similarArtist});

  @override
  String toString() {
    return 'Artist{id: $id, name: $name, bio: $bio, bornOrFormed: $bornOrFormed, image: $image, genres: $genres, albums: $albums, similarArtist: $similarArtist}';
  }
}

class Album {
  int id;
  String name;
  String labelName;
  int trackCount;
  String releaseDate;
  List<String> genres;
  String imageUrl;
  String contentRating;

  Album(
      {this.id,
      this.name,
      this.labelName,
      this.trackCount,
      this.releaseDate,
      this.genres,
      this.imageUrl,
      this.contentRating});

  @override
  String toString() {
    return 'Album{id: $id, name: $name, labelName: $labelName, trackCount: $trackCount, releaseDate: $releaseDate, genres: $genres, imageUrl: $imageUrl, contentRating: $contentRating}';
  }
}

class SimilarArtist {
  int id;
  String name;
  String image;

  SimilarArtist({this.id, this.name, this.image});

  @override
  String toString() {
    return 'SimilarArtist{id: $id, name: $name, image: $image}';
  }
}
