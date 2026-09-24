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
        ],
      ),
    );
  }
}
