import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_master/component/background/background_with_app_bar.dart';

class OpenBidForm extends StatefulWidget {
  const OpenBidForm({super.key});

  @override
  State<OpenBidForm> createState() => _OpenBidFormState();
}

class _OpenBidFormState extends State<OpenBidForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form field controllers
  String? _itemType;
  String? _itemPackage;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  XFile? _harvestImage;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _harvestImage = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BodyWithAppBar(
      scaffoldKey: _scaffoldKey,
      title: 'Bid Form',
      widget: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Item Type', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'fruits', child: Text('Fruits')),
                    DropdownMenuItem(
                        value: 'vegetables', child: Text('Vegetables')),
                    DropdownMenuItem(value: 'all', child: Text('All')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _itemType = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select an item type' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                      labelText: 'Item Quantity', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter item quantity'
                      : null,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Packaging Type',
                      border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'box', child: Text('Box')),
                    DropdownMenuItem(value: 'none', child: Text('None')),
                    DropdownMenuItem(value: 'bags', child: Text('Bags')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _itemPackage = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a packaging type' : null,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _minPriceController,
                  decoration: const InputDecoration(
                      labelText: 'Min Price', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a minimum price'
                      : null,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    _harvestImage == null
                        ? const Text('No image selected.')
                        : Image.file(
                            File(_harvestImage!.path),
                            width: 100,
                            height: 100,
                          ),
                    IconButton(
                      icon: const Icon(Icons.upload),
                      onPressed: _pickImage,
                    ),
                    const Text('Upload Harvest Image/Video'),
                  ],
                ),
                const Divider(height: 32.0),
                const Text(
                  'Bid Close Time',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _hoursController,
                  decoration: const InputDecoration(
                      labelText: 'Hours to Close Bid',
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter the hours to close the bid'
                      : null,
                ),
                const Divider(height: 32.0),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter description',
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Perform submit action
                      final int hoursToClose = int.parse(_hoursController.text);
                      final DateTime bidCloseTime =
                          DateTime.now().add(Duration(hours: hoursToClose));
                      print('Form submitted. Bid closes at: $bidCloseTime');
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Bid'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
