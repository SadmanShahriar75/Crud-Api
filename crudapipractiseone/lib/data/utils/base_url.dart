class Urls {
  static const String _baseurl = 'http://35.73.30.144:2008/api/v1';
  static const String getProductUrl = '$_baseurl/ReadProduct';
  static const String postProductUrl = '$_baseurl/CreateProduct';

  static String deleteProductsUrl(String id) => '$_baseurl/DeleteProduct/$id';

  static String updateProductUrl(String id) => '$_baseurl/UpdateProduct/$id';
}
