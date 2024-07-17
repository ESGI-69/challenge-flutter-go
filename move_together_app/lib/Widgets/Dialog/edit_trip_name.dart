import 'package:flutter/material.dart';

class EditTripNameDialog extends StatefulWidget {
  final Function(String) onNameUpdate;

  const EditTripNameDialog({super.key, required this.onNameUpdate});

  @override
  State<EditTripNameDialog> createState() => _EditTripNameDialogState();
}

class _EditTripNameDialogState extends State<EditTripNameDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 24,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Modifier le nom du voyage',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du voyage',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onNameUpdate(_nameController.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Enregistrer'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
