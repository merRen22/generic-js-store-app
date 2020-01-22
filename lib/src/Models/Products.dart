class Product {
  int id,quantity;
  String name, coverUrl;
  double price;

  Product();

  factory Product.fromGraph(data) {
    Product res = Product();

    res.id = int.parse(data['id']) ;
    res.price = double.parse(data['price'].toString()) ;
    res.name = data['name'];
    res.quantity = 10;
    res.coverUrl = data['coverUrl'];

    return res;
  }
  
  Map<String, dynamic> toJson() =>{
    "price": price,
    "idProduct": id
  };

}
