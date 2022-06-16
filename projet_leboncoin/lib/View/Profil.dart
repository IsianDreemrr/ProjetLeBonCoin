import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:projet_leboncoin/Services/FirestoreHelper.dart';
//import 'package:projet_leboncoin/Services/global.dart';
import 'package:file_picker/file_picker.dart';

import '/Services/FirestoreHelper.dart';
import '/Services/global.dart';

import '/View/ajoutArticle.dart';
import '/View/ModifArticle.dart';
import '/View/dashBoard.dart';

class MyDrawer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyDrawerState();
  }

}

class MyDrawerState extends  State<MyDrawer>{
  //Variable
  String? nomImage;
  String? urlImage;
  Uint8List? bytesImage;
  bool isEditing = false;
  String pseudoTempo="";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child:  Center(
            child: Column(
              children: [
                //Avatar cliquable
                InkWell(
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: NetworkImage(GlobalUser.avatar!),
                          fit: BoxFit.fitHeight
                      ),
                    ),

                  ),
                  onTap: (){
                    print("Ouverture sélection d'image");
                    pickImage();
                  },
                ),
                SizedBox(height: 10,),




                //Pseudo qui pourra changer
               TextButton.icon(

                   onPressed: (){

                     if (isEditing == true){
                       setState(() {
                         GlobalUser.pseudo = pseudoTempo;
                         Map<String,dynamic> map = {
                           "username": pseudoTempo
                         };
                         FirestoreHelper().updateUser(GlobalUser.id, map);
                       });

                     }
                     setState(() {
                       isEditing = !isEditing;
                     });

                   } ,
                   icon: (isEditing)?const Icon(Icons.check,color: Colors.green,):const Icon(Icons.edit),
                   label: (isEditing)?TextField(
                     decoration: const InputDecoration(
                       hintText: "Pseudonyme",
                     ),
                     onChanged: (newValue){
                       setState(() {
                         pseudoTempo=newValue;
                       });
                     },

                   ):
                   Text(GlobalUser.pseudo!)
               ),




                // nom et prénom complet
                Text(GlobalUser.nomComplet()),


                // adresee mail
                Text(GlobalUser.mail),


                ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.exit_to_app_sharp),
                    label: const Text("Fermer")
                ),

                ElevatedButton.icon(
                    onPressed : (){
                      //fonction pour s'inscrire
                      gotoDashboard();
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.orangeAccent[200]),
                    icon: const Icon(Icons.list_alt),// Text Color
                    label: const Text("Articles")


                ),


                ElevatedButton.icon(
                    onPressed : (){
                      //fonction pour s'inscrire
                      gotoAddArticle();
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green[500]),
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


              ],
            ),
          ),
        )
    );

  }

  //Fonction

  //Choisir l'image
  Future pickImage() async{
    FilePickerResult? resultat = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.image
    );
    if (resultat != null){
      nomImage = resultat.files.first.name;
      bytesImage = resultat.files.first.bytes;
      MyPopUp();
      
    }



  }
  
  //Création de notre popUp
MyPopUp(){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          if(Platform.isIOS){
            return CupertinoAlertDialog(
              title: const Text("Mon image"),
              content: Image.memory(bytesImage!),
              actions: [
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    child: const Text("Annuler"),
                ),

                ElevatedButton(
                  onPressed: (){
                    //Stocker et on va récupérer son url
                    FirestoreHelper().stockageImage(bytesImage!, nomImage!).then((value){
                      setState(() {
                        GlobalUser.avatar = value;
                        urlImage = value;
                      });
                      //Mettre à jour notre base de donnée en stockant l'url
                      Map<String,dynamic> map ={
                        //Key : Valeur
                        "avatar":urlImage
                      };
                      FirestoreHelper().updateUser(GlobalUser.id, map);



                      Navigator.pop(context);
                    });







                  },
                  child: const Text("Enregistrement"),
                ),
              ],
            );
          }
          else {
            return AlertDialog(
              title: const Text("Mon image"),
              content: Image.memory(bytesImage!),
              actions: [
                ElevatedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Annuler"),
                ),

                ElevatedButton(
                  onPressed: (){
                    //Stocker et on va récupérer son url
                    FirestoreHelper().stockageImage(bytesImage!, nomImage!).then((value){
                      setState(() {
                        GlobalUser.avatar = value;
                        urlImage = value;
                      });
                      //Mettre à jour notre base de donnée en stockant l'url
                      Map<String,dynamic> map ={
                        //Key : Valeur
                        "avatar":urlImage
                      };
                      FirestoreHelper().updateUser(GlobalUser.id, map);



                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Enregistrement"),
                ),
              ],
              
            );
          }
        }
    );
}


  gotoDashboard(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context){
          return dashBoard();
        }
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