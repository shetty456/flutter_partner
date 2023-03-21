import 'package:customer/providers/bookings.dart';
import 'package:customer/widgets/mybookings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<Bookings>(context, listen: false).getbookings();
    return Consumer<Bookings>(
      builder: (context, state, _) => Container(
          child: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.bookings.isNotEmpty
                  ? const MyBookings()
                  : Column(
                      children: [
                        const SizedBox(
                          height: 16.0,
                        ),
                        Image.asset(
                          'assets/images/bookings.png',
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Center(
                          child: Text(
                            'No Bookings',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        )
                      ],
                    )),
    );
  }
}
