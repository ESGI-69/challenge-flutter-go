import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_together_app/Provider/auth_provider.dart';
import 'package:move_together_app/Widgets/Input/cool_text_field.dart';
import 'package:move_together_app/core/models/note.dart';
import 'package:move_together_app/core/services/note_service.dart';

class NoteCreateModal extends StatefulWidget {
  final Function(Note) onNoteCreated;
  final int tripId;

  const NoteCreateModal({
    super.key,
    required this.onNoteCreated,
    required this.tripId,
  });

  @override
  State<NoteCreateModal> createState() => _NoteCreateModalState();
}

class _NoteCreateModalState extends State<NoteCreateModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void createNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      return;
    }
    final createdNote = await NoteService(context.read<AuthProvider>()).create(
      tripId: widget.tripId,
      title: _titleController.text,
      content: _contentController.text,
    );
    widget.onNoteCreated(createdNote);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const SizedBox(height: 8),
              CoolTextField(
                controller: _titleController,
                hintText: 'Titre',
                prefixIcon: Icons.title,
              ),
              const SizedBox(height: 8),
              CoolTextField(
                controller: _contentController,
                hintText: 'Contenu',
                prefixIcon: Icons.text_fields,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: createNote,
                style: _titleController.text.isEmpty || _contentController.text.isEmpty
                    ? ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.grey),
                )
                    : ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).primaryColor),
                ),
                child: const Text(
                  'Créer',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ]
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
              color: Colors.black38,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Expanded(child:
              Text(
                'Créer une note',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              )
            ],
          ),
        ],
      ),
    );
  }
}