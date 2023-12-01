// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provadelaco/src/essencial/providers/config/config_provider.dart';
import 'package:provider/provider.dart';

class TermosDeUso extends StatelessWidget {
  const TermosDeUso({super.key});

  final estiloTituloTermos = const TextStyle(fontSize: 15, fontWeight: FontWeight.w700);

  @override
  Widget build(BuildContext context) {
    var configProvider = context.read<ConfigProvider>();

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Termos de Uso',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Text.rich(
                textAlign: TextAlign.justify,
                TextSpan(
                  children: [
                    TextSpan(text: 'Aceitação dos Termos de Uso: \n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          'Estes Termos de Uso disciplinam os termos e condições aplicáveis a seu uso dos Serviços. Ao utilizar os Serviços, você ratifica que leu, compreendeu e concordou em ser legalmente vinculado a estes Termos. \n\n',
                    ),
                    TextSpan(text: 'Se você não concorda com estes Termos, por favor não utilize os Serviços.\n\n'),
                    TextSpan(
                      text:
                          'Sujeito às condições abaixo, A empresa poderá modificar estes Termos periodicamente e de modo não retroativo, e modificar, adicionar ou descontinuar qualquer aspecto, conteúdo ou característica dos Serviços, a seu próprio critério. Seu uso ou acesso continuado dos Serviços após a publicação de quaisquer mudanças nos Termos constitui sua aceitação de tais mudanças. Na medida em que uma lei ou decisão judicial aplicável determine que a aplicação de quaisquer mudanças a estes Termos seja inexequível, tais mudanças deverão ser aplicáveis apenas com relação a eventos ou circunstâncias que ocorrerem após a data de tais mudanças, na medida em que for necessário para evitar que estes Termos sejam considerados inexequíveis.\n\n',
                    ),
                    TextSpan(
                      text:
                          'Qualquer forma de transferência ou sublicença, ou acesso, distribuição, reprodução, cópia, retransmissão, publicação, venda ou exploração (comercial ou não) não autorizados de qualquer parte dos Serviços incluindo, mas não se limitando a todo conteúdo, serviços, produtos digitais, ferramentas ou produtos, é expressamente proibida por estes Termos.\n\n',
                    ),
                    TextSpan(text: 'Condições de compra:\n\n', style: estiloTituloTermos),
                    TextSpan(text: "- Limite de compra por Usuário: até ingressos para cada dia de evento.\n"),
                    TextSpan(
                      text:
                          '- O prazo para reembolso é de {dadosEmpresa.dias_de_cancelamento} dias contando a data da compra, desde que seja {dadosEmpresa.dias_limite_de_cancelamento} dias antes do evento, para que seja realizada a devolução do valor do ingresso.\n',
                    ),
                    TextSpan(text: '- O valor referente à taxa administrativa não será devolvido.\n'),
                    TextSpan(
                      text:
                          "- Onde solicitar o reembolso? Deverá ser solicitado no proprio app ou site, na aba compra, clicando em cima do ingresso, vai ter a opção para reembolso, e você será redirecionando para uma conversa no whatssap direto com a empresa promovedora do evento. Não sendo de responsabilidade do ${configProvider.configs!.nomeApp}.\n\n",
                    ),
                    TextSpan(text: 'Taxa de Conveniência: \n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          'A taxa de serviço é o valor cobrado pela ${configProvider.configs!.nomeApp} quando Você compra ingressos para Eventos parceiros da ${configProvider.configs!.nomeApp} através de nossos Serviços. O valor da taxa de serviço é mostrado durante o processo de compra de ingressos.\n\n',
                    ),
                    TextSpan(text: 'Cancelamento do evento / show:\n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          'Eventuais alterações na programação, tais como cancelamento do evento ou do show após a conclusão da compra, são de responsabilidade legal e exclusiva dos Produtores do evento, devendo estes se responsabilizarem por devoluções de valores e indenizações. Na hipótese de cancelamento do evento / show, seja por casos fortuitos ou motivos de força maior, ou por atos de intervenção do Poder Público, o ${configProvider.configs!.nomeApp} não será responsabilizada de nenhuma forma.\n\n',
                    ),
                    TextSpan(text: 'Documentação de Entrada:\n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          '- No dia do evento, apresente-o diretamente na entrada do evento, juntamente com documento com foto: CNH ou RG (original ou cópia autenticada) do(a) titular da compra.\n- Idosos: com idade superior a 60 anos: CNH ou RG (original ou cópia autenticada).\n\n',
                    ),
                    TextSpan(text: 'Direito de Uso de Imagens:\n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          'O evento / show poderá ser filmado, gravado, fotografado a critério do organizador / produtor, para posterior publicação, transmissão, retransmissão, reprodução ou divulgação em TV, cinema, rádio, internet, publicidade ou qualquer outro veículo de comunicação, produção de DVD e home-vídeo. Ao comparecer ao evento / show, você concorda, autoriza e cede o uso gratuito de sua imagem, nome, voz nos termos ora mencionados, sem limitação, sem que caracterize uso indevido ou qualquer outra violação de direitos e sem que deste uso decorra qualquer ônus / indenização. O comparecimento ao evento / show implica a aceitação incondicional do termo acima.\n\n',
                    ),
                    TextSpan(text: 'Política de Privacidade:\n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          ' Seu uso dos Serviços e o tratamento, por parte da ${configProvider.configs!.nomeApp}, de qualquer informação fornecida por você ou recolhida pela ${configProvider.configs!.nomeApp} ou partes terceiras durante qualquer visita ou uso dos Serviços é regida pela Política de Privacidade, aqui incorporada por meio desta referência. A Política de Privacidade é o documento que regula o tratamento de dados pessoais e/ou confidenciais pela ${configProvider.configs!.nomeApp} e seus prestadores de serviços ou parceiros. A coleta, uso e compartilhamento, por parte da ${configProvider.configs!.nomeApp}, de suas informações pessoais serão realizados nos termos determinados na Política de Privacidade, razão pela qual você deve ler tal Política com atenção e descontinuar o uso dos Serviços caso não concorde com a descrição do tratamento.\n\n',
                    ),
                    TextSpan(text: 'Menores de Idade:\n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          'Os Serviços não foram formulados nem são destinados para serem usados por indivíduos menores de 18 anos e, portanto, se você for menor de 18 anos, solicitamos que você não use os Serviços nem nos forneça qualquer dado pessoal.\n\n',
                    ),
                    TextSpan(text: '• IMPORTANTE:\n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          'Em caso de cópias do e-Ticket, o sistema de segurança validará apenas o primeiro acesso. Após validados uma vez, o e-Ticket não poderá ser reutilizado. Não nos responsabilizamos por qualquer PERDA, DANO ou ROUBO do seu e-Ticket. Nós da ${configProvider.configs!.nomeApp} e a Empresa pelo evento não se responsabiliza pela transferência de ingressos ou revenda do mesmo.\n\n',
                    ),
                    TextSpan(text: 'Reembolso:\n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          '- O prazo para reembolso é de {dadosEmpresa.dias_de_cancelamento} dias contando a data da compra, desde que seja {dadosEmpresa.dias_limite_de_cancelamento} dias antes do evento, para que seja realizada a devolução do valor do ingresso.\n\n',
                    ),
                    TextSpan(text: '- O valor referente à taxa administrativa não será devolvido.\n\n'),
                    TextSpan(
                      text:
                          '- Onde solicitar o reembolso? Deverá ser solicitado no proprio app ou site, na aba compra, clicando em cima do ingresso, vai ter a opção para reembolso, e você será redirecionando para uma conversa no whatssap direto com a empresa promovedora do evento. Não sendo de responsabilidade do ${configProvider.configs!.nomeApp}.\n\n',
                    ),
                    TextSpan(text: 'Reembolso:\n\n', style: estiloTituloTermos),
                    TextSpan(
                      text:
                          'Essa EMPRESA ou ORGANIZAÇÃO não permite Reembolso dos Ingressos. Em caso de dúvida entre em contato com a EMPRESA ou ORGANIZAÇÃO do Evento para mais informações. A ${configProvider.configs!.nomeApp} não se responsabiliza com reembolso devido que os pagamentos é feito diretamente aos responsáveis do Evento.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
