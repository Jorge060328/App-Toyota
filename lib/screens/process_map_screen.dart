import 'package:flutter/material.dart';
import 'dart:math'; // Import the math library to use mathematical functions and constants
import 'package:toyota_production_system/models/activity.dart';
import 'package:toyota_production_system/models/process_map.dart';

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
              // Share functionality
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
          processMaps.add(
            ProcessMap(
              name: 'Mapa ${processMaps.length + 1}',
              activities: List.from(activities),
            ),
          );
          activities.clear();
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        child: Icon(Icons.save),
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

    double columnWidth = size.width / 4;
    double y = 50;
    final headers = ['Actividad', 'Tiempo', 'Distancia', 'Símbolo'];

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
    y += 30;

    Offset? previousPosition;

    for (var activity in activities) {
      double x = columnWidth * 3 + 20;

      final namePainter = TextPainter(
        text: TextSpan(
          text: activity.name,
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      namePainter.layout();
      namePainter.paint(canvas, Offset(columnWidth * 0, y));

      final timePainter = TextPainter(
        text: TextSpan(
          text: 'T: ${activity.time}',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      timePainter.layout();
      timePainter.paint(canvas, Offset(columnWidth * 1, y));

      final distancePainter = TextPainter(
        text: TextSpan(
          text: 'D: ${activity.distance}',
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      distancePainter.layout();
      distancePainter.paint(canvas, Offset(columnWidth * 2, y));

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

      if (previousPosition != null) {
        drawArrow(canvas, previousPosition, currentPosition, paint);
      }
      previousPosition = currentPosition;

      y += 50;
    }
  }

  void drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);
    const arrowSize = 10.0;

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
