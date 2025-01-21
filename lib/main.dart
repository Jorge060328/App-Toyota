import 'package:flutter/material.dart';
import 'dart:ui'; // Para trabajar con el Canvas
import 'dart:math'; // Para usar la constante pi

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MainMenu(),
        '/newMap': (context) => MainScreenWrapper(NewMapScreen()),
        '/activity': (context) => MainScreenWrapper(ActivityScreen()),
        '/processMap': (context) => MainScreenWrapper(ProcessMapScreen()),
        '/editMap': (context) => MainScreenWrapper(EditMapScreen()),
      },
    );
  }
}

// Modelo para almacenar las actividades
class Activity {
  final String name;
  final String type;
  final double distance;
  final double time;

  Activity({
    required this.name,
    required this.type,
    required this.distance,
    required this.time,
  });
}

List<Activity> activities = []; // Lista para almacenar las actividades

class ProcessMap {
  final String name;
  final List<Activity> activities;

  ProcessMap({required this.name, required this.activities});
}

List<ProcessMap> processMaps = []; // Lista para almacenar los mapas de procesos

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Color del botón
                  minimumSize:
                      Size(300, 90), // Tamaño mínimo del botón (ancho x alto)
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Espaciado interno
                  textStyle:
                      TextStyle(fontSize: 36), // Tamaño de la fuente del texto
                ),
                onPressed: () {
                  activities.clear(); // Reinicia la lista de actividades
                  Navigator.pushNamed(context, '/newMap');
                },
                child:
                    Text('Nuevo mapa', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, // Color del botón
                  minimumSize:
                      Size(300, 90), // Tamaño mínimo del botón (ancho x alto)
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Espaciado interno
                  textStyle:
                      TextStyle(fontSize: 36), // Tamaño de la fuente del texto
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/editMap');
                },
                child:
                    Text('Editar mapa', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewMapScreen extends StatelessWidget {
  final TextEditingController processController = TextEditingController();
  final TextEditingController performedByController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: processController,
                decoration: InputDecoration(
                    labelText: 'Proceso',
                    fillColor: Colors.white,
                    filled: true),
              ),
              SizedBox(height: 10),
              TextField(
                controller: performedByController,
                decoration: InputDecoration(
                    labelText: 'Realizado por:',
                    fillColor: Colors.white,
                    filled: true),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Fecha:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
                onPressed: () {
                  if (processController.text.isEmpty ||
                      performedByController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Todos los campos son obligatorios')),
                    );
                    return;
                  }
                  Navigator.pushNamed(context, '/activity');
                },
                child:
                    Text('Iniciar mapa', style: TextStyle(color: Colors.white)),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text('Atrás', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String? selectedType;
  final TextEditingController activityController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón para volver a la pantalla principal
                        ElevatedButton(
                          onPressed: () {
                            // Mostrar cuadro de confirmación
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Salir sin guardar'),
                                content: Text(
                                    '¿Estás seguro de que deseas salir sin guardar los cambios?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                        context), // Cerrar el cuadro de diálogo
                                    child: Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.popUntil(
                                          context, ModalRoute.withName('/'));
                                    },
                                    child: Text('Sí'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                          child: Icon(Icons.home, color: Colors.white),
                        ),
                        SizedBox(
                            width:
                                10), // Espaciado entre el botón y el cuadro amarillo
                        Container(
                          color: Colors.yellow,
                          padding: EdgeInsets.all(8),
                          child: Text('${activities.length + 1}',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text('Actividad',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: activityController,
                decoration:
                    InputDecoration(fillColor: Colors.white, filled: true),
              ),
              SizedBox(height: 20),
              Text('Tipo', style: TextStyle(color: Colors.white)),
              Column(
                children: [
                  RadioListTile(
                    title: Text('Transformación',
                        style: TextStyle(color: Colors.white)),
                    value: 'Transformación',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Transportación',
                        style: TextStyle(color: Colors.white)),
                    value: 'Transportación',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Inspección',
                        style: TextStyle(color: Colors.white)),
                    value: 'Inspección',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Espera por lote',
                        style: TextStyle(color: Colors.white)),
                    value: 'Espera por lote',
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text('Espera por cola',
                        style: TextStyle(color: Colors.white)),
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
              TextField(
                controller: distanceController,
                decoration: InputDecoration(
                    labelText: 'Distancia',
                    fillColor: Colors.white,
                    filled: true),
              ),
              SizedBox(height: 10),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                    labelText: 'Tiempo', fillColor: Colors.white, filled: true),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text('Atrás', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/processMap');
                    },
                    child:
                        Text('Terminar', style: TextStyle(color: Colors.white)),
                  ),
                  Row(
                    children: [
                      Text('Sig', style: TextStyle(color: Colors.white)),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          if (activityController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'El nombre de la actividad es obligatorio')),
                            );
                            return;
                          }
                          if (selectedType == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Selecciona un tipo de actividad')),
                            );
                            return;
                          }
                          if (distanceController.text.isEmpty ||
                              double.tryParse(distanceController.text) ==
                                  null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Introduce una distancia válida')),
                            );
                            return;
                          }
                          if (timeController.text.isEmpty ||
                              double.tryParse(timeController.text) == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Introduce un tiempo válido')),
                            );
                            return;
                          }
                          setState(() {
                            activities.add(Activity(
                              name: activityController.text,
                              type: selectedType!,
                              distance: double.parse(distanceController.text),
                              time: double.parse(timeController.text),
                            ));
                            activityController.clear();
                            distanceController.clear();
                            timeController.clear();
                            selectedType = null;
                          });
                        },
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

class ProcessMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de proceso'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement export functionality here
            },
          ),
        ],
      ),
      body: CustomPaint(
        size: Size.infinite,
        painter: ProcessMapPainter(activities),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Guardar el mapa en la lista de mapas
          processMaps.add(
            ProcessMap(
              name: 'Mapa ${processMaps.length + 1}',
              activities: List.from(activities),
            ),
          );
          activities.clear(); // Limpiar las actividades
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

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
              },
            ),
            onTap: () {
              // Cargar actividades del mapa seleccionado
              activities = List.from(map.activities);
              Navigator.pushNamed(context, '/activity');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement import functionality here
        },
        child: Icon(Icons.file_upload),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ProcessMapPainter extends CustomPainter {
  final List<Activity> activities;

  ProcessMapPainter(this.activities);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Establecer el ancho de cada columna
    double columnWidth = size.width / 4;
    double y = 50; // Espaciado inicial
    final headers = ['Actividad', 'Tiempo', 'Distancia', 'Símbolo'];

    // Dibujar encabezados
    for (int i = 0; i < headers.length; i++) {
      final headerPainter = TextPainter(
        text: TextSpan(
          text: headers[i],
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      headerPainter.layout();
      headerPainter.paint(canvas, Offset(columnWidth * i, y));
    }
    y += 30; // Espaciado para el siguiente registro

    // Coordenadas iniciales para flechas
    Offset? previousPosition;

    // Dibujar actividades y flechas
    for (var activity in activities) {
      double x = columnWidth * 3 + 20; // Posición horizontal del símbolo

      // Columna 1: Nombre de la actividad
      final namePainter = TextPainter(
        text: TextSpan(
          text: activity.name,
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      namePainter.layout();
      namePainter.paint(canvas, Offset(columnWidth * 0, y));

      // Columna 2: Tiempo
      final timePainter = TextPainter(
        text: TextSpan(
          text: 'T: ${activity.time}',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      timePainter.layout();
      timePainter.paint(canvas, Offset(columnWidth * 1, y));

      // Columna 3: Distancia
      final distancePainter = TextPainter(
        text: TextSpan(
          text: 'D: ${activity.distance}',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      distancePainter.layout();
      distancePainter.paint(canvas, Offset(columnWidth * 2, y));

      // Columna 4: Símbolo y posición actual
      Offset currentPosition = Offset(x, y);
      switch (activity.type) {
        case 'Transformación':
          canvas.drawRect(
            Rect.fromCenter(center: currentPosition, width: 30, height: 30),
            paint,
          );
          break;
        case 'Transportación':
          canvas.drawLine(
            Offset(x - 20, y),
            Offset(x + 20, y),
            paint,
          );
          break;
        case 'Inspección':
          canvas.drawOval(
            Rect.fromCenter(center: currentPosition, width: 30, height: 15),
            paint,
          );
          break;
        case 'Espera por lote':
          Path star = Path();
          double radius = 20;
          double angle = 0;
          for (int i = 0; i < 6; i++) {
            star.lineTo(x + radius * cos(angle), y + radius * sin(angle));
            angle += pi / 3;
          }
          star.close();
          canvas.drawPath(star, paint);
          break;
        case 'Espera por cola':
          Path triangle = Path();
          triangle.moveTo(x, y - 20);
          triangle.lineTo(x - 20, y + 20);
          triangle.lineTo(x + 20, y + 20);
          triangle.close();
          canvas.drawPath(triangle, paint);
          break;
      }

      // Dibujar flecha si hay una posición previa
      if (previousPosition != null) {
        drawArrow(canvas, previousPosition, currentPosition, paint);
      }
      previousPosition = currentPosition; // Actualizar posición previa

      y += 50; // Espaciado entre filas
    }
  }

  void drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);
    const arrowSize = 10.0;

    // Cálculo para la punta de flecha
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    final path = Path();
    path.moveTo(end.dx, end.dy);
    path.lineTo(
      end.dx - arrowSize * cos(angle - pi / 6),
      end.dy - arrowSize * sin(angle - pi / 6),
    );
    path.lineTo(
      end.dx - arrowSize * cos(angle + pi / 6),
      end.dy - arrowSize * sin(angle + pi / 6),
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MainScreenWrapper extends StatelessWidget {
  final Widget child;

  MainScreenWrapper(this.child);

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Salir sin guardar cambios'),
        content: Text(
            '¿Estás seguro de que quieres volver a la pantalla principal? Los cambios no se guardarán.'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el cuadro de diálogo
            },
          ),
          TextButton(
            child: Text('Sí'),
            onPressed: () {
              Navigator.of(context).popUntil(
                  ModalRoute.withName('/')); // Regresa a la pantalla principal
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
