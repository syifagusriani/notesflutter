class Note {
  int id;
  String title;
  String content;
  DateTime time;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
  });

  get context => null;
}

List<Note> sample = [
  Note(
      id: 0,
      title: 'Note 1',
      content: 'Catatan pertama dalam contoh',
      time: DateTime(2023, 12, 31, 13, 26)),
  Note(
      id: 1,
      title: 'Note 2',
      content: 'Catatan kedua dalam contoh',
      time: DateTime(2023, 12, 20, 13, 26)),
  Note(
      id: 2,
      title: 'Note 3',
      content: 'Catatan ketiga dalam contoh',
      time: DateTime(2023, 12, 20, 13, 26)),
  Note(
      id: 3,
      title: 'Note 4',
      content: 'Catatan keempat dalam contoh',
      time: DateTime(2023, 12, 20, 13, 26)),
];
