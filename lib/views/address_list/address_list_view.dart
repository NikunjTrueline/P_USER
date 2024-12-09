import 'package:flutter/material.dart';
import 'package:grocery_app_user/constants/constants.dart';
import 'package:grocery_app_user/firebase/firebase_service.dart';
import 'package:grocery_app_user/model/order.dart';
import 'package:grocery_app_user/model/order_data.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../model/address.dart';
import '../../model/user_data.dart';

class ListAddressesPage extends StatefulWidget {
  OrderData data;

  ListAddressesPage({required this.data});

  @override
  _ListAddressesPageState createState() => _ListAddressesPageState();
}

class _ListAddressesPageState extends State<ListAddressesPage> {
  late Razorpay _razorpay;
  late UserData userData;
  late BuildContext _context;

  void openCheckOut(OrderData data) {
    FirebaseService().getUserData().then((user) {
      if (user != null) {
        userData = user;
        var options = {
          'key':
              'rzp_test_GRG9Wu7rbgyIbE', // Replace with your Razorpay API key
          'amount': data.totalAmount! *
              100, // Razorpay takes the amount in the smallest currency unit (e.g., paise for INR)
          'name': 'Pharmacy Management',
          'prefill': {
            'contact': '${user.contact}',
            'email': '${user.email != null ? user.email : 'test@gmail.com'}'
          },
          'external': {
            'wallets': ['paytm']
          }
        };

        try {
          _razorpay.open(options);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _storeOrderDetails(String paymentId, OrderData data) {
    Order order = Order(
      items: data.cartItems,
      orderDate: DateTime.now().millisecondsSinceEpoch,
      paymentId: paymentId,
      shippingAddress: data.address,
      status: 'pending',
      totalPrice: data.totalAmount,
      userId: userData.id,
    );

    FirebaseService().placeOrder(order).then((value) {
      ScaffoldMessenger.of(_context)
          .showSnackBar(SnackBar(content: Text('Order placed successfully')));
      // Navigator.popUntil(_context, ModalRoute.withName(AppConstant.checkoutView));
      Navigator.pushNamedAndRemoveUntil(
          context, AppConstant.dashboardView, (route) => false);
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment here
    final String paymentId = response.paymentId!;
    _storeOrderDetails(
        paymentId, widget.data); // Custom function to store order details
    print('payment id : $paymentId');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error here
    final String code = response.code.toString();
    final String message = response.message!;
    ScaffoldMessenger.of(_context)
        .showSnackBar(SnackBar(content: Text(message)));
    // Show an error message or handle it as needed
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payments
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Select Address',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.blueAccent.shade100,
      ),
      body: StreamBuilder<List<Address>>(
        stream: FirebaseService().getAddressStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No addresses added."));
          }

          return Padding(
            padding: EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Address address = snapshot.data![index];
                return Card(
                    elevation: 3,
                    color: Colors.blue.shade50,
                    child: FutureBuilder(
                      future: FirebaseService().getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var userData = snapshot.data;
                          return ListTile(
                            onTap: () {
                              widget.data.address = address;
                              openCheckOut(widget.data);
                            },
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            title: Text(
                              "${userData!.name} ",
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(
                              "${address.address}, ${address.addressLine1} , ${address.addressLine2} ,\n ${address.city} , ${address.state}  ${address.pincode} ",
                              maxLines: 5,
                            ),
                            // Additional logic for editing or deleting addresses could be added here
                          );
                        } else {
                          return Center(
                            child: Container(),
                          );
                        }
                      },
                    ));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstant.addressView);
          /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAddressPage(userId: widget.userId)),
          );*/
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent.shade100,
        tooltip: 'Add Address',
      ),
    );
  }
}
