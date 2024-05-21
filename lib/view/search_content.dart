import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchContentView extends StatelessWidget {
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
              return Center(child: Text('エラーがおきました'));
            }
            ;

            return ListView.builder(
              itemCount: BookList.bookData.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      importBook(BookList.bookData[index].ncode);
                    },
                    title: Text(
                      '${BookList.bookData[index].rank}位 ${BookList.bookData[index].title}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(BookList.bookData[index].author));
              },
            );
          }),
    );
  }

  String getRankingURL() {
    String result;
    switch (this.typeId) {
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

  importBook(String ncode) {
    print('download is $ncode');
  }
}

class BookList {
  static const String rankingUrl =
      'https://api.syosetu.com/rank/rankget/?out=json';
  static const String bookUrl =
      'https://api.syosetu.com/novelapi/api/?of=n-t-w-ga&out=json&lim=300';
  static List<BookData> bookData = [];

  static Future<void> getRanking(uri) async {
    bookData.clear();
    final rankResponse = await http.get(Uri.parse(uri));
    Map<String, String> rankList = {};

    if (rankResponse.statusCode == 200) {
      final parsed1 = jsonDecode(rankResponse.body);
      String ncodeJoin = parsed1.map((json) => json["ncode"]).join('-');

      parsed1
          .forEach((json) => rankList['${json["ncode"]}'] = '${json["rank"]}');
      final bookResponse = await http
          .get(Uri.parse('$bookUrl&ncode=${ncodeJoin.toLowerCase()}'));

      if (bookResponse.statusCode == 200) {
        final parsed2 = jsonDecode(bookResponse.body);
        parsed2.removeAt(0);
        parsed2.forEach((json) => bookData
            .add(BookData.fromJson(json, rankList['${json["ncode"]}']!)));

        bookData.sort((a, b) => int.parse(a.rank).compareTo(int.parse(b.rank)));
      } else {
        throw Exception('Failed to load data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

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

  BookData(
      {required this.rank,
      required this.ncode,
      required this.title,
      required this.author,
      required this.storyLength});

  factory BookData.fromJson(Map<String, dynamic> json, String rank) {
    return BookData(
        ncode: json['ncode'] as String,
        author: json['writer'] as String,
        title: json['title'] as String,
        storyLength: json['general_all_no'] as int,
        rank: rank);
  }
}

class Ranking {
  final String ncode;
  final int rank;

  Ranking({required this.ncode, required this.rank});

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(ncode: json['ncode'] as String, rank: json['rank'] as int);
  }
}
