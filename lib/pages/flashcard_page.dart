import 'package:codecard/widgets/colorpicker.dart';
import 'package:codecard/widgets/flashcard.dart';
import 'package:codecard/widgets/folder.dart';
import 'package:codecard/widgets/left_sidebar.dart';
import 'package:codecard/widgets/suchleiste.dart';
import 'package:flutter/material.dart';

class FlashcardPage extends StatefulWidget {
  final Folder folder;

  const FlashcardPage({Key? key, required this.folder}) : super(key: key);

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  List<Flashcard> flashcards = [];
  String searchTerm = "";
  int currentCardIndex = 0;

  Future<void> _showCreateFlashcardDialog(
      {Flashcard? existingFlashcard}) async {
    String frontCaption = existingFlashcard?.frontCaption ?? "";
    String backCaption = existingFlashcard?.backCaption ?? "";
    Color selectedColor = existingFlashcard?.color ?? Color(0xFFFfd4a4a);

    TextEditingController frontCaptionController =
        TextEditingController(text: frontCaption);
    TextEditingController backCaptionController =
        TextEditingController(text: backCaption);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            existingFlashcard == null
                ? "Karteikarte erstellen"
                : "Karteikarte bearbeiten",
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: frontCaptionController,
                    maxLength: 35,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState?.validate();
                      });
                      frontCaption = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte gib einen Text für die Vorderseite ein.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Text für die Vorderseite',
                      counterText: "",
                      errorText: formKey.currentState?.validate() == false
                          ? 'Bitte gib einen Text für die Vorderseite ein.'
                          : null,
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle: TextStyle(color: Colors.white),
                      suffixStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: backCaptionController,
                    maxLength: 35,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState?.validate();
                      });
                      backCaption = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte gib einen Text für die Rückseite ein.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Text für die Rückseite',
                      counterText: "",
                      errorText: formKey.currentState?.validate() == false
                          ? 'Bitte gib einen Text für die Rückseite ein.'
                          : null,
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle: TextStyle(color: Colors.white),
                      suffixStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text("Farbe auswählen:",
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  ColorPicker(
                    onColorSelected: (color) {
                      selectedColor = color;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
  ButtonBar(
    alignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Abbrechen', style: TextStyle(color: Colors.white)),
      ),
      ElevatedButton(
        onPressed: () {
          if (formKey.currentState?.validate() == true) {
            if (existingFlashcard == null) {
              // Erstelle eine neue Karteikarte
              setState(() {
                flashcards.add(Flashcard(
                  frontCaption: frontCaption,
                  backCaption: backCaption,
                  color: selectedColor,
                ));
              });
            } else {
              // Aktualisiere die vorhandene Karteikarte
              setState(() {
                existingFlashcard.frontCaption = frontCaption;
                existingFlashcard.backCaption = backCaption;
                existingFlashcard.color = selectedColor;
              });
            }
            Navigator.of(context).pop();
          }
        },
        child: Text('Erstellen', style: TextStyle(color: Colors.white)),
      ),
    ],
  ),
],

        );
      },
    );
  }

  Future<void> _showDeleteFlashcardDialog(Flashcard karteikarte) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Karteikarte löschen',
              style: TextStyle(color: Colors.white)),
          content: Text(
              'Bist du sicher, dass du die Karteikarte löschen möchtest?',
              style: TextStyle(color: Colors.white)),
          actions: [
  ButtonBar(
    alignment: MainAxisAlignment.spaceBetween, // Adjust alignment as needed
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Abbrechen', style: TextStyle(color: Colors.white)),
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            flashcards.remove(karteikarte);
          });
          Navigator.of(context).pop();
        },
        child: Text('Löschen', style: TextStyle(color: Colors.white)),
      ),
    ],
  ),
],

        );
      },
    );
  }

  void _startQuiz() {
    if (flashcards.isNotEmpty) {
      setState(() {
        currentCardIndex = 0;
      });
      _showQuizDialog();
    }
  }

  void _showQuizDialog() {
    bool showFront = true; // To toggle between front and back captions

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Abfrage starten',
                  style: TextStyle(color: Colors.white)),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showFront = !showFront;
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: showFront
                        ? _buildFlashcardSide(
                            flashcards[currentCardIndex].frontCaption,
                            flashcards[currentCardIndex].color,
                          )
                        : _buildFlashcardSide(
                            flashcards[currentCardIndex].backCaption,
                            flashcards[currentCardIndex].color,
                          ),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (currentCardIndex > 0) {
                      setState(() {
                        currentCardIndex--;
                        showFront =
                            true; // Reset to front when moving to the previous card
                      });
                    }
                  },
                  child: Text('Zurück', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentCardIndex < flashcards.length - 1) {
                      setState(() {
                        currentCardIndex++;
                        showFront =
                            true; // Reset to front when moving to the next card
                      });
                    }
                  },
                  child: Text('Weiter', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFlashcardSide(String caption, Color color) {
    return RotatedBox(
      quarterTurns: 0, // Set to 1 for a 90-degree turn, 2 for 180 degrees, etc.
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            caption,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardTile(Flashcard karteikarte) {
    return GestureDetector(
      onTap: () {
        _showCreateFlashcardDialog(existingFlashcard: karteikarte);
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: karteikarte.color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text("Bearbeiten"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Löschen"),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    _showCreateFlashcardDialog(existingFlashcard: karteikarte);
                  } else if (value == 2) {
                    _showDeleteFlashcardDialog(karteikarte);
                  }
                },
              ),
            ),
          ),
          Center(
            child: Text(
              karteikarte.frontCaption,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFlashcardMessage() {
    return Center(
      child: Text(
        'Klicke auf das +, um eine neue Karteikarte zu erstellen',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            LeftSideBar(),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF2c293a),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Suchleiste(
                          onSearch: (term) {
                            setState(() {
                              searchTerm = term;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 96, 92, 100),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add, color: Colors.black),
                                onPressed: () {
                                  _showCreateFlashcardDialog();
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 96, 92, 100),
                              ),
                              child: IconButton(
                                icon:
                                    Icon(Icons.play_arrow, color: Colors.black),
                                onPressed: () {
                                  _startQuiz();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    flashcards.isEmpty
                        ? _buildEmptyFlashcardMessage()
                        : Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: flashcards
                                  .where((karteikarte) => karteikarte
                                      .frontCaption
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()))
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                Flashcard karteikarte = flashcards
                                    .where((karteikarte) => karteikarte
                                        .frontCaption
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()))
                                    .toList()[index];
                                return _buildFlashcardTile(karteikarte);
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
