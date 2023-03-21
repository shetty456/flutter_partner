import 'package:customer/providers/bookings.dart';
import 'package:customer/providers/search.dart';
import 'package:intl/intl.dart';

import 'package:customer/screens/profilescreen.dart';
import 'package:customer/screens/selecttiming.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class IndividualSalonDisplayScreen extends StatefulWidget {
  static const routeName = '/individualsalon';
  const IndividualSalonDisplayScreen({super.key});

  @override
  State<IndividualSalonDisplayScreen> createState() =>
      _IndividualSalonDisplayScreenState();
}

class _IndividualSalonDisplayScreenState
    extends State<IndividualSalonDisplayScreen> {
  bool showCard = false;

  @override
  Widget build(BuildContext context) {
    final salonId = ModalRoute.of(context)!.settings.arguments as String;

    final String day = DateFormat.EEEE().format(DateTime.now()).toLowerCase();

    final String openingTime = '${day}OpeningTime';
    final String closingTime = '${day}ClosingTime';

    final Map<String, dynamic> salonData = Provider.of<Search>(
      context,
      listen: false,
    ).findById(salonId);

    String salonOpeningTime = salonData["timings"][day][openingTime];
    String salonClosingTime = salonData["timings"][day][closingTime];

    String latitude = salonData["latitude"];
    String longitude = salonData["longitude"];

    if (salonOpeningTime.isNotEmpty) {
      Provider.of<Bookings>(context)
          .slotMaker(salonOpeningTime, salonClosingTime, context);
      Provider.of<Bookings>(context, listen: false)
          .addSalonBooking(salonData['bookings']);
    }

    int serviceAmount = Provider.of<Bookings>(context).serviceAmount;

    final services = salonData["services"];

    final List<dynamic> serviceValues = [
      {
        'id': 1,
        'name': "Hair Cut",
        'amount': services["haircut"]["amount"],
        'time': services["haircut"]["timeRequired"],
        'imageurl': 'assets/images/haircut.jpg',
      },
      {
        'id': 2,
        'name': "Shaving",
        'amount': services["shaving"]["amount"],
        'time': services["shaving"]["timeRequired"],
        'imageurl': 'assets/images/shaving.jpg',
      },
      {
        'id': 3,
        'name': "Head Massage",
        'amount': services["massage"]["amount"],
        'time': services["massage"]["timeRequired"],
        'imageurl': 'assets/images/massage.jpg',
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Individual Salon'),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.center,
              children: [
                Image.asset(
                  'assets/images/4.jpg',
                  fit: BoxFit.cover,
                  height: 220,
                  width: double.infinity,
                ),
                Positioned(
                  top: 180,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        salonData["shopName"][0].toUpperCase() +
                            salonData["shopName"].substring(1).toLowerCase(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: Text(
                'Services',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Divider(
                height: 2.0,
                thickness: 1.0,
              ),
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                if (serviceValues[index]['amount'] != null) {
                  return ServiceCard(
                    serviceName: serviceValues[index]['name'],
                    serviceAmount: serviceValues[index]['amount'],
                    serviceTime: serviceValues[index]['time'],
                    imageUrl: serviceValues[index]['imageurl'],
                  );
                }
                return Container();
              },
              itemCount: serviceValues.length,
              shrinkWrap: true,
            )
          ],
        ),
      ),
      bottomNavigationBar: serviceAmount > 0
          ? Card(
              elevation: 24.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$serviceAmount Rupees'),
                    IconButton(
                      onPressed: () {
                        Provider.of<Bookings>(
                          context,
                          listen: false,
                        ).addSalonId(salonId);
                        Provider.of<Bookings>(
                          context,
                          listen: false,
                        ).addSalonName(salonData['shopName']);
                        Provider.of<Bookings>(
                          context,
                          listen: false,
                        ).addSalonToken(salonData['fcmtoken']);
                        Provider.of<Bookings>(context, listen: false)
                            .setcoordinates(
                          latitude: latitude,
                          longitude: longitude,
                        );
                        Navigator.of(context).pushNamed(SelectTiming.routeName);
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                      ),
                    )
                  ],
                ),
              ),
            )
          : const Card(),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final dynamic serviceName;
  final dynamic serviceAmount;
  final dynamic serviceTime;
  final String imageUrl;

  const ServiceCard({
    Key? key,
    required this.serviceName,
    required this.serviceAmount,
    required this.serviceTime,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  String buttontext = 'Add';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  widget.serviceName,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${widget.serviceAmount} Rupees',
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                  child: Image.asset(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    height: 70,
                    width: 70,
                  ),
                ),
                Positioned(
                  top: 48,
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: () {
                        if (buttontext == 'Add') {
                          Provider.of<Bookings>(context, listen: false)
                              .addServiceAmount(widget.serviceAmount);
                          Provider.of<Bookings>(context, listen: false)
                              .addService(widget.serviceName);
                          Provider.of<Bookings>(context, listen: false)
                              .addServiceTime(int.parse(widget.serviceTime));
                          setState(() {
                            buttontext = 'Remove';
                          });
                        } else {
                          Provider.of<Bookings>(context, listen: false)
                              .removeServiceAmount(widget.serviceAmount);
                          Provider.of<Bookings>(context, listen: false)
                              .removeService(widget.serviceName);
                          Provider.of<Bookings>(context, listen: false)
                              .removeServiceTime(int.parse(widget.serviceTime));
                          setState(() {
                            buttontext = 'Add';
                          });
                        }
                      },
                      child: Text(
                        buttontext,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
