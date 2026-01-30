import 'dart:convert';

import 'package:provadelaco/config/dio.dart';

class VerificarPagamentoServico {
  final DioClient client;

  VerificarPagamentoServico(this.client);

  Future<({bool sucesso})> verificarPagamento(String txid, String idFormaPagamento) async {
    var url = 'pagamentos/verificar_pagamento.php';

    var campos = {
      'txid': txid,
      'id_forma_pagamento': idFormaPagamento,
    };

    var response = await client.dio.post(url, data: jsonEncode(campos));
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    // dynamic resultado = jsonData['resultado'];

    return (sucesso: sucesso);
  }

  Future<bool> verificarPagamentoGerado(String txid, String idFormaPagamento) async {
    var url = 'pagamentos/verificar_pagamento_gerado.php';

    var campos = {
      'txid': txid,
      'id_forma_pagamento': idFormaPagamento,
    };

    var response = await client.dio.post(url, data: jsonEncode(campos));
    var jsonData = jsonDecode(response.data);

    bool sucesso = jsonData['sucesso'];
    // dynamic resultado = jsonData['resultado'];

    return sucesso;
  }
}
