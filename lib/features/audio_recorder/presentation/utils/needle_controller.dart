class NeedleController {
  late final void Function(Duration) setDuration;
  void setDurationCallback(void Function(Duration) callback) {
    setDuration = callback;
  }
}
