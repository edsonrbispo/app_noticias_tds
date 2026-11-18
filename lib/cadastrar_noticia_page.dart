import 'dart:io';

import 'package:app_noticias/models/categoria.dart';
import 'package:app_noticias/models/noticia.dart';
import 'package:app_noticias/services/categorias_services.dart';
import 'package:app_noticias/services/noticias_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CadastrarNoticiaPage extends StatefulWidget {
  final Noticia? noticia;
  const CadastrarNoticiaPage({super.key, this.noticia});

  @override
  State<CadastrarNoticiaPage> createState() => _CadastrarNoticiaPageState();
}

class _CadastrarNoticiaPageState extends State<CadastrarNoticiaPage> {
  final NoticiasService _noticiasService = NoticiasService();
  final CategoriasService _categoriasService = CategoriasService();

  final _tituloController = TextEditingController();
  final _resumoController = TextEditingController();
  final _conteudoController = TextEditingController();

  File? _imagemSelecionada;
  List<Categoria> _categorias = [];
  int? _categoriaSelecionadaId;
  final bool _status = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    carregarCategorias();
  }

  Future<void> carregarCategorias() async {
    try {
      final categorias = await _categoriasService.getCategorias();

      if (!mounted) return;

      setState(() {
        _categorias = categorias;
      });
    } catch (e) {
      debugPrint('Erro ao carregar categorias: $e');
    }
  }

  Future<void> _salvarNoticia() async {
    if (_tituloController.text.isEmpty ||
        _resumoController.text.isEmpty ||
        _conteudoController.text.isEmpty ||
        _categoriaSelecionadaId == null ||
        (widget.noticia == null && _imagemSelecionada == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios'),
        ),
      );
      return;
    }

    try {
      if (widget.noticia == null) {
        //cadastrar
        await _noticiasService.criarNoticia(
          titulo: _tituloController.text,
          resumo: _resumoController.text,
          conteudo: _conteudoController.text,
          categoriaId: _categoriaSelecionadaId!,
          status: _status,
          imagemArquivo: _imagemSelecionada,
        );
      } else {
        //editar
        await _noticiasService.editarNoticia(
          id: widget.noticia!.id,
          titulo: _tituloController.text,
          resumo: _resumoController.text,
          conteudo: _conteudoController.text,
          categoriaId: _categoriaSelecionadaId!,
          status: _status,
          imagemArquivo: _imagemSelecionada,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.noticia == null
                ? 'Notícia Cadastrada com sucesso!'
                : 'Notícia atualizada com sucesso!',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao cadastrar a notícia.'),
        ),
      );
    }
  }

  Future<void> _selecionarImagem(ImageSource origem) async {
    final XFile? foto = await _picker.pickImage(
      source: origem,
      imageQuality: 80,
    );

    if (foto != null) {
      setState(() {
        _imagemSelecionada = File(foto.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Notícia'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          TextFormField(
            controller: _tituloController,
            decoration: const InputDecoration(
              labelText: 'Título',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _resumoController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Resumo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            controller: _conteudoController,
            maxLines: 6,
            decoration: const InputDecoration(
              labelText: 'Conteúdo',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            'Imagem de Capa',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFD7D7D7),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: _imagemSelecionada != null
                ? Image.file(
                    _imagemSelecionada!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : (widget.noticia != null && widget.noticia!.imagem != null)
                ? Image.network(
                    widget.noticia!.imagem!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, erro, stack) => const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _selecionarImagem(ImageSource.camera);
                  },
                  icon: const Icon(
                    Icons.camera_alt,
                  ),
                  label: const Text('Câmera'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _selecionarImagem(ImageSource.gallery);
                  },
                  icon: const Icon(
                    Icons.photo_library,
                  ),
                  label: const Text('Galeria'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Categoria',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
            initialValue: _categoriaSelecionadaId,
            items: _categorias.map((categoria) {
              return DropdownMenuItem(
                value: categoria.id,
                child: Text(categoria.nome),
              );
            }).toList(),
            onChanged: (valor) {
              _categoriaSelecionadaId = valor;
            },
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Publicar notícia'),
          ),
        ],
      ),
    );
  }
}
