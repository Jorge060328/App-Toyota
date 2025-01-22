class Activity {
  final String id;
  final String name;
  final String type;
  final double distance;
  final double time;

  Activity({
    required this.id,
    required this.name,
    required this.type,
    required this.distance,
    required this.time,
  });
}

List<Activity> activities = [];
