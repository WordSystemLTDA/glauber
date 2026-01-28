import 'dart:convert';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provadelaco/src/data/servicos/listar_cartoes_servico_impl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/estados/listar_cartoes_estado.dart';
import 'package:provadelaco/src/domain/models/cartao_modelo.dart';
import 'package:provadelaco/src/data/repositories/listar_cartoes_store.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/ui/widgets/card_cartao.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModalSelecionarCartao extends StatefulWidget {
  final CartaoModelo? cartaoSelecionado;
  final int parcela;
  final Function(CartaoModelo cartao) aoMudarCartao;
  final List<CartaoModelo> cartaoMemoria;

  const ModalSelecionarCartao({
    super.key,
    this.cartaoSelecionado,
    required this.parcela,
    required this.aoMudarCartao,
    required this.cartaoMemoria,
  });

  @override
  State<ModalSelecionarCartao> createState() => _ModalSelecionarCartaoState();
}

class _ModalSelecionarCartaoState extends State<ModalSelecionarCartao> {
  final _formAdicionarCartaoKey = GlobalKey<FormState>();
  final _formCVVKey = GlobalKey<FormState>();

  bool salvarCartao = false;

  TextEditingController nomeCartaoController = TextEditingController();
  TextEditingController numeroCartaoController = TextEditingController();
  TextEditingController expiracaoCartaoController = TextEditingController();
  TextEditingController cpfCartaoController = TextEditingController();
  TextEditingController codigoCartaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        var listarCartoesStore = context.read<ListarCartoesStore>();
        listarCartoesStore.listarCartoes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var listarCartoesStore = context.read<ListarCartoesStore>();

    var cartaoSelecionado = widget.cartaoSelecionado;
    var cartaoMemoria = widget.cartaoMemoria;

    return ValueListenableBuilder<ListarCartoesEstado>(
      valueListenable: listarCartoesStore,
      builder: (context, state, _) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: width,
                  height: 40,
                  child: Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ElevatedButton(
                      onPressed: aparecerModalAdicionarCartao,
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(Colors.green),
                        foregroundColor: const WidgetStatePropertyAll(Colors.white),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text('Adicionar um cartão'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (state is! CartoesCarregadoInformacoes && cartaoMemoria.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text('Você não tem nenhum cartão cadastrado.'),
                  ),
                )
              ],
              if (state is CartoesCarregadoInformacoes || cartaoMemoria.isNotEmpty) ...[
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: [...(state is! CartoesCarregadoInformacoes ? [] : state.cartoes), ...cartaoMemoria].length,
                    itemBuilder: (context, index) {
                      CartaoModelo itemCartao = [...(state is! CartoesCarregadoInformacoes ? [] : state.cartoes), ...cartaoMemoria][index];

                      return CardCartao(
                        cartao: itemCartao,
                        aparecerVazio: false,
                        aoExcluir: aparecerModalExcluirCartao,
                        selecionado: cartaoSelecionado != null &&
                            ((itemCartao.nomeCartao == cartaoSelecionado.nomeCartao) ||
                                (itemCartao.numeroCartao == cartaoSelecionado.numeroCartao) ||
                                (itemCartao.expiracaoCartao == cartaoSelecionado.expiracaoCartao)),
                        aoClicar: () {
                          Navigator.pop(context);
                          aparecerModalColocarCodigo(itemCartao);
                        },
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void aparecerModalColocarCodigo(CartaoModelo cartao) {
    var width = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SizedBox(
            width: width,
            child: SafeArea(
              child: Form(
                key: _formCVVKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    top: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: codigoCartaoController,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Coloque o Código cartão';
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: '1234',
                          label: Text('Código de Segurança'),
                          errorStyle: TextStyle(fontSize: 0.00),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formCVVKey.currentState!.validate()) {
                              Navigator.pop(context);

                              cartao.codigoSeguracaoCartao = codigoCartaoController.text;
                              cartao.parcelasCartao = widget.parcela.toString();
                              codigoCartaoController.text = '';

                              widget.aoMudarCartao(cartao);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: const WidgetStatePropertyAll(Colors.green),
                            foregroundColor: const WidgetStatePropertyAll(Colors.white),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          child: const Text('OK'),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      codigoCartaoController.text = '';
    });
  }

  void aparecerModalExcluirCartao(CartaoModelo cartao) {
    var listarCartoesServico = context.read<ListarCartoesServicoImpl>();
    var listarCartoesStore = context.read<ListarCartoesStore>();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exclusão de cartão.'),
          content: const Text('Tem certeza que deseja excluir esse cartão?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                listarCartoesServico.excluirCartao(cartao).then((sucessoAoExcluir) {
                  if (sucessoAoExcluir) {
                    listarCartoesStore.listarCartoes();
                  } else {
                    setState(() {
                      widget.cartaoMemoria.remove(cartao);
                    });
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void aparecerModalAdicionarCartao() {
    var width = MediaQuery.of(context).size.width;
    var listarCartoesStore = context.read<ListarCartoesStore>();

    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateModalSalvarCartao) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SizedBox(
              width: width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formAdicionarCartaoKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Coloque o nome do cartão';
                              }

                              if (value.length < 3) {
                                return 'Nome de cartão inválido';
                              }
                              return null;
                            },
                            controller: nomeCartaoController,
                            decoration: const InputDecoration(
                              hintText: 'Seu nome',
                              errorStyle: TextStyle(fontSize: 0.00),
                              label: Text('Nome do Cartão'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Coloque o número do cartão';
                              }

                              if (value.length < 19) {
                                return 'Número de cartão inválido';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: numeroCartaoController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CartaoBancarioInputFormatter(),
                            ],
                            decoration: const InputDecoration(
                              hintText: '1234 1234 1234 1234',
                              label: Text('Número do Cartão'),
                              errorStyle: TextStyle(fontSize: 0.00),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Coloque o expiração do cartão';
                              }

                              if (value.length < 7) {
                                return 'Expiração inválida';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: expiracaoCartaoController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              ValidadeCartaoInputFormatter(maxLength: 6),
                            ],
                            decoration: const InputDecoration(
                              hintText: '06/2025',
                              label: Text('Expiração do Cartão'),
                              errorStyle: TextStyle(fontSize: 0.00),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Coloque o CPF do titular do cartão';
                              }

                              if (value.length < 14) {
                                return 'CPF inválido';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CpfInputFormatter(),
                            ],
                            controller: cpfCartaoController,
                            decoration: const InputDecoration(
                              hintText: '123.123.123-12',
                              label: Text('CPF do titular do Cartão'),
                              errorStyle: TextStyle(fontSize: 0.00),
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              setStateModalSalvarCartao(() {
                                salvarCartao = salvarCartao ? false : true;
                              });
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: salvarCartao,
                                  onChanged: (novoValor) {
                                    setStateModalSalvarCartao(() {
                                      salvarCartao = novoValor!;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: width - 100,
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    text: TextSpan(
                                      text: "Deseja guardar esse cartão para próximas compras?",
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formAdicionarCartaoKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  var cartaoNovo = CartaoModelo(
                                    nomeCartao: nomeCartaoController.text,
                                    numeroCartao: numeroCartaoController.text,
                                    expiracaoCartao: expiracaoCartaoController.text,
                                    cpfTitularCartao: cpfCartaoController.text,
                                  );

                                  if (salvarCartao) {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String? cartoesSalvos = prefs.getString('cartoesSalvos');

                                    if (cartoesSalvos != null) {
                                      List<dynamic> cartoesSalvosLista = json.decode(cartoesSalvos);

                                      List<CartaoModelo> cartoes = List<CartaoModelo>.from(cartoesSalvosLista.map((elemento) {
                                        return CartaoModelo.fromMap(jsonDecode(elemento));
                                      }));

                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      cartoes.add(cartaoNovo);

                                      String cartaoString = json.encode(cartoes);
                                      prefs.setString('cartoesSalvos', cartaoString);
                                      listarCartoesStore.listarCartoes();
                                    } else {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      List<CartaoModelo> cartoes = [];
                                      cartoes.add(cartaoNovo);

                                      String cartaoString = json.encode(cartoes);
                                      prefs.setString('cartoesSalvos', cartaoString);
                                      listarCartoesStore.listarCartoes();
                                    }

                                    nomeCartaoController.text = '';
                                    numeroCartaoController.text = '';
                                    expiracaoCartaoController.text = '';
                                    cpfCartaoController.text = '';
                                  } else {
                                    setState(() {
                                      widget.cartaoMemoria.add(cartaoNovo);
                                    });

                                    nomeCartaoController.text = '';
                                    numeroCartaoController.text = '';
                                    expiracaoCartaoController.text = '';
                                    cpfCartaoController.text = '';
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: const WidgetStatePropertyAll(Colors.green),
                                foregroundColor: const WidgetStatePropertyAll(Colors.white),
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              child: const Text('Salvar'),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
