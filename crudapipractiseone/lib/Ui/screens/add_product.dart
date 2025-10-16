import 'package:crudapipractiseone/data/service/api_caller.dart';
import 'package:crudapipractiseone/data/utils/base_url.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool _postinprogress = false;
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _codecontroller = TextEditingController();
  final TextEditingController _quantitycontroller = TextEditingController();
  final TextEditingController _unitprizecontroller = TextEditingController();
  final TextEditingController _imagecontroller = TextEditingController();
  final GlobalKey<FormState> _fromkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 238, 219),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 238, 219),
        title: const Text("Add Product"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _fromkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildTextField(
                controller: _namecontroller,
                label: 'Product Name',
                hint: 'Enter product name',
                icon: Icons.shopping_bag_outlined,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a product name'
                    : null,
              ),

              _buildTextField(
                controller: _codecontroller,
                label: 'Product Code',
                hint: 'Numeric product code',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Please enter a product code';
                  return int.tryParse(v.trim()) == null
                      ? 'Enter a valid number'
                      : null;
                },
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _quantitycontroller,
                      label: 'Quantity',
                      hint: 'e.g. 10',
                      icon: Icons.format_list_numbered,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Please enter quantity';
                        return int.tryParse(v.trim()) == null
                            ? 'Enter a valid integer'
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _unitprizecontroller,
                      label: 'Unit Price',
                      hint: 'e.g. 100',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Please enter unit price';
                        return int.tryParse(v.trim()) == null
                            ? 'Enter a valid integer'
                            : null;
                      },
                    ),
                  ),
                ],
              ),

              _buildTextField(
                controller: _imagecontroller,
                label: 'Image URL',
                hint: 'Optional - image url',
                icon: Icons.image_outlined,
                keyboardType: TextInputType.url,
                validator: (v) => null,
              ),

              const SizedBox(height: 24),

              Visibility(
                visible: _postinprogress == false,
                replacement: const Center(child: CircularProgressIndicator()),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      if (_fromkey.currentState!.validate()) {
                        _addPostProduct();
                      }
                    },
                    child: const Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey[700]) : null,
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 12.0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }

  // api part post
  Future<void> addProduct() async {
    if (_fromkey.currentState!.validate()) {
      _addPostProduct();
    }
  }

  // post api..
  Future<void> _addPostProduct() async {
    _postinprogress = true;
    setState(() {});

    // data pre
    int total =
        int.parse(_quantitycontroller.text) *
        int.parse(_unitprizecontroller.text);

    Map<String, dynamic> requestBody = {
      "ProductName": _namecontroller.text.trim(),
      "ProductCode": int.parse(_codecontroller.text.trim()),
      "Img": _imagecontroller.text,
      "Qty": int.parse(_quantitycontroller.text.trim()),
      "UnitPrice": int.parse(_unitprizecontroller.text.trim()),
      "TotalPrice": total,
    };

    ApiResponse response = await ApiCaller.postRequest(
      url: Urls.postProductUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      _clearTextFields();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('successfully added prodect')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('unsuccessfully ')));
    }

    _postinprogress = false;
    setState(() {});
  }

  void _clearTextFields() {
    _namecontroller.clear();
    _codecontroller.clear();
    _quantitycontroller.clear();
    _unitprizecontroller.clear();
    _imagecontroller.clear();
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _codecontroller.dispose();
    _quantitycontroller.dispose();
    _unitprizecontroller.dispose();
    _imagecontroller.dispose();
    super.dispose();
  }
}
