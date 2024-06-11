import 'package:flutter/material.dart';
import 'package:untitled/models/model_item_provider.dart';
//import 'package:untitled/models/model_item.dart';
import 'package:provider/provider.dart';


class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    return FutureBuilder(
      future: itemProvider.fetchItems(),
      builder: (context, snapshot) {
        if(itemProvider.items.length == 0) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          return Container(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 2.3,
                  ),
                  itemCount: itemProvider.items.length,
                  itemBuilder: (context, index) {
                    return GridTile(
                      child: Container(
                        margin: EdgeInsets.all(7),

                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.pushNamed(context, '/detail',
                                arguments: itemProvider.items[index]);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(itemProvider.items[index].imageUrl,
                                  width: 400,
                                  height: 200,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(itemProvider.items[index].title,
                                  style: TextStyle(fontSize: 15,
                                      fontFamily: 'NanumGothic',
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(itemProvider.items[index].price.toString() + '원',
                                  style: TextStyle(fontSize: 16, color: Colors.red,
                                      fontFamily: 'NanumGothic',
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  width: 60,
                                  height: 60,

                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(itemProvider.items[index].imageUrl),
                                    child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(100),

                                        onTap: () {
                                          if(itemProvider.items[index].keyNumber == 1)
                                            Navigator.pushNamed(context, '/effect1');
                                          else if(itemProvider.items[index].keyNumber == 2)
                                            Navigator.pushNamed(context, '/effect2');
                                          else if(itemProvider.items[index].keyNumber == 3)
                                            Navigator.pushNamed(context, '/effect3');
                                          else if(itemProvider.items[index].keyNumber == 4)
                                            Navigator.pushNamed(context, '/effect4');
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    );
                  }
              ),
          );

        }
      },
    );
  }
}