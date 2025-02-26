import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Eventos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup("mis_eventos") // Obtiene todos los documentos dentro de cualquier colección "mis_eventos"
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay eventos disponibles.'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index].data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: event["image_url"] != null
                      ? Image.network(
                    event["image_url"],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.event),
                  title: Text(event["title"] ?? "Sin título"),
                  subtitle: Text(event["description"] ?? "Sin descripción"),
                  trailing: Text(
                    event["date"]?.split('T')[0] ?? "Fecha no disponible",
                  ),
                  onTap: () {
                    // Al presionar, se abre la pantalla de detalles del evento
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(
                          event: event,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event["title"] ?? "Detalles del Evento"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen en la parte superior
            event["image_url"] != null
                ? Image.network(
              event["image_url"],
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25, // 25% de la pantalla
              fit: BoxFit.cover,
            )
                : Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              color: Colors.grey,
              child: const Icon(
                Icons.image_not_supported,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            // Título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                event["title"] ?? "Sin título",
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Fecha del evento
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Fecha: ${event["date"]?.split('T')[0] ?? "No disponible"}",
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Descripción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                event["description"] ?? "Sin descripción",
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
