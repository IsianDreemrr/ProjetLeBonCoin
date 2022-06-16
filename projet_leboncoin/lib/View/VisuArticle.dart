import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:ipssiaa3bd2022firstapplication/Model/Utilisateur.dart';
//import 'package:ipssiaa3bd2022firstapplication/Services/FirestoreHelper.dart';
//import 'package:ipssiaa3bd2022firstapplication/Services/librairie.dart';
//import 'package:ipssiaa3bd2022firstapplication/View/MyDrawer.dart';

import '/Model/Utilisateur.dart';
import '/Services/FirestoreHelper.dart';
import '/Services/librairie.dart';
import '/View/Profil.dart';
import '/View/dashBoard.dart';

import 'package:numberpicker/numberpicker.dart';
import '/Services/global.dart';

class VisuArticle extends StatefulWidget {

String idArticle;
VisuArticle(this.idArticle);

  @override
  State<StatefulWidget> createState(){
    return VisuArticleState();
  }
}

class VisuArticleState extends State<VisuArticle> {
 // String idArticle;
//  VisuArticle(this.idArticle);
  @override

  String nom = "";
  int prix = 0;
  String  description = "";
  DateTime date = DateTime.now();
  String mail = GlobalUser.mail;
  List<bool> selection = [true,false];



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
          title: const Text("Voir un article"),
          backgroundColor: Colors.deepOrange,
        ),
        backgroundColor: Colors.amber[100],
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

          ElevatedButton(
              onPressed : (){

                  //fonction pour s'inscrire
                  gotoDashboard();

              },
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.red[900]), // Text Color
              child : Text("Retour"),
          ),

          TextField(
              decoration : InputDecoration(
                  hintText : "Nom de l'article",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
              onChanged : (String value){
                setState((){
                  nom = value;
                });
              }),


          TextField(
              decoration : InputDecoration(
                  hintText : "Description",
                  border : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
              onChanged : (String value){
                setState((){
                  description = value;
                });
              }),

          NumberPicker(
            value: prix,
            minValue: 0,
            maxValue: 1000,
            onChanged: (value) => setState(() => prix = value),

          ),
          Text('Prix article: $prix'),

          ElevatedButton(
            onPressed : (){

              //fonction pour s'inscrire
              initArticle();

            },
            style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.green[900]), // Text Color
            child : Text("Créer"),
          ),


        ],
      ),
    );

  }

  //Fonction
  initArticle(){
    FirestoreHelper().createArticle(nom, description, prix, mail).then((value){
      if (value == true){
        gotoDashboard();
      }






    }).catchError((error){
      //Par exemple une perte de connexion
      print(error);

    });

  }

  //Fonction
  gotoDashboard(){
      Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return dashBoard();
          }
      ));


  }
}