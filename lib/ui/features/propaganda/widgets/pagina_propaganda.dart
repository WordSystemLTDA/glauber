import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provadelaco/data/repositories/propagandas_repository.dart';
import 'package:provadelaco/domain/models/propaganda_modelo.dart';
import 'package:provadelaco/ui/core/ui/app_bar_sombra.dart';
import 'package:provadelaco/utils/whatsapp.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaPropagandaArgumentos {
  final String idPropaganda;
  const PaginaPropagandaArgumentos({required this.idPropaganda});
}

class PaginaPropaganda extends StatefulWidget {
  final PaginaPropagandaArgumentos argumentos;
  const PaginaPropaganda({super.key, required this.argumentos});

  @override
  State<PaginaPropaganda> createState() => _PaginaPropagandaState();
}

class _PaginaPropagandaState extends State<PaginaPropaganda> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var propagandasStore = context.read<PropagandasStore>();

      propagandasStore.listar(widget.argumentos.idPropaganda);
    });
  }

  @override
  Widget build(BuildContext context) {
    var propagandasStore = context.read<PropagandasStore>();

    return ListenableBuilder(
      listenable: propagandasStore,
      builder: (context, _) {
        PropagandaModelo? propaganda = propagandasStore.propagandas;

        if (propaganda == null) {
          return const Text('Erro ao tentar listar');
        }

        return Scaffold(
          appBar: AppBarSombra(
            titulo: Text(propaganda.tipoServico.isNotEmpty ? propaganda.tipoServico : ''),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              propagandasStore.listar(widget.argumentos.idPropaganda);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: propaganda.foto,
                        width: double.infinity,
                        height: 240,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(value: downloadProgress.progress),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  propaganda.nome,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      if (await canLaunchUrl(Uri.parse(propaganda.instagram))) {
                                        await launchUrl(Uri.parse(propaganda.instagram));
                                      }
                                    },
                                    icon: const FaIcon(FontAwesomeIcons.instagram),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Whatsapp.abrir(propaganda.celular);
                                    },
                                    color: Colors.green,
                                    icon: const FaIcon(FontAwesomeIcons.whatsapp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(propaganda.obs),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
