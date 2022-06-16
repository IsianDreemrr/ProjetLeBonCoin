import 'dart:ffi';

import "package:cloud_firestore/cloud_firestore.dart";
import '/Services/global.dart';

//Firebase - table Articles
//Constructeur

class Article {
  //Attributs
  late String id;
  late int prix;
  late String nom;
  late String mail;
  String? image;
  String? description;
  DateTime? date;

  //Constructeur
  Article(DocumentSnapshot snapshot) {
    String? provisoire;
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    nom = map["nom"];
    prix = map["prix"];
    mail = GlobalUser.mail;
    date = DateTime.now();
    provisoire = map["image"];


    if (provisoire == null) {
      //Image par défaut
      image =
      "https://firebasestorage.googleapis.com/v0/b/ipssia3bdfirstapplication.appspot.com/o/icon.png?alt=media&token=c3d7cb1c-1d44-4bca-aeb8-63f08d559926";
    }
    else {
      image = provisoire;
    }

    provisoire = map["description"];
    if (provisoire == null) {
      description = "";
    }
    else {
      description = provisoire;
    }
  }

  //Constructeur par défaut
  Article.empty(){
    id = "";
    nom = "";
    mail = "";
    image = "";
    description = "";
  }


  String nomPrix() {
    return nom + " - " + prix.toString()+"€";
  }

}

