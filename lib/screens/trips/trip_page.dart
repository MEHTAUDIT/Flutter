import 'package:flutter/material.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trips'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming Journey'),
              Tab(text: 'Past Journey'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UpcomingTripPage(),
            LastTransactionPage(),
          ],
        ),
      ),
    );
  }
}

class UpcomingTripPage extends StatelessWidget {
  const UpcomingTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Table(
                      children: const [
                        TableRow(children: [
                          Text('Train', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('PNR', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('From', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('To', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Class', style: TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        TableRow(children: [
                          Text('INTERCITY EXP (22959)'),
                          Text('8421452649'),
                          Text('23 Aug 2024'),
                          Text('ND'),
                          Text('RJT'),
                          Text('2S'),
                        ]),
                      ],
                    ),
                    const SizedBox(height: 16),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LastTransactionPage extends StatelessWidget {
  const LastTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Past Journey'),
    );
  }
}
