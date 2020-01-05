import 'package:flutter/material.dart';

import 'entity/entity.dart';
import 'entity/purchase.dart';

class PurchaseView extends StatefulWidget {
  PurchaseView({Key key, this.purchase}) : super(key: key);

  final Purchase purchase;

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(widget.purchase.description),
        ),
      ),
      body: Center(
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              title: Text(IDField),
              subtitle: Text(widget.purchase.ID.toString()),
            ),
            ListTile(
              title: Text(descriptionField),
              subtitle: Text(widget.purchase.description),
            ),ListTile(
              title: Text(priceField),
              subtitle: Text(widget.purchase.price?.toString() ?? ""),
            ),
            ListTile(
              title: Text(externalCreditField),
              subtitle: Text(widget.purchase.externalCredit?.toString() ?? ""),
            ),
            ListTile(
              title: Text(dateField),
              subtitle: Text(widget.purchase.date?.toIso8601String() ?? "Unknown"),
            ),
            ListTile(
              title: Text(originalPriceField),
              subtitle: Text(widget.purchase.originalPrice?.toString() ?? ""),
            ),
          ],
        ),
      ),
    );

  }
}