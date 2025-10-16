import 'package:crudapipractiseone/data/model/product_model.dart';
import 'package:crudapipractiseone/Ui/screens/update_screen.dart';
import 'package:crudapipractiseone/data/service/api_caller.dart';
import 'package:crudapipractiseone/data/utils/base_url.dart';
import 'package:flutter/material.dart';

class itemproduct extends StatefulWidget {
  const itemproduct({
    super.key,
    required this.product,
    required this.refreshproductList,
  });

  final ProductModel product;
  final VoidCallback refreshproductList;

  @override
  State<itemproduct> createState() => _itemproductState();
}

class _itemproductState extends State<itemproduct> {
  bool _deleteinprogress = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 218, 241, 176),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Image.network(
                  widget.product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 36,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Code: ${widget.product.code}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Unit: ${widget.product.unitprize}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Total: ${widget.product.totalprize}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Visibility(
              visible: _deleteinprogress == false,
              replacement: const SizedBox(
                width: 36,
                height: 36,
                child: Center(child: CircularProgressIndicator()),
              ),
              child: PopupMenuButton<ProductOption>(
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: ProductOption.update,
                      child: Text("Update"),
                    ),
                    PopupMenuItem(
                      value: ProductOption.delete,
                      child: Text("Delete"),
                    ),
                  ];
                },
                onSelected: (ProductOption seletedoption) {
                  if (seletedoption == ProductOption.delete) {
                    _deleteproductlist();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateProductScreen(product: widget.product),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteproductlist() async {
    _deleteinprogress = true;
    setState(() {});

    ApiResponse response = await ApiCaller.getRequest(
      url: Urls.deleteProductsUrl(widget.product.id),
    );

    if (response.isSuccess) {
      widget.refreshproductList();
    }

    _deleteinprogress = false;
    setState(() {});
  }
}

enum ProductOption { update, delete }
