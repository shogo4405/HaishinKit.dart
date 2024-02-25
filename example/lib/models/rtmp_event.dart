enum EventLevel {
  error,
  status,
}

/// https://github.com/shogo4405/HaishinKit.swift/blob/main/Sources/RTMP/RTMPConnection.swift

// case callBadVersion       = "NetConnection.Call.BadVersion"
// case callFailed           = "NetConnection.Call.Failed"
// case callProhibited       = "NetConnection.Call.Prohibited"
// case connectAppshutdown   = "NetConnection.Connect.AppShutdown"
// case connectClosed        = "NetConnection.Connect.Closed"
// case connectFailed        = "NetConnection.Connect.Failed"
// case connectIdleTimeOut   = "NetConnection.Connect.IdleTimeOut"
// case connectInvalidApp    = "NetConnection.Connect.InvalidApp"
// case connectNetworkChange = "NetConnection.Connect.NetworkChange"
// case connectRejected      = "NetConnection.Connect.Rejected"
// case connectSuccess       = "NetConnection.Connect.Success"

enum RtmpConnectionCode {
  unknown("unknown", EventLevel.error),
  callBadVersion("NetConnection.Call.BadVersion", EventLevel.error),
  callFailed("NetConnection.Call.Failed", EventLevel.error),
  callProhibited("NetConnection.Call.Prohibited", EventLevel.error),
  connectAppshutdown("NetConnection.Connect.AppShutdown", EventLevel.error),
  connectClosed("NetConnection.Connect.Closed", EventLevel.status),
  connectFailed("NetConnection.Connect.Failed", EventLevel.error),
  connectIdleTimeOut("NetConnection.Connect.IdleTimeOut", EventLevel.status),
  connectInvalidApp("NetConnection.Connect.InvalidApp", EventLevel.error),
  connectNetworkChange(
      "NetConnection.Connect.NetworkChange", EventLevel.status),
  connectRejected("NetConnection.Connect.Rejected", EventLevel.error),
  connectSuccess("NetConnection.Connect.Success", EventLevel.status);

  final String value;
  final EventLevel level;

  const RtmpConnectionCode(this.value, this.level);
}

// case bufferEmpty               = "NetStream.Buffer.Empty"
// case bufferFlush               = "NetStream.Buffer.Flush"
// case bufferFull                = "NetStream.Buffer.Full"
// case connectClosed             = "NetStream.Connect.Closed"
// case connectFailed             = "NetStream.Connect.Failed"
// case connectRejected           = "NetStream.Connect.Rejected"
// case connectSuccess            = "NetStream.Connect.Success"
// case drmUpdateNeeded           = "NetStream.DRM.UpdateNeeded"
// case failed                    = "NetStream.Failed"
// case multicastStreamReset      = "NetStream.MulticastStream.Reset"
// case pauseNotify               = "NetStream.Pause.Notify"
// case playFailed                = "NetStream.Play.Failed"
// case playFileStructureInvalid  = "NetStream.Play.FileStructureInvalid"
// case playInsufficientBW        = "NetStream.Play.InsufficientBW"
// case playNoSupportedTrackFound = "NetStream.Play.NoSupportedTrackFound"
// case playReset                 = "NetStream.Play.Reset"
// case playStart                 = "NetStream.Play.Start"
// case playStop                  = "NetStream.Play.Stop"
// case playStreamNotFound        = "NetStream.Play.StreamNotFound"
// case playTransition            = "NetStream.Play.Transition"
// case playUnpublishNotify       = "NetStream.Play.UnpublishNotify"
// case publishBadName            = "NetStream.Publish.BadName"
// case publishIdle               = "NetStream.Publish.Idle"
// case publishStart              = "NetStream.Publish.Start"
// case recordAlreadyExists       = "NetStream.Record.AlreadyExists"
// case recordFailed              = "NetStream.Record.Failed"
// case recordNoAccess            = "NetStream.Record.NoAccess"
// case recordStart               = "NetStream.Record.Start"
// case recordStop                = "NetStream.Record.Stop"
// case recordDiskQuotaExceeded   = "NetStream.Record.DiskQuotaExceeded"
// case secondScreenStart         = "NetStream.SecondScreen.Start"
// case secondScreenStop          = "NetStream.SecondScreen.Stop"
// case seekFailed                = "NetStream.Seek.Failed"
// case seekInvalidTime           = "NetStream.Seek.InvalidTime"
// case seekNotify                = "NetStream.Seek.Notify"
// case stepNotify                = "NetStream.Step.Notify"
// case unpauseNotify             = "NetStream.Unpause.Notify"
// case unpublishSuccess          = "NetStream.Unpublish.Success"
// case videoDimensionChange      = "NetStream.Video.DimensionChange"

enum RtmpStreamCode {
  unknown("unknown", EventLevel.error),
  bufferEmpty("NetStream.Buffer.Empty", EventLevel.status),
  bufferFlush("NetStream.Buffer.Flush", EventLevel.status),
  bufferFull("NetStream.Buffer.Full", EventLevel.status),
  connectClosed("NetStream.Connect.Closed", EventLevel.status),
  connectFailed("NetStream.Connect.Failed", EventLevel.error),
  connectRejected("NetStream.Connect.Rejected", EventLevel.error),
  connectSuccess("NetStream.Connect.Success", EventLevel.status),
  drmUpdateNeeded("NetStream.DRM.UpdateNeeded", EventLevel.status),
  failed("NetStream.Failed", EventLevel.error),
  multicastStreamReset("NetStream.MulticastStream.Reset", EventLevel.status),
  pauseNotify("NetStream.Pause.Notify", EventLevel.status),
  playFailed("NetStream.Play.Failed", EventLevel.error),
  playFileStructureInvalid(
      "NetStream.Play.FileStructureInvalid", EventLevel.error),
  playInsufficientBW("NetStream.Play.InsufficientBW", EventLevel.error),
  playNoSupportedTrackFound(
      "NetStream.Play.NoSupportedTrackFound", EventLevel.error),
  playReset("NetStream.Play.Reset", EventLevel.status),
  playStart("NetStream.Play.Start", EventLevel.status),
  playStop("NetStream.Play.Stop", EventLevel.status),
  playStreamNotFound("NetStream.Play.StreamNotFound", EventLevel.error),
  playTransition("NetStream.Play.Transition", EventLevel.status),
  playUnpublishNotify("NetStream.Play.UnpublishNotify", EventLevel.status),
  publishBadName("NetStream.Publish.BadName", EventLevel.error),
  publishIdle("NetStream.Publish.Idle", EventLevel.status),
  publishStart("NetStream.Publish.Start", EventLevel.status),
  recordAlreadyExists("NetStream.Record.AlreadyExists", EventLevel.error),
  recordFailed("NetStream.Record.Failed", EventLevel.error),
  recordNoAccess("NetStream.Record.NoAccess", EventLevel.error),
  recordStart("NetStream.Record.Start", EventLevel.status),
  recordStop("NetStream.Record.Stop", EventLevel.status),
  recordDiskQuotaExceeded(
      "NetStream.Record.DiskQuotaExceeded", EventLevel.error),
  secondScreenStart("NetStream.SecondScreen.Start", EventLevel.status),
  secondScreenStop("NetStream.SecondScreen.Stop", EventLevel.status),
  seekFailed("NetStream.Seek.Failed", EventLevel.error),
  seekInvalidTime("NetStream.Seek.InvalidTime", EventLevel.error),
  seekNotify("NetStream.Seek.Notify", EventLevel.status),
  stepNotify("NetStream.Step.Notify", EventLevel.status),
  unpauseNotify("NetStream.Unpause.Notify", EventLevel.status),
  unpublishSuccess("NetStream.Unpublish.Success", EventLevel.status),
  videoDimensionChange("NetStream.Video.DimensionChange", EventLevel.status);

  final String value;
  final EventLevel level;

  const RtmpStreamCode(this.value, this.level);
}

class RtmpEvent {
  const RtmpEvent();

  /// if code starts with "NetStream", it's a stream event
  /// otherwise it's a connection event
  /// for all unmatched codes, it's a unknown RtmpConnectionEvent
  factory RtmpEvent.fromMap(Map<dynamic, dynamic> map) {
    final code = map["code"] as String?;

    if (code == null) {
      return const RtmpConnectionEvent(RtmpConnectionCode.unknown);
    }

    if (code.startsWith("NetStream")) {
      return RtmpStreamEvent.fromMap(map);
    } else {
      return RtmpConnectionEvent.fromMap(map);
    }
  }
}

class RtmpConnectionEvent extends RtmpEvent {
  final RtmpConnectionCode code;
  final String? description;

  const RtmpConnectionEvent(this.code, [this.description]);

  factory RtmpConnectionEvent.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return const RtmpConnectionEvent(RtmpConnectionCode.unknown);
    }

    final code = RtmpConnectionCode.values.firstWhere(
      (element) => element.value == map["code"],
      orElse: () => RtmpConnectionCode.unknown,
    );

    return RtmpConnectionEvent(code, map["description"]);
  }

  @override
  String toString() {
    return 'RtmpConnectionEvent{code: $code, description: $description}';
  }
}

class RtmpStreamEvent extends RtmpEvent {
  final RtmpStreamCode code;
  final String? description;

  const RtmpStreamEvent(this.code, [this.description]);

  factory RtmpStreamEvent.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return const RtmpStreamEvent(RtmpStreamCode.unknown);
    }

    final code = RtmpStreamCode.values.firstWhere(
      (element) => element.value == map["code"],
      orElse: () => RtmpStreamCode.failed,
    );

    return RtmpStreamEvent(code, map["description"]);
  }

  @override
  String toString() {
    return 'RtmpStreamEvent{code: $code, description: $description}';
  }
}
