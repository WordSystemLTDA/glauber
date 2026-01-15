-- phpMyAdmin SQL Dump
-- version 4.7.7
-- https://www.phpmyadmin.net/
--
-- Host: gsequine.mysql.dbaas.com.br
-- Generation Time: 06-Dez-2025 às 22:38
-- Versão do servidor: 5.7.32-35-log
-- PHP Version: 5.6.40-0+deb8u12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gsequine`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `1_teste`
--

CREATE TABLE `1_teste` (
  `id` int(11) NOT NULL,
  `campo1` varchar(100) NOT NULL,
  `campo2` varchar(100) NOT NULL,
  `campo3` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `acessos`
--

CREATE TABLE `acessos` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `chave` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `alerta_notificacoes`
--

CREATE TABLE `alerta_notificacoes` (
  `id` int(11) NOT NULL,
  `ativo_prova` varchar(5) NOT NULL DEFAULT 'Sim',
  `cabeceiro_provas` varchar(100) NOT NULL,
  `pezeiro_provas` varchar(100) NOT NULL,
  `ativo_cadastro` varchar(5) NOT NULL DEFAULT 'Sim',
  `possui_cadastro_1` varchar(100) NOT NULL,
  `possui_cadastro_2` varchar(250) NOT NULL,
  `ativo_pagamento` varchar(5) NOT NULL DEFAULT 'Sim' COMMENT 'Dar um aAberta quando for pagamento em Pix.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `anexos_de_comprovantes`
--

CREATE TABLE `anexos_de_comprovantes` (
  `id` int(11) NOT NULL,
  `id_referencia` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `arquivo` varchar(150) NOT NULL,
  `id_tipo_de_anexo` int(11) NOT NULL,
  `nome_da_tabela` varchar(100) NOT NULL,
  `data_de_cadastro` date NOT NULL,
  `hora_de_cadastro` time NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `animais`
--

CREATE TABLE `animais` (
  `id` int(11) NOT NULL,
  `nome_do_animal` varchar(150) COLLATE latin1_general_ci NOT NULL,
  `ativo` varchar(5) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `data_nasci_animal` date NOT NULL,
  `sexo` varchar(50) COLLATE latin1_general_ci NOT NULL COMMENT 'Macho / \r\nFêmea',
  `registro` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `raca_do_animal` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `foto` varchar(250) COLLATE latin1_general_ci NOT NULL,
  `id_usuario_lanc` int(11) NOT NULL DEFAULT '0',
  `id_proprietario` int(11) NOT NULL DEFAULT '0',
  `data_cadastro` date NOT NULL,
  `hora_cadastro` time NOT NULL,
  `padrao` varchar(5) COLLATE latin1_general_ci DEFAULT 'Não'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `atualizacoes`
--

CREATE TABLE `atualizacoes` (
  `id` int(11) NOT NULL,
  `versao` varchar(20) NOT NULL,
  `arquivo` varchar(250) NOT NULL,
  `data_cadastro` date NOT NULL,
  `hora_cadastro` time NOT NULL,
  `ativo` varchar(5) NOT NULL DEFAULT '''Sim''',
  `obrigacao_de_atualizacao` int(11) NOT NULL DEFAULT '1' COMMENT '1 - Não Obrigatório\r\n2 - Obrigação Opcional\r\n3 - Obrigatório'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `atualizacoes_hc`
--

CREATE TABLE `atualizacoes_hc` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `hc_cabeceira` int(11) DEFAULT NULL,
  `hc_pezeiro` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `empresa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `bancos`
--

CREATE TABLE `bancos` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `empresa` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `banco_pix`
--

CREATE TABLE `banco_pix` (
  `id` int(11) NOT NULL,
  `nome` varchar(20) DEFAULT NULL,
  `banco` int(11) DEFAULT NULL,
  `pix_dinamico` varchar(5) DEFAULT NULL,
  `token_pix` varchar(100) DEFAULT NULL,
  `empresa` int(11) DEFAULT NULL,
  `registro` int(11) DEFAULT NULL,
  `ativo` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `banner_carrossel_evento`
--

CREATE TABLE `banner_carrossel_evento` (
  `id` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL,
  `foto` varchar(150) COLLATE latin1_general_ci NOT NULL,
  `ativo` varchar(5) COLLATE latin1_general_ci NOT NULL DEFAULT 'Sim',
  `data_de_cadastro` date NOT NULL,
  `hora_de_cadastro` time NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cabeceira`
--

CREATE TABLE `cabeceira` (
  `id` int(11) NOT NULL,
  `nome` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `caixa`
--

CREATE TABLE `caixa` (
  `id` int(11) NOT NULL,
  `data_ab` date DEFAULT NULL,
  `hora_ab` time DEFAULT NULL,
  `valor_ab` decimal(8,2) DEFAULT NULL,
  `usuario_ab` int(11) DEFAULT NULL,
  `data_fec` date DEFAULT NULL,
  `hora_fec` time DEFAULT NULL,
  `usuario_fec` int(11) DEFAULT NULL,
  `valor_fechamento` decimal(8,2) DEFAULT NULL,
  `status` varchar(15) DEFAULT NULL,
  `id_caixa_torno` int(11) DEFAULT NULL,
  `empresa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `caixa_turno`
--

CREATE TABLE `caixa_turno` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) DEFAULT NULL,
  `empresa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `calendario_eventos`
--

CREATE TABLE `calendario_eventos` (
  `id` int(11) NOT NULL,
  `titulo` varchar(100) NOT NULL,
  `ativo` varchar(5) DEFAULT NULL,
  `cor` varchar(55) NOT NULL,
  `link` varchar(255) NOT NULL,
  `cidade` int(11) DEFAULT NULL,
  `obs` varchar(255) NOT NULL,
  `data_inicio` date NOT NULL,
  `data_fim` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fim` time NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `categorias_menu`
--

CREATE TABLE `categorias_menu` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `imagem` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cat_despesas`
--

CREATE TABLE `cat_despesas` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `empresa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `certificado_digital_inter`
--

CREATE TABLE `certificado_digital_inter` (
  `id` int(11) NOT NULL,
  `tipo` varchar(30) COLLATE latin1_general_ci NOT NULL,
  `nome_certi_digital` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `ativo` varchar(5) COLLATE latin1_general_ci NOT NULL,
  `vencimento` date NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `certificado_digital_sicoob`
--

CREATE TABLE `certificado_digital_sicoob` (
  `id` int(11) NOT NULL,
  `tipo` varchar(55) NOT NULL,
  `nome_certi_digital` varchar(100) NOT NULL,
  `ativo` varchar(5) NOT NULL,
  `vencimento` date NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `certificado_digital_sicredi`
--

CREATE TABLE `certificado_digital_sicredi` (
  `id` int(11) NOT NULL,
  `tipo` varchar(55) NOT NULL,
  `nome_certi_digital` varchar(100) NOT NULL,
  `ativo` varchar(5) NOT NULL,
  `vencimento` date NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `cidades`
--

CREATE TABLE `cidades` (
  `id` int(11) NOT NULL,
  `codigo_uf` int(10) NOT NULL,
  `nome_uf` varchar(100) NOT NULL,
  `ibge` varchar(60) NOT NULL,
  `nome` varchar(200) NOT NULL,
  `sigla_uf` varchar(10) NOT NULL,
  `latitude` varchar(10) NOT NULL,
  `longitude` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estrutura da tabela `clientes`
--

CREATE TABLE `clientes` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `apelido` varchar(100) NOT NULL,
  `ativo` varchar(100) DEFAULT NULL,
  `civil` varchar(20) DEFAULT NULL,
  `sexo` varchar(100) DEFAULT NULL COMMENT 'Masculino\r\nFeminino\r\nNão Informado',
  `data_nascimento` date DEFAULT NULL,
  `cpf` varchar(100) DEFAULT NULL,
  `rg` varchar(30) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(100) NOT NULL,
  `token` varchar(255) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `celular` varchar(100) DEFAULT NULL,
  `cep` varchar(30) DEFAULT NULL,
  `endereco` varchar(30) DEFAULT NULL,
  `numero` varchar(30) DEFAULT NULL,
  `bairro` varchar(30) DEFAULT NULL,
  `complemento` varchar(30) DEFAULT NULL,
  `cidade` int(11) DEFAULT NULL,
  `observacoes` varchar(255) DEFAULT NULL,
  `hc_cabeceira` int(11) DEFAULT NULL,
  `hc_pezeiro` int(11) DEFAULT NULL,
  `data_cadastro` date DEFAULT NULL,
  `hora_cadastro` time DEFAULT NULL,
  `primeiro_acesso` varchar(5) DEFAULT 'Não',
  `hash` varchar(50) DEFAULT NULL,
  `tipo_de_pix` varchar(50) DEFAULT NULL,
  `chave_pix` varchar(250) DEFAULT NULL,
  `empresa` int(11) DEFAULT NULL,
  `nivel` varchar(50) DEFAULT 'Cliente',
  `laco_em_dupla` varchar(10) DEFAULT 'Pendente',
  `3_tambores` varchar(10) DEFAULT 'Pendente',
  `laco_individual` varchar(10) DEFAULT 'Pendente',
  `tipo_de_categoria_profissional` varchar(10) DEFAULT 'Pendente',
  `handi_cap_laco_individual` varchar(10) DEFAULT 'Pendente' COMMENT '1\r\n2\r\n3',
  `id;nome;apelido;email` varchar(50) DEFAULT NULL,
  `nome;apelido;email;senha` varchar(50) DEFAULT NULL,
  `ï»¿nome` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `clientes_bloqueados`
--

CREATE TABLE `clientes_bloqueados` (
  `id` int(11) UNSIGNED NOT NULL,
  `cliente` int(11) DEFAULT NULL,
  `empresa` int(11) DEFAULT NULL,
  `usuario` int(11) DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `data` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `config_wordsystem`
--

CREATE TABLE `config_wordsystem` (
  `id` int(11) NOT NULL,
  `nome_app` varchar(100) NOT NULL,
  `ano_app` varchar(100) NOT NULL,
  `logo_app` varchar(100) NOT NULL,
  `versao_app` varchar(30) NOT NULL,
  `versao_app_ios` varchar(30) NOT NULL,
  `atualizacao_android` varchar(100) NOT NULL,
  `atualizacao_ios` varchar(100) NOT NULL,
  `token_padrao_ml` varchar(100) NOT NULL,
  `obrigar_celular` varchar(5) DEFAULT 'Não',
  `obrigar_cidade` varchar(5) DEFAULT 'Não',
  `celular_suporte` varchar(50) DEFAULT NULL,
  `dias_de_consulta_pix` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `confirmacao_envios`
--

CREATE TABLE `confirmacao_envios` (
  `id` int(11) NOT NULL,
  `empresa` int(11) NOT NULL,
  `data_envio` date NOT NULL,
  `hora_envio` time NOT NULL,
  `tipo_de_envio` int(11) NOT NULL COMMENT '1 = Contas a Receber e Painel de Controle\r\n2 = Consultas e Marcações\r\n3 = Aniversariantes',
  `id_registro` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `contagem` int(11) NOT NULL,
  `obs` varchar(250) DEFAULT NULL,
  `hora_expeircao` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `contas_pagar`
--

CREATE TABLE `contas_pagar` (
  `id` int(11) NOT NULL,
  `descricao` varchar(50) NOT NULL,
  `cliente` int(11) DEFAULT NULL,
  `saida` varchar(50) DEFAULT NULL,
  `documento` varchar(50) DEFAULT NULL,
  `plano_conta` varchar(50) NOT NULL,
  `id_despesas` int(11) DEFAULT '0',
  `data_emissao` date NOT NULL,
  `vencimento` date NOT NULL,
  `frequencia` varchar(50) NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `usuario_lanc` int(11) NOT NULL,
  `usuario_baixa` int(11) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `data_recor` date DEFAULT NULL,
  `juros` decimal(8,2) DEFAULT NULL,
  `multa` decimal(8,2) DEFAULT NULL,
  `desconto` decimal(8,2) DEFAULT NULL,
  `subtotal` decimal(8,2) DEFAULT NULL,
  `data_baixa` date DEFAULT NULL,
  `id_compra` int(11) NOT NULL,
  `codigo_de_barras` varchar(150) DEFAULT NULL,
  `nosso_numero` varchar(50) DEFAULT NULL,
  `tipo_chave_pix` varchar(30) DEFAULT NULL,
  `chave_pix` varchar(150) DEFAULT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `contas_receber`
--

CREATE TABLE `contas_receber` (
  `id` int(11) NOT NULL,
  `empresa` int(11) NOT NULL,
  `descricao` varchar(50) NOT NULL,
  `cliente` int(11) DEFAULT NULL,
  `entrada` varchar(50) DEFAULT NULL,
  `documento` varchar(50) DEFAULT NULL,
  `plano_conta` varchar(50) NOT NULL,
  `data_emissao` date NOT NULL,
  `vencimento` date NOT NULL,
  `frequencia` varchar(50) NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `usuario_lanc` int(11) NOT NULL,
  `usuario_baixa` int(11) DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `data_recor` date DEFAULT NULL,
  `juros` decimal(8,2) DEFAULT NULL,
  `multa` decimal(8,2) DEFAULT NULL,
  `desconto` decimal(8,2) DEFAULT NULL,
  `subtotal` decimal(8,2) DEFAULT NULL,
  `data_baixa` date DEFAULT NULL,
  `id_venda` int(11) NOT NULL,
  `numero_contrato` varchar(100) DEFAULT NULL,
  `id_medico` int(11) NOT NULL DEFAULT '0',
  `obs_de_cobranca` varchar(500) DEFAULT NULL,
  `nosso_numero` varchar(100) DEFAULT NULL,
  `seraza` varchar(3) DEFAULT NULL,
  `id_vendedor` int(11) DEFAULT NULL,
  `tipo_de_finalizarcao` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `deletar_ordem_de_entrada`
--

CREATE TABLE `deletar_ordem_de_entrada` (
  `id` int(11) NOT NULL,
  `id_usuario_executado` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `data_cadastro` date NOT NULL,
  `hora_cadastro` time NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `denunciar_evento`
--

CREATE TABLE `denunciar_evento` (
  `id` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `denuncia` varchar(250) COLLATE latin1_general_ci DEFAULT NULL,
  `nome` varchar(60) COLLATE latin1_general_ci DEFAULT NULL,
  `celular` varchar(20) COLLATE latin1_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `descontos_por_provas`
--

CREATE TABLE `descontos_por_provas` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `valor` decimal(11,2) DEFAULT NULL,
  `data_cadastro` date DEFAULT NULL,
  `hora_cadastro` time DEFAULT NULL,
  `ativo` varchar(5) COLLATE latin1_general_ci DEFAULT 'Sim',
  `empresa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `despesas`
--

CREATE TABLE `despesas` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `cat_despesa` int(11) NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `empresas`
--

CREATE TABLE `empresas` (
  `id` int(11) NOT NULL,
  `razao_social` varchar(100) NOT NULL,
  `nome_fantasia` varchar(100) DEFAULT NULL,
  `ativo` varchar(5) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `cep` varchar(20) DEFAULT NULL,
  `endereco` varchar(100) DEFAULT NULL,
  `numero` varchar(20) DEFAULT NULL,
  `bairro` varchar(20) DEFAULT NULL,
  `complemento` varchar(20) DEFAULT NULL,
  `cidade` int(11) DEFAULT NULL,
  `observacoes` varchar(255) DEFAULT NULL,
  `data_cadastro` date DEFAULT NULL,
  `hora_cadastro` time DEFAULT NULL,
  `venda_dia1` varchar(10) DEFAULT NULL,
  `venda_dia2` varchar(10) DEFAULT NULL,
  `venda_dia3` varchar(10) DEFAULT NULL,
  `venda_dia4` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `eventos`
--

CREATE TABLE `eventos` (
  `id` int(11) NOT NULL,
  `nome_evento` varchar(100) NOT NULL,
  `ativo` varchar(5) NOT NULL,
  `descricao_1` varchar(100) NOT NULL,
  `descricao_2` varchar(100) NOT NULL,
  `data_evento` date NOT NULL,
  `data_fim_evento` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_termino` time NOT NULL,
  `foto` varchar(100) NOT NULL,
  `cep` varchar(100) NOT NULL,
  `endereco` varchar(100) NOT NULL,
  `numero` varchar(100) NOT NULL,
  `bairro` varchar(100) NOT NULL,
  `complemento` varchar(100) NOT NULL,
  `cidade` int(11) NOT NULL,
  `data_cadastro` date NOT NULL,
  `hora_cadastro` time NOT NULL,
  `hash` varchar(50) NOT NULL DEFAULT '',
  `liberacao_de_compra` int(11) NOT NULL COMMENT '1 => Somente um pacote por Competidor\r\n2 => Correndo invertido é considerado como Outro.',
  `empresa` int(11) NOT NULL,
  `latitude` varchar(50) NOT NULL DEFAULT '',
  `longitude` varchar(50) NOT NULL DEFAULT '',
  `categoria` int(11) DEFAULT '0',
  `permitir_editar_parceiros` varchar(5) DEFAULT 'Sim',
  `perm_vincular_parceiro` varchar(5) DEFAULT 'Sim',
  `tipo_de_cobranca_inscricao` int(11) DEFAULT NULL COMMENT '1 => transação\r\n2 => por Inscrição',
  `valor_taxa` decimal(11,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `filiacoes`
--

CREATE TABLE `filiacoes` (
  `id` int(11) NOT NULL,
  `valor` decimal(11,2) NOT NULL,
  `empresa` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL,
  `data_cadastro` date NOT NULL,
  `hora_cadastro` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `formas_pgtos`
--

CREATE TABLE `formas_pgtos` (
  `id` int(11) NOT NULL,
  `nome` varchar(30) NOT NULL,
  `empresa` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `fornecedores`
--

CREATE TABLE `fornecedores` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `email` varchar(50) DEFAULT NULL,
  `pessoa` varchar(15) NOT NULL,
  `doc` varchar(20) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `inscricao_municipal` varchar(100) DEFAULT NULL,
  `inscricao_estadual` varchar(100) DEFAULT NULL,
  `ativo` varchar(5) NOT NULL,
  `obs` varchar(100) DEFAULT NULL,
  `data` date NOT NULL,
  `cep` varchar(50) NOT NULL,
  `endereco` varchar(100) DEFAULT NULL,
  `numero` varchar(30) DEFAULT NULL,
  `bairro` varchar(100) DEFAULT NULL,
  `cidade` varchar(50) NOT NULL,
  `estado` varchar(50) NOT NULL,
  `complemento` varchar(50) NOT NULL,
  `banco` int(11) DEFAULT NULL,
  `tipo_de_conta` varchar(60) DEFAULT NULL,
  `agencia` varchar(10) DEFAULT NULL,
  `conta` varchar(25) DEFAULT NULL,
  `tipo_chave_pix` varchar(30) DEFAULT NULL,
  `chave_pix` varchar(150) DEFAULT NULL,
  `empresa` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `frequencias`
--

CREATE TABLE `frequencias` (
  `id` int(11) NOT NULL,
  `nome` varchar(30) NOT NULL,
  `dias` int(11) NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `funcionarios`
--

CREATE TABLE `funcionarios` (
  `id` int(11) NOT NULL,
  `nome_completo` varchar(100) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `ativo` varchar(10) NOT NULL,
  `cpf` varchar(30) NOT NULL,
  `rg` varchar(30) NOT NULL,
  `funcao` varchar(60) NOT NULL,
  `email` varchar(60) NOT NULL,
  `celular` varchar(30) NOT NULL,
  `cidade` varchar(60) NOT NULL,
  `cep` varchar(30) NOT NULL,
  `endereco` varchar(100) NOT NULL,
  `numero` varchar(10) NOT NULL,
  `bairro` varchar(30) NOT NULL,
  `nascimento` date NOT NULL,
  `obs` varchar(200) NOT NULL,
  `foto` varchar(255) NOT NULL,
  `complemento` varchar(100) NOT NULL,
  `estado` varchar(50) NOT NULL,
  `percentual_comissao` decimal(11,2) DEFAULT NULL,
  `valor_hab_comissao` decimal(11,2) DEFAULT NULL,
  `data` date NOT NULL,
  `empresa` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `funcoes`
--

CREATE TABLE `funcoes` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `empresa` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `instancias`
--

CREATE TABLE `instancias` (
  `id` int(11) NOT NULL,
  `empresa` int(11) NOT NULL DEFAULT '0',
  `enviar_api` varchar(3) NOT NULL,
  `financeiro` varchar(30) NOT NULL,
  `comercial` varchar(30) NOT NULL,
  `consulta` varchar(30) NOT NULL,
  `administrador` varchar(30) NOT NULL,
  `meu_token` varchar(100) NOT NULL,
  `aniversariantes_automatico` varchar(3) NOT NULL,
  `consultas_do_dia` varchar(3) NOT NULL,
  `consultas_1_dia_anterior` varchar(3) NOT NULL,
  `vencimento_do_dia` varchar(3) NOT NULL,
  `dias_de_carencia_vencido` int(11) NOT NULL DEFAULT '0' COMMENT 'se for = 0 não vai disparar mensagem nos dias anteriores automaticamente',
  `habilitar_contas_receber` int(3) NOT NULL COMMENT 'Com Quantos Dias que vai aparecer o Botão para fazer a Cobrança novamente em Contas a receber',
  `enviar_consultas_por_usuario` varchar(50) DEFAULT NULL,
  `enviar_confir_horario` varchar(3) DEFAULT NULL,
  `enviar_contas_pagar_do_dia` varchar(3) DEFAULT NULL,
  `enviar_contas_pagar_1_dia_antes` varchar(3) DEFAULT NULL,
  `disparar_retorno_automatico` varchar(3) DEFAULT NULL,
  `disparo_do_retorno_dias_antes` int(11) DEFAULT '0',
  `celular_rece_contas_pagar_1` varchar(30) DEFAULT NULL,
  `celular_rece_contas_pagar_2` varchar(30) DEFAULT NULL,
  `celular_rece_contas_pagar_3` varchar(30) DEFAULT NULL,
  `e_mail` varchar(200) DEFAULT NULL,
  `senha_email` varchar(200) DEFAULT NULL,
  `enviar_notific_recarga_cartao` varchar(3) DEFAULT NULL,
  `enviar_saldo_automaticamente` varchar(3) DEFAULT NULL,
  `halilitar_envio_saldo_novamente` int(11) DEFAULT NULL,
  `enviar_total_das_contas_receber_no_dia` varchar(3) DEFAULT NULL COMMENT 'Enviar Total que a Pessoa Esta Devendo no Dia as Contas a Receber\r\n',
  `enviar_total_das_contas_receber_1_dia_antes` varchar(3) DEFAULT NULL COMMENT 'Enviar Total que a Pessoa Esta Devendo \r\n1 dia Antes as Contas a Receber\r\n',
  `enviar_todas_as_contas_receber_atrasadas` varchar(3) DEFAULT NULL COMMENT 'Habilitar o Envio de Todas as\r\nContas a Receber que estão em Atraso\r\nTodas as Notinhas',
  `carencia_de_envio_de_todas_as_contas_receber_atrasadas` int(11) DEFAULT NULL COMMENT 'Quantos dias para envio das Contas a receber\r\nQue estão em Atraso\r\n',
  `enviar_novamente_a_cada_todas_contas_receber` int(11) DEFAULT NULL COMMENT 'Quantos dias que vai enviar novamente as \r\nContas que Estão em Atraso',
  `enviar_somente_total_de_todas_as_contas_receber_atrasadas` varchar(3) DEFAULT NULL COMMENT 'Habilitar o Envio de Todas as\r\nContas a Receber que estão em Atraso \r\nSomente o Valor Total',
  `enviar_notificacao_agendamento` varchar(5) DEFAULT NULL,
  `enviar_pos_operatorio` varchar(20) DEFAULT NULL,
  `confirmacao_de_fim_semana` varchar(20) DEFAULT NULL,
  `enviar_conf_cancelamento` varchar(20) DEFAULT NULL,
  `envios_nome_dr_mens` varchar(5) DEFAULT NULL,
  `intervado_de_dias_not` varchar(5) DEFAULT NULL,
  `tipo_envio_massa` varchar(5) DEFAULT NULL,
  `notificar_edicao_horario` varchar(5) DEFAULT 'Não',
  `debitar_automatico_mensalidde` varchar(3) DEFAULT NULL,
  `data_do_debito_mensalidade` date DEFAULT NULL,
  `valor_da_mensalidade` decimal(11,2) DEFAULT NULL,
  `enviar_pedido_em_producao` varchar(5) DEFAULT 'Não',
  `enviar_recebimento_de_pedido` varchar(5) DEFAULT 'Não',
  `enviar_detalhes_do_pedido` varchar(5) DEFAULT 'Não',
  `enviar_chave_pix` varchar(5) DEFAULT 'Não'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `itens_venda`
--

CREATE TABLE `itens_venda` (
  `id` int(11) NOT NULL,
  `id_venda` int(11) NOT NULL,
  `id_prova` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL,
  `id_cabeceira` int(11) NOT NULL,
  `valor` decimal(11,2) NOT NULL DEFAULT '0.00',
  `quantidade` decimal(11,2) NOT NULL DEFAULT '0.00',
  `total` decimal(11,2) NOT NULL DEFAULT '0.00',
  `data_lanc` date NOT NULL,
  `hora_lanc` time NOT NULL,
  `empresa` int(11) NOT NULL DEFAULT '0',
  `id_modalidade` int(11) DEFAULT NULL,
  `id_animal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `lista_competicao`
--

CREATE TABLE `lista_competicao` (
  `id` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL,
  `nome` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `data_de_cadastro` date NOT NULL,
  `hora_de_cadastro` time NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `logs`
--

CREATE TABLE `logs` (
  `id` int(11) NOT NULL,
  `data` date NOT NULL,
  `hora` time NOT NULL,
  `tabela` varchar(30) NOT NULL,
  `acao` varchar(35) NOT NULL,
  `usuario` int(11) NOT NULL,
  `id_reg` int(11) NOT NULL,
  `descricao` varchar(250) NOT NULL,
  `empresa` int(11) NOT NULL,
  `contagem` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `logs_view`
--

CREATE TABLE `logs_view` (
  `id` int(11) NOT NULL,
  `cliente` int(11) NOT NULL,
  `data` date NOT NULL,
  `hora` time NOT NULL,
  `empresa` int(11) NOT NULL,
  `evento` int(11) NOT NULL,
  `tipo_acesso` varchar(30) DEFAULT 'App',
  `contagem` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `logs_visitante`
--

CREATE TABLE `logs_visitante` (
  `id` int(11) NOT NULL,
  `data` date NOT NULL,
  `hora` time NOT NULL,
  `acao` varchar(35) NOT NULL,
  `quant` int(11) NOT NULL,
  `descricao` varchar(35) NOT NULL,
  `tipo_acesso` varchar(30) NOT NULL,
  `ip_acesso` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `mensagens_padrao`
--

CREATE TABLE `mensagens_padrao` (
  `id` int(11) NOT NULL,
  `empresa` varchar(200) NOT NULL,
  `cliente_1` varchar(200) NOT NULL,
  `aniversariante_1` varchar(200) NOT NULL,
  `aniversariante_2` varchar(200) NOT NULL,
  `marcacoes_1` varchar(200) NOT NULL,
  `marcacoes_2` varchar(200) NOT NULL,
  `marcacoes_3` varchar(200) NOT NULL,
  `marcacoes_4` varchar(200) NOT NULL,
  `marcacoes_5` varchar(200) NOT NULL,
  `consultas_1` varchar(200) NOT NULL,
  `consultas_2` varchar(200) NOT NULL,
  `consultas_3` varchar(200) NOT NULL,
  `consultas_4` varchar(200) NOT NULL,
  `consultas_5` varchar(200) NOT NULL,
  `receber_1` varchar(200) NOT NULL,
  `receber_2` varchar(200) NOT NULL,
  `receber_3` varchar(200) NOT NULL,
  `retorno_1` varchar(200) NOT NULL,
  `retorno_2` varchar(200) NOT NULL,
  `retorno_3` varchar(200) NOT NULL,
  `retorno_4` varchar(200) NOT NULL,
  `receber_vencida_1` varchar(200) NOT NULL,
  `receber_vencida_2` varchar(200) NOT NULL,
  `receber_vencida_3` varchar(200) NOT NULL,
  `receber_vencida_4` varchar(200) NOT NULL,
  `mensagem_confir_horario` varchar(200) NOT NULL,
  `contas_pagar_1` varchar(200) NOT NULL,
  `contas_pagar_2` varchar(200) NOT NULL,
  `contas_pagar_3` varchar(200) NOT NULL,
  `contas_pagar_4` varchar(200) NOT NULL,
  `receber_total_contas_no_dia` varchar(250) NOT NULL,
  `receber_total_contas_amanha` varchar(250) NOT NULL,
  `receber_total_todas_contas_vencidas` varchar(250) NOT NULL,
  `notif_agendamento_1` varchar(250) NOT NULL,
  `notif_agendamento_2` varchar(250) NOT NULL,
  `notif_agendamento_3` varchar(250) NOT NULL,
  `consulta_1_dia_antes` varchar(250) NOT NULL,
  `consulta_2_dia_antes` varchar(250) NOT NULL,
  `consulta_3_dia_antes` varchar(250) NOT NULL,
  `consulta_4_dia_antes` varchar(250) NOT NULL,
  `consulta_5_dia_antes` varchar(250) NOT NULL,
  `mensagem_confir_cancelamento1` varchar(250) NOT NULL,
  `mensagem_confir_cancelamento2` varchar(250) NOT NULL,
  `edicao_de_agendamento` varchar(200) DEFAULT NULL,
  `recebimento_de_pedido` varchar(250) DEFAULT 'Seu pedido foi realizado com Sucesso',
  `detalhes_do_pedido` varchar(250) DEFAULT 'Obrigado pela preferência, se precisar de algo é só chamar!',
  `chave_pix_manual` varchar(250) DEFAULT '44999213336',
  `tipo_de_chave_pix_manual` varchar(250) DEFAULT 'Celular',
  `nome_da_chave_pix_manual` varchar(250) DEFAULT 'Word System'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `modelo_pagamento`
--

CREATE TABLE `modelo_pagamento` (
  `id` int(11) NOT NULL,
  `nome` varchar(60) NOT NULL,
  `obs` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `movimentacoes`
--

CREATE TABLE `movimentacoes` (
  `id` int(11) NOT NULL,
  `id_mov` int(11) DEFAULT NULL,
  `tipo` varchar(15) NOT NULL,
  `movimento` varchar(50) NOT NULL,
  `descricao` varchar(100) NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `usuario` int(11) NOT NULL,
  `data` date NOT NULL,
  `lancamento` varchar(35) DEFAULT NULL,
  `plano_conta` varchar(35) DEFAULT NULL,
  `documento` varchar(35) DEFAULT NULL,
  `caixa_periodo` int(11) DEFAULT NULL,
  `cliente` varchar(60) NOT NULL,
  `empresa` int(11) NOT NULL DEFAULT '0',
  `id_medico` int(11) DEFAULT NULL,
  `percentual_comissao` decimal(11,2) DEFAULT NULL,
  `id_vendedor` int(11) DEFAULT NULL,
  `tipo_de_finalizarcao` varchar(10) DEFAULT NULL,
  `venc_conta_receber` date DEFAULT NULL,
  `valor_sem_juros` decimal(11,2) DEFAULT NULL,
  `valor_multa` decimal(11,2) DEFAULT NULL,
  `valor_juros` decimal(11,2) DEFAULT NULL,
  `id_conta_receber` int(11) NOT NULL DEFAULT '0',
  `id_caixa_turno` int(11) DEFAULT NULL,
  `id_caixa` int(11) DEFAULT NULL,
  `observacoes` varchar(250) DEFAULT NULL,
  `valor_desconto` decimal(11,2) DEFAULT NULL,
  `valor_taxa` decimal(11,2) DEFAULT NULL,
  `total` decimal(11,2) DEFAULT NULL,
  `hora` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `niveis`
--

CREATE TABLE `niveis` (
  `id` int(11) NOT NULL,
  `nivel` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `ordem_de_entrada`
--

CREATE TABLE `ordem_de_entrada` (
  `id` int(11) NOT NULL,
  `id_venda` int(11) DEFAULT NULL,
  `id_cabeceira` int(11) DEFAULT NULL,
  `id_pezeiro` int(11) DEFAULT NULL,
  `id_prova` int(11) DEFAULT NULL,
  `somatoria` varchar(50) DEFAULT NULL,
  `numero_da_inscricao` varchar(50) DEFAULT NULL,
  `sorteio_cabeceira` varchar(10) DEFAULT NULL,
  `sorteio_pezeiro` varchar(10) NOT NULL,
  `data_cadastro` date DEFAULT NULL,
  `empresa` int(11) DEFAULT '0',
  `boi_1` varchar(50) DEFAULT NULL,
  `boi_2` varchar(50) DEFAULT NULL,
  `boi_3` varchar(50) DEFAULT NULL,
  `boi_4` varchar(50) DEFAULT NULL,
  `final` varchar(50) DEFAULT NULL,
  `medio` varchar(50) DEFAULT NULL,
  `ranking` int(11) DEFAULT NULL,
  `dt_edicao_horsecode` varchar(50) DEFAULT '50',
  `classificacao` int(11) DEFAULT NULL,
  `id_modalidade` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `permissoes_dados`
--

CREATE TABLE `permissoes_dados` (
  `id` int(11) NOT NULL,
  `empresa` varchar(5) NOT NULL,
  `cliente_cpf` varchar(5) NOT NULL,
  `cliente_rg` varchar(5) NOT NULL,
  `cliente_data_nascimento` varchar(5) NOT NULL,
  `cliente_email` varchar(5) NOT NULL,
  `cliente_telefone` varchar(5) NOT NULL,
  `cliente_celular` varchar(5) NOT NULL,
  `cliente_endereco` varchar(5) NOT NULL,
  `cliente_apelido` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `permissoes_empresa`
--

CREATE TABLE `permissoes_empresa` (
  `id` int(11) NOT NULL,
  `empresa` int(11) NOT NULL,
  `token_mercadopago` varchar(200) DEFAULT NULL,
  `parcelas_mercadopago` int(11) DEFAULT NULL,
  `whatsapp_suporte` varchar(50) DEFAULT '',
  `desconto_maximo` decimal(11,2) DEFAULT NULL,
  `tempo_cancel` varchar(10) DEFAULT NULL,
  `status_libera_pix_MP` int(11) DEFAULT '2' COMMENT '1 = Liberado\r\n2 = Não Liberdado',
  `status_libera_local` int(11) DEFAULT '2' COMMENT '1 = Liberado\r\n2 = Não Liberdado',
  `status_libera_cc_MP` int(11) DEFAULT '2' COMMENT '1 = Liberado\r\n2 = Não Liberdado',
  `status_libera_pix_inter` int(11) DEFAULT '2' COMMENT '1 = Liberado\r\n2 = Não Liberdado',
  `status_libera_pix_sicredi` int(11) DEFAULT '2' COMMENT '1 = Liberado\r\n2 = Não Liberdado',
  `status_libera_pix_asaas` int(11) DEFAULT '2' COMMENT '1 = Liberado\r\n2 = Não Liberdado',
  `taxa_cartao` decimal(11,2) DEFAULT '0.00',
  `obrigar_celular_venda` varchar(5) NOT NULL DEFAULT 'Sim',
  `obrigar_cidade_venda` varchar(5) NOT NULL DEFAULT 'Sim',
  `chave_pix_inter` varchar(100) DEFAULT '2326c8b8-d335-4b23-80ec-c2ee6f6fd768',
  `client_id_inter` varchar(100) DEFAULT '5a512d4b-8b35-4b1d-818b-c4b1a13e9360',
  `client_secret_inter` varchar(100) DEFAULT '21bf84cb-bb19-4b36-8531-7f5b8972f4a9',
  `token_sicredi` varchar(100) DEFAULT 'TkRZeU5EVXhOVE13TURBeE1EZzZNREF3TWpveFZIZzpLekZqUUZCNk1ETWpSakJvYlZreQ',
  `chave_pix_sicredi` varchar(100) DEFAULT 'da443c17-131e-4b48-a222-ff78bb057c73',
  `token_de_acesso_inter` varchar(100) DEFAULT 'feb3729c-7005-4d95-ad02-95957b58508b',
  `expiracao_token_de_acesso` datetime DEFAULT NULL,
  `chave_api_asaas` varchar(200) DEFAULT '$aact_YTU5YTE0M2M2N2I4MTliNzk0YTI5N2U5MzdjNWZmNDQ6OjAwMDAwMDAwMDAwMDAwMzE5MzQ6OiRhYWNoX2VlMzNmYzY2LTA2NTUtNDNiYy04MzJlLTQ4ZWNiMjZmZWQwMA==',
  `chave_pix_asaas` varchar(200) DEFAULT '31d25ba6-1989-484f-92a2-bd8dbc2478ed',
  `status_libera_pix_sicoob` int(11) DEFAULT '1' COMMENT '1 = Liberado 2 = Não Liberdado',
  `client_id_sicoob` varchar(100) DEFAULT '37175afe-6e75-4f90-9dab-189cbc9fe478',
  `chave_pix_sicoob` varchar(100) DEFAULT 'fcbe3b23-60df-446d-a5bd-cc4d204d03db',
  `requerido_for_doc` varchar(10) DEFAULT 'Não',
  `requerido_for_email` varchar(10) DEFAULT 'Não',
  `requerido_for_telefone` varchar(10) DEFAULT 'Não',
  `requerido_for_esdereco` varchar(10) DEFAULT 'Não',
  `habil_logs_sistema` varchar(10) DEFAULT 'Sim',
  `habilitar_fechamento_banco` varchar(10) DEFAULT 'Sim',
  `habil_caixa_gerenciado` varchar(10) DEFAULT 'Não'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `pesquisa_personalizada`
--

CREATE TABLE `pesquisa_personalizada` (
  `id` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `informacao_de_pesquisa` varchar(50) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `empresa` int(11) NOT NULL,
  `posicao_de_select` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `propaganda_publicidade`
--

CREATE TABLE `propaganda_publicidade` (
  `id` int(11) NOT NULL,
  `nome` varchar(60) COLLATE latin1_general_ci NOT NULL,
  `ativo` varchar(3) COLLATE latin1_general_ci NOT NULL,
  `foto` varchar(250) COLLATE latin1_general_ci NOT NULL,
  `tipo_servico` varchar(60) COLLATE latin1_general_ci NOT NULL,
  `instagram` varchar(250) COLLATE latin1_general_ci NOT NULL,
  `codigo_video` varchar(250) COLLATE latin1_general_ci NOT NULL,
  `celular` varchar(15) COLLATE latin1_general_ci NOT NULL,
  `obs` varchar(1000) COLLATE latin1_general_ci NOT NULL,
  `data_cadastro` date NOT NULL,
  `hora_cadastro` time NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `provas`
--

CREATE TABLE `provas` (
  `id` int(11) NOT NULL,
  `id_evento` int(11) NOT NULL,
  `nome_prova` varchar(100) DEFAULT NULL,
  `ativo` varchar(5) DEFAULT NULL,
  `prova_oculta` varchar(5) DEFAULT NULL,
  `taxa` decimal(11,2) DEFAULT '0.00',
  `valor` decimal(11,2) DEFAULT NULL,
  `lote` int(11) DEFAULT NULL,
  `aviso` varchar(100) DEFAULT NULL,
  `descricao_1` varchar(40) DEFAULT NULL,
  `descricao_2` varchar(100) DEFAULT NULL,
  `data_liberacao_venda` date DEFAULT NULL,
  `hora_liberacao_venda` time DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `data_cadastro` date DEFAULT NULL,
  `hora_cadastro` time DEFAULT NULL,
  `h_c_minimo` int(11) DEFAULT NULL,
  `h_c_maximo` int(11) DEFAULT NULL,
  `empresa` int(11) DEFAULT NULL,
  `avulsa` varchar(5) DEFAULT 'Não',
  `quant_minima` int(11) DEFAULT '1',
  `quant_maxima` int(11) DEFAULT '1',
  `id_somatoria_handicaps` int(11) DEFAULT NULL,
  `quant_parceiros` int(11) DEFAULT NULL,
  `quant_max_inscricoes` int(11) DEFAULT NULL COMMENT 'Se for Igual 0 = Será compra Ilimitada',
  `permitir_sorteio` varchar(5) DEFAULT 'Sim',
  `habilitar_aovivo` varchar(5) DEFAULT 'Não',
  `permitir_editar_parceiros` varchar(5) DEFAULT 'Sim',
  `quant_max_inscri_p_fechado` int(11) DEFAULT '1' COMMENT 'Se for Igual 0 = Será compra Ilimitada',
  `liberar_reembolso` varchar(5) DEFAULT 'Sim',
  `quant_max_inscricoes_cabeceira` int(11) DEFAULT NULL COMMENT 'Se for Igual 0 = Será compra Ilimitada	',
  `quant_max_inscricoes_pezeiro` int(11) DEFAULT NULL COMMENT 'Se for Igual 0 = Será compra Ilimitada	',
  `id_lista_competicao` int(11) DEFAULT NULL,
  `id_categorias_menu` int(11) DEFAULT '2',
  `idade_maxima` int(11) DEFAULT '0' COMMENT '0 = Qualquer Idade',
  `genero_permitido` varchar(10) DEFAULT NULL COMMENT 'Todos\r\nMasculino\r\nFeminino',
  `tipo_de_categoria_profissional` varchar(20) DEFAULT NULL COMMENT 'Todos\r\nProfissional\r\nAmador',
  `compra_ordenada` varchar(5) DEFAULT NULL COMMENT 'Não',
  `sequencia_ordenada` int(11) DEFAULT NULL,
  `hand_cap_maximo_individual` int(11) DEFAULT NULL,
  `lib_me_ani_outra_pes` varchar(5) DEFAULT NULL COMMENT 'liberar_mesmo_animal_outra_pessoa',
  `id_descontos_por_provas` int(11) DEFAULT NULL,
  `ins_cab_eq` int(11) DEFAULT NULL,
  `insc_pe_eq` int(11) DEFAULT NULL,
  `hc_min_enc` int(11) DEFAULT NULL,
  `hc_max_enc` int(11) DEFAULT NULL,
  `soma_min_enc` int(11) DEFAULT NULL,
  `soma_max_enc` int(11) DEFAULT NULL,
  `soma_min_enc2` int(11) DEFAULT NULL,
  `hc_min_sort` int(11) DEFAULT NULL,
  `hc_max_sort` int(11) DEFAULT NULL,
  `dist_ins` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `somatoria`
--

CREATE TABLE `somatoria` (
  `id` int(11) NOT NULL,
  `nome` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `somatoria_handicaps`
--

CREATE TABLE `somatoria_handicaps` (
  `id` int(11) NOT NULL,
  `nome` decimal(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tipo_de_anexo`
--

CREATE TABLE `tipo_de_anexo` (
  `id` int(11) NOT NULL,
  `nome` varchar(150) NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `tokens_notificacao`
--

CREATE TABLE `tokens_notificacao` (
  `id` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `token` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `id_funcionario` int(11) NOT NULL,
  `ativo` varchar(3) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(100) NOT NULL,
  `confirmacao_senha` varchar(100) NOT NULL,
  `nivel` varchar(100) NOT NULL,
  `receber_not_venda` varchar(100) NOT NULL,
  `empresa` int(11) NOT NULL,
  `data_cadastro` date NOT NULL,
  `hora_cadastro` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuarios_permissoes`
--

CREATE TABLE `usuarios_permissoes` (
  `id` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `permissao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `valor_parcial`
--

CREATE TABLE `valor_parcial` (
  `id` int(11) NOT NULL,
  `id_conta` int(11) NOT NULL,
  `tipo` varchar(30) NOT NULL,
  `valor` decimal(8,2) NOT NULL,
  `data` date NOT NULL,
  `usuario` int(11) NOT NULL,
  `id_movimentacoes` int(11) NOT NULL,
  `empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `vendas`
--

CREATE TABLE `vendas` (
  `id` int(11) NOT NULL,
  `id_empresa` int(11) DEFAULT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_compra` varchar(100) DEFAULT NULL,
  `id_evento` int(11) DEFAULT '0',
  `data_evento` date DEFAULT NULL,
  `id_forma_pagamento` int(11) DEFAULT NULL,
  `lancamento` int(11) DEFAULT NULL,
  `data_pgto` date DEFAULT NULL,
  `valor_ingresso` decimal(11,2) DEFAULT NULL,
  `valor_taxa` decimal(11,2) DEFAULT NULL,
  `valor_taxa_cartao` decimal(11,2) DEFAULT NULL,
  `valor_desconto` decimal(11,2) DEFAULT NULL,
  `valor_total` decimal(11,2) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `pago` varchar(5) DEFAULT 'Não',
  `codigo_qr` varchar(100) DEFAULT NULL,
  `txid` varchar(100) DEFAULT NULL,
  `codigo_pix` varchar(255) DEFAULT NULL,
  `parcelas` int(11) DEFAULT NULL,
  `tipo_de_venda` varchar(100) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `data_compra` date DEFAULT NULL,
  `hora_compra` time DEFAULT NULL,
  `local_compra` varchar(5) DEFAULT 'App',
  `valor_filiacao` decimal(11,2) DEFAULT NULL,
  `txid_2` varchar(100) DEFAULT NULL,
  `pix_vencido` varchar(5) DEFAULT 'Não',
  `reembolso` varchar(10) DEFAULT 'Não' COMMENT 'Não\r\nPendente\r\nConfirmado',
  `hora_pgto` time DEFAULT NULL,
  `excluido` varchar(5) DEFAULT 'Não',
  `data_excluido` date DEFAULT NULL,
  `hora_excluido` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estrutura da tabela `vincular_parceiros`
--

CREATE TABLE `vincular_parceiros` (
  `id` int(11) NOT NULL,
  `id_vendas_cabeceira` varchar(100) NOT NULL DEFAULT '0',
  `id_vendas_pezeiro` varchar(100) NOT NULL DEFAULT '0',
  `id_provas` int(11) NOT NULL,
  `id_cabeceira` int(11) NOT NULL,
  `id_pezeiro` int(11) NOT NULL,
  `data_cadastro` date DEFAULT NULL,
  `hora_cadastro` time DEFAULT NULL,
  `editado_parc` varchar(5) DEFAULT 'Não',
  `empresa` int(11) NOT NULL,
  `data_edicao` date DEFAULT NULL,
  `hora_edicao` time DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL COMMENT 'APENAS INFORMATIVO	',
  `status` varchar(50) DEFAULT NULL COMMENT 'Pendente -> Tem que confirmar a inscrição Confirmado	'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `1_teste`
--
ALTER TABLE `1_teste`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `acessos`
--
ALTER TABLE `acessos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `alerta_notificacoes`
--
ALTER TABLE `alerta_notificacoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `anexos_de_comprovantes`
--
ALTER TABLE `anexos_de_comprovantes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `animais`
--
ALTER TABLE `animais`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `atualizacoes`
--
ALTER TABLE `atualizacoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `atualizacoes_hc`
--
ALTER TABLE `atualizacoes_hc`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bancos`
--
ALTER TABLE `bancos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `banco_pix`
--
ALTER TABLE `banco_pix`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `banner_carrossel_evento`
--
ALTER TABLE `banner_carrossel_evento`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cabeceira`
--
ALTER TABLE `cabeceira`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `caixa`
--
ALTER TABLE `caixa`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `caixa_turno`
--
ALTER TABLE `caixa_turno`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `calendario_eventos`
--
ALTER TABLE `calendario_eventos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categorias_menu`
--
ALTER TABLE `categorias_menu`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cat_despesas`
--
ALTER TABLE `cat_despesas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `certificado_digital_inter`
--
ALTER TABLE `certificado_digital_inter`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `certificado_digital_sicoob`
--
ALTER TABLE `certificado_digital_sicoob`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `certificado_digital_sicredi`
--
ALTER TABLE `certificado_digital_sicredi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cidades`
--
ALTER TABLE `cidades`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `clientes_bloqueados`
--
ALTER TABLE `clientes_bloqueados`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `config_wordsystem`
--
ALTER TABLE `config_wordsystem`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `confirmacao_envios`
--
ALTER TABLE `confirmacao_envios`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contas_pagar`
--
ALTER TABLE `contas_pagar`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contas_receber`
--
ALTER TABLE `contas_receber`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deletar_ordem_de_entrada`
--
ALTER TABLE `deletar_ordem_de_entrada`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `denunciar_evento`
--
ALTER TABLE `denunciar_evento`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `descontos_por_provas`
--
ALTER TABLE `descontos_por_provas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `despesas`
--
ALTER TABLE `despesas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `empresas`
--
ALTER TABLE `empresas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ativo` (`ativo`),
  ADD KEY `empresa` (`empresa`);

--
-- Indexes for table `filiacoes`
--
ALTER TABLE `filiacoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `formas_pgtos`
--
ALTER TABLE `formas_pgtos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `fornecedores`
--
ALTER TABLE `fornecedores`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `frequencias`
--
ALTER TABLE `frequencias`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `funcionarios`
--
ALTER TABLE `funcionarios`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `funcoes`
--
ALTER TABLE `funcoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `instancias`
--
ALTER TABLE `instancias`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `itens_venda`
--
ALTER TABLE `itens_venda`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_venda_id_prova` (`id_venda`,`id_prova`);

--
-- Indexes for table `lista_competicao`
--
ALTER TABLE `lista_competicao`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_view`
--
ALTER TABLE `logs_view`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `logs_visitante`
--
ALTER TABLE `logs_visitante`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mensagens_padrao`
--
ALTER TABLE `mensagens_padrao`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modelo_pagamento`
--
ALTER TABLE `modelo_pagamento`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `movimentacoes`
--
ALTER TABLE `movimentacoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `empresa` (`empresa`),
  ADD KEY `documento` (`documento`),
  ADD KEY `id_mov` (`id_mov`),
  ADD KEY `data` (`data`),
  ADD KEY `lancamento` (`lancamento`);

--
-- Indexes for table `niveis`
--
ALTER TABLE `niveis`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ordem_de_entrada`
--
ALTER TABLE `ordem_de_entrada`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_cabeceira_id_pezeiro_id_prova_numero_da_inscricao_empresa` (`id_cabeceira`,`id_pezeiro`,`id_prova`,`numero_da_inscricao`,`empresa`);

--
-- Indexes for table `permissoes_dados`
--
ALTER TABLE `permissoes_dados`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissoes_empresa`
--
ALTER TABLE `permissoes_empresa`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pesquisa_personalizada`
--
ALTER TABLE `pesquisa_personalizada`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `propaganda_publicidade`
--
ALTER TABLE `propaganda_publicidade`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `provas`
--
ALTER TABLE `provas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_evento` (`id_evento`),
  ADD KEY `ativo` (`ativo`),
  ADD KEY `prova_oculta` (`prova_oculta`),
  ADD KEY `empresa` (`empresa`);

--
-- Indexes for table `somatoria`
--
ALTER TABLE `somatoria`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `somatoria_handicaps`
--
ALTER TABLE `somatoria_handicaps`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tipo_de_anexo`
--
ALTER TABLE `tipo_de_anexo`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tokens_notificacao`
--
ALTER TABLE `tokens_notificacao`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usuarios_permissoes`
--
ALTER TABLE `usuarios_permissoes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `valor_parcial`
--
ALTER TABLE `valor_parcial`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `vendas`
--
ALTER TABLE `vendas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_id_cliente_status` (`id`,`id_cliente`,`status`);

--
-- Indexes for table `vincular_parceiros`
--
ALTER TABLE `vincular_parceiros`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_vendas_cabeceira` (`id_vendas_cabeceira`),
  ADD KEY `id_vendas_pezeiro` (`id_vendas_pezeiro`),
  ADD KEY `id_provas` (`id_provas`),
  ADD KEY `id_cabeceira` (`id_cabeceira`),
  ADD KEY `id_pezeiro` (`id_pezeiro`),
  ADD KEY `empresa` (`empresa`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `1_teste`
--
ALTER TABLE `1_teste`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1855;

--
-- AUTO_INCREMENT for table `acessos`
--
ALTER TABLE `acessos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `alerta_notificacoes`
--
ALTER TABLE `alerta_notificacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `anexos_de_comprovantes`
--
ALTER TABLE `anexos_de_comprovantes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `animais`
--
ALTER TABLE `animais`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=388;

--
-- AUTO_INCREMENT for table `atualizacoes`
--
ALTER TABLE `atualizacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `atualizacoes_hc`
--
ALTER TABLE `atualizacoes_hc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1473;

--
-- AUTO_INCREMENT for table `bancos`
--
ALTER TABLE `bancos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

--
-- AUTO_INCREMENT for table `banco_pix`
--
ALTER TABLE `banco_pix`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=230;

--
-- AUTO_INCREMENT for table `banner_carrossel_evento`
--
ALTER TABLE `banner_carrossel_evento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `cabeceira`
--
ALTER TABLE `cabeceira`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `caixa`
--
ALTER TABLE `caixa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `caixa_turno`
--
ALTER TABLE `caixa_turno`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `calendario_eventos`
--
ALTER TABLE `calendario_eventos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `categorias_menu`
--
ALTER TABLE `categorias_menu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `cat_despesas`
--
ALTER TABLE `cat_despesas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `certificado_digital_inter`
--
ALTER TABLE `certificado_digital_inter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT for table `certificado_digital_sicoob`
--
ALTER TABLE `certificado_digital_sicoob`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=99;

--
-- AUTO_INCREMENT for table `certificado_digital_sicredi`
--
ALTER TABLE `certificado_digital_sicredi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `cidades`
--
ALTER TABLE `cidades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5571;

--
-- AUTO_INCREMENT for table `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9482;

--
-- AUTO_INCREMENT for table `clientes_bloqueados`
--
ALTER TABLE `clientes_bloqueados`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95;

--
-- AUTO_INCREMENT for table `config_wordsystem`
--
ALTER TABLE `config_wordsystem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `confirmacao_envios`
--
ALTER TABLE `confirmacao_envios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contas_pagar`
--
ALTER TABLE `contas_pagar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `contas_receber`
--
ALTER TABLE `contas_receber`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2473;

--
-- AUTO_INCREMENT for table `deletar_ordem_de_entrada`
--
ALTER TABLE `deletar_ordem_de_entrada`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `denunciar_evento`
--
ALTER TABLE `denunciar_evento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `descontos_por_provas`
--
ALTER TABLE `descontos_por_provas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `despesas`
--
ALTER TABLE `despesas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1135;

--
-- AUTO_INCREMENT for table `empresas`
--
ALTER TABLE `empresas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `eventos`
--
ALTER TABLE `eventos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=134;

--
-- AUTO_INCREMENT for table `filiacoes`
--
ALTER TABLE `filiacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `formas_pgtos`
--
ALTER TABLE `formas_pgtos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=421;

--
-- AUTO_INCREMENT for table `fornecedores`
--
ALTER TABLE `fornecedores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `frequencias`
--
ALTER TABLE `frequencias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `funcionarios`
--
ALTER TABLE `funcionarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `funcoes`
--
ALTER TABLE `funcoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=170;

--
-- AUTO_INCREMENT for table `instancias`
--
ALTER TABLE `instancias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;

--
-- AUTO_INCREMENT for table `itens_venda`
--
ALTER TABLE `itens_venda`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=95449;

--
-- AUTO_INCREMENT for table `lista_competicao`
--
ALTER TABLE `lista_competicao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `logs`
--
ALTER TABLE `logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10551;

--
-- AUTO_INCREMENT for table `logs_view`
--
ALTER TABLE `logs_view`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=354570;

--
-- AUTO_INCREMENT for table `logs_visitante`
--
ALTER TABLE `logs_visitante`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6703;

--
-- AUTO_INCREMENT for table `mensagens_padrao`
--
ALTER TABLE `mensagens_padrao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `modelo_pagamento`
--
ALTER TABLE `modelo_pagamento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `movimentacoes`
--
ALTER TABLE `movimentacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68293;

--
-- AUTO_INCREMENT for table `niveis`
--
ALTER TABLE `niveis`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `ordem_de_entrada`
--
ALTER TABLE `ordem_de_entrada`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=261285;

--
-- AUTO_INCREMENT for table `permissoes_dados`
--
ALTER TABLE `permissoes_dados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `permissoes_empresa`
--
ALTER TABLE `permissoes_empresa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `pesquisa_personalizada`
--
ALTER TABLE `pesquisa_personalizada`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=93;

--
-- AUTO_INCREMENT for table `propaganda_publicidade`
--
ALTER TABLE `propaganda_publicidade`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `provas`
--
ALTER TABLE `provas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1186;

--
-- AUTO_INCREMENT for table `somatoria`
--
ALTER TABLE `somatoria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `somatoria_handicaps`
--
ALTER TABLE `somatoria_handicaps`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `tipo_de_anexo`
--
ALTER TABLE `tipo_de_anexo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=325;

--
-- AUTO_INCREMENT for table `tokens_notificacao`
--
ALTER TABLE `tokens_notificacao`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14131;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `usuarios_permissoes`
--
ALTER TABLE `usuarios_permissoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `valor_parcial`
--
ALTER TABLE `valor_parcial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vendas`
--
ALTER TABLE `vendas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91072;

--
-- AUTO_INCREMENT for table `vincular_parceiros`
--
ALTER TABLE `vincular_parceiros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=176868;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
