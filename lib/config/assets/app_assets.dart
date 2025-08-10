class AppAssets {
  static final icons = _Icons();
  static final images = _Images();
}

class _Icons {
  const _Icons();

  static const prefix = "assets/icons/";
  final mic = "${prefix}mic.svg";
  final pause = "${prefix}pause.svg";
  final play = "${prefix}play.svg";
  final plus = "${prefix}plus.svg";
  final stop = "${prefix}stop.svg";
}

class _Images {
  const _Images();

  static const prefix = "assets/images/";
  final backgroundSvg = "${prefix}background.svg";
  final echoLogo = "${prefix}echo_logo.png";
  final waveForm = "${prefix}wave_form.png";
}
