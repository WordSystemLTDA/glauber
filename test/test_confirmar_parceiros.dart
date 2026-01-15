// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provadelaco/src/essencial/providers/usuario/usuario_modelo.dart';
// import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/formulario_compra_modelo.dart';
// import 'package:provadelaco/src/modulos/finalizar_compra/interator/servicos/finalizar_compra_servico.dart';
// import 'package:provadelaco/src/modulos/home/interator/servicos/home_servico.dart';
// import 'package:provadelaco/src/modulos/provas/interator/modelos/permitir_compra_modelo.dart';
// import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

// // Mock das dependências
// class MockHomeServico extends Mock implements HomeServico {}
// class MockFinalizarCompraServico extends Mock implements FinalizarCompraServico {}

// void main() {
//   // 1. Configuração do Teste
//   late MockHomeServico mockHomeServico;
//   late MockFinalizarCompraServico mockFinalizarCompraServico;

//   setUp(() {
//     mockHomeServico = MockHomeServico();
//     mockFinalizarCompraServico = MockFinalizarCompraServico();
//   });

//   // 2. Descrição do Grupo de Testes
//   group('Confirmacao de Inscrição com Parceiro', () {
//     // 3. Descrição do Teste Específico
//     test('deve usar a venda existente do tipo sorteio ao confirmar a inscrição', () async {
//       // 4. ARRANGE (Organização)
//       // Definindo os usuários
//       final glauber = UsuarioModelo(
//         id: '1',
//         nome: 'Glauber',
//         email: '',
//         tipoDePix: '',
//         chavePix: '',
//         senha: '',
//         token: '',
//         hcCabeceira: '',
//         hcPezeiro: '',
//         idHcCabeceira: '',
//         idHcPezeiro: '',
//         tipo: '',
//         primeiroAcesso: '',
//         cpf: '',
//         dataNascimento: '',
//         sexo: '',
//         rg: '',
//         telefone: '',
//         celular: '',
//         cep: '',
//         endereco: '',
//         numero: '',
//         bairro: '',
//         complemento: '',
//         foto: '',
//         civil: '',
//         apelido: '',
//         nomeCidade: '',
//         idCidade: '',
//         clienteBloqueado: false,
//         celularSuporte: '',
//         nivel: '',
//         somaDeHandicaps: '',
//         atualizacaoAndroid: '',
//         atualizacaoIos: '',
//         cabeceiroProvas: '',
//         pezeiroProvas: '',
//         ativoProva: '',
//         lacoemdupla: '',
//         tambores3: '',
//         lacoindividual: '',
//         tipodecategoriaprofissional: '',
//         handicaplacoindividual: '',
//         idhandicaplacoindividual: '',
//       );

//       final joao = UsuarioModelo(
//         id: '9',
//         nome: 'João Pedro',
//         email: '',
//         tipoDePix: '',
//         chavePix: '',
//         senha: '',
//         token: '',
//         hcCabeceira: '',
//         hcPezeiro: '',
//         idHcCabeceira: '',
//         idHcPezeiro: '',
//         tipo: '',
//         primeiroAcesso: '',
//         cpf: '',
//         dataNascimento: '',
//         sexo: '',
//         rg: '',
//         telefone: '',
//         celular: '',
//         cep: '',
//         endereco: '',
//         numero: '',
//         bairro: '',
//         complemento: '',
//         foto: '',
//         civil: '',
//         apelido: '',
//         nomeCidade: '',
//         idCidade: '',
//         clienteBloqueado: false,
//         celularSuporte: '',
//         nivel: '',
//         somaDeHandicaps: '',
//         atualizacaoAndroid: '',
//         atualizacaoIos: '',
//         cabeceiroProvas: '',
//         pezeiroProvas: '',
//         ativoProva: '',
//         lacoemdupla: '',
//         tambores3: '',
//         lacoindividual: '',
//         tipodecategoriaprofissional: '',
//         handicaplacoindividual: '',
//         idhandicaplacoindividual: '',
//       );

//       // Criando a venda inicial (sorteio)
//       final vendaGlauber = FormularioCompraModelo(
//         idProva: '',
//         idEmpresa: '',
//         idEvento: '',
//         idFormaPagamento: '',
//         valorIngresso: '',
//         valorTaxa: '',
//         valorTaxaCartao: '',
//         valorDesconto: '',
//         valorTotal: '',
//         temValorFiliacao: '',
//         tipoDeVenda: '',
//         provas: [
//           ProvaModelo(
//             id: '',
//             nomeProva: '',
//             valor: '',
//             hcMinimo: '',
//             hcMaximo: '',
//             avulsa: '',
//             quantMinima: '',
//             quantMaxima: '',
//             permitirCompra: PermitirCompraModelo(liberado: true, mensagem: ''),
//             permitirSorteio: '',
//             habilitarAoVivo: '',
//             idListaCompeticao: '',
//             permitirEditarParceiros: '',
//           ),
//         ],
//         cartao: null,
//       );

//       // Configurando o mock para retornar a vendaSorteio quando o método
//       // `buscarVendaPorUsuario` for chamado com o ID do Glauber.
//       // when(mockHomeServico.buscarVendaPorUsuario(glauber.id)).thenAnswer((_) async => vendaSorteio);

//       // 5. ACT (Ação)
//       // Simulando a confirmação da inscrição pelo Glauber, com João como parceiro.
//       await mockHomeServico.confirmarParceiro(glauber, parceiro: joao);

//       // 6. ASSERT (Verificação)
//       // Verificando se o método `criarNovaVenda` NUNCA foi chamado.
//       mockFinalizarCompraServico.inserir(glauber, vendaGlauber);
//       mockFinalizarCompraServico.inserir(joao, vendaGlauber);

//     });
//   });
// }
