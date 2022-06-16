
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:projet_leboncoin/Model/Utilisateur.dart';

import '/Model/Utilisateur.dart';

class FirestoreHelper{

  //Attributs
   final auth = FirebaseAuth.instance;
   final fire_users = FirebaseFirestore.instance.collection("Utilisateurs");
   final storage = FirebaseStorage.instance;





   //Méthodes
    Future <Utilisateur> createUser(String nom, String password, String mail, String prenom) async {
       UserCredential resultat = await auth.createUserWithEmailAndPassword(email: mail, password: password);
       User userFirebase = resultat.user!;
       String uid = userFirebase.uid;
       Map<String,dynamic> map = {
         "mail": mail,
         "avatar" : null,
         "username" : null,
         "prenom" : prenom,
         "nom": nom,
       };
       addUser(uid, map);
       return getUser(uid);

    }

     Future <Utilisateur> connectUser(String mail , String password) async {
        UserCredential resultat =  await auth.signInWithEmailAndPassword(email: mail, password: password);
        String uid = resultat.user!.uid;
        return getUser(uid);

    }


    Future <Utilisateur> getUser( String uid) async {
      DocumentSnapshot snapshot = await fire_users.doc(uid).get();
      return Utilisateur(snapshot);

    }

    String getIdentifant(){
      return auth.currentUser!.uid;
    }



    addUser(String uid , Map<String,dynamic> map){
       fire_users.doc(uid).set(map);
    }

    updateUser(String uid , Map<String,dynamic> map){
      fire_users.doc(uid).update(map);
    }

    deleteUser(String uid){
      fire_users.doc(uid).delete();
    }

    Future <String> stockageImage(Uint8List bytes, String name) async {
      String nameFinal = name+getIdentifant();
      String url ="";
      //Stockage de l'image dans la bdd
      TaskSnapshot taskSnapshot = await storage.ref("ProfilImage/$nameFinal").putData(bytes);
      //récupération du lien de l'image dans la bdd
      url = await taskSnapshot.ref.getDownloadURL();
      return url;

    }













}