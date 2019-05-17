class Tmdb {
  static const apiKey = "c80439488364417bc2a4fd25612df122&";
  static const baseUrl = "https://api.themoviedb.org/3/movie/";
  static const baseImageUrl = "https://image.tmdb.org/t/p/";

  static const nowPlayingUrl = "${baseUrl}now_playing?api_key=$apiKey";
  static const upcomingUrl = "${baseUrl}upcoming?api_key=$apiKey";
  static const popularUrl = "${baseUrl}popular?api_key=$apiKey";
  static const topRatedUrl = "${baseUrl}top_rated?api_key=$apiKey";
   
}
