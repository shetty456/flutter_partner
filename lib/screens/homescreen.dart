import 'package:customer/screens/searchscreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Our Services',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      LocCard(
                        url: 'assets/images/haircut.jpg',
                        textline: 'Hair Cut',
                      ),
                      LocCard(
                        url: 'assets/images/shaving.jpg',
                        textline: 'Shaving',
                      ),
                      LocCard(
                        url: 'assets/images/massage.jpg',
                        textline: 'Head Massage',
                      ),
                      LocCard(
                        url: 'assets/images/salon1.jpg',
                        textline: 'Others',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        HomeCard(
          search: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName);
          },
          tagline: 'Fantastic Salons For Handsome Men',
          url: 'assets/images/salon4.png',
        ),
        HomeCard(
          search: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName);
          },
          tagline: 'Choose The Best Of All The Worlds',
          url: 'assets/images/salon5.png',
        ),
        HomeCard(
          search: () {
            Navigator.of(context).pushNamed(SearchScreen.routeName);
          },
          tagline: 'Explore The Best Salons In Your Locality',
          url: 'assets/images/salon6.png',
        ),
      ],
    );
  }
}

class LocCard extends StatelessWidget {
  final String url;
  final String textline;
  const LocCard({
    Key? key,
    required this.url,
    required this.textline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(url),
            radius: 40,
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            textline,
            style: Theme.of(context).textTheme.subtitle2,
          )
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String tagline;
  final String url;
  final VoidCallback search;
  const HomeCard({
    Key? key,
    required this.tagline,
    required this.url,
    required this.search,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(url),
              fit: BoxFit.fill,
            ),
          ),
          height: 220,
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 64.0,
                vertical: 0.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: search,
                    child: const Text('Search'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
