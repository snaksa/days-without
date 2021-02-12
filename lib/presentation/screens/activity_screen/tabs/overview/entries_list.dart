import 'package:days_without/data/models/activity.dart';
import 'package:days_without/presentation/screens/entry_form_screen.dart';
import 'package:days_without/presentation/screens/activity_screen/tabs/overview/entry_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntriesList extends StatelessWidget {
  final Activity activity;
  final DateTime date;

  EntriesList(this.activity, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                'All entries on this day',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
            ...this
                .activity
                .dates
                .where(
                  (DateTime d) => (date.day == d.day &&
                      date.month == d.month &&
                      date.year == d.year),
                )
                .map((DateTime d) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return EntryDetails(this.activity.id, d);
                      });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 8),
                                Text(
                                  DateFormat('HH:mm').format(d),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            Center(
              child: ElevatedButton(
                child: const Text('New Entry'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    EntryFormScreen.ROUTE_NAME,
                    arguments: EntryFormProps(this.activity.id, date),
                  ).then((value) => Navigator.of(context).pop());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
