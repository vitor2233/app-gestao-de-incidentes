import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestaoincidentes/Pages/view_incident.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeUserWidget extends StatefulWidget {

  GoogleSignIn _googleSignIn;
  User _user;

  WelcomeUserWidget(User user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _WelcomeUserWidgetState createState() => _WelcomeUserWidgetState();
}

class _WelcomeUserWidgetState extends State<WelcomeUserWidget> {
  Query query = FirebaseFirestore.instance.collection('incidents');
  List<Map<String, dynamic>> incidents = [];
  List<Map<String, dynamic>> userIncidents = [];
  

  @override
  void initState() { 
    super.initState();
    getIncidents();
  }

  Future getIncidents() async {
    incidents = [];
    userIncidents = [];
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((element) {
        incidents.add(element.data());
      });
    });
    for (var incident in incidents) {
      if(incident["user"]["uid"] == widget._user.uid) {
        userIncidents.add(incident);
      }
    }
    setState(() {});
  }

  Text getPriorityText(String priority) {
    if(priority == "Baixa") {
      return Text(priority + " prioridade", style: TextStyle(color: Colors.green));
    } else if(priority == "Média") {
      return Text(priority + " prioridade", style: TextStyle(color: Colors.amber));
    } else if(priority == "Alta") {
      return Text(priority + " prioridade", style: TextStyle(color: Colors.red));
    } else {
      return Text(priority);

    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(icon: Icon(Icons.refresh), onPressed: (){
            getIncidents().then((value) {
              setState(() {
                
              });
            }); 
          })],
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Image.network(
                      widget._user.photoURL,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover
                    )
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    widget._user.displayName,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(
          preferredSize: Size.square(140.0),
          child: TabBar(
            tabs: [
              Icon(Icons.person_search),
              Icon(Icons.search),
            ],
          ),
        ),
      ),
      body: TabBarView(
        children: [
          Center(child: 
            ListView.builder(
              itemCount: userIncidents.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                    leading: ClipOval(
                    child: Image.network(
                      userIncidents[index]["user"]["avatarURL"],
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover
                    )
                  ),
                    title: Text(userIncidents[index]["subject"]),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(userIncidents[index]["description"]),
                      Text(userIncidents[index]["area"] + ", " + userIncidents[index]["level"]),
                    ],),
                    trailing:  Column(children: [
                      Text(userIncidents[index]["status"]),
                      getPriorityText(userIncidents[index]["priority"]),
                    ],),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewIncident(userIncidents[index])),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Center(child: 
            ListView.builder(
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                    leading: ClipOval(
                    child: Image.network(
                      incidents[index]["user"]["avatarURL"],
                      width: 46,
                      height: 46,
                      fit: BoxFit.cover
                    )
                  ),
                    title: Text(incidents[index]["subject"]),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(incidents[index]["description"]),
                      Text(incidents[index]["area"] + ", " + incidents[index]["level"]),
                    ],),
                    trailing:  Column(children: [
                      Text(incidents[index]["status"]),
                      getPriorityText(incidents[index]["priority"]),
                    ],),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewIncident(incidents[index],),),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
  }
}