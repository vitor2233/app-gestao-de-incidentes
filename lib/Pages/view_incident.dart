import 'package:flutter/material.dart';

class ViewIncident extends StatefulWidget {
  @override
  _ViewIncidentState createState() => _ViewIncidentState();
  ViewIncident(this.incident);
  final incident;
}

class _ViewIncidentState extends State<ViewIncident> {
  @override
  void initState() {
    super.initState();
    print(widget.incident);
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
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: 300.0,
        child: Card(
          child: Column(
            children: [
              ListTile(
              leading: ClipOval(
                child: Image.network(
                  widget.incident["user"]["avatarURL"],
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover
                )
              ),
                title: Text(widget.incident["subject"]),
                subtitle: Text(widget.incident["description"]),
              ),
              Column(children: [
                Text(widget.incident["status"]),
                getPriorityText(widget.incident["priority"]),
                Text("Área: "+widget.incident["area"]),
                Text("Nível: "+widget.incident["level"]),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}