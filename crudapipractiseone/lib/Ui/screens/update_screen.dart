import 'package:crudapipractiseone/data/model/product_model.dart';
import 'package:crudapipractiseone/data/service/api_caller.dart';
import 'package:crudapipractiseone/data/utils/base_url.dart';
import 'package:flutter/material.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final TextEditingController _unitpriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _imageUrlTEController = TextEditingController();

  bool _updatepostinprogress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.name;
    _codeTEController.text = widget.product.code.toString();
    _quantityTEController.text = widget.product.quantity.toString();
    _unitpriceTEController.text = widget.product.unitprize.toString();
    _imageUrlTEController.text = widget.product.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update product')),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              children: [
                TextFormField(
                  controller: _nameTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Product name',
                    labelText: 'Product name',
                  ),
                ),
                TextFormField(
                  controller: _codeTEController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Product code',
                    labelText: 'Product code',
                  ),
                ),
                TextFormField(
                  controller: _quantityTEController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                    labelText: 'Quantity',
                  ),
                ),
                TextFormField(
                  controller: _unitpriceTEController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Unit price',
                    labelText: 'Unit price',
                  ),
                ),
                TextFormField(
                  controller: _imageUrlTEController,
                  decoration: InputDecoration(
                    hintText: 'Image Url',
                    labelText: 'Image Url',
                  ),
                ),
                const SizedBox(height: 8),
                Visibility(
                  visible: _updatepostinprogress == false,
                  replacement: CircularProgressIndicator(),
                  child: FilledButton(
                    onPressed: updateProduct,
                    child: Text('Update'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateProduct() async {
    if (_formKey.currentState!.validate()) {
      _updatePostProduct();
    }
  }

  // post api..
  Future<void> _updatePostProduct() async {
    _updatepostinprogress = true;
    setState(() {});

    // data pre
    int total =
        int.parse(_quantityTEController.text) *
        int.parse(_unitpriceTEController.text);

    Map<String, dynamic> requestBody = {
      "ProductName": _nameTEController.text.trim(),
      "ProductCode": int.parse(_codeTEController.text.trim()),
      "Img": _imageUrlTEController.text,
      "Qty": int.parse(_quantityTEController.text.trim()),
      "UnitPrice": int.parse(_unitpriceTEController.text.trim()),
      "TotalPrice": total,
    };

    ApiResponse response = await ApiCaller.postRequest(
      url: Urls.updateProductUrl(widget.product.id),
      body: requestBody,
    );

    if (response.isSuccess) {
      // _clearTextFields();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('product update successfully')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('product update unsuccessfully ')));
    }

    _updatepostinprogress = false;
    setState(() {});
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _unitpriceTEController.dispose();
    _quantityTEController.dispose();
    _imageUrlTEController.dispose();
    _codeTEController.dispose();
    super.dispose();
  }
}
