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
import '/View/dashBoard.dart';
import '/Services/FirestoreHelper.dart';
import '/View/VisuArticle.dart';
import '/View/ajoutArticle.dart';
import 'package:numberpicker/numberpicker.dart';

class ModifArticle extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return ModifArticleState();
  }
}

class ModifArticleState extends State<ModifArticle> {

String EditActuel = "";
bool isEditing = false;
String NomTempo="";
String? DescriptionTempo="";
int PrixTempo= 0;

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
          title: const Text("Mes articles"),
          backgroundColor: Colors.deepOrange,
        ),
        backgroundColor: Colors.blue[100],
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
                gotoDashboard();

              },
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.orangeAccent[200]), // Text Color
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
                backgroundColor: Colors.green[500]), // Text Color
            icon: const Icon(Icons.new_label),// Text Color
            label: const Text("Ajouter article"),
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
                          height: 1,
                        );
                      }
                      else {

                        if (EditActuel == item.id) {

                          return Container(
                            height: 400,
                            child: Card(
                              elevation: 100,
                              color: Colors.blue[200],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),

                                child: Column(
                                    children : [

                                      TextField(
                                          decoration : InputDecoration(
                                              hintText : item.nom,
                                              border : OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onChanged : (String value){
                                            setState((){
                                              NomTempo = value;
                                            });
                                          }),



                                      TextField(
                                          decoration : InputDecoration(
                                              hintText : item.description,
                                              border : OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(5)
                                              )
                                          ),
                                          onChanged : (String value){
                                            setState((){
                                              DescriptionTempo = value;
                                            });
                                          }),

                                      NumberPicker(
                                        value: PrixTempo,
                                        minValue: 0,
                                        maxValue: 1000,
                                        onChanged: (value) => setState(() => PrixTempo = value),

                                      ),
                                      Text('Prix article: $PrixTempo'),

                                      ElevatedButton(
                                        onPressed : (){

                                          //fonction pour s'inscrire
                                          ModifierArticle();

                                          setState(() {
                                            EditActuel ="";
                                            isEditing= false;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.green[900]), // Text Color
                                        child : Text("Mettre à jour"),
                                      ),


                                      ElevatedButton(
                                        onPressed : (){

                                          //fonction pour s'inscrire
                                          SupprimerArticle();

                                        },
                                        style: TextButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Colors.red[900]), // Text Color
                                        child : Text("Supprimer"),
                                      ),




                                  ],
                                )



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
                                  EditActuel =item.id;

                                  if (isEditing == true){
                                    setState(() {

                                      Map<String,dynamic> map = {
                                        "nom": NomTempo,
                                        "description": DescriptionTempo,
                                        "prix": PrixTempo,
                                      };
                                      //FirestoreHelper().updateUser(GlobalUser.id, map);
                                    });

                                  }
                                  setState(() {
                                    isEditing = !isEditing;
                                    NomTempo = item.nom;
                                    DescriptionTempo = item.description;
                                    PrixTempo = item.prix;
                                  });

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
ModifierArticle(){

  Map<String,dynamic> map = {
    "description" : DescriptionTempo,
    "prix" : PrixTempo,
    "nom": NomTempo,
    "date": DateTime.now()
  };

  FirestoreHelper().updateArticle(EditActuel, map).then((value){
    if (value == true){

    }
    stopEditing();
    gotoDashboard();
  }).catchError((error){
    //Par exemple une perte de connexion
    print(error);

  });

}
//Fonction
  SupprimerArticle(){

    FirestoreHelper().deleteArticle(EditActuel).then((value){
      if (value == true){

      }
      stopEditing();
      gotoDashboard();
    }).catchError((error){
      //Par exemple une perte de connexion
      print(error);

    });

  }

  //Fonction
  gotoArticle(String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VisuArticle(id),

    ));
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



  stopEditing(){

    //Détail de l'utilisateur

    setState(() {
      EditActuel = "";
      isEditing = false;
    });

  }



}






Widget _buildPopupDialog(BuildContext context, String Titre, String Message) {
  return new AlertDialog(
    title: Text(Titre),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(Message),
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },

        child: const Text('Close'),
      ),
    ],
  );
}
