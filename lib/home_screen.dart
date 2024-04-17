import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/pokemon_detail_screen.dart';
import 'dart:convert';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var pokeApi = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  late List<dynamic> pokedex = [];

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -20,
            right: -50,
            child: Image.asset('images/pokeball.png', width: 200, fit: BoxFit.fitWidth,),
          ),
          const Positioned(
            top: 80,
            left: 20,
            child: Text(
              "Pokedex",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Positioned(
            top: 150,
            bottom: 0,
            width: width,
            child: Column(
              children: [
                Expanded(
                  child: pokedex.isNotEmpty
                      ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: pokedex.length,
                    itemBuilder: (context, index) {
                      var type = pokedex[index]['type'][0];
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: type == 'Grass' ? Colors.greenAccent : type == "Fire" ? Colors.redAccent : type == "Water" ? Colors.blue
                                  : type == "Electric" ? Colors.yellow : type == "Rock" ? Colors.grey : type == "Ground" ? Colors.brown
                                  : type == "Psychic" ? Colors.indigo : type == "Fighting" ? Colors.orange : type == "Bug" ? Colors.lightGreenAccent
                                  : type == "Ghost" ? Colors.deepPurple : type == "Normal" ? Colors.black26 : type == 'Poison' ? Colors.deepPurpleAccent : Colors.pink,
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: -10,
                                  left: 95,
                                  child: Image.asset(
                                    'images/pokeball.png',
                                    width: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: -3,
                                  child: Row(
                                    // Nombre del Pokémon y tipo alineados verticalmente
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pokedex[index]['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: Colors.black26,
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            child: Text(
                                              type.toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white, // Color del texto del tipo
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 5), // Espacio entre el texto y la imagen
                                      CachedNetworkImage(
                                        imageUrl: pokedex[index]['img'],
                                        height: 100,
                                        fit: BoxFit.fitHeight,
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          // Navegación a la pantalla de detalles del Pokémon
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(heroTag: index, pokemonDetail: pokedex[index],
                            color: pokedex[index]['type'][0] == "Grass" ? Colors.greenAccent : pokedex[index]['type'][0] == "Fire" ? Colors.redAccent
                                : pokedex[index]['type'][0] == "Water" ? Colors.blue : pokedex[index]['type'][0] == "Poison" ? Colors.deepPurpleAccent
                                : pokedex[index]['type'][0] == "Electric" ? Colors.amber : pokedex[index]['type'][0] == "Rock" ? Colors.grey
                                : pokedex[index]['type'][0] == "Ground" ? Colors.brown : pokedex[index]['type'][0] == "Psychic" ? Colors.indigo
                                : pokedex[index]['type'][0] == "Fighting" ? Colors.orange : pokedex[index]['type'][0] == "Bug" ? Colors.lightGreenAccent
                                : pokedex[index]['type'][0] == "Ghost" ? Colors.deepPurple : pokedex[index]['type'][0] == "Normal" ? Colors.white70 : Colors.pink,
                          )));
                        },
                      );
                    },
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fetchPokemonData() {
    var url = Uri.https("raw.githubusercontent.com", "Biuni/PokemonGO-Pokedex/master/pokedex.json");
    http.get(url).then((value) {
      if (value.statusCode == 200) {
        var decodedJsonData = jsonDecode(value.body);
        setState(() {
          pokedex = decodedJsonData['pokemon'];
        });
      }
    }).catchError((error) {
    });
  }
}
