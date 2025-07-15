class V2RayConfig {
  final String id;
  final String protocol;
  final String host;
  final int port;
  final Map<String, String> params;
  final String remark;

  V2RayConfig({
    required this.id,
    required this.protocol,
    required this.host,
    required this.port,
    required this.params,
    required this.remark,
  });

  factory V2RayConfig.fromUrl(String url) {
    try {

      final protocol = url.split('://').first;

      final uriParts = url.split('@');
      if (uriParts.length < 2) {
        throw const FormatException('Invalid URL format: missing @');
      }
      final id = uriParts[0].split('://').last;

      final hostPortRemark = uriParts[1].split('#');
      final hostPortQuery = hostPortRemark[0].split('?');
      final hostPort = hostPortQuery[0];
      final hostPortParts = hostPort.split(':');
      if (hostPortParts.length < 2) {
        throw const FormatException('Invalid host:port format');
      }
      final host = hostPortParts[0];


      final portString = hostPortParts[1].replaceAll(RegExp(r'[^0-9]'), '');
      if (portString.isEmpty) {
        throw const FormatException('Port is empty or invalid');
      }
      final port = int.parse(portString);


      final params = <String, String>{};
      if (hostPortQuery.length > 1) {
        final paramsString = hostPortQuery[1];
        paramsString.split('&').forEach((param) {
          final parts = param.split('=');
          if (parts.length == 2) {
            params[parts[0]] = parts[1];
          }
        });
      }

      final remark = hostPortRemark.length > 1
          ? Uri.decodeComponent(hostPortRemark[1])
          : 'No Remark';

      return V2RayConfig(
        id: id,
        protocol: protocol,
        host: host,
        port: port,
        params: params,
        remark: remark,
      );
    } catch (e) {
      throw FormatException('Failed to parse V2Ray URL: $e');
    }
  }
}