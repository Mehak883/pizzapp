import 'package:flutter/material.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:pizza_app/HomeScreen/RestaurantProvider.dart';
import 'package:pizza_app/main.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var restProvider = Provider.of<RestProvider>(context, listen: false);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search your favourite food',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Our ',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w500), // Set the color for "Our"
                  ),
                  TextSpan(
                    text: 'offer',
                    style: TextStyle(
                        color: MyApp.reddish,
                        fontSize: 25,
                        fontWeight:
                            FontWeight.w500), // Set the color for "offer"
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              loremIpsum(
                  words: 14,
                  initWithLorem:
                      true), // Generates 20 words of Lorem Ipsum text
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 270,
                child: Stack(
                  children: [
                    Container(
                      height: 210,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: MyApp.reddish,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, top: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PIZZA',
                              style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              width: 130,
                              child: Text(
                                loremIpsum(words: 8),
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              width: 120,
                              height: 30,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber[300]),
                                child: const Text(
                                  'Order Now',
                                  style: TextStyle(
                                      color: MyApp.reddish,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        left: MediaQuery.of(context).size.width - 180,
                        child: Container(
                          width: 65,
                          height: 100,
                          color: const Color.fromARGB(255, 241, 214, 124),
                        )),
                    Positioned(
                        left: MediaQuery.of(context).size.width - 230,
                        top : 25,
                        child: Image.asset(
                          'assets/pizza.png',
                          width: 180,
                        )),
                  ],
                )),
            Row(
              children: [
                const Text(
                  'Top Restaurant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text('View All',
                          style: TextStyle(
                              color: MyApp.reddish,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_drop_down,
                  color: MyApp.reddish,
                  size: 30,
                )
              ],
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset(
                                    restProvider.topRestList[index][2],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: -5,
                                  right: -7,
                                  child: Consumer<RestProvider>(
                                    builder: (context,value,child) {
                                      return IconButton(
                                          onPressed: () {
                                         if (value.favourite.contains(
                                                restProvider.topRestList[index]
                                                    [0])) {
                                              value.remFav(value
                                                  .topRestList[index][0]);
                                            } else {
                                              value.addFav(value
                                                  .topRestList[index][0]);
                                            }
                                         
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: value.favourite.contains(
                                                    value.topRestList[index]
                                                        [0])
                                                ? Colors.red
                                                : Colors.white,
                                            size: 20,
                                          ));
                                    }
                                  ))
                            ],
                          )),
                      Text(
                        restProvider.topRestList[index][1],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      )
                    ],
                  );
                },
                itemCount: restProvider.topRestList.length,
              ),
            ),
            Row(
              children: [
                const Text(
                  'Near by Restaurant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Text('View All',
                          style: TextStyle(
                              color: MyApp.reddish,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_drop_down,
                  color: MyApp.reddish,
                  size: 30,
                )
              ],
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                  child: Image.asset(
                                    restProvider.nearRestList[index][2],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: -5,
                                  right: -7,
                                  child:Consumer<RestProvider>(
                                    builder: (context,value,child) {
                                      return IconButton(
                                          onPressed: () {
                                            if (value.favourite.contains(
                                                restProvider.nearRestList[index]
                                                    [0])) {
                                              value.remFav(value
                                                  .nearRestList[index][0]);
                                            } else {
                                              value.addFav(value
                                                  .nearRestList[index][0]);
                                            }
                                    
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: value.favourite.contains(
                                                    value.nearRestList[index]
                                                        [0])
                                                ? Colors.red
                                                : Colors.white,
                                            size: 20,
                                          ));
                                    }
                                  ))
                            ],
                          )),
                      Text(
                        restProvider.topRestList[index][1],
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      )
                    ],
                  );
                },
                itemCount: restProvider.nearRestList.length,
              ),
            )
          ],
        ),
      ),
    )));
  }
}
