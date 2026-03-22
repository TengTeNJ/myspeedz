import 'dart:typed_data';

const int HEADER = 0xA5;
const int TAIL = 0xAA;
const int CMD_BATTERY = 0x0030;
const int CMD_VERSION = 0x0034;

class SpeedDeviceData {
  int? speed;
  int? battery;
  String? version;
  int? rawVersion;
}

class SpeedProtocolParser {


  final List<int> _buffer = [];

  Function(SpeedDeviceData data)? onData;

  /// =============================
  /// 数据入口
  /// =============================
  void onReceive(List<int> data) {
    for (var byte in data) {
      // 👉 正在拼协议帧
      if ((_buffer.isNotEmpty || byte == HEADER ) ) {
        _handleFrame(byte);
        continue;
      }

      // 👉 否则全部当速度
      _emitSpeed(byte);
    }
  }

  /// =============================
  /// 协议帧处理（防分包）
  /// =============================
  void _handleFrame(int byte) {
    _buffer.add(byte);

    while (true) {
      int start = _buffer.indexOf(HEADER);
      if (start == -1) {
        _buffer.clear();
        return;
      }

      // 长度不够
      if (_buffer.length < start + 2) return;

      int len = _buffer[start + 1];

      // 防止误判（非常关键）
      if (len < 6 || len > 10) {
        // ❗ 当作速度吐掉
        _emitSpeed(_buffer.removeAt(0));
        continue;
      }

      // 数据不完整
      if (_buffer.length < start + len) return;

      List<int> frame = _buffer.sublist(start, start + len);
      _buffer.removeRange(0, start + len);

      // 校验失败 → 当速度吐掉
      if (!_verify(frame)) {
        for (var b in frame) {
          _emitSpeed(b);
        }
        continue;
      }

      // 解析
      final parsed = _parseFrame(frame);
      if (parsed != null) {
        _emit(parsed);
      }
    }
  }

  /// =============================
  /// 解析帧
  /// =============================
  SpeedDeviceData? _parseFrame(List<int> data) {
    int cmd = (data[2] << 8) | data[3];

    switch (cmd) {
      case CMD_BATTERY:
        return _parseBattery(data);

      case CMD_VERSION:
        return _parseVersion(data);

      default:
        return null;
    }
  }

  SpeedDeviceData _parseBattery(List<int> data) {
    int value = data[7];

    return SpeedDeviceData()
      ..battery = value;
  }

  SpeedDeviceData _parseVersion(List<int> data) {
    // 正常版本号不大于9999
    int raw = (data[6] << 8) | data[7];

    int major = raw ~/ 1000;
    int minor = (raw % 1000) ~/ 100;
    int patch = raw % 100;

    String version =
        "$major.$minor.${patch.toString().padLeft(2, '0')}";

    return SpeedDeviceData()
      ..version = version
      ..rawVersion = raw;
  }

  /// =============================
  /// 校验
  /// =============================
  bool _verify(List<int> data) {
    if (data.length < 6) return false;

    int checksumIndex = data.length - 2;
    int expected = data[checksumIndex];

    int sum = 0;
    for (int i = 0; i < checksumIndex; i++) {
      sum += data[i];
    }
    sum+=TAIL;

    return (sum & 0xFF) == expected;
  }

  /// =============================
  /// 输出
  /// =============================
  void _emit(SpeedDeviceData data) {
    onData?.call(data);
  }

  void _emitSpeed(int value) {
    _emit(SpeedDeviceData()..speed = value);
  }
}

List<int>getVersionData(){
  return [HEADER, 0x06 ,CMD_VERSION >> 8 & 0XFF ,CMD_VERSION & 0xFF ,0xDB ,TAIL];
}

List<int>getBatteryData(){
  return [HEADER, 0x06 ,CMD_BATTERY >> 8 & 0XFF ,CMD_BATTERY & 0xFF ,0xDF ,TAIL];
}