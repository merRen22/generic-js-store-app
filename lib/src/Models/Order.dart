class Order{
  int id;
  String name,coverUrl;
  double totalProductsPrice = 0.0,taxes = 0.0,shippingCost = 0.0;
  DateTime deliveryDate;
  List products;

  Order();

  getProdcutsJson(){
    List listMap =  List();
    products.forEach((f) => listMap.add( f.toJson()));
    return listMap;
  }

  Map<String, dynamic> toJson() =>{
    "order":{
        "totalPrice": totalProductsPrice,
        "taxes": totalProductsPrice*0.18,
        "shippingCost": totalProductsPrice*0.10,
        "deliveryDate": "${deliveryDate.year}-${deliveryDate.month}-${deliveryDate.day}",
        "products": getProdcutsJson()
    }
  };
}