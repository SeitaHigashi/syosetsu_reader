import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchContentView extends StatelessWidget{
  final int typeId;
  static const Map<int, String> searchType = {
    0: '条件検索',
    1: '日間ランキング',
    2: '週間ランキング',
    3: '月間ランキング',
    4: '四半期ランキング',
    5: '年間ランキング',
    6: '累計ランキング'
  };

  SearchContentView({required this.typeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: BookList.getRanking(getRankingURL()),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.error != null) {
            return Center(
                child: Text('エラーがおきました')
            );
          };

          return ListView.builder(
            itemCount: BookList.bookData.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 50,
                child: ListTile(
                  onTap: () {
                    importBook(BookList.bookData[index].ncode);
                  },
                  title: Text(
                    BookList.bookData[index].title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    BookList.bookData[index].author
                  )
                )
              );
            },
          );
        }
      ),
    );
  }

  String getRankingURL(){
    String result;
    switch (this.typeId){
      case 1:
        result = BookList.dayRankingURL();
        break;
      case 2:
        result = BookList.weekRankingURL();
        break;
      case 3:
        result = BookList.monthRankingURL();
        break;
      case 4:
        result = BookList.quoteRankingURL();
        break;
      case 5:
        result = BookList.dayRankingURL();
        break;
      case 6:
        result = BookList.dayRankingURL();
        break;
      default:
        result = BookList.dayRankingURL();
        break;
    } 
    return result;
  }

  String importBook(String ncode){
    return 'download is $ncode';
  }
}

class BookList {
  static const String rankingUrl = 'https://api.syosetu.com/rank/rankget/?out=json';
  static const String bookUrl = 'https://api.syosetu.com/novelapi/api/?of=n-t-w-ga&out=json';
  static List<BookData> bookData = [];
  
  static Future<void> getRanking(uri) async {
    final rankResponse = await http.get(Uri.parse(uri));
    Map<String, String> rankList = {};
    List<String> rankAndNcode = [];
    debugPrint(rankResponse.body);
    
    if (rankResponse.statusCode == 200) {
      final parsed1 = jsonDecode(rankResponse.body).cast<Map<String, dynamic>>();
      rankList = parsed1.map(
        (json) =>
          {'${json["ncode"]}': '${json["rank"]}'}
        );
      rankAndNcode = parsed1.map((json) => '${json["rank"]}-${json["ncode"]}').toList();
      String ncodeJoin = rankAndNcode.map((str) => str.split('-')[1]).join('-');
      final bookResponse = await http.get(Uri.parse('${bookUrl}&${ncodeJoin}'));

      if (bookResponse.statusCode == 200) {
        final parsed2 = jsonDecode(rankResponse.body).cast<Map<String, dynamic>>();
        bookData = parsed2.map<BookData>((json) => BookData.fromJson(json, rankList)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  String get url => url;

  static String dayRankingURL() {
    final DateTime nowdate = DateTime.now();
    final String strdate = DateFormat('yyyyMMdd').format(nowdate);
    return '${BookList.rankingUrl}&rtype=$strdate-d';
  }

  static String weekRankingURL() {
    final DateTime nowdate = DateTime.now();
    final String strdate = DateFormat('yyyyMMdd').format(nowdate);
    return '${BookList.rankingUrl}&rtype=$strdate-w';
  }

  static String monthRankingURL() {
    final DateTime nowdate = DateTime.now();
    final String strdate = DateFormat('yyyyMM01').format(nowdate);
    return '${BookList.rankingUrl}&rtype=$strdate-m';
  }

  static String quoteRankingURL() {
    final DateTime nowdate = DateTime.now();
    final String strdate = DateFormat('yyyyMM01').format(nowdate);
    return '${BookList.rankingUrl}&rtype=$strdate-q';
  }
}

class BookData {
  final String rank;
  final String ncode;
  final String title;
  final String author;
  final int storyLength;

  BookData({
    required this.rank,
    required this.ncode,
    required this.title,
    required this.author,
    required this.storyLength
  });
  
  factory BookData.fromJson(Map<String, dynamic> json, Map rankList){
    return BookData(
      ncode: json['ncode'] as String,
      author: json['writer'] as String,
      title: json['title'] as String,
      storyLength: json['general_all_no'] as int,
      rank: rankList[json['ncode']]);
  }
}

class Ranking{
  final String ncode;
  final int rank;

  Ranking({
    required this.ncode,
    required this.rank
  });

  factory Ranking.fromJson(Map<String, dynamic> json){
    return Ranking(
      ncode: json['ncode'] as String,
      rank: json['rank'] as int);
  }
}