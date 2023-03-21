import 'package:customer/screens/profilescreen.dart';
import 'package:customer/widgets/searchresult.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class SearchResultScreen extends StatefulWidget {
  static const routeName = '/searchresult';
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Result'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: CircleAvatar(
                child: Text(
                  Provider.of<Auth>(context).username[0],
                ),
              ),
            ),
          )
        ],
      ),
      body: const Card(
        child: SearchResult(),
      ),
    );
  }
}
