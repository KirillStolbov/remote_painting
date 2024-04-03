import 'dart:typed_data';
import 'dart:ui';

const _nullValue = 0.0;

abstract final class OffsetCodec {
  static Uint8List encode(Offset? offset) {
    final byteData = ByteData(16);

    if (offset != null) {
      byteData.setFloat64(0, offset.dx, Endian.little);
      byteData.setFloat64(8, offset.dy, Endian.little);
    } else {
      byteData.setFloat64(0, _nullValue, Endian.little);
      byteData.setFloat64(8, _nullValue, Endian.little);
    }

    return byteData.buffer.asUint8List();
  }

  static Offset? decode(Uint8List bytes) {
    final float64List = bytes.buffer.asFloat64List();

    final dx = float64List[0];
    final dy = float64List[1];

    if (dx == _nullValue && dy == _nullValue) {
      return null;
    } else {
      return Offset(dx, dy);
    }
  }
}
