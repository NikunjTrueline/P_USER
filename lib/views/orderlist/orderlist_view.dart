import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../../firebase/firebase_service.dart';
import '../../model/order.dart';
import '../../widget/custom_button.dart';
// Update this with the path to your Order model

class OrderListView extends StatefulWidget {
  @override
  _OrderListViewState createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Items',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blueAccent.shade100,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<List<Order>>(
        stream: FirebaseService().orderStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading orders'));
          }

          List<Order> orders = snapshot.data ?? [];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              Order order = orders[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await FirebaseService()
                                        .removeUserOrder(order.orderId!);
                                  },
                                  icon: Icon(Icons.delete)),
                              // Spacer(),
                              IconButton(
                                onPressed: () async {
                                  List<Map<dynamic, dynamic>> productList =
                                      order.items!.map((e) {
                                    return {
                                      "id": e.id,
                                      "name": e.name,
                                      "description": e.description,
                                      "price": e.price,
                                      "unit": e.unit,
                                      // "imageUrl": e.imageUrl,
                                      "quantity": e.quantity,
                                      "totalPrice": e.totalPrice,
                                      // "createdAt": e.createdAt,
                                    };
                                  }).toList();
                                  // log("productList :: ${productList}");
                                  Map<String, dynamic> invoiceBody = {
                                    "totoalAmount": order.totalPrice.toString(),
                                    "productList": jsonEncode(productList),
                                    "orderDate":
                                        formatMilliseconds(order.orderDate!),
                                    "orderId": order.orderId,
                                    "shippingAddress":
                                        "${order.shippingAddress?.address} ${order.shippingAddress?.addressLine1} ${order.shippingAddress?.addressLine2} ${order.shippingAddress?.city} ${order.shippingAddress?.pincode} ${order.shippingAddress?.state}",
                                    "paymentId": order.paymentId
                                  };
                                  log("invoiceBody :: ${invoiceBody}");
                                  String apiUrl =
                                      "http://165.232.189.4:8085/downloadinvoice";
                                  log("apiUrl :: ${apiUrl}");
                                  final response = await post(Uri.parse(apiUrl),
                                      body: invoiceBody,
                                      headers: {
                                        'Accept': 'application/json',
                                        "Connection": "Keep-Alive",
                                      });
                                  final value = jsonDecode(response.body);
                                  log("jsonDecode(response.body :: ${value}");
                                  final filename =
                                      value["data"]["filename"] ?? "";
                                  final filenamee = value["data"]["url"] ?? "";
                                  log("filenamefilename :: ${filename}");
                                  log("filenameefilenamee :: ${filenamee}");
                                  await downloadFileAtAnyLocation(
                                      filenamee, filename, "Product Invoice");
                                },
                                icon: Icon(Icons.download),
                              )
                            ],
                          ),
                          Text(
                            'Order ID: ${order.orderId}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              'User ID : ${order.userId}\nPayment ID : ${order.paymentId}\nTotal Price : ${order.totalPrice}\nStatus: ${order.status}\nShpping Address : ${order.shippingAddress!.address}, ${order.shippingAddress!.addressLine1}, ${order.shippingAddress!.addressLine2}, ${order.shippingAddress!.city}, ${order.shippingAddress!.pincode}, ${order.shippingAddress!.state}\nOrder Date : ${formatMilliseconds(order.orderDate!)}'),
                        ],
                      ),
                    )),
              );
            },
          );
        },
      ),
    );
  }

  String formatMilliseconds(int milliseconds) {
    // Convert the milliseconds to a DateTime object
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

    // Create a DateFormat object with the desired format
    DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm:ss');

    // Format the DateTime object to a string
    return formatter.format(dateTime);
  }

  void showUpdateStatusDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Order Status"),
          content: Text("Do you want to mark this order as delivered?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Done"),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}

/*
ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text('Order ID: ${order.orderId}', style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle:
                ),
 */
