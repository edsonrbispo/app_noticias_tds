import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final List<Map<String, dynamic>> noticias = [
    {
      'titulo': 'Flutter 3.35 traz novidades para desenvolvedores',
      'resumo':
          'Nova versão do Flutter apresenta melhorias de desempenho e novos recursos para criação de aplicativos.',
      'categoria': 'Programação',
      'data': '23/09/2026',
    },
    {
      'titulo': 'Inteligência Artificial ganha espaço no desenvolvimento',
      'resumo':
          'Ferramentas de inteligência artificial estão sendo cada vez mais utilizadas para auxiliar no desenvolvimento de software.',
      'categoria': 'IA',
      'data': '22/09/2026',
    },
    {
      'titulo': 'Novas tecnologias prometem melhorar a segurança digital',
      'resumo':
          'Empresas estão adotando novas soluções para proteger dados e sistemas contra ataques virtuais.',
      'categoria': 'Cibersegurança',
      'data': '21/09/2026',
    },
    {
      'titulo': 'Computação em nuvem continua em crescimento',
      'resumo':
          'Serviços de computação em nuvem seguem sendo utilizados por empresas de diferentes tamanhos.',
      'categoria': 'Cloud',
      'data': '20/09/2026',
    },
    {
      'titulo': 'Novos processadores aumentam desempenho dos computadores',
      'resumo':
          'Fabricantes apresentam novos processadores com maior desempenho e eficiência energética.',
      'categoria': 'Hardware',
      'data': '19/09/2026',
    },
  ];

  static final List<String> categorias = [
    "Todas",
    "Programação",
    "Cloud",
    "Hardware",
    "Cibersegurança",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/img/logotipo.png',
          height: 20,
        ),
        centerTitle: true,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Column(
        children: [
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: categorias.map((categoria) {
                final selecionada = categoria == "Todas";

                return Container(
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
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final noticia = noticias[index];

                return Card(
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
                        color: const Color(0xFFE4E9Ef),
                        child: const Icon(Icons.image_outlined),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF4F8),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Text(noticia['categoria']),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  noticia['data'],
                                  style: const TextStyle(
                                    color: Color(0xFF858D96),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              noticia['titulo'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1b2A4A),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis, //...
                            ),
                            const SizedBox(height: 8),
                            Text(
                              noticia['resumo'],
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
