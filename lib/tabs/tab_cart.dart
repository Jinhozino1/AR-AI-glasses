import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/models/model_cart.dart';
import 'package:untitled/models/model_auth.dart';

class CartTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   final cart = Provider.of<CartProvider>(context);
   final authClient = Provider.of<FirebaseAuthProvider>(context);
   return FutureBuilder(
       future: cart.fetchCartItemsOrAddCart(authClient.user),
       builder: (context, snapshot) {
         if(cart.cartItems.length == 0) {
           return Center(
             child: Text('등록된 상품이 없습니다.',
                 style: TextStyle(fontSize: 16,
                 fontFamily: 'NanumGothic',
                 fontWeight: FontWeight.w800)
             ),
           );
         }
         else {
           return ListView.builder(
               shrinkWrap: true,
             itemCount: cart.cartItems.length,
               itemBuilder: (context, index) {
               return Expanded(
                 child: ListTile(

                   onTap: () {
                     Navigator.pushNamed(context, '/detail',
                     arguments: cart.cartItems[index]);
                   },
                   title: Text(cart.cartItems[index].title),
                   subtitle: Text(cart.cartItems[index].price.toString()),
                   leading: Image.network(cart.cartItems[index].imageUrl),
                   trailing: InkWell(
                     onTap: () {
                       cart.removeItemFromCart(
                         authClient.user, cart.cartItems[index]);
                     },
                     child: Icon(Icons.delete),
                   ),
                 ),
               );
             }
           );

         }

       }
   );
  }
}