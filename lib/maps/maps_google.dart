import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const String _googleApiKey = 'AIzaSyDN6oYrSPCNj2rD5oa9GCqahkIpPXS33eI';
  Set<Marker> _markers = {}; // Conjunto de marcadores para el mapa
  LatLng _initialPosition = const LatLng(5.33775, -72.39586); // Coordenadas de Yopal, Casanare, Colombia
  bool _loadingMarkers = true;

  @override
  void initState() {
    super.initState();
    _loadMarkersFromDatabase();
  }

  /// Carga las direcciones y nombres de la base de datos y genera marcadores
  Future<void> _loadMarkersFromDatabase() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('mapas').get();

      if (snapshot.docs.isNotEmpty) {
        Set<Marker> markers = {};

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final address = data['address'] as String?;
          final userName = data['name'] as String?; // Nombre del usuario empresarial

          if (address != null && address.isNotEmpty && userName != null && userName.isNotEmpty) {
            final coordinates = await _getCoordinatesFromAddress(address);
            if (coordinates != null) {
              markers.add(
                Marker(
                  markerId: MarkerId(doc.id),
                  position: coordinates,
                  infoWindow: InfoWindow(
                    title: userName,
                    snippet: address,
                  ),
                ),
              );

              // Actualiza la posición inicial al primer marcador si no se ha configurado previamente
              if (_markers.isEmpty) {
                _initialPosition = coordinates;
              }
            }
          }
        }

        setState(() {
          _markers = markers;
          _loadingMarkers = false;
        });
      } else {
        setState(() {
          _loadingMarkers = false;
        });
      }
    } catch (e) {
      print('Error al cargar las direcciones y nombres desde la base de datos: $e');
      setState(() {
        _loadingMarkers = false;
      });
    }
  }

  /// Obtiene las coordenadas a partir de una dirección usando la API de Google Maps
  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        } else {
          print('No se encontraron resultados para la dirección: $address.');
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener coordenadas para $address: $e');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa con múltiples marcadores'),
      ),
      body: _loadingMarkers
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 13.5,
        ),
        markers: _markers,
      ),
    );
  }
}
