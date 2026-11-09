import 'dart:convert';
import 'dart:io';

import 'package:app_noticias/services/login_service.dart';
import 'package:http/http.dart' as http;
import '../models/noticia.dart';

class NoticiasService {
  final LoginService _loginService = LoginService();
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Noticia>> getNoticias() async {
    try {
      final resposta = await http.get(Uri.parse('$baseUrl/noticias'));
      if (resposta.statusCode == 200) {
        final List dados = jsonDecode(resposta.body);
        return dados.map((item) => Noticia.fromJson(item)).toList();
      } else {
        throw 'Não foi possivel carregar as notícias';
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<void> criarNoticia({
    required String titulo,
    required String resumo,
    required String conteudo,
    required int categoriaId,
    File? imagemArquivo,
  }) async {
    try {
      final token = await _loginService.getToken();

      final int status;

      if (imagemArquivo != null) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/noticias'),
        );
        request.headers['Accept'] = 'application/json';
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['titulo'] = titulo;
        request.fields['resumo'] = resumo;
        request.fields['conteudo'] = conteudo;
        request.fields['categoria_id'] = categoriaId.toString();
        request.files.add(
          await http.MultipartFile.fromPath('imagem', imagemArquivo.path),
        );
      } else {}
    } catch (e) {
      throw Exception('$e');
    }
  }
}
