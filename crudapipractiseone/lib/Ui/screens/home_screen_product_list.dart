import 'dart:convert';

import 'package:crudapipractiseone/data/model/product_model.dart';
import 'package:crudapipractiseone/Ui/screens/add_product.dart';
import 'package:crudapipractiseone/data/service/api_caller.dart';
import 'package:crudapipractiseone/data/utils/base_url.dart';

import 'package:crudapipractiseone/widgets/item_product.dart';
import 'package:flutter/material.dart';

class HomeCrud extends StatefulWidget {
  const HomeCrud({super.key});

  @override
  State<HomeCrud> createState() => _HomeCrudState();
}

class _HomeCrudState extends State<HomeCrud> {
  List<ProductModel> _productlist = [];
  bool _getinprogress = false;

  // get api....
  Future<void> _getProductList() async {
    _productlist.clear();
    _getinprogress = true;
    setState(() {});

    // map
    ApiResponse response = await ApiCaller.getRequest(url: Urls.getProductUrl);

    if (response.isSuccess) {
      final decodedproduct = response.responseData;

      for (Map<String, dynamic> proudctJosn in decodedproduct['data']) {
        final productModelall = ProductModel.fromJson(proudctJosn);

        _productlist.add(productModelall);
      }
    }

    _getinprogress = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 238, 219),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 226, 238, 219),
        title: const Text("Products"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _getProductList();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Visibility(
          visible: _getinprogress == false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: RefreshIndicator(
            onRefresh: _getProductList,
            child: _productlist.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 80),
                      Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    itemCount: _productlist.length,
                    itemBuilder: (context, index) {
                      return itemproduct(
                        product: _productlist[index],
                        refreshproductList: () {
                          _getProductList();
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8);
                    },
                  ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (contex) => AddProduct()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
