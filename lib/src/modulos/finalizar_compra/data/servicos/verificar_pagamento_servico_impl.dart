import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/verificar_pagamento_servico.dart';

class VerificarPagamentoServicoImpl implements VerificarPagamentoServico {
  final IHttpClient client;

  VerificarPagamentoServicoImpl(this.client);

  @override
  Future<bool> verificarPagamento(String txid, String idFormaPagamento) async {
    var url = 'pagamentos/verificar_pagamento.php';

    var campos = {
      'txid': txid,
      'id_forma_pagamento': idFormaPagamento,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    // dynamic resultado = jsonData['resultado'];

    return sucesso;
  }

  @override
  Future<bool> verificarPagamentoGerado(String txid, String idFormaPagamento) async {
    var url = 'pagamentos/verificar_pagamento_gerado.php';

    var campos = {
      'txid': txid,
      'id_forma_pagamento': idFormaPagamento,
    };

    var response = await client.post(url: url, body: jsonEncode(campos));
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    // dynamic resultado = jsonData['resultado'];

    return sucesso;
  }
}
