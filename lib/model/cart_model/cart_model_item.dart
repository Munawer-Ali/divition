class CartModel {
  int id = 0;
  int quantity=0;
  int price=0;
  int subtotal=0;
  String image='';
  String name="";
  int totalQuantity=0;


  CartModel(
      {required this.id,
        required this.quantity,
        required this.price,
        required this.subtotal,
        required this.image,
        required this.name,
        required this.totalQuantity});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    price = json['price'];
    subtotal = json['subtotal'];
    image = json['image'];
    name = json['name'];
    totalQuantity = json['total_quantity'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id']=this.id;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['subtotal'] = this.subtotal;
    data['image'] = this.image;
    data['name'] = this.name;
    data['total_quantity'] = this.totalQuantity;
    return data;
  }
}