import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:config/Model/Articles.dart';
import 'package:flutter/material.dart';
//import 'package:ipssiaa3bd2022firstapplication/Model/Utilisateur.dart';
//import 'package:ipssiaa3bd2022firstapplication/Services/FirestoreHelper.dart';
//import 'package:ipssiaa3bd2022firstapplication/Services/librairie.dart';
//import 'package:ipssiaa3bd2022firstapplication/View/MyDrawer.dart';

import '/Model/Utilisateur.dart';
import '/Services/FirestoreHelper.dart';
import '/Services/librairie.dart';
import '/View/Profil.dart';
import '/View/ajoutArticle.dart';
import '/View/ModifArticle.dart';
import '/View/VisuArticle.dart';
import '/Services/FirestoreHelper.dart';

class dashBoard extends StatefulWidget {



  @override
  State<StatefulWidget> createState(){
    return dashboardState();
  }
}

class dashboardState extends State<dashBoard> {
  String id = 'Text';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Container(
          width: MediaQuery
              .of(context)
              .size
              .width / 1.5,
          height: MediaQuery
              .of(context)
              .size
              .height,
          color: Colors.white,
          child: MyDrawer(),
        ),

        appBar: AppBar(
          title: const Text("Accueil"),
          backgroundColor: Colors.deepOrange,
        ),
        backgroundColor: Colors.white,
        body: bodyPage()
    );
  }

  Widget bodyPage() {

    return SingleChildScrollView(
      child: Column(
        children : [
          Container(
            height : 10,
            decoration : const BoxDecoration(
                shape : BoxShape.rectangle,

            ),
          ),
          //Bouton
          const SizedBox(height : 10),

          ElevatedButton.icon(
              onPressed : (){
                  //fonction pour s'inscrire
                  gotoAddArticle();
              },
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.green[500]), // Text Color
              icon: const Icon(Icons.new_label),// Text Color
              label: const Text("Ajouter article")

          ),

          ElevatedButton.icon(
              onPressed : (){
                //fonction pour s'inscrire
                gotoEditArticle();
              },
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blue[500]), // Text Color
              icon: const Icon(Icons.edit),// Text Color
              label: const Text("Mes articles")

          ),

          Container(
            height : 650,
            decoration : const BoxDecoration(
              shape : BoxShape.rectangle,
            ),
            child: bodyList(),
          ),





        ],
      ),
    );


    }


  Widget bodyList() {
         return StreamBuilder<QuerySnapshot>(
              stream: FirestoreHelper().fire_articles.snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Text("Chargement...");
                }
                else{
                  List documents = snapshot.data!.docs;
                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      Article item = Article(documents[index]);
                      if (GlobalUser.mail != item.mail) {
                        return Container(
                          height: 200,
                          child: Card(
                            elevation: 10,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              onTap: () {
                                //Détail de l'utilisateur
                                //gotoArticle(item.id);
                              },
                              title: Text((item.prix).toString()+"€"),

                              subtitle: Text(item.description!),
                              leading:   Text(item.nom,
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                              //trailing: Text(item.mail),
                            ),
                          ),
                        );
                      }
                      else {
                        return Container(
                          height: 200,
                          child: Card(
                            elevation: 10,
                            color: Colors.yellow[100],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              onTap: () {
                                //Détail de l'utilisateur
                                //gotoArticle(item.id);
                              },
                              title: Text((item.prix).toString()+"€"),

                              subtitle: Text(item.description!),
                              leading:   Text(item.nom,
                                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                              //trailing: Text(item.mail),
                            ),
                          ),
                        );
                      }
                      }
                      ,

                  );
                }
              }
          );



  }

  //Future getArticles() async {
  //  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Articles").getDocuments();
  //  for (int i = 0; i < querySnapshot.documents.length; i++) {
  //    var a = querySnapshot.documents[i];
   //   print(a.documentID);
  //  }
  //}





  //Fonction
  gotoArticle(String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisuArticle(id),

    ));
  }

    //Fonction
  gotoAddArticle(){
      Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return ajoutArticle();
          }
      ));
  }


  //Fonction
  gotoEditArticle(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return ModifArticle();
        }
    ));
  }
}

