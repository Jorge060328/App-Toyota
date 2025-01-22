import 'package:flutter/material.dart';
import 'package:toyota_production_system/models/activity.dart';
import 'package:toyota_production_system/models/process_map.dart';

class EditMapScreen extends StatefulWidget {
  @override
  _EditMapScreenState createState() => _EditMapScreenState();
}

class _EditMapScreenState extends State<EditMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Mapas')),
      body: ListView.builder(
        itemCount: processMaps.length,
        itemBuilder: (context, index) {
          final map = processMaps[index];
          return ListTile(
            title: Text(map.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  processMaps.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mapa eliminado')),
                );
              },
            ),
            onTap: () {
              activities = List.from(map.activities);
              Navigator.pushNamed(context, '/activity');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your logic here
        },
        child: Icon(Icons.file_upload),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
