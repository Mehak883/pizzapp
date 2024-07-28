// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pizza_app/HomeScreen/RestaurantProvider.dart';
import 'package:pizza_app/main.dart';
import 'package:provider/provider.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    var restProvider = Provider.of<RestProvider>(context);
    var favouriteRestaurants = restProvider.getFavourites();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Your ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: 'Favourites',
                      style: TextStyle(
                        color: MyApp.reddish,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              favouriteRestaurants.isEmpty
                  ? Column(
                      children: [
                        Image.asset('assets/boy.png', width: 600, height: 400),
                        const Text('Your Wishlist is empty?',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600)),
                      ],
                    )
                  : Column(
                    children: [
                      const SizedBox(height: 20,),
                      SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: favouriteRestaurants.length,
                            itemBuilder: (context, index) {
                              var restaurant = favouriteRestaurants[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: 120,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                            child: Image.asset(
                                              restaurant[2],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -5,
                                          right: -7,
                                          child: Consumer<RestProvider>(
                                            builder: (context, value, child) {
                                              return IconButton(
                                                onPressed: () {
                                                  value.remFav(restaurant[0]);
                                                },
                                                icon: const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    restaurant[1],
                                    style: const TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: const RoundedRectangleBorder(side: BorderSide(color: MyApp.reddish),borderRadius: BorderRadius.all(Radius.circular(10)))), child: const Row(children: [Icon(Icons.shopping_cart_outlined),Text('  Buy Now',style: TextStyle(color: Colors.black),)],))],),
                        )
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
