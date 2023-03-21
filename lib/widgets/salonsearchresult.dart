import 'package:customer/providers/bookings.dart';
import 'package:customer/providers/location.dart';
import 'package:customer/screens/individualsalondisplayscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SalonSearchResult extends StatelessWidget {
  final Map<String, dynamic> salondata;
  final String url;
  const SalonSearchResult({
    super.key,
    required this.salondata,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    double latitude = salondata['latitude'] == null
        ? 0.0
        : double.parse(salondata['latitude']);
    double longitude = salondata['longitude'] == null
        ? 0.0
        : double.parse(salondata['longitude']);
    String distance = Provider.of<LocationState>(context)
        .distanceBetweenCoords(
          latitude,
          longitude,
        )
        .toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 6.0,
      ),
      child: Card(
        elevation: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Stack(
                children: [
                  Image.asset(
                    url,
                    fit: BoxFit.cover,
                    height: 220,
                    width: double.infinity,
                  ),
                  Positioned(
                      left: 5.0,
                      bottom: 5.0,
                      child: Row(
                        children: [
                          Card(
                            shape: const CircleBorder(
                              side: BorderSide.none,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.nordic_walking),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('$distance KM'),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      salondata["shopName"][0].toUpperCase() +
                          salondata["shopName"].substring(1).toLowerCase(),
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  RatingBarIndicator(
                    rating: 0.0,
                    itemSize: 25.0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    salondata["city"][0].toUpperCase() +
                        salondata["city"].substring(1).toLowerCase(),
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'Rs. ${salondata['services']['haircut']['amount']}',
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<Bookings>(context, listen: false)
                      .resetServiceContent();
                  Navigator.pushNamed(
                    context,
                    IndividualSalonDisplayScreen.routeName,
                    arguments: salondata["_id"],
                  );
                },
                child: const Text("Book Now"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
