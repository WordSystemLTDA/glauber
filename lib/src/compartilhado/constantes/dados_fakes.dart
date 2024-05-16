import 'package:provadelaco/src/modulos/compras/interator/modelos/compras_modelo.dart';
import 'package:provadelaco/src/modulos/compras/interator/modelos/retorno_lista_compra_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/dados_provas_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/valor_adicional_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/categoria_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/ordem_de_entrada/interator/modelos/ordem_de_entrada_modelo.dart';
import 'package:provadelaco/src/modulos/propaganda/interator/modelos/propaganda_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/permitir_compra_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class DadosFakes {
  static List<PropagandaModelo> dadosFakesPropagandas = [
    PropagandaModelo(
      id: "1",
      nome: "Glauber Sampaio",
      instagram: "https://www.instagram.com/glaubersampaio/",
      codigoVideo: "",
      celular: "(44) 99138-5327",
      obs:
          "lorem akosdkoasdokpaspodkas pokdpask dpoakspdok aspodk poaskd opaskdpoaskdpoaskdpoaskopdkaspsaopdsapodk oapsk dpoaskdop kasopdkapsokdopsakdpoaskdposakodpkaspod kasop dkopaskdpoaskdpaksdpaskopdsakopd",
      foto: "https://gsequine.com.br/sistema/img/propagandas/banner1.png",
      tipoServico: "Nome do Serviço",
      idEmpresa: "1",
      nomeEmpresa: "Word System",
    ),
    PropagandaModelo(
      id: "1",
      nome: "Glauber Sampaio",
      instagram: "https://www.instagram.com/glaubersampaio/",
      codigoVideo: "",
      celular: "(44) 99138-5327",
      obs: "",
      foto: "https://gsequine.com.br/sistema/img/propagandas/banner1.png",
      tipoServico: "Nome do Serviço",
      idEmpresa: "1",
      nomeEmpresa: "Word System",
    ),
    PropagandaModelo(
      id: "1",
      nome: "Glauber Sampaio",
      instagram: "https://www.instagram.com/glaubersampaio/",
      codigoVideo: "",
      celular: "(44) 99138-5327",
      obs: "",
      foto: "https://gsequine.com.br/sistema/img/propagandas/banner1.png",
      tipoServico: "Nome do Serviço",
      idEmpresa: "1",
      nomeEmpresa: "Word System",
    ),
  ];

  static List<CategoriaModelo> dadosFakesCategoria = [
    CategoriaModelo(id: '0', nome: 'Todos'),
  ];

  static List<EventoModelo> dadosFakesEventos = [
    EventoModelo(
      id: "19",
      idEmpresa: "4",
      nomeEvento: "Aniversário João Vitor Fadel",
      dataEvento: "2023-12-16",
      horaInicio: "09:00:00",
      horaTermino: "19:00:00",
      descricao1: "",
      descricao2: "",
      liberacaoDeCompra: "2",
      foto: "https://gsequine.com.br/sistema/img/eventos/12-12-2023-10-30-40-hojeeee.jpg",
      cep: "86770-000",
      endereco: "Rancho São Jose",
      numero: "S/N",
      bairro: "Rural",
      complemento: "",
      nomeCidade: "Cambé",
      nomeEmpresa: "Glauber Sampaio",
      longitude: "",
      latitude: "",
    ),
    EventoModelo(
      id: "19",
      idEmpresa: "4",
      nomeEvento: "Aniversário João Vitor Fadel",
      dataEvento: "2023-12-16",
      horaInicio: "09:00:00",
      horaTermino: "19:00:00",
      descricao1: "",
      descricao2: "",
      liberacaoDeCompra: "2",
      foto: "https://gsequine.com.br/sistema/img/eventos/12-12-2023-10-30-40-hojeeee.jpg",
      cep: "86770-000",
      endereco: "Rancho São Jose",
      numero: "S/N",
      bairro: "Rural",
      complemento: "",
      nomeCidade: "Cambé",
      nomeEmpresa: "Glauber Sampaio",
      longitude: "",
      latitude: "",
    ),
  ];

  static List<ProvaModelo> dadosFakesProvas = List.generate(
    2,
    (index) => ProvaModelo(
      avulsa: '',
      quantMaxima: '',
      quantMinima: '',
      permitirSorteio: '',
      id: '31',
      habilitarAoVivo: '',
      nomeProva: 'WARM UP #6 E #9',
      valor: '150.00',
      permitirCompra: const PermitirCompraModelo(liberado: true, mensagem: '', rota: '', tituloAcao: '', permVincularParceiro: ''),
      idCabeceira: null,
      hcMinimo: '1.00',
      hcMaximo: '7.00',
      somatoriaHandicaps: '0',
    ),
  );

  static List<NomesCabeceiraModelo> dadosFakesNomesCabeceira = [
    NomesCabeceiraModelo(id: '1', nome: 'Cabeceiro'),
    NomesCabeceiraModelo(id: '2', nome: 'Pezeiro'),
  ];

  static ListarInformacoesModelo dadosFakesFinalizarCompra = ListarInformacoesModelo(
    prova: DadosProvasModelo(valor: '150', taxaProva: '0.00'),
    parcelasDisponiveisCartao: [],
    taxaCartao: '0',
    ativoPagamento: '',
    pagamentoPix: '',
    tempoCancel: '',
    valorAdicional: ValorAdicionalModelo(tipo: "", titulo: "", valor: "1.00"),
    evento: EventoModelo(
      id: "19",
      idEmpresa: "4",
      nomeEvento: "Aniversário João Vitor Fadel",
      dataEvento: "2023-12-16",
      horaInicio: "09:00:00",
      horaTermino: "19:00:00",
      descricao1: "",
      descricao2: "",
      liberacaoDeCompra: "2",
      foto: "https://gsequine.com.br/sistema/img/eventos/12-12-2023-10-30-40-hojeeee.jpg",
      cep: "86770-000",
      endereco: "Rancho São Jose",
      numero: "S/N",
      bairro: "Rural",
      complemento: "",
      nomeCidade: "Cambé",
      nomeEmpresa: "Glauber Sampaio",
      longitude: "",
      latitude: "",
    ),
    pagamentos: [PagamentosModelo(id: "1", nome: "Pix Mercado Pago"), PagamentosModelo(id: "2", nome: "Pagamento Local")],
  );

  static final List<RetornoListaCompraModelo> dadosFakesCompras = [
    RetornoListaCompraModelo(
        id: 'id',
        nomeEvento: 'nomeEvento',
        nomeProva: '',
        somaTotal: '',
        compras: List.generate(
          5,
          (index) => ComprasModelo(
            id: "187",
            permVincularParceiro: '',
            idEmpresa: '1',
            valorIngresso: "150.00",
            valorTaxa: "0.00",
            valorDesconto: "0.00",
            valorTotal: "150.00",
            status: "Pendente",
            codigoQr: "MTAwMDAwMDAwMDE4Nw==",
            codigoPIX: "00020126330014br.gov.bcb.pix0111061528269505204000053039865406150.005802BR5911SAGL84237736011Santo Incio62240520mpqrinter7002336949763044DB5",
            idCliente: "10",
            dataCompra: "2024-01-08",
            horaCompra: "13:16 PM",
            pago: "Não",
            nomeProva: "Sem nome prova",
            nomeEvento: "Aniversário João Vitor Fadel",
            dataEvento: "2023-12-16",
            horaInicio: "09:00:00",
            horaInicioF: "09:00 AM",
            horaTermino: "19:00:00",
            idEvento: '1',
            nomeEmpresa: 'Nome empresa',
            numeroCelular: "(44) 99921-3336",
            formaPagamento: "Pix Mercado Pago",
            permitirEditarParceiros: '',
            idFormaPagamento: "1",
            quandoInscricaoNaoPaga: "mostrar_qrcode_pix",
            mensagemQuandoInscricaoNaoPaga: "",
            parceiros: [],
            provas: [],
            valorFiliacao: '0',
          ),
        )),
  ];

  static List<OrdemDeEntradaModelo> dadosFakesOrdemEntrada = [
    OrdemDeEntradaModelo(
      id: '',
      idProva: '1',
      nomeEvento: 'nomeEvento',
      nomeProva: 'nomeProva',
      nomeCliente: 'nomeCliente',
      parceiros: [],
      nomeCabeceira: '',
      idCabeceira: '',
    ),
    OrdemDeEntradaModelo(
      id: '',
      idProva: '1',
      nomeEvento: 'nomeEvento',
      nomeProva: 'nomeProva',
      nomeCliente: 'nomeCliente',
      parceiros: [],
      nomeCabeceira: '',
      idCabeceira: '',
    ),
    OrdemDeEntradaModelo(
      id: '',
      idProva: '1',
      nomeEvento: 'nomeEvento',
      nomeProva: 'nomeProva',
      nomeCliente: 'nomeCliente',
      parceiros: [],
      nomeCabeceira: '',
      idCabeceira: '',
    ),
    OrdemDeEntradaModelo(
      id: '',
      idProva: '1',
      nomeEvento: 'nomeEvento',
      nomeProva: 'nomeProva',
      nomeCliente: 'nomeCliente',
      parceiros: [],
      nomeCabeceira: '',
      idCabeceira: '',
    ),
    OrdemDeEntradaModelo(
      id: '',
      idProva: '1',
      nomeEvento: 'nomeEvento',
      nomeProva: 'nomeProva',
      nomeCliente: 'nomeCliente',
      parceiros: [],
      nomeCabeceira: '',
      idCabeceira: '',
    ),
    OrdemDeEntradaModelo(
      id: '',
      idProva: '1',
      nomeEvento: 'nomeEvento',
      nomeProva: 'nomeProva',
      nomeCliente: 'nomeCliente',
      parceiros: [],
      nomeCabeceira: '',
      idCabeceira: '',
    ),
    OrdemDeEntradaModelo(
      id: '',
      idProva: '1',
      nomeEvento: 'nomeEvento',
      nomeProva: 'nomeProva',
      nomeCliente: 'nomeCliente',
      parceiros: [],
      nomeCabeceira: '',
      idCabeceira: '',
    ),
    OrdemDeEntradaModelo(
      id: '',
      idProva: '1',
      nomeEvento: 'nomeEvento',
      nomeProva: 'nomeProva',
      nomeCliente: 'nomeCliente',
      parceiros: [],
      nomeCabeceira: '',
      idCabeceira: '',
    ),
  ];
}
