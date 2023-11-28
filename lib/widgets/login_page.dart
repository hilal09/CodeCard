import 'package:flutter/material.dart'; //import von packages

//StatefulWidget (zustand derseite kann sich ändern)
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState(); //erstellt zugehöriges state-objekt, verwaltet zustand der seite
}
//zustand für loginPage wird definiert
class _LoginPageState extends State<LoginPage> {
  bool isAnmeldenTab = true; //damit kann man den ausgewählten tab verfolgen

  //build methode, erstellt ui der seite
  @override
  Widget build(BuildContext context) {
    return Scaffold( //grundgerüst???
      appBar: AppBar( //app leiste
        title: Text(
          'Code Card', //titel code card
          style: TextStyle(color: Colors.white), //weisser text
        ),
        backgroundColor: Color(0xFF2c293a), //hintergrundfarbe
        elevation: 0,
      ),
      body: Container( //body container, hauptinhalt der seite
        color: Color(0xFF2c293a), //hintergrundfarbe
        padding: EdgeInsets.all(16.0), //abstand zwischen ui elementen
        child: Column( //widget wird verwendet um widgets vertikal anzuordnen
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row( //buttons für anmelden und registrieren
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTabButton('Anmelden', true),
                buildTabButton('Registrieren', false),
              ],
            ),
            SizedBox(height: 20),
            TextField( //textfeld für email
              style: TextStyle(color: Colors.white), // Textfarbe weiß setzen
              decoration: InputDecoration(
                labelText: 'E-mail Adresse',
                prefixIcon: Icon(Icons.mail, color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField( //textfeld für passwort
              style: TextStyle(color: Colors.white), // Textfarbe weiß setzen
              decoration: InputDecoration(
                labelText: 'Passwort',
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true, //passwort verbergen
            ),
            SizedBox(height: 20),
            ElevatedButton( //erhebener button für bestätigung
              onPressed: () { //
                // ANMELDELOGIK FEHLT!!! FIREBASE!!!
                print('Bestätigen erfolgreich');
              },
              style: ElevatedButton.styleFrom( //button stil
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                primary: Color(0xFF10111a), //farbe
              ),
              child: Container(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Bestätigen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabButton(String text, bool isSelected) { //funktion für tab buttons
    return ElevatedButton( //tab wird hervorgehoben
      onPressed: () {
        setState(() {
          isAnmeldenTab = isSelected;
        });
      },
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Color(0xFF10111a) : Color(0xFF2c293a),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
        ),
      ),
    );
  }
}
