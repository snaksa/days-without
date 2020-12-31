import 'package:flutter/material.dart';

class NoRecords extends StatelessWidget {
  final bool withImage;
  NoRecords({this.withImage, key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          this.withImage
              ? Image.asset(
                  'assets/images/arrow-2.png',
                  color: Theme.of(context).primaryColor,
                  height: 100,
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('Click the '),
              Text(
                '+ ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Text('button'),
            ],
          ),
          const Text('to add your first '),
          const Text('record'),
        ],
      ),
    );
  }
}
