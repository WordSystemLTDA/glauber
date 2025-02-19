import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
import 'package:provadelaco/src/modulos/autenticacao/data/servicos/autenticacao_servico_impl.dart';
import 'package:provadelaco/src/modulos/autenticacao/interator/modelos/modelo_modalidades_cadastro.dart';

abstract interface class AutenticacaoServico {
  Future<(bool, String, UsuarioModelo?)> entrar(String email, String senha, TiposLogin tipoLogin, dynamic usuario, String? tokenNotificacao);
  Future<(bool, String, UsuarioModelo?)> verificar(UsuarioModelo? usuario, String? tokenNotificacao);
  Future<(bool, String, UsuarioModelo?)> cadastrarSocial(dynamic usuario, TiposLogin tipo, String nome, String hcCabeceira, String hcPiseiro);
  Future<(bool, String)> sair(UsuarioModelo? usuario, String? tokenNotificacao);
  Future<(bool, String)> excluirConta(UsuarioModelo? usuario, String? tokenNotificacao);
  Future<(bool, String)> cadastrar(
    String? idcliente,
    String nome,
    String apelido,
    String email,
    String senha,
    String celular,
    String cidade,
    String hcCabeceira,
    String hcPiseiro,
    String tipodecategoriaprofissional,
    String handicaplacoindividual,
    String datanascimento,
    String sexo,
    List<ModeloModalidadesCadastro> modalidades,
    bool jaEstaCadastrado,
  );
}
