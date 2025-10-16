class ProductModel {
  late String id;
  late String name;
  late int code;
  late int quantity;
  late int unitprize;
  late String image;
  late int totalprize;

  ProductModel.fromJson(Map<String, dynamic> productJson) {
    id = productJson['_id'];
    name = productJson['ProductName'];
    code = productJson['ProductCode'];
    image = productJson['Img'];
    quantity = productJson['Qty'];
    unitprize = productJson['UnitPrice'];
    totalprize = productJson['TotalPrice'];
  }
}
