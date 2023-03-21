import 'package:customer/providers/search.dart';
import 'package:customer/widgets/salonsearchresult.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<String> urls = [
  'assets/images/1.jpg',
  'assets/images/2.jpg',
  'assets/images/3.jpg',
  'assets/images/4.jpg',
  'assets/images/5.jpg',
];

class SearchResult extends StatefulWidget {
  const SearchResult({super.key});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> results = Provider.of<Search>(context).result;
    final bool loading = Provider.of<Search>(context).loading;

    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : results.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Sorry No Salon Found For The Provided Location, Please Search Another Location',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: ((context, index) => SalonSearchResult(
                      salondata: results[index],
                      url: urls[index % 5],
                    )),
                itemCount: results.length,
              );
  }
}
