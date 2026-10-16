import 'package:app_noticias/detalhe_noticia_page.dart';
import 'package:app_noticias/models/noticia.dart';
import 'package:app_noticias/services/noticias_service.dart';
import 'package:app_noticias/sobre_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoticiasService _noticiasService = NoticiasService();
  late Future<List<Noticia>> _listaNoticias;

  bool _buscando = false;
  String _textoPesquisa = '';
  String _categoriaSelecionada = 'Todas';

  // Pesquisa em todas as categorias OU filtra pela categoria selecionada
  List<Noticia> aplicarFiltro(List<Noticia> noticias) {
    if (_textoPesquisa.isNotEmpty) {
      return noticias.where((noticia) {
        return noticia.titulo.toLowerCase().contains(
              _textoPesquisa.toLowerCase(),
            ) ||
            noticia.resumo.toLowerCase().contains(_textoPesquisa.toLowerCase());
      }).toList();
    }

    if (_categoriaSelecionada != 'Todas') {
      return noticias.where((noticia) {
        return noticia.categoriaNome == _categoriaSelecionada;
      }).toList();
    }

    return noticias;
  }

  @override
  void initState() {
    super.initState();
    _listaNoticias = _noticiasService.getNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buscando
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar...',
                ),
                onChanged: (valor) {
                  setState(() {
                    _textoPesquisa = valor;
                  });
                },
              )
            : Image.asset(
                'assets/img/logotipo.png',
                height: 20,
              ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(_buscando ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _buscando = !_buscando;
                  if (!_buscando) _textoPesquisa = '';
                });
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              child: Image.asset(
                'assets/img/logotipo.png',
                height: 24,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Lista de Notícias'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SobrePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Noticia>>(
        future: _listaNoticias,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (asyncSnapshot.hasError) {
            return Center(
              child: Text('${asyncSnapshot.error}'),
            );
          }

          final todasNoticias = asyncSnapshot.data ?? <Noticia>[];

          // Categorias obtidas das notícias da API
          final categorias = [
            'Todas',
            ...todasNoticias.map((noticia) => noticia.categoriaNome).toSet(),
          ];

          // Chama a função de filtro
          final noticias = aplicarFiltro(todasNoticias);

          return Column(
            children: [
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  children: categorias.map((categoria) {
                    final selecionada = categoria == _categoriaSelecionada;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _categoriaSelecionada = categoria;
                          _textoPesquisa = '';
                          _buscando = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selecionada
                                ? Colors.black
                                : const Color(0xFFEDEDED),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          categoria,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: noticias.isEmpty
                    ? const Center(
                        child: Text('Nenhuma notícia encontrada.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: noticias.length,
                        itemBuilder: (context, index) {
                          final noticia = noticias[index];

                          return InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalheNoticiaPage(
                                  noticia: noticia,
                                ),
                              ),
                            ),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 0,
                              color: Colors.white,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color(0xFFCBD2D9),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 120,
                                    color: const Color(0xFFE4E9EF),
                                    child:
                                        noticia.imagem != null &&
                                            noticia.imagem!.isNotEmpty
                                        ? Image.network(
                                            noticia.imagem!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, erro, stack) =>
                                                    const Icon(
                                                      Icons.image_outlined,
                                                    ),
                                          )
                                        : const Icon(Icons.image_outlined),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEFF4F8),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Text(
                                                noticia.categoriaNome,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              noticia.dataFormatada,
                                              style: const TextStyle(
                                                color: Color(0xFF858D96),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          noticia.titulo,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1B2A4A),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          noticia.resumo,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF5B6B79),
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
