/* 
DateiName: flashcard_page.dart
Authors: Hilal Cubukcu(UI, Funktionalität), Amara Akram (Abfragelogik), Ceyda Sariouglu (UI, Funktionalität), Arkan Kadir (Firebase)
Zuletzt bearbeitet am: 08.01.2024
Beschreibung: Dieses Stateful Widget ist für die Darstellung und Verwaltung von Karteikarten (Flashcards) innerhalb eines bestimmten Ordners (Folder) zuständig.
Hauptfunktionen:
- Abrufen der Karteikarten eines Benutzers von einem Firestore-Dienst (`_fetchUserFlashcards`).
- Erstellen neuer Karteikarten und Bearbeiten bestehender Karteikarten durch einen Dialog (`_showCreateFlashcardDialog`).
- Löschen von Karteikarten über einen Dialog (`_showDeleteFlashcardDialog`).
- Durchführung einer Quiz-Funktion (`_startQuiz`), die die Benutzerinteraktion mit den Karteikarten ermöglicht.
- Darstellung von Karteikartendetails und Interaktionsoptionen, einschließlich der Möglichkeit, Karteikarten zu bearbeiten und zu löschen.
- Suchfunktionalität, die es Benutzern ermöglicht, Karteikarten basierend auf ihrem Inhalt zu filtern (`Suchleiste`).
- Implementiert den Leitner-Algorithmus, eine bekannte Methode zum effizienten Lernen und Wiederholen von Karteikarten. Der Algorithmus hilft, den Fortschritt des Benutzers zu verfolgen und Karteikarten basierend auf früheren Antworten zu organisieren.
- Enthält Logik für Benutzerinteraktionen und dynamische Anzeige von Inhalten basierend auf dem aktuellen Status der Karteikarten.
 Dieses Widget bildet eine Schlüsselkomponente der Benutzeroberfläche der App und ermöglicht eine dynamische und interaktive Lernerfahrung.
 Die Seite dient als interaktives Element für Benutzer, um mit ihren Lerninhalten effektiv zu arbeiten. Der Fokus liegt auf der Handhabung von Daten
(Hinzufügen, Bearbeiten, Löschen von Karteikarten) sowie der Benutzerinteraktion mit diesen Daten.
*/

import 'package:codecard/widgets/flashcard.dart';
import 'package:codecard/widgets/folder.dart';
import 'package:codecard/widgets/left_sidebar.dart';
import 'package:codecard/widgets/suchleiste.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

enum ReviewAction {
  AllFlashcards,
  Right,
  Wrong,
  Skip,
}

class FlashcardPage extends StatefulWidget {
  final Folder folder;

  const FlashcardPage({Key? key, required this.folder}) : super(key: key);

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  AuthService authService = AuthService();
  static const Color placeholderColor = Colors.transparent;

  ReviewAction currentPageState = ReviewAction.AllFlashcards;
  List<Flashcard> flashcards = [];
  List<Flashcard> incorrectlyAnswered = [];
  String searchTerm = "";

  int _currentIndex = 0;
  late Color selectedColor;

  List<Flashcard> leitnerBox1 = [];
  List<Flashcard> leitnerBox2 = [];
  List<Flashcard> leitnerBox3 = [];

  @override
  void initState() {
    super.initState();
    _fetchUserFlashcards();
  }

  Future<void> _fetchUserFlashcards() async {
    try {
      List<Flashcard> userFlashcards =
          await authService.getUserFlashcards(widget.folder.id);

      print(
          "Fetched ${userFlashcards.length} flashcards for folder ${widget.folder.id}");

      setState(() {
        flashcards.clear();
        flashcards.addAll(userFlashcards);

        leitnerBox1.clear();
        leitnerBox2.clear();
        leitnerBox3.clear();
        leitnerBox1.addAll(flashcards);
      });
    } catch (e) {
      print("Error fetching user flashcards: $e");
    }
  }

  Widget _buildFlashcardsListView(List<Flashcard> flashcardsToShow) {
    return ListView.builder(
      itemCount: flashcardsToShow.length,
      itemBuilder: (context, index) {
        return _buildFlashcardTile(flashcardsToShow[index]);
      },
    );
  }

  Future<void> _showCreateFlashcardDialog({
    Flashcard? existingFlashcard,
    required AuthService authService,
  }) async {
    String frontCaption = existingFlashcard?.frontCaption ?? "";
    String backCaption = existingFlashcard?.backCaption ?? "";
    Color selectedColor = existingFlashcard?.color ?? const Color(0xFFFfd4a4a);

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
                ? "Erstelle Karteikarte"
                : "Bearbeite Karteikarte",
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                    controller: frontCaptionController,
                    maxLength: 350,
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
                    maxLength: 350,
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
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text('Abbrechen', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      if (existingFlashcard == null) {
                        final newFlashcard = Flashcard(
                          id: '',
                          userUID: authService.currentUserUID()!,
                          frontCaption: frontCaption,
                          backCaption: backCaption,
                          color: placeholderColor,
                          leitnerBox: 1,
                        );

                        await authService.addFlashcardToUser(
                          authService.currentUserUID()!,
                          widget.folder.id,
                          newFlashcard,
                        );

                        setState(() {
                          flashcards.insert(0, newFlashcard);
                        });
                      } else {
                        existingFlashcard.frontCaption = frontCaption;
                        existingFlashcard.backCaption = backCaption;
                        existingFlashcard.color = selectedColor;

                        await authService.updateFlashcardInUser(
                          authService.currentUserUID()!,
                          widget.folder.id,
                          existingFlashcard,
                        );
                      }

                      Navigator.of(context).pop();
                    }
                  },
                  child:
                      Text('Erstellen', style: TextStyle(color: Colors.green)),
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
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text('Abbrechen', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await authService.deleteFlashcardInUser(
                      authService.currentUserUID()!,
                      widget.folder.id,
                      karteikarte.id,
                    );

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
        _currentIndex = 0;
      });
      _showQuizDialog();
    }
  }

  void _showQuizDialog() {
    bool showFront = true;
    List<Flashcard> incorrectCards = [];
    int currentIndex = 0;
    List<Flashcard> reviewedCards = [];
    bool allCardsReviewed = false;

    void _showNextFlashcard() {
      setState(() {
        if (_currentIndex < flashcards.length - 1) {
          _currentIndex++;
        } else {}
      });
    }

    void startReview() {
      if (flashcards.isNotEmpty) {
        setState(() {
          allCardsReviewed = true;
          flashcards.clear();
          flashcards.addAll(incorrectCards);
          incorrectCards.clear();
          currentIndex = 0;
          showFront = true;
        });

        _showQuizDialog();
      }
    }

    void _handleReviewAction(ReviewAction action) async {
      try {
        String uid = AuthService().currentUserUID()!;
        String folderId = widget.folder.id;
        Flashcard currentFlashcard = flashcards[_currentIndex];

        switch (action) {
          case ReviewAction.Right:
            currentFlashcard.leitnerBox++;
            currentFlashcard.color = Colors.green;
            break;
          case ReviewAction.Wrong:
            currentFlashcard.leitnerBox = 1;
            currentFlashcard.color = Colors.red;
            break;
          case ReviewAction.Skip:
            currentFlashcard.leitnerBox = 1;
            currentFlashcard.color = Colors.grey;
            break;
          default:
            break;
        }

        await AuthService().updateFlashcardInUser(
          uid,
          folderId,
          currentFlashcard,
        );

        _showNextFlashcard();
      } catch (e) {
        print('Error handling review action: $e');
      }
    }

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
                            flashcards[currentIndex].frontCaption,
                            flashcards[currentIndex].color,
                          )
                        : _buildFlashcardSide(
                            flashcards[currentIndex].backCaption,
                            flashcards[currentIndex].color,
                          ),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    _handleReviewAction(ReviewAction.Right);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Text('Richtig', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleReviewAction(ReviewAction.Wrong);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Falsch', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleReviewAction(ReviewAction.Skip);
                    _showNextFlashcard();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Text('Überspringen',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      if (allCardsReviewed) {
        Navigator.of(context).pop();
      }
    });
  }

  Widget _buildFlashcardSide(String caption, Color color) {
    return RotatedBox(
      quarterTurns: 0,
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
        AuthService authService = AuthService();
        _showCreateFlashcardDialog(
          existingFlashcard: karteikarte,
          authService: authService,
        );
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: karteikarte.color ?? placeholderColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _truncateText(karteikarte.frontCaption, 150),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Align(
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
                  AuthService authService = AuthService();
                  _showCreateFlashcardDialog(
                    existingFlashcard: karteikarte,
                    authService: authService,
                  );
                } else if (value == 2) {
                  _showDeleteFlashcardDialog(karteikarte);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + '...';
    }
  }

  Widget _buildEmptyFlashcardMessage() {
    return const SizedBox(
      height: 450,
      child: Center(
        child: Text(
          'Klick auf das + Zeichen, um ein neues Set zu erstellen.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildLeitnerBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLeitnerBox("Box 1", leitnerBox1),
        _buildLeitnerBox("Box 2", leitnerBox2),
        _buildLeitnerBox("Box 3", leitnerBox3),
      ],
    );
  }

  Widget _buildLeitnerBox(String title, List<Flashcard> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
        Container(
            height: 100,
            width: 100,
            color: Colors.grey,
            child: ListView.builder(
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                if (flashcards[index].color == Colors.green) {
                  return _buildFlashcardTile(flashcards[index]);
                } else {
                  return SizedBox.shrink();
                }
              },
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (currentPageState) {
      case ReviewAction.AllFlashcards:
        content = _buildFlashcardsListView(flashcards);
        break;
      case ReviewAction.Right:
        content = _buildFlashcardsListView(flashcards
            .where((flashcard) => flashcard.color == Colors.green)
            .toList());
        break;
      case ReviewAction.Wrong:
        content = _buildFlashcardsListView(flashcards
            .where((flashcard) => flashcard.color == Colors.red)
            .toList());
        break;
      case ReviewAction.Skip:
        content = _buildFlashcardsListView(flashcards
            .where((flashcard) => flashcard.color == Colors.grey)
            .toList());
        break;
    }

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
                                  AuthService authService = AuthService();
                                  _showCreateFlashcardDialog(
                                    authService: authService,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(234, 78, 116, 97),
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
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Richtige Antworten',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 400,
                                        child: _buildFlashcardsListView(
                                            flashcards),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Falsche Antworten',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 400,
                                        child: _buildFlashcardsListView(
                                            flashcards),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Übersprungene Antworten',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 400,
                                        child: _buildFlashcardsListView(
                                            flashcards),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
