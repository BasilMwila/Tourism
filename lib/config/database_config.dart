class DatabaseConfig {
  static const String host =
      'ls-ab91bdaf741ac46789f3e1084d92ae72d98ef346.c0vyackkg5lk.us-east-1.rds.amazonaws.com';
  static const String username = 'dbmasteruser';
  static const String password = 'eXon4kXY-B4sUm#H&^nIysYa#m,}V)nZ';
  static const int port = 3306;
  static const String database = 'zambia_tourism';

  static String get connectionString =>
      'mysql://$username:$password@$host:$port/$database';
}
