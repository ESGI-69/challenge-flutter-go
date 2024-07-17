import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Widgets/Input/cool_text_field.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/core/models/document.dart';
import 'package:move_together_app/core/services/document_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:move_together_app/utils/exception_to_string.dart';

class DocumentCreateModal extends StatefulWidget {
  final Function(Document) onDocumentCreated;
  final int tripId;

  const DocumentCreateModal({
    super.key,
    required this.onDocumentCreated,
    required this.tripId,
  });

  @override
  State<DocumentCreateModal> createState() => _DocumentCreateModalState();
}

class _DocumentCreateModalState extends State<DocumentCreateModal> {
  final TextEditingController _titleDocumentController =
      TextEditingController();
  final TextEditingController _descriptionDocumentController =
      TextEditingController();
  PlatformFile? _selectedFile;

  void selectDocument() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  void createDocument() async {
    if (_titleDocumentController.text.isEmpty ||
        _descriptionDocumentController.text.isEmpty ||
        _selectedFile == null) {
      return;
    }

    try {
      final createdDocument =
          await DocumentService(context.read<AuthProvider>()).create(
        tripId: widget.tripId,
        title: _titleDocumentController.text,
        description: _descriptionDocumentController.text,
        document: File(_selectedFile!.path!),
      );
      widget.onDocumentCreated(createdDocument);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exceptionToString(error)),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.only(bottom: 32),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Header(),
              const SizedBox(height: 16),
              CoolTextField(
                controller: _titleDocumentController,
                hintText: 'Titre du document',
                prefixIcon: Icons.title,
              ),
              const SizedBox(height: 8),
              CoolTextField(
                controller: _descriptionDocumentController,
                hintText: 'Description du document',
                prefixIcon: Icons.description,
              ),
              const SizedBox(height: 8),
              Button(
                onPressed: selectDocument,
                child: Text(_selectedFile == null
                    ? 'Sélectionner un document'
                    : 'Document sélectionné : ${_selectedFile!.name}'),
              ),
              const SizedBox(height: 8),
              Button(
                onPressed: createDocument,
                style: _titleDocumentController.text.isEmpty ||
                        _descriptionDocumentController.text.isEmpty ||
                        _selectedFile == null
                    ? ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.black12))
                    : ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).primaryColor)),
                child: const Text(
                  'Créer le document',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Créer un nouveau document',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
