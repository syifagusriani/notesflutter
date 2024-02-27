import 'package:flutter/material.dart';
import 'package:first/order/colors.dart';
import 'package:first/pages/newnote.dart';
import 'package:first/model/note.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // This widget is the root of your application.
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<Note> selectedNotes = [];
  bool arranged = false;

  @override
  void initState() {
    super.initState();
    selectedNotes = sample;
  }

  List<Note> notesBasedOnTime(List<Note> notes) {
    if (arranged) {
      notes.sort((a, b) => a.time.compareTo(b.time));
    } else {
      notes.sort((b, a) => a.time.compareTo(b.time));
    }

    arranged = !arranged;

    return notes;
  }

  void textBarSearch(String searchText) {
    setState(() {
      selectedNotes = sample
          .where((note) =>
              note.content.toLowerCase().contains(searchText.toLowerCase()) ||
              note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void delete(int index) {
    setState(() {
      Note note =
          selectedNotes[index]; //memilih notes mana sesuai di tampilan UI
      sample.remove(
          note); //note terpilih tadi sekalian dihapus baik di UI dan di local database
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 213, 225),
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 167, 167),
          title: Text('I Notes'),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  selectedNotes = notesBasedOnTime(selectedNotes);
                });
              },
              icon: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 138, 156).withOpacity(.8),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.sort, color: Colors.white),
              ),
            )
          ]),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Column(
            children: [
              TextField(
                onChanged: textBarSearch,
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 255, 134, 13)),
                decoration: InputDecoration(
                  hintText: "Search notes...",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 255, 134, 13)),
                  prefixIcon: Icon(Icons.search,
                      color: Color.fromARGB(255, 255, 134, 13)),
                  fillColor: Color.fromARGB(255, 255, 211, 167),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: selectedNotes.length,
                    itemBuilder: (context, index) {
                      int currentColor = index % shades.length;
                      return Card(
                        color: shades[currentColor],
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NewNote(note: selectedNotes[index]),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  int originalIndex =
                                      sample.indexOf(selectedNotes[index]);
                                  sample[originalIndex] = Note(
                                      //edit di offline database
                                      id: sample[originalIndex].id,
                                      title: result[0],
                                      content: result[1],
                                      time: DateTime.now());

                                  selectedNotes[index] = Note(
                                      // edit di tampilan UI
                                      id: sample[index].id,
                                      title: result[0],
                                      content: result[1],
                                      time: DateTime.now());
                                });
                              }
                            },
                            title: RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: '${selectedNotes[index].title}\n',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 92, 92, 92),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      height: 1),
                                  children: [
                                    TextSpan(
                                      text: '${selectedNotes[index].content}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 92, 92, 92),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                          height: 1.5),
                                    )
                                  ]),
                            ),
                            subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Edited: ${DateFormat('EEE MMM d, yyyy h:mm a').format(selectedNotes[index].time)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                    color:
                                        const Color.fromARGB(255, 92, 92, 92),
                                  ),
                                )),
                            trailing: IconButton(
                              onPressed: () async {
                                final hasil = await confirmDialog(context);
                                if (hasil != null && hasil) {
                                  delete(index);
                                }
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const NewNote(),
              ),
            );
            if (result != null) {
              setState(() {
                sample.add(Note(
                    id: sample.length,
                    title: result[0],
                    content: result[1],
                    time: DateTime.now()));
                selectedNotes = sample;
              });
            }
          },
          backgroundColor: Color.fromARGB(255, 255, 217, 172),
          child: const Icon(Icons.add, size: 40)),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 255, 167, 167),
            icon: const Icon(Icons.info, color: Colors.blueGrey),
            title: const Text(
              'Are you sure want to delete?',
              style: TextStyle(color: Colors.white),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent),
                      child: const SizedBox(
                        width: 60,
                        child: const Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: const SizedBox(
                        width: 60,
                        child: const Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ]),
          );
        });
  }
}
