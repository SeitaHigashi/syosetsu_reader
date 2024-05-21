import 'package:flutter/material.dart';
import 'search_content.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<int, String> searchType = SearchContentView.searchType;
    return ListView.builder(
      itemCount: searchType.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 50,
          child: ListTile(
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SearchContentView(typeId: index),
                ),
              ),
            },
            title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                searchType[index]!,
              ),
            ),
          )
        );
      },
    );
  }
}

class ListTileItem {
  final String title;

  const ListTileItem({
    required this.title,
  });
}

class ListItemData {
  final Map<int, String> searchMap = {
    1: '条件検索',
    2: '日間ランキング',
    3: '週間ランキング',
    4: '月間ランキング',
    5: '四半期ランキング',
    6: '年間ランキング',
    7: '累計ランキング'
  };

  ListItemData();
}