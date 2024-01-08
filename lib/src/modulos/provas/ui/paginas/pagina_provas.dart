import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provadelaco/src/app_routes.dart';
import 'package:provadelaco/src/compartilhado/constantes/dados_fakes.dart';
import 'package:provadelaco/src/compartilhado/constantes/uteis.dart';
import 'package:provadelaco/src/compartilhado/widgets/termos_de_uso.dart';
import 'package:provadelaco/src/essencial/providers/usuario/usuario_provider.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/paginas/pagina_finalizar_compra.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/estados/provas_estado.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/servicos/denunciar_servico.dart';
import 'package:provadelaco/src/modulos/provas/interator/stores/provas_store.dart';
import 'package:provadelaco/src/modulos/provas/ui/widgets/card_provas.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaProvasArgumentos {
  final String idEvento;

  PaginaProvasArgumentos({required this.idEvento});
}

class PaginaProvas extends StatefulWidget {
  final PaginaProvasArgumentos argumentos;
  const PaginaProvas({super.key, required this.argumentos});

  @override
  State<PaginaProvas> createState() => _PaginaProvasState();
}

class _PaginaProvasState extends State<PaginaProvas> {
  List<ProvaModelo> provasCarrinho = [];
  List<double> valoresProvasCarrinho = [];

  TextEditingController nomeDenuncia = TextEditingController();
  TextEditingController celularDenuncia = TextEditingController();
  TextEditingController mensagemDenuncia = TextEditingController();

  bool concordaDenunciar = false;

  void adicionarNoCarrinho(ProvaModelo prova, EventoModelo evento) {
    // Irá permitir escolher so um pacote por prova
    if (evento.liberacaoDeCompra == '1') {
      var valoresDuplicados = provasCarrinho.where((element) => element.id == prova.id);

      setState(() {
        if (provasCarrinho.contains(prova)) {
          provasCarrinho.remove(prova);
          valoresProvasCarrinho.remove(double.parse(prova.valor));
        } else if (valoresDuplicados.isNotEmpty) {
          valoresProvasCarrinho.remove(double.parse(valoresDuplicados.firstOrNull!.valor));
          provasCarrinho.remove(valoresDuplicados.first);

          provasCarrinho.add(prova);
          valoresProvasCarrinho.add(double.parse(prova.valor));
        } else {
          provasCarrinho.add(prova);
          valoresProvasCarrinho.add(double.parse(prova.valor));
        }
      });

      // Poderá escolher multiplos pacotes por prova
    } else if (evento.liberacaoDeCompra == '2') {
      setState(() {
        if (provasCarrinho.contains(prova)) {
          provasCarrinho.remove(prova);
          valoresProvasCarrinho.remove(double.parse(prova.valor));
        } else {
          provasCarrinho.add(prova);
          valoresProvasCarrinho.add(double.parse(prova.valor));
        }
      });
    }
  }

  void abrirTermosDeUso() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: TermosDeUso(),
        );
      },
    );
  }

  void abrirDenunciar(ProvasEstado state) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return Dialog(
          child: StatefulBuilder(builder: (context, setStateDialog) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(contextDialog).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nomeDenuncia,
                        decoration: const InputDecoration(
                          hintText: "Nome",
                        ),
                        onChanged: (value) {
                          setStateDialog(() {});
                        },
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: celularDenuncia,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          TelefoneInputFormatter(),
                        ],
                        onChanged: (value) {
                          setStateDialog(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: "Celular",
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: TextField(
                          onChanged: (value) {
                            setStateDialog(() {});
                          },
                          controller: mensagemDenuncia,
                          decoration: const InputDecoration(
                            hintText: "Mensagem",
                          ),
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setStateDialog(() {
                            concordaDenunciar = concordaDenunciar ? false : true;
                          });
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: concordaDenunciar,
                              onChanged: (novoValor) {
                                setStateDialog(() {
                                  concordaDenunciar = novoValor!;
                                });
                              },
                            ),
                            Flexible(
                              child: RichText(
                                textAlign: TextAlign.left,
                                softWrap: true,
                                text: TextSpan(
                                  text: "Autorizo que a Empresa entre em contato para pedir mais informações",
                                  style: Theme.of(context).textTheme.titleSmall,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setStateDialog(() {
                                        concordaDenunciar = concordaDenunciar ? false : true;
                                      });
                                    },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      AbsorbPointer(
                        absorbing: !concordaDenunciar || nomeDenuncia.text.isEmpty || celularDenuncia.text.isEmpty || mensagemDenuncia.text.isEmpty,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(Colors.white),
                            foregroundColor: (!concordaDenunciar || nomeDenuncia.text.isEmpty || celularDenuncia.text.isEmpty || mensagemDenuncia.text.isEmpty)
                                ? const MaterialStatePropertyAll(Colors.grey)
                                : const MaterialStatePropertyAll(Colors.red),
                          ),
                          onPressed: () {
                            var denunciarServico = context.read<DenunciarServico>();

                            denunciarServico.denunciar(state.evento!.id, state.evento!.idEmpresa, nomeDenuncia.text, celularDenuncia.text, mensagemDenuncia.text).then((sucesso) {
                              if (sucesso) {
                                Navigator.pop(context);

                                setStateDialog(() {
                                  nomeDenuncia.text = '';
                                  celularDenuncia.text = '';
                                  mensagemDenuncia.text = '';
                                  concordaDenunciar = concordaDenunciar ? false : true;
                                });

                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text('Sucesso ao fazer denuncia.'),
                                  backgroundColor: Colors.green,
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {},
                                  ),
                                ));
                              }
                            });
                          },
                          child: const Text('Enviar Denúncia'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  void abrirLocalizacao(evento) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "CEP: ",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(evento!.cep),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Bairro: ",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(evento!.bairro),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Complemento: ",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(evento!.complemento),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Endereço: ",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(evento!.endereco),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Cidade: ",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(evento!.nomeCidade),
                  ],
                ),
                if (evento.longitude != '0' && evento.latitude != '0') ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        var latitude = evento.latitude;
                        var longitude = evento.longitude;

                        String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                        if (await canLaunchUrl(Uri.parse(googleUrl))) {
                          await launchUrl(Uri.parse(googleUrl));
                        } else {
                          throw 'Não foi possível abrir o mapa.';
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Abrir no Google Maps'),
                          SizedBox(width: 5),
                          Icon(Icons.map_sharp, size: 20),
                        ],
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  void abrirPagamentosDisponiveis(List<PagamentosModelo> pagamentosDisponiveis) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pagamentos Disponíveis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pagamentosDisponiveis.length,
                    itemBuilder: (context, index) {
                      var item = pagamentosDisponiveis[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item.nome),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double setarTamanho(double height, state) {
    var provas = state is ProvasCarregando ? DadosFakes.dadosFakesProvas : state.provas;

    if (((height * 0.40) - ((provas.isNotEmpty ? provas.length : 1) * (provas.isNotEmpty ? 110 : 0))).isNegative) {
      return 50;
    } else {
      return (height * 0.40) - ((provas.isNotEmpty ? provas.length : 1) * (provas.isNotEmpty ? 110 : 0));
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provasStore = context.read<ProvasStore>();
      var usuarioProvider = context.read<UsuarioProvider>();
      provasStore.listar(usuarioProvider.usuario, widget.argumentos.idEvento);
    });
  }

  @override
  void dispose() {
    nomeDenuncia.dispose();
    celularDenuncia.dispose();
    mensagemDenuncia.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provasStore = context.read<ProvasStore>();

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    double valorTotal = valoresProvasCarrinho.fold(0, (previousValue, element) => previousValue + element);

    return Consumer<UsuarioProvider>(builder: (context, usuarioProvider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Visibility(
          visible: provasCarrinho.isNotEmpty,
          child: SizedBox(
            width: 250,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRotas.finalizarCompra,
                  arguments: PaginaFinalizarCompraArgumentos(provas: provasCarrinho, idEvento: widget.argumentos.idEvento),
                );
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 247, 24, 8),
              label: Row(
                children: [
                  Text("${provasCarrinho.length.toString()} Itens"),
                  const SizedBox(width: 10),
                  Text(
                    Utils.coverterEmReal.format(valorTotal),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_ios_outlined),
                ],
              ),
            ),
          ),
        ),
        body: ValueListenableBuilder<ProvasEstado>(
          valueListenable: provasStore,
          builder: (context, state, _) {
            var evento = state is ProvasCarregando ? DadosFakes.dadosFakesEventos[0] : state.evento;
            var provas = state is ProvasCarregando ? DadosFakes.dadosFakesProvas : state.provas;
            var nomesCabeceira = state is ProvasCarregando ? DadosFakes.dadosFakesNomesCabeceira : state.nomesCabeceira;

            if (state is ErroAoCarregar) {
              return const Text('Erro ao listar Provas.');
            }

            if (evento != null) {
              return RefreshIndicator(
                onRefresh: () async {
                  provasStore.listar(usuarioProvider.usuario, widget.argumentos.idEvento);
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Skeletonizer(
                    enabled: state is ProvasCarregando,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CachedNetworkImage(
                                  imageUrl: evento.foto,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator(value: downloadProgress.progress),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              Skeleton.ignore(
                                child: GestureDetector(
                                  onTap: () {
                                    final imageProvider = Image.network(evento.foto).image;
                                    showImageViewer(
                                      context,
                                      imageProvider,
                                      useSafeArea: true,
                                      doubleTapZoomable: true,
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 300,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          end: const Alignment(0.0, -0.6),
                                          begin: const Alignment(0.0, 0),
                                          colors: <Color>[const Color(0x8A000000), Colors.black12.withOpacity(0.0)],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // const Text('CASA DE SHOWS', style: TextStyle(color: Colors.white, fontSize: 16)),
                                      Text(
                                        evento.nomeEvento,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(DateTime.parse(evento.dataEvento)),
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ),
                              Skeleton.ignore(
                                child: SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      width: 90,
                                      decoration: const BoxDecoration(color: Color.fromARGB(106, 0, 0, 0), borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: IconButton(
                                        icon: const Row(
                                          children: [
                                            Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                                            SizedBox(width: 10),
                                            Text('Voltar', style: TextStyle(color: Colors.white, fontSize: 14)),
                                          ],
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              ActionChip(
                                avatar: const Icon(Icons.location_on_outlined),
                                label: const Text('Localização'),
                                onPressed: () {
                                  abrirLocalizacao(evento);
                                },
                              ),
                              const SizedBox(width: 10),
                              ActionChip(
                                avatar: const Icon(Icons.payment_outlined),
                                label: const Text('Pagamentos'),
                                onPressed: () {
                                  abrirPagamentosDisponiveis(state.pagamentosDisponiveis!);
                                },
                              ),
                              const SizedBox(width: 10),
                              ActionChip(
                                avatar: const Icon(Icons.warning_amber),
                                label: const Text('Termos de Uso'),
                                onPressed: () {
                                  abrirTermosDeUso();
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                        if (provas.isNotEmpty && nomesCabeceira != null) ...[
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Escolha sua Prova',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(10),
                            itemCount: provas.length,
                            itemBuilder: (context, index) {
                              var prova = provas[index];

                              return CardProvas(
                                prova: prova,
                                evento: evento,
                                nomesCabeceira: nomesCabeceira,
                                idEvento: widget.argumentos.idEvento,
                                provasCarrinho: provasCarrinho,
                                aoClicarNaProva: (prova) {
                                  adicionarNoCarrinho(prova, evento);
                                },
                              );
                            },
                          ),
                        ],
                        if (provas.isEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Não há provas para esse evento.',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                        Padding(
                          padding: EdgeInsets.only(
                            top: setarTamanho(height, state),
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(bottom: 10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                              ),
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: provasCarrinho.isNotEmpty ? 110 : (Platform.isAndroid ? 50 : 20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.pin_drop_outlined, size: 20),
                                            Opacity(
                                              opacity: 0.6,
                                              child: Text(
                                                " ${evento.nomeCidade}",
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Row(
                                          children: [
                                            const Icon(Icons.date_range, size: 20),
                                            Opacity(
                                              opacity: 0.6,
                                              child: Text(
                                                " ${DateFormat('dd/MM/yyyy').format(DateTime.parse(evento.dataEvento))}",
                                                style: const TextStyle(fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Descrição do evento',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    if (evento.descricao1.isNotEmpty) ...[
                                      const SizedBox(height: 15),
                                      Text(evento.descricao1),
                                    ],
                                    if (evento.descricao2.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Text(evento.descricao2),
                                    ],
                                    if (evento.descricao1.isEmpty && evento.descricao2.isEmpty) ...[
                                      const SizedBox(height: 15),
                                      const Text('...'),
                                    ],
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width / 2.4,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              abrirTermosDeUso();
                                            },
                                            style: const ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                              elevation: MaterialStatePropertyAll(0),
                                              side: MaterialStatePropertyAll<BorderSide>(
                                                BorderSide(
                                                  width: 1,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Termos de Uso',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: width / 2.4,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              abrirDenunciar(state);
                                            },
                                            style: const ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll(Colors.transparent),
                                              elevation: MaterialStatePropertyAll(0),
                                              side: MaterialStatePropertyAll<BorderSide>(
                                                BorderSide(
                                                  width: 1,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Denunciar',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const Text('Erro ao listar Provas.');
          },
        ),
      );
    });
  }
}
