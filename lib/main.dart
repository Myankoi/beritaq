import 'package:beritaq/domain/usecases/get_favorites.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/local/user_pref.dart';
import 'core/network/api_client.dart';

import 'data/datasources/news_remote_datasource.dart';
import 'data/datasources/favorite_local_datasource.dart';
import 'data/repositories/news_repository_impl.dart';

import 'domain/usecases/add_favorite.dart';
import 'domain/usecases/check_favorite.dart';
import 'domain/usecases/get_news.dart';

import 'domain/usecases/remove_favorite.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/onboarding_page.dart';

import 'core/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ===== USER SESSION =====
  final isLoggedIn = await UserPref.isLoggedIn();

  // ===== CORE =====
  final httpClient = http.Client();
  final prefs = await SharedPreferences.getInstance();

  final apiClient = ApiClient(
    client: httpClient,
    baseUrl: 'https://newsapi.org/v2',
    apiKey: 'eb338ecaf17c460eb6cb8113d6f34cd1',
  );

  // ===== DATASOURCES =====
  final remoteDatasource = NewsRemoteDatasourceImpl(apiClient);
  final localDatasource = FavoriteLocalDatasourceImpl(prefs);

  // ===== REPOSITORY =====
  final repository = NewsRepositoryImpl(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
  );

  // ===== USE CASE =====
  final getNewsUseCase = GetNews(repository);
  final addFavorite = AddFavorite(repository);
  final removeFavorite = RemoveFavorite(repository);
  final checkFavorite = CheckFavorite(repository);
  final getFavorites = GetFavorites(repository);

  runApp(
    MyApp(
      isLoggedIn: isLoggedIn,
      getNews: getNewsUseCase,
      addFavorite: addFavorite,
      checkFavorite: checkFavorite,
      removeFavorite: removeFavorite,
      getFavorites: getFavorites,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  final GetNews getNews;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final CheckFavorite checkFavorite;
  final GetFavorites getFavorites;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.getNews,
    required this.addFavorite,
    required this.removeFavorite,
    required this.checkFavorite,
    required this.getFavorites
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: isLoggedIn ? '/home' : '/onboarding',
      routes: {
        '/onboarding': (_) => const OnboardingPage(),
        '/login': (_) => const LoginPage(),
        '/home': (_) => HomePage(
          getNews: getNews,
          getFavorites: getFavorites,
          addFavorite: addFavorite,
          removeFavorite: removeFavorite,
          checkFavorite: checkFavorite,
        ),
      },
    );

  }
}
