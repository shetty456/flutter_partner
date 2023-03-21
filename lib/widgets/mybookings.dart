import 'package:customer/providers/bookings.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';

class MyBookings extends StatelessWidget {
  const MyBookings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> bookings = Provider.of<Bookings>(context).bookings;
    bookings.sort(((b, a) => a['date'].compareTo(b['date'])));
    initializeDateFormatting('in');
    String todayDate = DateFormat.yMd('in').format(DateTime.now());
    String formatDate = DateFormat.yMd().format(DateTime.now());
    return Card(
      elevation: 0,
      child: ListView.separated(
        itemCount: bookings.length,
        itemBuilder: ((context, index) => Dismissible(
              confirmDismiss: (direction) => showDialog(
                context: context,
                builder: ((ctx) => AlertDialog(
                      title: const Text('Are You Sure?'),
                      content: const Text(
                          'Do you really want to cancel your booking?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Provider.of<Bookings>(
                              context,
                              listen: false,
                            ).cancelBooking(
                              salonId: bookings[index]['salonId'],
                              bookingtime: bookings[index]['selectedTiming'],
                              salonName: bookings[index]['salonName'],
                            );
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes'),
                        )
                      ],
                    )),
              ),
              direction: (bookings[index]['date']! == todayDate ||
                      bookings[index]['date']! == formatDate)
                  ? DismissDirection.endToStart
                  : DismissDirection.none,
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              key: UniqueKey(),
              child: BookingsCard(
                booking: bookings[index],
              ),
            )),
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1.0,
          );
        },
      ),
    );
  }
}

class BookingsCard extends StatelessWidget {
  final dynamic booking;
  const BookingsCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('in');
    String todayDate = DateFormat.yMd('in').format(DateTime.now());
    String formatDate = DateFormat.yMd().format(DateTime.now());
    double latitude = double.parse(booking['latitude']);
    double longitude = double.parse(booking['longitude']);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.asset(
              'assets/images/4.jpg',
              fit: BoxFit.cover,
              height: 70,
              width: 70,
            ),
          ),
          title: Text(
            booking['salonName'][0].toUpperCase() +
                booking["salonName"].substring(1).toLowerCase(),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          subtitle: Text(
            (booking['date']! == todayDate || booking['date']! == formatDate)
                ? booking['selectedTiming']
                : booking['date'],
            style: Theme.of(context).textTheme.subtitle2,
          ),
          trailing:
              (booking['date']! == todayDate || booking['date']! == formatDate)
                  ? ElevatedButton(
                      onPressed: () async {
                        final availableMaps = await MapLauncher.installedMaps;
                        await availableMaps.first.showDirections(
                          destination: Coords(
                            latitude,
                            longitude,
                          ),
                        );
                      },
                      child: const Text('Location'),
                    )
                  : OutlinedButton(
                      onPressed: () {},
                      child: const Text('Feedback'),
                    ),
        ),
      ),
      // child: Row(
      //   children: [
      //     ClipRRect(
      //       borderRadius: BorderRadius.circular(5.0),
      //       child: Image.asset(
      //         'assets/images/bangalore.jpg',
      //         fit: BoxFit.cover,
      //         height: 100,
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 20.0,
      //     ),
      //     Column(
      //       children: [
      //         Text(
      //           booking['salonName'],
      //           style: Theme.of(context).textTheme.headline6,
      //         ),
      //         const SizedBox(
      //           height: 10.0,
      //         ),
      //         Text(
      //           booking['date'],
      //           style: Theme.of(context).textTheme.subtitle1,
      //         ),
      //       ],
      //     )
      //   ],
    );
  }
}
