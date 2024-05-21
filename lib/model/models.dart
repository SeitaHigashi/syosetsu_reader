// Bookテーブル定義
class Book {
  final int? id;
  final String ncode;
  final String title;
  final String author;
  bool is_download;
  final DateTime create_date;
  DateTime update_date;

  Book({
    this.id,
    required this.ncode,
    required this.title,
    required this.author,
    required this.is_download,
    required this.create_date,
    required this.update_date
  });
}

class Story {

}

class Bookmark {

}