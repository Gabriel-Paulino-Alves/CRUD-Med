import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MedicamentosApp());
}

class MedicamentosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Medicamentos',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16, color: Colors.teal[900]), // Substituído bodyText1
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[800]), // Substituído bodyText2
        ),
      ),
      home: MedicamentosScreen(),
    );
  }
}

class MedicamentosScreen extends StatefulWidget {
  @override
  _MedicamentosScreenState createState() => _MedicamentosScreenState();
}

class _MedicamentosScreenState extends State<MedicamentosScreen> {
  List medicamentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMedicamentos();
  }

  Future<void> fetchMedicamentos() async {
    final response =
        await http.get(Uri.parse('https://arquivos.ectare.com.br/medicamentos.json'));
    if (response.statusCode == 200) {
      setState(() {
        medicamentos = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Erro ao carregar medicamentos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicamentos'),
        centerTitle: true,
        leading: Icon(Icons.local_pharmacy),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: medicamentos.length,
              itemBuilder: (context, index) {
                final medicamento = medicamentos[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(Icons.medical_services_outlined, color: Colors.teal),
                    title: Text(
                      medicamento['nome'] ?? 'Nome desconhecido',
                      style: Theme.of(context).textTheme.bodyLarge, // Atualizado
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipo: ${medicamento['tipo'] ?? 'N/A'}'),
                        Text('Uso: ${medicamento['uso'] ?? 'N/A'}'),
                        Text('Classe: ${medicamento['classe'] ?? 'N/A'}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
                  ),
                );
              },
            ),
    );
  }
}
