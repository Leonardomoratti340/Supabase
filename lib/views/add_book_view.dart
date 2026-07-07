import 'package:flutter/material.dart';
import 'package:flutter_supabase/models/book_model.dart' show BookStatus;

String _statusLabel(BookStatus status) {
  switch (status) {
    case BookStatus.nonLetto:
      return "Non letto";
    case BookStatus.inLettura:
      return "In lettura";
    case BookStatus.daLeggere:
      return "Da leggere";
    case BookStatus.lasciato:
      return "Lasciato";
    case BookStatus.nonInteressa:
      return "Non interessa";
  }
}

class AddBookView extends StatefulWidget {
  const AddBookView({super.key});

  @override
  State<AddBookView> createState() => _AddBookViewState();
}

class _AddBookViewState extends State<AddBookView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _pagesController = TextEditingController();
  final _commentController = TextEditingController();
  BookStatus? _selectedStatus;
  double _rating = 3.0;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _pagesController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // logica del salvataggio la inseriamo tra poco
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Dati validi possiamo andare avanti")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form ins libro")), // AppBar
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // form per inserire il titolo
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'titolo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'campo obbligatorio'
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _genreController,
                  decoration: InputDecoration(
                    labelText: "Genere",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _pagesController,
                  decoration: InputDecoration(
                    labelText: 'Numero di pagine',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final pages = int.tryParse(value);
                    if (pages == null || pages <= 0) {
                      return 'inserisci numero valido';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<BookStatus>(
                  initialValue: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Stato di lettura',
                    border: OutlineInputBorder(),
                  ),
                  items: BookStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(_statusLabel(status)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Seleziona uno stato di lettura" : null,
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valutazione',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          min: 1,
                          max: 5,
                          divisions: 4,
                          value: _rating,
                          onChanged: (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                        ),
                      ),
                      Text("${_rating.toStringAsFixed(0)} ⭐"),
                    ],
                  ),
                ],
              ),

              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Inserisci il commento',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),

              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(Icons.arrow_forward),
                label: Text("Continua"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
