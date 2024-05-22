class BookData {
  final String rank;
  final String ncode;
  final String title;
  final String author;
  final String create_date;
  final String update_date;
  final int storyLength;

  BookData(
      {required this.rank,
      required this.ncode,
      required this.title,
      required this.author,
      required this.create_date,
      required this.update_date,
      required this.storyLength});

  factory BookData.fromJson(Map<String, dynamic> json, String rank) {
    return BookData(
        ncode: json['ncode'] as String,
        author: json['writer'] as String,
        title: json['title'] as String,
        create_date: json['general_firstup'],
        update_date: json['novelupdated_at'],
        storyLength: json['general_all_no'] as int,
        rank: rank);
  }
}
