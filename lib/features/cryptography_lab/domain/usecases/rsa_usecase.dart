import 'dart:math';
import '../entities/rsa_entity.dart';

class RSAUseCase {
  RSAKeyPair generateKeyPair() {
    final primes = [11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61];
    final random = Random();

    int pIdx = random.nextInt(primes.length);
    int qIdx = random.nextInt(primes.length);
    while (pIdx == qIdx) {
      qIdx = random.nextInt(primes.length);
    }

    final p = BigInt.from(primes[pIdx]);
    final q = BigInt.from(primes[qIdx]);

    final n = p * q;
    final phi = (p - BigInt.one) * (q - BigInt.one);

    BigInt e = BigInt.from(3);
    while (_gcd(e, phi) != BigInt.one) {
      e += BigInt.two;
    }

    final d = _modInverse(e, phi);

    return RSAKeyPair(p: p, q: q, n: n, phi: phi, e: e, d: d);
  }

  BigInt encrypt(BigInt m, BigInt e, BigInt n) {
    return m.modPow(e, n);
  }

  BigInt decrypt(BigInt c, BigInt d, BigInt n) {
    return c.modPow(d, n);
  }

  BigInt _gcd(BigInt a, BigInt b) {
    while (b != BigInt.zero) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  BigInt _modInverse(BigInt e, BigInt phi) {
    BigInt m0 = phi, t, q;
    BigInt x0 = BigInt.zero, x1 = BigInt.one;

    if (phi == BigInt.one) return BigInt.zero;

    while (e > BigInt.one) {
      q = e ~/ phi;
      t = phi;
      phi = e % phi;
      e = t;
      t = x0;
      x0 = x1 - q * x0;
      x1 = t;
    }

    if (x1 < BigInt.zero) x1 += m0;

    return x1;
  }
}
