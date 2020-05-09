import 'package:dailynotes/helper/anotacaoHelper.dart';
import 'package:dailynotes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Variáveis de controller
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  // Instância da classe
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = List<Anotacao>();

  // Métodos
  _modalCadastro({Anotacao anotacao}){

    String textoSalvarAtualizar = "";
    if(anotacao == null){ //está salvando
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    }else{
      _tituloController.text = anotacao.titulo;
      _descricaoController.text = anotacao.descricao;
      textoSalvarAtualizar = "Atualizar";
    }


    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("$textoSalvarAtualizar Anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite o título...",
                  ),
                ),

                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a descrição..."
                  ),
                )
              ],
            ),

            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")
              ),

              FlatButton(
                  onPressed: (){
          _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
          },
                  child: Text(textoSalvarAtualizar)
              ),
            ],
          );
        }
    );
  }

  _recuperarAnotacao() async{

    List anotacoesRecuperadas = await _db.recuperarDB();

    List<Anotacao> listaTemporaria = List<Anotacao>();
    for( var item in anotacoesRecuperadas ){

      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);

    }

    setState(() {
      _anotacoes = listaTemporaria;
    });

    listaTemporaria = null;

    //print("Lista: " + anotacoesRecuperadas.toString());

  }

  _salvarAtualizarAnotacao( {Anotacao anotacaoSelecionada} ) async{
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;
    
  if(anotacaoSelecionada == null){ //está salvando
    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarDB( anotacao );
  } else { // está atualizando
    anotacaoSelecionada.titulo = titulo;
    anotacaoSelecionada.descricao = descricao;
    anotacaoSelecionada.data = DateTime.now().toString();
    int resultado = await _db.atualizarDB(anotacaoSelecionada);
  }

    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacao();
    Navigator.pop(context);

  }

  _formatarData(String data){

    initializeDateFormatting("pt_BR");

    //var formater = DateFormat("d/M/y");
    var formater = DateFormat.yMMMMd("pt_BR");

    DateTime dataConvertida = DateTime.parse(data);

    String dataFormatada = formater.format(dataConvertida);

    return dataFormatada;

  }

  _removerAnotacao(int id) async {

  return await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Tem certeza que quer excluir?"),

            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar")
              ),

              FlatButton(
                  onPressed: (){
                    _db.deletarDB(id);
                    _recuperarAnotacao();
                    Navigator.pop(context);
                  },
                  child: Text("Excluir")
              ),
            ],
          );
        }
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.white,

        title: Center(
          child: Text(
            'Daily Notes',
            style: GoogleFonts.rokkitt(
              textStyle: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  wordSpacing: 1,
                  letterSpacing: -0.5
              ),
            ),
          ),
          ),
        ),



      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[900],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: _modalCadastro,
      ),

      body: Container(
        margin: EdgeInsets.only(bottom: 80, right: 5, left: 5),

        child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 18),
            itemCount: _anotacoes.length,
            itemBuilder: (context, index){

               final anotacao = _anotacoes[index];

              return Card(

                color: Colors.deepPurple[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)
                ),

                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                       ListTile(
                        contentPadding: EdgeInsets.only(left: 20, top: 25, bottom: -30, right: 5),
                        title: Text(
                          anotacao.titulo,
                          style: TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3
                          )
                        ),

                        subtitle: Text(
                          anotacao.descricao,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              wordSpacing: 1,
                              letterSpacing: 1
                          ) ,
                        ),
                      ),

                      Container(
                        child: SizedBox(height: 7),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            _formatarData(anotacao.data),
                            style: TextStyle(
                              color: Colors.white,

                            ),
                          ),
                        ),
                      ),

                      // ignore: deprecated_member_use
                      ButtonTheme.bar(
                        child: ButtonBar(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.update,
                                  color: Colors.white,
                                ),
                                onPressed: (){
                                  _modalCadastro(anotacao: anotacao);
                                }
                            ),

                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: (){
                                  _removerAnotacao(anotacao.id);
                                }
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

        ),
      ),

    );
  }
}




