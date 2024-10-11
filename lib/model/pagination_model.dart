class AnimePaginatedList {
  final Pagination pagination;
  final List<AnimeItem> data;

  AnimePaginatedList({
    required this.pagination,
    required this.data,
  });

  factory AnimePaginatedList.fromJson(Map<String, dynamic> json) {
    return AnimePaginatedList(
      pagination: Pagination.fromJson(json['pagination']),
      data: List<AnimeItem>.from(json['data'].map((x) => AnimeItem.fromJson(x))),
    );
  }
}

class Pagination {
  final int lastVisiblePage;
  final bool hasNextPage;
  final int currentPage;
  final Items items;

  Pagination({
    required this.lastVisiblePage,
    required this.hasNextPage,
    required this.currentPage,
    required this.items,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      lastVisiblePage: json['last_visible_page'],
      hasNextPage: json['has_next_page'],
      currentPage: json['current_page'],
      items: Items.fromJson(json['items']),
    );
  }
}

class Items {
  final int count;
  final int total;
  final int perPage;

  Items({
    required this.count,
    required this.total,
    required this.perPage,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      count: json['count'],
      total: json['total'],
      perPage: json['per_page'],
    );
  }
}

class AnimeItem {
  final int malId;
  final String url;
  final Images images;
  final Trailer? trailer;
  final bool approved;
  final List<Title> titles;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final List<String> titleSynonyms;
  final String type;
  final String source;
  final int? episodes;
  final String status;
  final bool airing;
  final Aired aired;
  final String duration;
  final String rating;
  final double score;
  final int scoredBy;
  final int rank;
  final int popularity;
  final int members;
  final int favorites;
  final String synopsis;
  final String? background;
  final String? season;
  final int? year;
  final Broadcast? broadcast;
  final List<Producer> producers;
  final List<Producer> licensors;
  final List<Producer> studios;
  final List<Genre> genres;
  final List<Genre> explicitGenres;
  final List<Genre> themes;
  final List<Genre> demographics;

  AnimeItem({
    required this.malId,
    required this.url,
    required this.images,
    this.trailer,
    required this.approved,
    required this.titles,
    required this.title,
    this.titleEnglish,
    this.titleJapanese,
    required this.titleSynonyms,
    required this.type,
    required this.source,
    this.episodes,
    required this.status,
    required this.airing,
    required this.aired,
    required this.duration,
    required this.rating,
    required this.score,
    required this.scoredBy,
    required this.rank,
    required this.popularity,
    required this.members,
    required this.favorites,
    required this.synopsis,
    this.background,
    this.season,
    this.year,
    this.broadcast,
    required this.producers,
    required this.licensors,
    required this.studios,
    required this.genres,
    required this.explicitGenres,
    required this.themes,
    required this.demographics,
  });

  factory AnimeItem.fromJson(Map<String, dynamic> json) {
    return AnimeItem(
      malId: json['mal_id'],
      url: json['url'],
      images: Images.fromJson(json['images']),
      trailer: json['trailer'] != null ? Trailer.fromJson(json['trailer']) : null,
      approved: json['approved'],
      titles: List<Title>.from(json['titles'].map((x) => Title.fromJson(x))),
      title: json['title'],
      titleEnglish: json['title_english'],
      titleJapanese: json['title_japanese'],
      titleSynonyms: List<String>.from(json['title_synonyms']),
      type: json['type'],
      source: json['source'],
      episodes: json['episodes'],
      status: json['status'],
      airing: json['airing'],
      aired: Aired.fromJson(json['aired']),
      duration: json['duration'],
      rating: json['rating'],
      score: json['score'].toDouble(),
      scoredBy: json['scored_by'],
      rank: json['rank'],
      popularity: json['popularity'],
      members: json['members'],
      favorites: json['favorites'],
      synopsis: json['synopsis'],
      background: json['background'],
      season: json['season'],
      year: json['year'],
      broadcast: json['broadcast'] != null ? Broadcast.fromJson(json['broadcast']) : null,
      producers: List<Producer>.from(json['producers'].map((x) => Producer.fromJson(x))),
      licensors: List<Producer>.from(json['licensors'].map((x) => Producer.fromJson(x))),
      studios: List<Producer>.from(json['studios'].map((x) => Producer.fromJson(x))),
      genres: List<Genre>.from(json['genres'].map((x) => Genre.fromJson(x))),
      explicitGenres: List<Genre>.from(json['explicit_genres'].map((x) => Genre.fromJson(x))),
      themes: List<Genre>.from(json['themes'].map((x) => Genre.fromJson(x))),
      demographics: List<Genre>.from(json['demographics'].map((x) => Genre.fromJson(x))),
    );
  }
}

class Images {
  final ImageUrls jpg;
  final ImageUrls webp;

  Images({required this.jpg, required this.webp});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: ImageUrls.fromJson(json['jpg']),
      webp: ImageUrls.fromJson(json['webp']),
    );
  }
}

class ImageUrls {
  final String imageUrl;
  final String smallImageUrl;
  final String largeImageUrl;

  ImageUrls({required this.imageUrl, required this.smallImageUrl, required this.largeImageUrl});

  factory ImageUrls.fromJson(Map<String, dynamic> json) {
    return ImageUrls(
      imageUrl: json['image_url'],
      smallImageUrl: json['small_image_url'],
      largeImageUrl: json['large_image_url'],
    );
  }
}

class Trailer {
  final String? youtubeId;
  final String? url;
  final String? embedUrl;
  final TrailerImages? images;

  Trailer({this.youtubeId, this.url, this.embedUrl, this.images});

  factory Trailer.fromJson(Map<String, dynamic> json) {
    return Trailer(
      youtubeId: json['youtube_id'],
      url: json['url'],
      embedUrl: json['embed_url'],
      images: json['images'] != null ? TrailerImages.fromJson(json['images']) : null,
    );
  }
}

class TrailerImages {
  final String? imageUrl;
  final String? smallImageUrl;
  final String? mediumImageUrl;
  final String? largeImageUrl;
  final String? maximumImageUrl;

  TrailerImages({
    this.imageUrl,
    this.smallImageUrl,
    this.mediumImageUrl,
    this.largeImageUrl,
    this.maximumImageUrl,
  });

  factory TrailerImages.fromJson(Map<String, dynamic> json) {
    return TrailerImages(
      imageUrl: json['image_url'],
      smallImageUrl: json['small_image_url'],
      mediumImageUrl: json['medium_image_url'],
      largeImageUrl: json['large_image_url'],
      maximumImageUrl: json['maximum_image_url'],
    );
  }
}

class Title {
  final String type;
  final String title;

  Title({required this.type, required this.title});

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      type: json['type'],
      title: json['title'],
    );
  }
}

class Aired {
  final String? from;
  final String? to;
  final Prop prop;
  final String string;

  Aired({required this.from, this.to, required this.prop, required this.string});

  factory Aired.fromJson(Map<String, dynamic> json) {
    return Aired(
      from: json['from'],
      to: json['to'],
      prop: Prop.fromJson(json['prop']),
      string: json['string'],
    );
  }
}

class Prop {
  final DateProp from;
  final DateProp to;

  Prop({required this.from, required this.to});

  factory Prop.fromJson(Map<String, dynamic> json) {
    return Prop(
      from: DateProp.fromJson(json['from']),
      to: DateProp.fromJson(json['to']),
    );
  }
}

class DateProp {
  final int? day;
  final int? month;
  final int? year;

  DateProp({this.day, this.month, this.year});

  factory DateProp.fromJson(Map<String, dynamic> json) {
    return DateProp(
      day: json['day'],
      month: json['month'],
      year: json['year'],
    );
  }
}

class Broadcast {
  final String? day;
  final String? time;
  final String? timezone;
  final String? string;

  Broadcast({this.day, this.time, this.timezone, this.string});

  factory Broadcast.fromJson(Map<String, dynamic> json) {
    return Broadcast(
      day: json['day'],
      time: json['time'],
      timezone: json['timezone'],
      string: json['string'],
    );
  }
}

class Producer {
  final int malId;
  final String type;
  final String name;
  final String url;

  Producer({required this.malId, required this.type, required this.name, required this.url});

  factory Producer.fromJson(Map<String, dynamic> json) {
    return Producer(
      malId: json['mal_id'],
      type: json['type'],
      name: json['name'],
      url: json['url'],
    );
  }
}

class Genre {
  final int malId;
  final String type;
  final String name;
  final String url;

  Genre({required this.malId, required this.type, required this.name, required this.url});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      malId: json['mal_id'],
      type: json['type'],
      name: json['name'],
      url: json['url'],
    );
  }
}
