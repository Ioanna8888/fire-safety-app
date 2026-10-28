
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
void main() {
  runApp(const FireSafetyApp());
}

class FireSafetyApp extends StatelessWidget {
  const FireSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Χάρτης Πυρκαγιών',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
      ),
      home: const FireMapScreen(),
    );
  }
}

class FireMapScreen extends StatefulWidget {
  const FireMapScreen({super.key});

  @override
  State<FireMapScreen> createState() => _FireMapScreenState();
}

class _FireMapScreenState extends State<FireMapScreen> {
  bool showMenu = false;
LatLng? selectedReportPoint;
String? reportDescription;
void showFireDetails(String category, String location) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text('Περιοχή: $location'),
          const Text('Ώρα καταγραφής: 14:30'),
          const SizedBox(height: 12),
          const Text(
            'Πληροφορίες δοκιμαστικού περιστατικού',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

void showShareLocationDialog() {
  bool neighbor1 = false;
  bool neighbor2 = false;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Κοινοποίηση τοποθεσίας'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Επίλεξε με ποιους γείτονες θέλεις '
                  'να μοιραστείς τη θέση σου.',
                ),
                CheckboxListTile(
                  title: const Text('Γείτονας 1'),
                  value: neighbor1,
                  onChanged: (value) {
                    setDialogState(() {
                      neighbor1 = value ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Γείτονας 2'),
                  value: neighbor2,
                  onChanged: (value) {
                    setDialogState(() {
                      neighbor2 = value ?? false;
                    });
                  },
                ),
                const Text(
                  'Δοκιμαστική λειτουργία – '
                  'δεν αποστέλλεται πραγματική τοποθεσία.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Ακύρωση'),
              ),
              ElevatedButton(
                onPressed: (neighbor1 || neighbor2)
                    ? () {
                        Navigator.pop(dialogContext);

                        ScaffoldMessenger.of(this.context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Η κοινοποίηση τοποθεσίας '
                              'προσομοιώθηκε επιτυχώς',
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Κοινοποίηση'),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Χάρτης Πυρκαγιών'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),

floatingActionButton: showMenu ? null : Padding(
  padding: EdgeInsets.only(bottom: showMenu ? 150 : 55),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    FloatingActionButton.extended(
      heroTag: 'reportFire',
  onPressed: () {
  final descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Αναφορά πιθανής πυρκαγιάς'),
      content: TextField(
        controller: descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Περιγραφή',
          hintText: 'Π.χ. Βλέπω καπνό κοντά στο δάσος',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Ακύρωση'),
        ),
        ElevatedButton(
          
onPressed: () {
  if (descriptionController.text.trim().isEmpty) {
    return;
  }

  if (selectedReportPoint == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Επίλεξε πρώτα ένα σημείο στον χάρτη'),
      ),
    );
    Navigator.pop(dialogContext);
    return;
  }

  setState(() {
    reportDescription = descriptionController.text.trim();
  });

  Navigator.pop(dialogContext);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Η αναφορά καταχωρίστηκε ως μη επιβεβαιωμένη (δοκιμή)',
      ),
    ),
  );
},

          child: const Text('Υποβολή'),
        ),
      ],
    ),
  );
},
  backgroundColor: Colors.deepOrange,
  foregroundColor: Colors.white,
  icon: const Icon(Icons.add_location_alt),
  label: const Text('Αναφορά πυρκαγιάς'),

    ),
    const SizedBox(height: 12),
    FloatingActionButton.extended(
      heroTag: 'shareLocation',
      onPressed: showShareLocationDialog,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.share_location),
      label: const Text('Κοινοποίηση τοποθεσίας'),
    ),
  ],
),
),
floatingActionButtonLocation:
    FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
  
options: MapOptions(
  initialCenter: const LatLng(38.130, 23.760),
  initialZoom: 12.5,
  onTap: (tapPosition, point) {
    setState(() {
      selectedReportPoint = point;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Επιλέχθηκε σημείο για αναφορά'),
      ),
    );
  },
),

  children: [
    TileLayer(
      urlTemplate:
          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'com.example.fire_safety_app',
    ),



MarkerLayer(
  markers: [

Marker(
  point: const LatLng(38.136, 23.751),
  width: 100,
  height: 75,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        'Η θέση μου',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      IconButton(
        icon: const Icon(
          Icons.person_pin_circle,
          color: Colors.blue,
          size: 38,
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ενδεικτική θέση της Μαρίας (δοκιμή)',
              ),
            ),
          );
        },
      ),
    ],
  ),
),

    Marker(
      point: const LatLng(38.130, 23.760),
      width: 48,
      height: 48,
      child: IconButton(
        icon: const Icon(
          Icons.sensors,
          color: Colors.deepOrange,
          size: 32,
        ),
        onPressed: () => showFireDetails(
          'Δορυφορική θερμική ανίχνευση',
          'Θρακομακεδόνες',
        ),
      ),
    ),
    Marker(
      point: const LatLng(38.140, 23.780),
      width: 48,
      height: 48,
      child: IconButton(
        icon: const Icon(
          Icons.report,
          color: Colors.amber,
          size: 32,
        ),
        onPressed: () => showFireDetails(
          'Μη επιβεβαιωμένη αναφορά πολίτη',
          'Αχαρνές',
        ),
      ),
    ),
    Marker(
      point: const LatLng(38.120, 23.740),
      width: 48,
      height: 48,
      child: IconButton(
        icon: const Icon(
          Icons.local_fire_department,
          color: Colors.red,
          size: 32,
        ),
        onPressed: () => showFireDetails(
          'Επιβεβαιωμένη πυρκαγιά',
          'Βαρυμπόμπη',
        ),
      ),
    ),
    if (selectedReportPoint != null)
      Marker(
        point: selectedReportPoint!,
        width: 55,
        height: 55,
        child: IconButton(
          icon: Icon(
            Icons.report,
            color: reportDescription == null
                ? Colors.blue
                : Colors.amber,
            size: 36,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  reportDescription == null
                      ? 'Επιλεγμένο σημείο αναφοράς'
                      : 'Μη επιβεβαιωμένη: $reportDescription',
                ),
              ),
            );
          },
        ),
      ),
  ],
),



    const RichAttributionWidget(
      attributions: [
        TextSourceAttribution('OpenStreetMap contributors'),
      ],
    ),
  ],
),
          ),
          if (showMenu)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.sensors, color: Colors.orange),
                    title: Text('Θερμικές ανιχνεύσεις'),
                  ),
                  ListTile(
                    leading: Icon(Icons.report, color: Colors.amber),
                    title: Text('Αναφορές πολιτών'),
                  ),
                  ListTile(
                    leading: Icon(Icons.local_fire_department,
                        color: Colors.red),
                    title: Text('Επιβεβαιωμένες πυρκαγιές'),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  showMenu = !showMenu;
                });
              },
              icon: Icon(showMenu ? Icons.close : Icons.menu),
              label: Text(showMenu ? 'Κλείσιμο μενού' : 'Εμφάνιση επιλογών'),
            ),
          ),
        ],
      ),
    );
  }
}
