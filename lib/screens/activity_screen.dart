import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:toyota_production_system/models/activity.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String? selectedType;
  final TextEditingController activityController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isEditMode = false;
  String? editingActivityId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args['editMode'] == true) {
      isEditMode = true;
    }
  }

  void _addOrUpdateActivity() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (isEditMode && editingActivityId != null) {
          // Update existing activity
          final index = activities
              .indexWhere((activity) => activity.id == editingActivityId);
          if (index != -1) {
            activities[index] = Activity(
              id: editingActivityId!,
              name: activityController.text,
              type: selectedType!,
              distance: double.parse(distanceController.text),
              time: double.parse(timeController.text),
            );
          }
        } else {
          // Add new activity
          activities.add(Activity(
            id: Uuid().v4(),
            name: activityController.text,
            type: selectedType!,
            distance: double.parse(distanceController.text),
            time: double.parse(timeController.text),
          ));
        }
        _clearForm();
      });
    }
  }

  void _clearForm() {
    activityController.clear();
    distanceController.clear();
    timeController.clear();
    selectedType = null;
    editingActivityId = null;
  }

  void _editActivity(Activity activity) {
    setState(() {
      activityController.text = activity.name;
      selectedType = activity.type;
      distanceController.text = activity.distance.toString();
      timeController.text = activity.time.toString();
      editingActivityId = activity.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Actividad'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: activityController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Actividad',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre de la actividad es obligatorio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Tipo', style: TextStyle(fontSize: 16)),
              Column(
                children: [
                  RadioListTile(
                    title: Text('Transformación'),
                    value: 'Transformación',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Transportación'),
                    value: 'Transportación',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Inspección'),
                    value: 'Inspección',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Espera por lote'),
                    value: 'Espera por lote',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Espera por cola'),
                    value: 'Espera por cola',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: distanceController,
                decoration: InputDecoration(
                  labelText: 'Distancia',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Introduce una distancia válida';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: 'Tiempo',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Introduce un tiempo válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                onPressed: _addOrUpdateActivity,
                child: Text(
                    isEditMode ? 'Actualizar Actividad' : 'Añadir Actividad',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return ListTile(
                      title: Text(activity.name),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editActivity(activity),
                      ),
                    );
                  },
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.blue),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text('Atrás', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/processMap');
                    },
                    child:
                        Text('Terminar', style: TextStyle(color: Colors.white)),
                  ),
                  Row(
                    children: [
                      Text('Sig', style: TextStyle(color: Colors.blue)),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.blue),
                        onPressed: _addOrUpdateActivity,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
