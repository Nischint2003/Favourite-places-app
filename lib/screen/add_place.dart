import 'dart:io';

import 'package:favourite_places/Provider/user_provider.dart';
import 'package:favourite_places/models/favorite_places.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaces extends ConsumerStatefulWidget {
  const AddPlaces({super.key});

  @override
  ConsumerState<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends ConsumerState<AddPlaces> {
  final _placeNameController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void savePlace() {
    final enteredPlace = _placeNameController.text;
    if (enteredPlace.isEmpty) {
      showDialog(
        //Dailog if place name is not given

        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a valid place name.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    if (_selectedImage == null || _selectedLocation == null) {
      return;
    } else {
      ref
          .read(userPlaceProvider.notifier)
          .addPlace(enteredPlace, _selectedImage!, _selectedLocation!);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _placeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place '),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              //text field to add the name of the widget
              decoration: const InputDecoration(labelText: 'Place Name'),
              controller: _placeNameController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(height: 12),
            ImageInput(
              // Input image
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 12),
            LocationInput(
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              // Add Place Button
              onPressed: () {
                savePlace(); //function to add the place
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
