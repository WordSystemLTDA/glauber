import 'dart:convert';

import 'package:provadelaco/src/essencial/network/http_cliente.dart';

class VerificarPagamentoServicoImpl {
  final IHttpClient client;

  VerificarPagamentoServicoImpl(this.client);

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
