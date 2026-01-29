import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provadelaco/src/data/servicos/denunciar_servico.dart';
import 'package:provadelaco/src/data/repositories/provas_store.dart';
import 'package:provider/provider.dart';

class ModalDenunciar extends StatefulWidget {
  const ModalDenunciar({super.key});

  @override
  State<ModalDenunciar> createState() => _ModalDenunciarState();
}

class _ModalDenunciarState extends State<ModalDenunciar> {
  TextEditingController nomeDenuncia = TextEditingController();
  TextEditingController celularDenuncia = TextEditingController();
  TextEditingController mensagemDenuncia = TextEditingController();

  bool concordaDenunciar = false;

  @override
  void dispose() {
    nomeDenuncia.dispose();
    celularDenuncia.dispose();
    mensagemDenuncia.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provasEstado = context.read<ProvasStore>();

    return Dialog(
      child: StatefulBuilder(builder: (context, setStateDialog) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
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
                        backgroundColor: const WidgetStatePropertyAll(Colors.white),
                        foregroundColor: (!concordaDenunciar || nomeDenuncia.text.isEmpty || celularDenuncia.text.isEmpty || mensagemDenuncia.text.isEmpty)
                            ? const WidgetStatePropertyAll(Colors.grey)
                            : const WidgetStatePropertyAll(Colors.red),
                      ),
                      onPressed: () {
                        var denunciarServico = context.read<DenunciarServico>();

                        denunciarServico
                            .denunciar(provasEstado.evento!.id, provasEstado.evento!.idEmpresa, nomeDenuncia.text, celularDenuncia.text, mensagemDenuncia.text)
                            .then((sucesso) {
                          if (sucesso) {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }

                            setStateDialog(() {
                              nomeDenuncia.text = '';
                              celularDenuncia.text = '';
                              mensagemDenuncia.text = '';
                              concordaDenunciar = concordaDenunciar ? false : true;
                            });

                            if (context.mounted) {
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
  }
}
