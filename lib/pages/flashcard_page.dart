import 'package:codecard/widgets/colorpicker.dart';
import 'package:codecard/widgets/flashcard.dart';
import 'package:codecard/widgets/folder.dart';
import 'package:codecard/widgets/left_sidebar.dart';
import 'package:codecard/widgets/suchleiste.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class FlashcardPage extends StatefulWidget {
  final Folder folder;

  const FlashcardPage({Key? key, required this.folder}) : super(key: key);

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  AuthService authService = AuthService(); // Instantiate AuthService

  List<Flashcard> flashcards = [];
  List<Flashcard> incorrectlyAnswered = [];
  String searchTerm = "";
  int currentCardIndex = 0;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    _fetchUserFlashcards();
  }

  Future<void> _fetchUserFlashcards() async {
    try {
      // Assuming you have a method in AuthService to get user's flashcards
      List<Flashcard> userFlashcards =
      await authService.getUserFlashcards(widget.folder.id);

      print("Fetched ${userFlashcards.length} flashcards for folder ${widget.folder.id}");

      setState(() {
        flashcards.clear(); // Clear existing flashcards
        flashcards.addAll(userFlashcards); // Add newly fetched flashcards
      });
    } catch (e) {
      print("Error fetching user flashcards: $e");
      // Handle error fetching user flashcards
    }
  }

  Future<void> _showCreateFlashcardDialog({
    Flashcard? existingFlashcard,
    required AuthService authService,
  }) async {
    String frontCaption = existingFlashcard?.frontCaption ?? "";
    String backCaption = existingFlashcard?.backCaption ?? "";
    Color selectedColor =
        existingFlashcard?.color ?? const Color(0xFFFfd4a4a);

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
            existingFlashcard == null ? "Erstelle Karteikarte" : "Bearbeite Karteikarte",
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
                    maxLines: null, // Erlaube beliebig viele Zeilen
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState?.validate();
                      });
                      frontCaption = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte gebe den Text für die Vorderseite ein.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Text für die Vorderseite',
                      counterText: "",
                      errorText: formKey.currentState?.validate() == false
                          ? 'Bitte gebe den Text für die Vorderseite ein.'
                          : null,
                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 93, 130)),
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
                    maxLines: null, // Erlaube beliebig viele Zeilen
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState?.validate();
                      });
                      backCaption = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bitte gebe den Text für die Hinterseite ein.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Text für die Hinterseite',
                      counterText: "",
                      errorText: formKey.currentState?.validate() == false
                          ? 'Bitte gebe den Text für die Hinterseite ein.'
                          : null,
                      labelStyle: TextStyle(color: Color.fromARGB(255, 120, 93, 130)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle: TextStyle(color: Colors.white),
                      suffixStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text("Wähle eine Farbe aus:", style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  ColorPicker(
                    onColorSelected: (color) {
                      selectedColor = color;
                    },
                    initialColor: selectedColor,
                  ),
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
                  child: Text('Abbrechen', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      if (existingFlashcard == null) {
                        final newFlashcard = Flashcard(
                          userUID: authService.currentUserUID()!,
                          frontCaption: frontCaption,
                          backCaption: backCaption,
                          color: selectedColor,
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
                      }

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Erstellen', style: TextStyle(color: Color.fromARGB(211, 106, 202, 144))),
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
              alignment: MainAxisAlignment.spaceBetween,
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
    bool showFront = true;
    List<Flashcard> incorrectCards = [];
    int currentIndex = 0;
    List<Flashcard> reviewedCards = [];
    bool allCardsReviewed = false;

    void showNextCard() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
        showFront = true;
      }
    }

    void startReview() {
      allCardsReviewed = true;
      flashcards.clear();
      flashcards.addAll(incorrectCards);
      incorrectCards.clear();
      currentIndex = 0;
      showFront = true;
      if (flashcards.isNotEmpty) {
        _showQuizDialog();
      }
    }

    void _handleReviewAction(bool isCorrect) {
      setState(() {
        reviewedCards.add(flashcards[currentIndex]);
        if (currentIndex == flashcards.length - 1) {
          startReview();
          Navigator.of(context)
              .pop(); // Schließe das Popup-Fenster, wenn die letzte Karte bearbeitet wurde
        } else {
          showNextCard();
        }
      });
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
                    _handleReviewAction(true); // Markiere als richtig
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Text('Richtig', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleReviewAction(false); // Markiere als falsch
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Falsch', style: TextStyle(color: Colors.white)),
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
        AuthService authService = AuthService(); // Instantiate AuthService

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
                color: karteikarte.color,
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
                  AuthService authService = AuthService(); // Instantiate AuthService
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
                                  AuthService authService = AuthService(); // Instantiate AuthService
                                  _showCreateFlashcardDialog(authService: authService,);
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
                      child: GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 4,  // Anzahl der Karten in einer Zeile
  crossAxisSpacing: 10, // Horizontaler Abstand zwischen den Karten
  mainAxisSpacing: 5,  // Vertikaler Abstand zwischen den Karten
  childAspectRatio: 1.5, // Seitenverhältnis der Karten (Länge / Höhe)
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
