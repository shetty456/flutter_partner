import 'package:customer/providers/location.dart';
import 'package:customer/providers/search.dart';
import 'package:customer/screens/searchresultscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _loading = false;
  final searchTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchTextController.text =
        Provider.of<LocationState>(context).currentAddress;
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    collapsedHeight: 70.0,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: const Icon(Icons.arrow_back),
                                )),
                            Expanded(
                              child: TextField(
                                controller: searchTextController,
                                onSubmitted: (value) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  Provider.of<Search>(context, listen: false)
                                      .searchsalons(value);
                                  Navigator.of(context).pushReplacementNamed(
                                    SearchResultScreen.routeName,
                                  );
                                  if (kDebugMode) {
                                    print(value);
                                  }
                                },
                                onTap: () {},
                                decoration: const InputDecoration(
                                  hintText: 'Search For Salons',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _loading = true;
                                  });
                                  Provider.of<Search>(context, listen: false)
                                      .searchsalons(searchTextController.text);
                                  Navigator.of(context).pushReplacementNamed(
                                    SearchResultScreen.routeName,
                                  );
                                },
                                icon: const Icon(Icons.search),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Provider.of<LocationState>(
                                context,
                                listen: false,
                              ).getCurrentLocation();
                              // if (!mounted) return;
                              // searchTextController.text =
                              //     Provider.of<LocationState>(
                              //   context,
                              //   listen: false,
                              // ).currentAddress;
                            },
                            child: const Text('Use Current Location'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
