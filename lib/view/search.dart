import 'package:flutter/material.dart';
import 'package:syosetsu_reader/constant/novel.dart';
import 'search_content.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    const Map<int, String> searchType = SearchType.searchType;
    return ListView.builder(
      itemCount: searchType.length,
      itemBuilder: (context, index) {
        return SizedBox(
            height: 50,
            child: ListTile(
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => index == 0
                          ? SearchRankingView(typeId: index)
                          : SearchRankingView(typeId: index)),
                ),
              },
              title: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  searchType[index]!,
                ),
              ),
            ));
      },
    );
  }
}
