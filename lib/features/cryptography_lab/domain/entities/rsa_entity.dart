// ignore_for_file: non_constant_identifier_names

class RSAKeyPair {
  final BigInt p;
  final BigInt q;
  final BigInt n;
  final BigInt phi;
  final BigInt e;
  final BigInt d;

  RSAKeyPair({
    required this.p,
    required this.q,
    required this.n,
    required this.phi,
    required this.e,
    required this.d,
  });

  @override
  String toString() {
    return 'Public(n: $n, e: $e)\nPrivate(d: $d)';
  }
}

class RSAEncryptionStep {
  final String message;
  final List<BigInt> plainValues;
  final List<BigInt> cipherValues;
  final BigInt n;
  final BigInt Key;

  RSAEncryptionStep({
    required this.message,
    required this.plainValues,
    required this.cipherValues,
    required this.n,
    required this.Key,
  });
}
