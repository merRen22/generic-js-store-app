
import 'package:flutter/material.dart';
import 'package:generic_store_app/src/Models/Order.dart';
import 'package:generic_store_app/src/Models/Products.dart';

class StoreScreen extends StatefulWidget {

  const StoreScreen({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>{

  List productos = List<Product>();
  Order order = Order();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: searchBox(),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: productos.isEmpty
              ?emptyCard()
              :ListView.builder(
                shrinkWrap: true,
                itemCount: productos.length,
                itemBuilder: (ctx,productIndex){
                  return productCard(productos[productIndex]);
                },
              ),
            ),
            orderCard()
          ],
        )
        ));
  }

  Widget productCard(producto){
    return Card(
      child: Text('Yogurg Laive'),
    );
  }
  
  Widget orderCard(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add_box,color: Theme.of(context).accentIconTheme.color),
              SizedBox(width: 12,),
              RichText(
                          text: TextSpan(
                            style: Theme.of(context).primaryTextTheme.body1,
                            children: [
                            TextSpan(text: "Buy now and get it by "),
                            TextSpan(text: DateTime.now().day.toString(), style: Theme.of(context).primaryTextTheme.body2)
                          ]),
                        ),
            ],
          ),
        ),
        orderDetaildRow("Products",0.0,0),
        orderDetaildRow("Shipping Cost",0.0,1),
        orderDetaildRow("Taxes",0.0,0),
        orderDetaildRow("Total",0.0,2),
        Container(
          height: 64,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: OutlineButton(
                      onPressed: () =>Navigator.pushNamed(context, '/orderComplete'),
                      child: Text(
                        "COMPLETE ORDER",
                        style: Theme.of(context).primaryTextTheme.display2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0),)
                    ),
        ),
      ],
    );
  }

  Widget orderDetaildRow(label,charge,remarcable){
    return Padding(
      padding: remarcable == 2
        ?EdgeInsets.fromLTRB(16,12,16,32)
        :EdgeInsets.fromLTRB(16,4,16,4),
      child: Container(
          color: remarcable == 1?Colors.yellow:Colors.transparent,
          child: Row(
            children: <Widget>[
              Text(
                label,
                style: remarcable > 0
                ?Theme.of(context).primaryTextTheme.body2
                :Theme.of(context).primaryTextTheme.body1),
              Spacer(),
              Text(
                charge.toStringAsFixed(2),
                style: remarcable == 2
                ?Theme.of(context).primaryTextTheme.display1
                :Theme.of(context).primaryTextTheme.body1,
                )
            ],
          ),
    ));
  }

  Widget searchBox(){
    return Container(
      height: 48,
      child: TextField(
        keyboardType: TextInputType.text,
        style: Theme.of(context).primaryTextTheme.body1,
        cursorColor: Theme.of(context).primaryIconTheme.color,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: "Search Products",
          hintStyle: Theme.of(context).primaryTextTheme.body1,
          border: OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.circular(0)),
            ),
        onChanged: (searchValue) => {}, 
            autocorrect: false,
          ),
    );
        
  }
  
  Widget emptyCard(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add_box, color: Theme.of(context).primaryIconTheme.color, size: 70,),
            ),
            Text(
              'Your cart is empty',
              style: Theme.of(context).primaryTextTheme.title,
              ),
            Container(
              padding: EdgeInsets.fromLTRB(0,8,0,8),
              width: MediaQuery.of(context).size.width * 2/3,
              child: Text(
                "Seems like you haven't chosen what to buy...",
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.body1,
                )),
          ],
      ),
    );
  }

}