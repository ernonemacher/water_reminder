class AnaliseConsumo {
  /// Total de dias em sequencia, contando com o dia atual
  int diasConsecutivos;

  /// Sequencia atual de meta atingida sem contar o dia atual
  int sequenciaAtual;

  AnaliseConsumo({
    this.diasConsecutivos: 0,
    this.sequenciaAtual: 0,
  });

  void incrementarDiasConsecutivos() {
    diasConsecutivos++;
  }

  void incrementarSequenciaAtual() {
    sequenciaAtual++;
  }

  bool get hasDiasConsecutivos => diasConsecutivos > 0;
  bool get hasSequenciaAtual => sequenciaAtual > 0;
}
