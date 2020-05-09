import 'package:dailynotes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

// PADRÃO SINGLETON
class AnotacaoHelper {

  // Variáveis
  static final String nomeTabela = "anotacao";
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _db;

  // Construtores
  factory AnotacaoHelper(){

    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){

  }

// Métodos
  get db async {
    if( _db != null ){
      return _db;
    }
    else{
      _db = await iniciarDB();
      return _db;
    }
  }

  _onCreate (Database db, int version) async {
    String sql = "CREATE TABLE $nomeTabela("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        " titulo VARCHAR,"
        " descricao TEXT,"
        " data DATETIME) ";

    await db.execute(sql);
  }

  iniciarDB() async{

    final caminhoBanco = await getDatabasesPath();
    final localBanco = join(caminhoBanco, "banco_anotacoes.db");

    var db = await openDatabase(localBanco, version: 1, onCreate: _onCreate );

    return db;
  }

  Future<int> salvarDB (Anotacao anotacao) async{

    var banco = await db;

    int resultado = await banco.insert(nomeTabela, anotacao.toMap());

    return resultado;
  }

  recuperarDB() async {
    var banco = await db;
    String sql = "SELECT * FROM $nomeTabela ORDER BY data DESC";
    List anotacoes = await banco.rawQuery(sql);
    return anotacoes;
  }

  Future<int> atualizarDB (Anotacao anotacao) async{

    var banco = await db;

    return await banco.update(
        nomeTabela,
        anotacao.toMap(),
        where: "id=?",
        whereArgs: [anotacao.id]
    );
  }

  Future<int> deletarDB (int id) async{

    var banco = await db;

      return await banco.delete(
        nomeTabela,
        where: "id=?",
        whereArgs: [id]
    );

  }




} // fimClass