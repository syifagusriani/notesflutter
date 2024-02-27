import 'package:flutter/material.dart';
import 'package:first/model/note.dart';

class NewNote extends StatefulWidget {
  final Note? note;
  const NewNote({super.key, this.note});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late Color colors;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.note != null) {
      titleController = TextEditingController(text: widget.note!.title);
      contentController = TextEditingController(text: widget.note!.content);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          AppBar(backgroundColor: Color.fromARGB(255, 255, 167, 167), actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 245, 138, 156).withOpacity(.8),
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Row(children: [
          Expanded(
              child: ListView(
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.black, fontSize: 30),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 30)),
              ),
              TextField(
                controller: contentController,
                style: const TextStyle(color: Colors.black, fontSize: 15),
                maxLines: null,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something here..',
                    hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 15)),
              )
            ],
          ))
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(
                context, [titleController.text, contentController.text]);
          },
          elevation: 10,
          backgroundColor: Color.fromARGB(255, 255, 217, 172),
          child: const Icon(Icons.save, size: 40)),
    );
  }
}
