class SensorData {
  final String deviceCode;
  final double accelX, accelY, accelZ;
  final double gyroX, gyroY, gyroZ;
  final int heartRate, oxygen;
  SensorData({
    required this.deviceCode,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.heartRate,
    required this.oxygen,
  });
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      deviceCode: json['device_code'],
      accelX: (json['accelX'] as num).toDouble(),
      accelY: (json['accelY'] as num).toDouble(),
      accelZ: (json['accelZ'] as num).toDouble(),
      gyroX: (json['gyroX'] as num).toDouble(),
      gyroY: (json['gyroY'] as num).toDouble(),
      gyroZ: (json['gyroZ'] as num).toDouble(),
      heartRate: json['heartRate'],
      oxygen: json['oxygen'],
    );
  }
}
