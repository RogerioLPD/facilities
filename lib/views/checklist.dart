import 'package:flutter/material.dart';

class MontagemChecklistScreen extends StatefulWidget {
  @override
  _MontagemChecklistScreenState createState() =>
      _MontagemChecklistScreenState();
}

class _MontagemChecklistScreenState extends State<MontagemChecklistScreen> {
  List<ItemChecklist> items = [
    ItemChecklist('Lâmpada'),
    ItemChecklist('Armário'),
    ItemChecklist('Cama'),
    ItemChecklist('Janela'),
    ItemChecklist('Cortina/Persiana'),
    ItemChecklist('Mesa'),
  ];

  bool showFinalizarButton = false; // Estado para controlar visibilidade do botão

  double getCompletionPercentage() {
    int filledItems = items.where((item) => item.checked != null).length;
    double percentage = (filledItems / items.length) * 100;
    
    // Ativa o botão "Finalizar" quando a barra de progresso chegar a 100%
    if (percentage == 100) {
      setState(() {
        showFinalizarButton = true;
      });
    } else {
      setState(() {
        showFinalizarButton = false;
      });
    }
    
    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist Sala 1'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: LinearProgressIndicator(
              value: getCompletionPercentage() / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Progresso: ${getCompletionPercentage().toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: items[index].checked != null
                            ? Color.fromARGB(255, 18, 57, 88)
                            : Color.fromARGB(255, 83, 82, 82),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(4, -2),
                      ),
                    ],
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(items[index].title),
                          ),
                          _buildStatusButton(
                            context: context,
                            text: 'Conforme',
                            color: items[index].checked ==
                                    ItemChecklistStatus.conforme
                                ? Color.fromARGB(255, 63, 131, 65)
                                : Colors.white,
                            onPressed: () {
                              setState(() {
                                items[index].checked =
                                    ItemChecklistStatus.conforme;
                                items[index].comment = '';
                              });
                            },
                          ),
                          _buildStatusButton(
                            context: context,
                            text: 'Não Conforme',
                            color: items[index].checked ==
                                    ItemChecklistStatus.naoConforme
                                ? Colors.red
                                : Colors.white,
                            onPressed: () {
                              setState(() {
                                items[index].checked =
                                    ItemChecklistStatus.naoConforme;
                                items[index].comment = '';
                              });
                              if (items[index].checked ==
                                  ItemChecklistStatus.naoConforme) {
                                _showCommentDialog(context, items[index]);
                              }
                            },
                          ),
                          _buildStatusButton(
                            context: context,
                            text: 'Inexistente',
                            color: items[index].checked ==
                                    ItemChecklistStatus.inexistente
                                ? Colors.grey
                                : Colors.white,
                            onPressed: () {
                              setState(() {
                                items[index].checked =
                                    ItemChecklistStatus.inexistente;
                                items[index].comment = '';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: showFinalizarButton
          ? FloatingActionButton.extended(
              onPressed: () {
                // Lógica para finalizar
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Finalizar Checklist'),
                      content: Text('Deseja realmente finalizar o checklist?'),
                      actions: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Finalizar'),
                          onPressed: () {
                            // Lógica para finalizar o checklist
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              label: Text('Finalizar'),
              icon: Icon(Icons.check),
            )
          : null,
    );
  }

  Widget _buildStatusButton({
    required BuildContext context,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color,
            onPrimary: Colors.black,
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(text),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Future<void> _showCommentDialog(BuildContext context, ItemChecklist item) async {
    TextEditingController commentController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comentários'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Insira um comentário',
                ),
              ),
              SizedBox(height: 16), // Espaçamento entre o TextField e o botão
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.camera_alt), // Ícone de câmera
                  SizedBox(width: 8), // Espaçamento entre o ícone e o texto
                  TextButton(
                    child: Text('Tirar Foto'),
                    onPressed: () {
                      // Lógica para tirar foto
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                setState(() {
                  item.comment = commentController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

enum ItemChecklistStatus {
  conforme,
  naoConforme,
  inexistente,
}

class ItemChecklist {
  String title;
  ItemChecklistStatus? checked;
  String comment;

  ItemChecklist(this.title)
      : checked = null,
        comment = '';
}

