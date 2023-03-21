import 'package:customer/providers/bookings.dart';
import 'package:customer/screens/successscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTiming extends StatefulWidget {
  static const routeName = '/selecttiming';
  const SelectTiming({super.key});

  @override
  State<SelectTiming> createState() => _SelectTimingState();
}

class _SelectTimingState extends State<SelectTiming> {
  @override
  Widget build(BuildContext context) {
    List<String> timeslots = Provider.of<Bookings>(context).timeslots;
    List<String> bookedSlots = Provider.of<Bookings>(context).bookedSlots;
    timeslots.retainWhere(
      (element) => !bookedSlots.contains(element),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Timing'),
      ),
      body: Center(
        child: timeslots.isEmpty
            ? const Text('We are Sorry, But all slots have been Booked')
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: timeslots.length,
                itemBuilder: ((context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SlotCard(
                        text: timeslots[index],
                        selected: false,
                      ),
                    )),
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 40.0,
          child: ElevatedButton(
            onPressed: Provider.of<Bookings>(context).selectedTiming.isEmpty
                ? null
                : () {
                    Navigator.of(context)
                        .pushReplacementNamed(SuccessScreen.routeName);
                    Provider.of<Bookings>(context, listen: false).booksalon();
                  },
            child: const Text('Book Now'),
          ),
        ),
      ),
    );
  }
}

class SlotCard extends StatefulWidget {
  final String text;
  final bool selected;
  const SlotCard({
    super.key,
    required this.text,
    required this.selected,
  });

  @override
  State<SlotCard> createState() => _SlotCardState();
}

class _SlotCardState extends State<SlotCard> {
  @override
  Widget build(BuildContext context) {
    String selectedText = Provider.of<Bookings>(context).selectedTiming;
    return InkWell(
      onTap: () {
        Provider.of<Bookings>(context, listen: false)
            .addSelectedTiming(widget.text);
      },
      child: Card(
        color: selectedText == widget.text ? Colors.green : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(widget.text),
          ),
        ),
      ),
    );
  }
}
