class Ratio {
  final double _ht;
  final double _wd;

  Ratio(this._ht, this._wd);
  int flex(double x) => ((x / _ht) * 100).floor();
}
