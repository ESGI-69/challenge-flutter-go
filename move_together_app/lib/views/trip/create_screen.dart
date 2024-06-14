import 'package:flutter/material.dart';
import 'package:move_together_app/core/services/api_services.dart';
import 'package:go_router/go_router.dart';
import 'package:move_together_app/Widgets/Button/button_back.dart';
import 'package:move_together_app/Widgets/Popup/pop_up.dart';

class CreateTripScreen extends StatefulWidget {
  @override
  _CreateTripScreenState createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _departureController = TextEditingController();
  int _voyageurCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
        padding: EdgeInsets.only(left: 16.0),
         child: Row(
          children: [
            ButtonBack(),
          ],
        ),
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nouveau Voyage', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Text('Où veux-tu aller ?', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        hintText: 'Ville, pays, région...',
                        prefixIcon: Icon(Icons.place, color: Color(0xFF79D0BF)),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        ),
                      ),
                  ),
                  const SizedBox(height: 5),
                    const Text('Quelle est la ville de départ (optionnel) ?', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                      hintText: 'Adresse, gare ou aéroport...',
                      prefixIcon: Icon(Icons.home, color: Color(0xFF79D0BF)),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  const Text('Plus d\'infos', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: ElevatedButton.icon(
                       onPressed: () {
                          showDialog(context: context, builder: 
                            (BuildContext context) {
                             return Text('Saisir la date de départ et de retour de ton voyage');
                            },
                          );
                        },
                      icon: Icon(Icons.calendar_month),
                      label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(width: 5),
                  ),
                  Expanded(
                    flex: 10,
                    child: ElevatedButton.icon(
                       onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PopupWidget(
                                content: Container(
                                  child: 
                                    Text('Saisir le nom d\'utilisateur ou l\'adresse e-mail du voyageur de la personne que tu souhaites inviter'),
                                ),
                              );
                            },
                          );
                        },
                      icon: Icon(Icons.person),
                      label: Text('Voyageur ($_voyageurCount)', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
            ),
            const SizedBox(height: 5),
            ElevatedButton(
                  onPressed: () {
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF79D0BF)),               
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(vertical:  10.0)
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 0)),
                ),
                  child: const Text('Ajoute un voyage'),
            ),
          ],
        ),
      ),
    );
  }
}