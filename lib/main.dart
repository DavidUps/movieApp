import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_flims/models/movie.dart';
import './models/movie.dart';
import 'package:carousel_slider/carousel_slider.dart';

const baseUrl = "https://api.themoviedb.org/3/movie/";
const baseImageUrl = "https://image.tmdb.org/t/p/";
const apiKey = "c80439488364417bc2a4fd25612df122&";

const nowPlayingUrl = "${baseUrl}now_playing?api_key=$apiKey";
const upcomingUrl = "${baseUrl}upcoming?api_key=$apiKey";
const popularUrl = "${baseUrl}popular?api_key=$apiKey";
const topRatedUrl = "${baseUrl}top_rated?api_key=$apiKey";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoviApp',
      theme: ThemeData.dark(),
      home: MyMovieApp(),
    ));

class MyMovieApp extends StatefulWidget {
  @override
  _MyMovieApp createState() => new _MyMovieApp();
}

class _MyMovieApp extends State<MyMovieApp> {
  Movie nowPlayingMovies;
  Movie upComingMovies;
  Movie popularMovies;
  Movie topRatedMovies;
  int heroTag = 0;

  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovies();
    _fetchNowUpComingMovies();
    _fetchPopularMovies();
    _fetchTopRatedMovies();
  }

  void _fetchNowPlayingMovies() async {
    var response = await http.get(nowPlayingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      nowPlayingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchNowUpComingMovies() async {
    var response = await http.get(upcomingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      upComingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(popularUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      popularMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchTopRatedMovies() async {
    var response = await http.get(topRatedUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      topRatedMovies = Movie.fromJson(decodeJson);
    });
  }

  Widget _buildCarouselSlider() => CarouselSlider(
      items: nowPlayingMovies == null
          ? <Widget>[Center(child: CircularProgressIndicator())]
          : nowPlayingMovies.results
              .map((movieItem) => _buildMoviItem(movieItem))
              .toList(),
      autoPlay: false,
      height: 249.0,
      viewportFraction: 0.5);

  Widget _buildMoviesListView(Movie movie, String movieListTitle) => Container(
        height: 258.0,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
              child: Text(
                movieListTitle,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400]),
              ),
            ),
            Flexible(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: movie == null
                    ? <Widget>[Center(child: CircularProgressIndicator())]
                    : movie.results.map((movieItem) => Padding(
                          padding: EdgeInsets.only(left: 6.0, right: 2.0),
                          child: _buildMoveListItem(movieItem),
                        )).toList(),
              ),
            )
          ],
        ),
      );

  Widget _buildMoviItem(Results movieItem) {
    heroTag += 1;
    return Material(
      elevation: 15.0,
      child: InkWell(
        onTap: () {

        },
        child: Hero(
          tag: movieItem.id,
          child: Image.network(
            "${baseImageUrl}w342${movieItem.posterPath}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMoveListItem(Results movieItem) => Material(
        child: Container(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(6.0),
                  child: _buildMoviItem(movieItem)),
              Padding(
                  padding: EdgeInsets.only(left: 6.0, top: 2.0),
                  child: Text(movieItem.title,
                      style: TextStyle(fontSize: 8.0),
                      overflow: TextOverflow.ellipsis)),
              Padding(
                  padding: EdgeInsets.only(left: 6.0, top: 2.0),
                  child: Text(
                    movieItem.releaseDate,
                    style: TextStyle(fontSize: 8.0),
                  ))
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Movies",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: (8.0)),
                  child: Text(
                    "CARTELERA",
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              expandedHeight: 290.0,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        "${baseImageUrl}w500/2uNW4WbgBXL25BAbXGLnLqX71Sw.jpg",
                        fit: BoxFit.cover,
                        width: 1000.0,
                        colorBlendMode: BlendMode.dstATop,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: _buildCarouselSlider())
                  ],
                ),
              ),
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            _buildMoviesListView(upComingMovies, "PROXIMAS PELÍCULAS"),
            _buildMoviesListView(popularMovies, "PELÍCULAS POPULARES"),
            _buildMoviesListView(topRatedMovies, "MEJORES PELÍCULAS"),
          ],
        ),
      ),
    );
  }
}
