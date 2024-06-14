import 'package:flutter/material.dart';

class PopupWidget extends StatefulWidget {
  final Widget content;

  PopupWidget({required this.content});

  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,

            ),
            height: 500,
            width: 300,
            child: Column(
              children: [
                widget.content,
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le popup
                  },
                  child: const Text('Annuler'),
                ),
              ],
            ),
          ),
      ),
    );
  }
}