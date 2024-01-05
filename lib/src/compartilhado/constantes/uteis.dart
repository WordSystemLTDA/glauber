import 'package:intl/intl.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/dados_provas_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/listar_informacoes_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/nomes_cabeceira_modelo.dart';
import 'package:provadelaco/src/modulos/finalizar_compra/interator/modelos/pagamentos_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/categoria_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/evento_modelo.dart';
import 'package:provadelaco/src/modulos/home/interator/modelos/propaganda_modelo.dart';
import 'package:provadelaco/src/modulos/provas/interator/modelos/prova_modelo.dart';

class Utils {
  static final coverterEmReal = NumberFormat.currency(locale: 'pt_BR', symbol: "R\$");

  static List<PropagandaModelo> dadosFakesPropagandas = [
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

  static List<ProvaModelo> dadosFakesProvas = [
    ProvaModelo(
      id: '31',
      nomeProva: 'WARM UP #6 E #9',
      valor: '150.00',
      jaComprou: false,
      idCabeceira: null,
      tempoFaltante: '',
      hcMinimo: '1.00',
      hcMaximo: '7.00',
      compraLiberada: true,
    ),
    ProvaModelo(
      id: '31',
      nomeProva: 'WARM UP #6 E #9',
      valor: '150.00',
      jaComprou: false,
      idCabeceira: null,
      tempoFaltante: '',
      hcMinimo: '1.00',
      hcMaximo: '7.00',
      compraLiberada: true,
    ),
  ];
  static List<NomesCabeceiraModelo> dadosFakesNomesCabeceira = [
    NomesCabeceiraModelo(id: '1', nome: 'Cabeceiro'),
    NomesCabeceiraModelo(id: '2', nome: 'Pezeiro'),
  ];

  static ListarInformacoesModelo dadosFakesFinalizarCompra = ListarInformacoesModelo(
    prova: DadosProvasModelo(valor: '150', taxaProva: '0.00'),
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
}
