import 'package:flutter/material.dart';

class NetworkErrorItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.signal_wifi_connected_no_internet_4,
              color: Colors.red,
              size: 100,
            ),
            SizedBox(height: 30),
            Text(
              'Sin conexión',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Revise su conexión a internet.\nNo se puede ver cursos y tareas.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
