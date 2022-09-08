import 'package:flutter/material.dart';
import 'package:sonime_app/blogdetailbackup.dart';
import '../carousel.dart';
//import '../screens/backupoverview.dart';

import '../user_profile.dart';
import 'screens/custom_search.dart';
import 'add_blog_post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sonime_app/providers/products.dart';
//import '../blog_detail.dart';
import '../usermodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../blogdetailbackup.dart';
import 'package:flutter/material.dart';
import '../carousel.dart';
import '../appDrawer.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  var image;
  var recipes;
  var idss;
  var name;
  void didChangeDependencies() async {
    final getProd = Provider.of<Products>(context).allPosts();
    getProd;
    final rec = Provider.of<Products>(context).recipeNames;
    final id = Provider.of<Products>(context).ids;
    
    
    final getnames =  Provider.of<Products>(context).getusers(); 
    final filterUser =  Provider.of<Products>(context).getspecificuser();
    final filterimage =  Provider.of<Products>(context).getspecificimage();
    final images =  Provider.of<Products>(context).images;
    final names =  Provider.of<Products>(context).users;
    await  getnames;
     await filterUser;
     await filterimage;
    Future.delayed(Duration(seconds: 7),() => setState(() {
      name = names[FirebaseAuth.instance.currentUser!.email];
      image=images[FirebaseAuth.instance.currentUser!.email];
    }));
    

    
    
    //print(names);
    
    idss = id;
    recipes = rec;
    
    print(image);
    print(rec);
    print(id);

    //getProd;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  final Stream<QuerySnapshot> products =
      FirebaseFirestore.instance.collection('products').snapshots();
  final commentRef = FirebaseFirestore.instance.collection('products');
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromARGB(255, 243, 235, 152),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        drawer: AppDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: products,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            final data = snapshot.requireData;
            return SafeArea(
                
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Text(
                              'Welcome Back, ${name}!',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            ((image == null || image == "no" )
                                ? CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor: Colors.orange,
                                    backgroundImage: 
                                         AssetImage(
                                            "assets/images/person-304893_1280.png"),
                                       // fit: BoxFit.contain
                                        //  backgroundColor: Colors.transparent
                                        )
                                : CircleAvatar(
                                    radius: 25.0,
                                     // Image radius
                                        backgroundImage: NetworkImage('${image}',
                                            ),
                                      
                                    
                                    backgroundColor: Colors.orange,
                                  ))
                          ])),
                      SizedBox(height: 20),
                      Text(
                        'explore new recipes it\'s time🙌',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: CustomSearchDelegate(
                                recipesThem: recipes, ids: idss),
                          );
                          print(recipes);
                          print(idss);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Search Recipes',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Icon(Icons.search, color: Colors.grey),
                              ]),
                        ),
                      )
                    ],
                  )),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(
                                    'Top Recipe this week',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  padding: EdgeInsets.all(20)),
                            ],
                          ),
                          SingleChildScrollView(
                            padding: EdgeInsets.all(0),
                            child: Container(
                              child: ComplicatedImageDemo(),
                              padding: EdgeInsets.all(10),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text('Recommended',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  padding: EdgeInsets.all(0),
                                ),
                              ],
                            ),
                          ),

                          // padding: EdgeInsets.all(20),

                          Expanded(
                            child: SizedBox(
                              height: 400,
                              child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            BlogDetail.routeName,
                                            arguments: data.docs[index].id,
                                          );
                                        },
                                        child: Row(children: [
                                          Container(
                                              child: Card(
                                                child: Image.network(
                                                  '${data.docs[index]['image']}',
                                                  fit: BoxFit.cover,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                              ),
                                              height: 130,
                                              width: 150),
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            height: 130,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    '${data.docs[index]['name']}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                SizedBox(height: 5),
                                                Text(
                                                  'by ${data.docs[index]['author']}',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 30),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Icon(
                                                      Icons.alarm,
                                                      color: Color.fromARGB(
                                                          255, 167, 248, 169),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                        '${data.docs[index]['duration']}'),
                                                    SizedBox(width: 10),
                                                    Icon(Icons.check_box,
                                                        color: Colors.orange),
                                                    SizedBox(width: 10),
                                                    Text(
                                                        '${data.docs[index]['complexity']}')
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                      ),
                                      SizedBox(height: 40)
                                    ],
                                  );
                                },
                                itemCount: data.docs.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddBlogBackup()));
            // arguments: user!.email);
            // Add your onPressed code here!
          },
          backgroundColor: Color.fromARGB(255, 239, 225, 105),
          child: const Icon(Icons.add),
        ));
  }
}
