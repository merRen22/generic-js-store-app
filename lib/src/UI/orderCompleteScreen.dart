
import 'package:flutter/material.dart';

class OrderCompleteScreen extends StatefulWidget {
  final int id;

  const OrderCompleteScreen({Key key, this.id}): super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderCompleteScreenState();
}

class _OrderCompleteScreenState extends State<OrderCompleteScreen>{

  String getCode() => widget.id.toString().padLeft(4,'0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Thank you",style: Theme.of(context).primaryTextTheme.subtitle),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,16,0,8),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).primaryTextTheme.body1,
                              children: [
                              TextSpan(text: "Your order "),
                              TextSpan(text: "P${getCode()}", style: Theme.of(context).primaryTextTheme.body2),
                              TextSpan(text: " has been registrated"),
                            ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,40),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Continue shopping",style: Theme.of(context).primaryTextTheme.display4),
                  )
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 2/3,
                child: Image.asset('images/success.png',fit: BoxFit.fitWidth,)
                )
            ],
          ),
        )
        );
  }
}