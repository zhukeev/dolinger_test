import 'dart:collection';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'model/product.dart';

class SecondPage extends StatefulWidget {
  final String imageUrl;
  final int additionallyQuntity;
  SecondPage(
      {Key key, @required this.imageUrl, @required this.additionallyQuntity})
      : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Map<Product, int> productsHashMap = HashMap();

  @override
  void initState() {
    super.initState();

    Random rnd = new Random();
    final int min = 5, max = 99;

    productsHashMap = Map.fromIterable(
        List.generate(
            widget.additionallyQuntity,
            (index) => Product(
                price: min + rnd.nextInt(max - min),
                image: widget.imageUrl,
                title: 'Product${index + 1}')),
        value: (_) => 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: CachedNetworkImage(
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Произвольный текст как заголовок',
                  style: Theme.of(context).textTheme.headline4),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.all(16),
              color: Color(0xFFF8F8F8).withRed(240),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
                  Text('Дополнительно ',
                      style: Theme.of(context).textTheme.headline5),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget?.additionallyQuntity ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (_, i) => ProductItem(
                            product: productsHashMap.keys.elementAt(i),
                            onQuantityChanged: (int value) {
                              final prod =
                                  productsHashMap.entries.elementAt(i).key;
                              setState(() {
                                productsHashMap[prod] = value;
                              });
                            },
                          )),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.maxFinite,
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: DottedDecoration(
                  shape: Shape.box, linePosition: LinePosition.top),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Дополнительно'),
                  Text(
                      'x${productsHashMap.values.fold(0, (previousValue, current) => previousValue + current)}  ${productsHashMap.entries.map((e) => e.key.price * e.value).toList().fold(0, (previousValue, current) => previousValue + current)} р.'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatefulWidget {
  final Product product;
  final ValueChanged<int> onQuantityChanged;
  ProductItem(
      {Key key, @required this.product, @required this.onQuantityChanged})
      : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: [
          CachedNetworkImage(
              height: 50, width: 50, imageUrl: widget.product.image),
          SizedBox(width: 8),
          Flexible(
              fit: FlexFit.tight,
              child: Text(widget.product.title, maxLines: 3)),
          SizedBox(
            width: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    height: 25,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: 50,
                    decoration: BoxDecoration(
                        color: Color(0xFFEEF3F4).withOpacity(.5),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: RaisedButton(
                            padding: const EdgeInsets.all(0),
                            color: Color(0xFFEEF3F4),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: () {
                              if (quantity >= 1) {
                                setState(() {
                                  quantity--;
                                  widget.onQuantityChanged(quantity);
                                });
                              }
                            },
                            child: Center(child: Icon(Icons.remove, size: 15))),
                      ),
                      Text(quantity.toString()),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: RaisedButton(
                            padding: const EdgeInsets.all(0),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: () {
                              if (quantity < 20) {
                                setState(() {
                                  quantity++;
                                  widget.onQuantityChanged(quantity);
                                });
                              }
                            },
                            child: Center(child: Icon(Icons.add, size: 15))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            '+${widget.product.price} р.',
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
