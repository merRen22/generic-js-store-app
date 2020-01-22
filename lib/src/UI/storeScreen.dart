
import 'package:flutter/material.dart';
import 'package:generic_store_app/src/Models/Order.dart';
import 'package:generic_store_app/src/Models/Products.dart';
import 'package:generic_store_app/src/UI/orderCompleteScreen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../Utils/customIcons.dart.dart';

class StoreScreen extends StatefulWidget {

  const StoreScreen({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>{

  List productos = List<Product>();
  Order order = Order();
  String shipDate;
  DateTime date;
  String searchText = "";
  bool loadingRequest = false;
  TextEditingController textEditingController = TextEditingController();
  
  final String query = r"""
    query GetProductsByName($name: String!){
      getProductsByName(name:$name){
        id
        name
        coverUrl
        price
      }
    }
  """;

  String addOrder = r"""
  mutation CreateOrder($order: OrderInput!){
    createOrder(
      input: $order){
      id
    }
  }
  """;

  void calculateDate(){
    if(DateTime.now().weekday >= DateTime.friday){
      var monday = 1;
      DateTime nextMonday = DateTime.now();
      
      //Adds dates until next monday is found
      while(nextMonday.weekday!=monday)
      {
        nextMonday=nextMonday.add(Duration(days:1));
      }

      //finds the difference between actual date and monday so it can be added to shipping date
      date = DateTime.now().add(
        Duration(days: DateTime.now().difference(nextMonday).inDays)
      );
    }else{
      date = DateTime.now().add(Duration(days: 1));
    }
    
    shipDate = "${date.day}/${date.month}/${date.year}"; 
  }

  @override
  void initState() {
    super.initState();
    calculateDate();
  }

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
        body: loadingRequest
        ?Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).iconTheme.color),
                    ),
            ],
          ),
        )
        :Column(
          children: <Widget>[
            Expanded(
              child:  (productos.isEmpty && searchText.isEmpty) || searchText.isEmpty
              ? productos.isEmpty
                ?emptyCard()
                :ListView.builder(
                  shrinkWrap: true,
                  itemCount: productos.length,
                  itemBuilder: (ctx,productIndex){
                    return productCard(productos[productIndex],true);
                  },
                )
              :
        Query(
          options: QueryOptions(document: query, variables: <String, dynamic>{"name": searchText}),
          builder: (QueryResult result, {VoidCallback refetch,FetchMore fetchMore,}) {
            if(result.loading){
              return Center(child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(Theme.of(context).iconTheme.color),
              ),);
            }
            if(result.data == null || result.data['getProductsByName'].length == 0){
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "We don't have any product with the given name at the moment",
                    style: Theme.of(context).textTheme.body1,
                    textAlign: TextAlign.center,
                    ),
                ));
            }
            /*
            return ListView.builder(
                shrinkWrap: true,
                itemCount: productos.length,
                itemBuilder: (ctx,productIndex){
                  return productCard(productos[productIndex]);
                },
              );
              */
            return ListView.builder(
                shrinkWrap: true,
                itemCount: result.data['getProductsByName'].length,
                itemBuilder: (ctx,productIndex){
                  return productCard(
                    Product.fromGraph(result.data['getProductsByName'][productIndex]),false);
                },
              );
        })
            ),
            orderCard()
          ],
        )
        ));
  }

  Widget productCard(Product producto, bool isInCart){
    return Container(
      height: isInCart?212:106,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.network(producto.coverUrl,height: 74,fit:BoxFit.fitHeight),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(producto.name ,style: Theme.of(context).primaryTextTheme.body1),
                    SizedBox(height: 18,),
                    Text(producto.price.toStringAsFixed(2) + r' $',style: Theme.of(context).primaryTextTheme.display1,),
                  ],
                ),
              ),
              Spacer(),
              Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      if(!isInCart){
                        textEditingController.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                        productos.add(producto);
                        order.totalProductsPrice = producto.price *10;
                        setState(() {searchText = "";});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, 
                        color: Theme.of(context).iconTheme.color),
                      child: isInCart
                      ?Container(
                        padding: EdgeInsets.all(20),
                        child: Text("1",style: Theme.of(context).primaryTextTheme.display3))
                      :Icon(Icons.add, color: Colors.white,size: 48),
                    ),
                  ),
                 if(isInCart) 
                 GestureDetector(
                   onTap: () {
                     order.totalProductsPrice -= producto.price * producto.quantity;
                     setState(() {productos.remove(producto);});
                   },
                   child: Padding(
                     padding: const EdgeInsets.all(6.0),
                     child: Text("delete",style: Theme.of(context).primaryTextTheme.body1),
                   ),          
                )
                ],
              ),
            ],
          ),
          if(isInCart)
          Expanded(child: selectProductQuantity(producto)),
        ],
      ),
    );
  }

  Widget selectProductQuantity(producto){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 180,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.0),
                topRight: Radius.circular( 6.0),
                bottomLeft: Radius.circular( 6.0),
                bottomRight: Radius.circular( 6.0)
            ),
            color: Theme.of(context).iconTheme.color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon:Icon(Icons.remove,color:Colors.white),
                onPressed: () { 
                  if(producto.quantity > 0){
                    setState(() {
                      order.totalProductsPrice -= (10 * producto.price);
                      producto.quantity -= 10;
                    });
                  }
                 },
                ),
              Text(producto.quantity.toString(), style: Theme.of(context).primaryTextTheme.display3,),
              IconButton(
                icon:Icon(Icons.add,color:Colors.white),
                onPressed: () { 
                    setState(() {
                      order.totalProductsPrice += (10 * producto.price);
                      producto.quantity += 10;
                    });
                 },
                ),
            ],
          ),
        )
      ],
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
              Icon(CustomIcons.ic_car ,color: Theme.of(context).accentIconTheme.color),
              SizedBox(width: 12,),
              RichText(
                          text: TextSpan(
                            style: Theme.of(context).primaryTextTheme.body1,
                            children: [
                            TextSpan(text: "Buy now and get it by "),
                            TextSpan(text: shipDate, style: Theme.of(context).primaryTextTheme.body2)
                          ]),
                        ),
            ],
          ),
        ),
        orderDetaildRow("Products",order.totalProductsPrice,0),
        orderDetaildRow("Shipping Cost",order.totalProductsPrice * 0.10,1),
        orderDetaildRow("Taxes",(order.totalProductsPrice)* 0.18,0),
        orderDetaildRow("Total",order.totalProductsPrice * 1.10,2),
        Container(
          height: 64,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Mutation(
            options: MutationOptions(documentNode: gql(addOrder),
            update: (Cache cache, QueryResult result) {return cache;},
            onCompleted: (dynamic resultData) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return OrderCompleteScreen(id: int.parse(resultData['createOrder']['id']));})).then((v){
                    setState(() {  
                      order = Order();
                      productos = List();
                      searchText = "";
                      textEditingController.clear();
                      loadingRequest = false;
                      });
                  });
            }),
            builder: (RunMutation runMutation,QueryResult result) {
              return FlatButton(
                      onPressed: () {
                        if(productos.isNotEmpty){
                          order.products = productos;
                          order.deliveryDate = date;
                          setState(() {
                            loadingRequest = true;
                          });
                          runMutation(order.toJson());
                        }
                          },
                      child: Text(
                        "COMPLETE ORDER",
                        style: productos.isEmpty
                        ?Theme.of(context).primaryTextTheme.display2
                        :Theme.of(context).primaryTextTheme.display3
                        ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0),),
                      color: productos.isEmpty
                          ? Colors.transparent
                          : Theme.of(context).iconTheme.color,
                    );
            }))
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
                charge.toStringAsFixed(2) + (remarcable == 1?r" $":""),
                style: remarcable == 2
                ?Theme.of(context).primaryTextTheme.display1
                :Theme.of(context).primaryTextTheme.body1
                )
            ],
          ),
    ));
  }

  Widget searchBox(){
    return Container(
      height: 48,
      child: TextField(
        controller: textEditingController,
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
        onChanged: (searchValue) {
          setState(() {searchText = searchValue;});
        }, 
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
              padding: const EdgeInsets.fromLTRB(8,8,8,20),
              child: Icon(CustomIcons.ic_basket, color: Theme.of(context).primaryIconTheme.color, size: 70,),
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