import "package:cloud_firestore/cloud_firestore.dart";


//Firebase - table Utilisateur
//Constructeur

class Utilisateur {
  //Attributs
  late String id;

  late String nom;
  late String prenom;
  late String mail;
  String? avatar;
  String? pseudo;


  //Constructeur
  Utilisateur(DocumentSnapshot snapshot) {
    String? provisoire;
    id = snapshot.id;
    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    nom = map["nom"];
    prenom = map["prenom"];
    mail = map["mail"];
    provisoire = map["avatar"];


    if (provisoire == null) {
      //Image par défaut
      avatar =
      "https://firebasestorage.googleapis.com/v0/b/ipssia3bdfirstapplication.appspot.com/o/icon.png?alt=media&token=c3d7cb1c-1d44-4bca-aeb8-63f08d559926";
    }
    else {
      avatar = provisoire;
    }

    provisoire = map["pseudo"];
    if (provisoire == null) {
      pseudo = "";
    }
    else {
      pseudo = provisoire;
    }
  }

  //Constructeur par défaut
  Utilisateur.empty(){
    id = "";
    nom = "";
    prenom = "";
    mail = "";
    avatar = "";
    pseudo = "";
  }


  String nomComplet() {
    return prenom + " " + nom;
  }

}

