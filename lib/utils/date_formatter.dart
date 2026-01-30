class DateFormatter {
  static String trocarFormatacaoData(String data, {String pattern = '/', String to = '-', bool trocarOrdem = false}) {
    var dataSplit = data.split(pattern);

    if (trocarOrdem) {
      return "${dataSplit[0]}$to${dataSplit[1]}$to${dataSplit[2]}";
    }

    return "${dataSplit[2]}$to${dataSplit[1]}$to${dataSplit[0]}";
  }
}
