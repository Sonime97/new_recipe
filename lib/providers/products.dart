import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class recipe {
  // final instructions;
  String id;
  String name;
  String img;
  String prep;
  recipe(
      {required this.id,
      required this.name,
      required this.img,
      required this.prep});
}

class Products with ChangeNotifier {
  final ids = [];
  final recipeNames = [];
  var _items = [];
  var user_Id = {};
  var allItems = [];
  final users = {};
  final images = {};
  //final _test = recipe(id: '',name: 'name', img: 'argo');
   Future allPosts() async {
  
  await FirebaseFirestore.instance
    .collection('products')
    .get()
    .then((QuerySnapshot querySnapshot) {
       
      querySnapshot.docs.forEach((doc) {
      if(recipeNames.length < querySnapshot.size) {
        recipeNames.add(doc['name']);
      }
      if(ids.length < querySnapshot.size) {
        ids.add(doc.id);
      }
      
      allItems.add({
        'name': '${doc['name']}',
        'commentnumber': '${doc['commentnumber']}',
        'image': '${doc['image']}',
        'prep': '${doc['prep']}',
        'date': '${doc['date']}',
        'author': '${doc['author']}'

      });
         
      
           // print(doc["first_name"]);
        });
    });
    

   }
  logout() {
    FirebaseAuth.instance.signOut();
  }

  Future getspecificuser() async {
    users.removeWhere((key, value) => key !=  FirebaseAuth.instance.currentUser!.email);
  }
  Future getspecificimage() async {
    images.removeWhere((key, value) => key != FirebaseAuth.instance.currentUser!.email);
  }
  Future getspecificId() async {
    user_Id.removeWhere((key, value) => key != FirebaseAuth.instance.currentUser!.email);
  }
 

  Future getusers() async{
    await FirebaseFirestore.instance
    .collection('users')
    .get()
    .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
      users.addAll({"${doc['email']}":"${doc['name']}"});
      // put the images in a map
      images.addAll({"${doc['email']}":"${doc['image']}"});
    // puting the ids in a map
      user_Id.addAll({"${doc['email']}":"${doc.id}"});
      
           // print(doc["first_name"]);
        });
    });
  }
  Future fetchcomment() async {
    final posts = await FirebaseFirestore.instance
        .collection('products')
        .doc('8ooLDoL1c2uAXAo3AHmY')
        .collection('comments')
        .doc('uFFTIgaaS7Aj0LefHR9v')
        .get()
        .then((value) => (value['comment']));
    return print(posts);

// try{
//    return posts.get().then((value) => value.id);

    //.collection('comments').get().then((value) => value.docs.forEach((element) {element.id;}));
    // return posts.docs.forEach((element) { element.id;});
// }
// catch(e) {}
  }

  Future fetchCommentNumber(docId) async {
    final result = await FirebaseFirestore.instance
        .collection('products')
        .doc(docId)
        .collection('comments')
        .snapshots()
        .length;
    return result;
  }

  Future<void> senduserdetails(username, email) async {
    final ref = await FirebaseFirestore.instance.collection('users');
    ref.add({'name': username, 'email': email, 'image': 'no'});
  }

  Future<void> fetchrecipe() async {
    const bm = 'https://my-blog-project-73e32-default-rtdb.firebaseio.com/';
    const url = 'https://www.themealdb.com/api/json/v1/1/search.php?f=a';
    try {
      final response = await http.get(Uri.parse(url));
      //final responsed = await http.post(Uri.parse(bm),body: {'name': 'ijp'});
      print('');
      var loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //var tit = recipe(id: '', name: 'sonimes', img: 'imitate',prep: '');
      // print(products);
      extractedData['meals'].forEach((value) => {
            loadedProducts.add(recipe(
                id: value['idMeal'],
                name: value['strMeal'],
                img: value['strMealThumb'],
                prep: value['strInstructions'])),

            //_loadedProducts.add(
            // recipe(name: value['strMeal'] ,instructions:value["strInstructions"] ,img:value['strMealThumb'])
            //  )
          });

      _items = loadedProducts;
      //print(_items[0].img);
      print(_items[0].prep);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  get getItems {
    return _items;
    // return [..._items];
    //_items;
    //
    //
  }
}
