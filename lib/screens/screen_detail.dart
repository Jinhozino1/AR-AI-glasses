import 'package:flutter/material.dart';
import 'package:untitled/models/model_item.dart';
import 'package:untitled/models/model_auth.dart';
import 'package:untitled/models/model_cart.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as Item;
    final cart = Provider.of<CartProvider>(context);
    final authClient = Provider.of<FirebaseAuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title:
      Text(item.title,
          style: TextStyle(fontSize: 22,
              fontFamily: 'NanumGothic',
              fontWeight: FontWeight.w900)
      ),
      ),
      body: Container(
        child: ListView(

          children: [
            Image.network(item.imageUrl),
            Padding(
              padding: EdgeInsets.all(7),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Text(
                item.title,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.price.toString() + '원',
                      style: TextStyle(fontSize: 18, color: Colors.red,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.w900),
                      ),
                      Text('브랜드 : ' + item.brand,
                      style: TextStyle(fontSize: 16,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.w900),
                      ),
                      Text('등록일자 : ' + item.registerDate,
                      style: TextStyle(fontSize: 16,
                          fontFamily: 'NanumGothic',
                          fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      cart.addItemToCart(authClient.user, item);
                    }, // 장바구니 기능
                    child: Column(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                        Text('담기', style: TextStyle(color: Colors.blue,
                            fontFamily: 'NanumGothic',
                            fontWeight: FontWeight.w900),
                        )
                      ],
                    ),

                  )
                ],
              ),
            ),
            /*
            Container(
              padding: EdgeInsets.all(15),
              child: Text(item.description, style: TextStyle(fontSize: 16,
                  fontFamily: 'NanumGothic',
                  fontWeight: FontWeight.w900)),
            ),*/
          ],
        ),
      ),
    );
  }
}