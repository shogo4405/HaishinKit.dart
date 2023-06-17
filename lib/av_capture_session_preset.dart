enum AVCaptureSessionPreset {
  high('high'),
  medium('medium'),
  low('low'),
  qHD960x540('qHD960x540'),
  hd1280x720('hd1280x720'),
  hd1920x1080('hd1920x1080'),
  hd4K3840x2160('hd4K3840x2160'),
  vga640x480('vga640x480'),
  iFrame960x540('iFrame960x540'),
  iFrame1280x720('iFrame1280x720'),
  cif352x288('cif352x288'),
  ;

  const AVCaptureSessionPreset(this.presetName);
  final String presetName;
}
