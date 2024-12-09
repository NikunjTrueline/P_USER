import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:grocery_app_user/model/item.dart';
import 'package:grocery_app_user/widget/custom_button.dart';
import '../../firebase/firebase_service.dart';

class ItemDetailView extends StatefulWidget {
  final Item item;

  ItemDetailView({required this.item});

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  ValueNotifier<int> _quantity = ValueNotifier<int>(1); // Start with quantity 1


  @override
  void initState() {


    super.initState();
  }

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  void _addToCart() {
    // Assuming FirebaseService is initialized with a userId somewhere in your app
    FirebaseService firebaseService = FirebaseService();

    firebaseService.addToCart(widget.item, _quantity.value).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to cart successfully',style: TextStyle(color: Colors.white)),backgroundColor: Colors.blueAccent,),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart')),
      );
    });
  }

  double _userRating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Hero(
                    tag: 'imageHero${widget.item.id}',
                    child: Image.network(widget.item.imageUrl)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: FirebaseService().getFavoriteNotifier(widget.item.id!),
                  builder: (context, isFavorite, _) {
                    return InkWell(
                      onTap: () => FirebaseService().toggleFavorite(widget.item.id!),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '${widget.item.price} /${widget.item.unit}',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FloatingActionButton(
                        heroTag: 'decreaseButton${widget.item.id}',
                        onPressed: () {
                          if (_quantity.value > 1) {
                            _quantity.value--;
                          }
                        },
                        child: Icon(Icons.remove),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent,
                        mini: true,
                      ),
                      SizedBox(width: 16),
                      ValueListenableBuilder<int>(
                        valueListenable: _quantity,
                        builder: (context, value, child) => Text(
                          '$value',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 16),
                      FloatingActionButton(
                        heroTag: 'increaseButton${widget.item.id}',
                        onPressed: () {
                          _quantity.value++;
                        },
                        child: Icon(Icons.add),
                        mini: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _quantity,
                  builder: (context, value, child) => Text(
                    'Rs. ${(widget.item.price * value).toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Description',
              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.item.description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text("Company Name : ${widget.item.companyName}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "Batch No : ${widget.item.batchNumber}"
              ,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "Manufacturing Date : ${widget.item.manufacturingDate}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              "Expiry Date : ${widget.item.expiryDate}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            StreamBuilder(
                stream: FirebaseService().ratingStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    var item = snapshot.data ?? [];

                    for (int i = 0; i < item.length; i++) {
                      if (widget.item.id == item[i].productId) {
                        _userRating = item[i].rating.toDouble();
                      }
                    }

                    return RatingBar.builder(
                      initialRating: _userRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.blueAccent,
                      ),
                      onRatingUpdate: (rating) {
                        _userRating = rating;
                        FirebaseService().submitRating(
                            _userRating.toDouble() + 0.1 - 0.2, widget.item.id!);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error : ${snapshot.error}"),
                    );
                  } else {
                    return Container();
                  }
                },
                ),

          ],
        ),
      ),
      bottomSheet: Container(
        margin: EdgeInsets.all(16),
        child: CustomButton(
          backgroundColor: Colors.blueAccent,
          title: 'Add to Cart',
          foregroundColor: Colors.white,
          callback: _addToCart,
        ),
      ),
    );
  }
}

/*
Text(
              widget.item.description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              widget.item.batchNo,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              widget.item.companyName,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              widget.item.manufactureDate,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              widget.item.expiryDate,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
 */