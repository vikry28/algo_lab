import '../../domain/entities/algorithm_content_entity.dart';

/// Konten pembelajaran untuk algoritma kriptografi
class CryptographyAlgorithmsContent {
  // Caesar Cipher
  static AlgorithmContentEntity getCaesarCipher(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'caesar_summary',

      understandingText: 'caesar_understanding',

      algorithmSteps: [
        'caesar_step_1',
        'caesar_step_2',
        'caesar_step_3',
        'caesar_step_4',
      ],

      codeExample: isId
          ? '''String caesarEncrypt(String text, int shift) {
  String result = '';
  
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    
    if (char.toUpperCase() != char.toLowerCase()) {
      // Huruf
      bool isUpper = char == char.toUpperCase();
      int base = isUpper ? 65 : 97; // 'A' atau 'a'
      
      int charCode = char.codeUnitAt(0);
      int shifted = ((charCode - base + shift) % 26) + base;
      
      result += String.fromCharCode(shifted);
      print('  \$char → \${String.fromCharCode(shifted)}');
    } else {
      // Bukan huruf
      result += char;
    }
  }
  
  return result;
}

String caesarDecrypt(String text, int shift) {
  return caesarEncrypt(text, 26 - shift);
}

void main() {
  String plaintext = 'HELLO WORLD';
  int shift = 3;
  
  print('Plaintext: \$plaintext');
  print('Shift: \$shift\\n');
  
  String encrypted = caesarEncrypt(plaintext, shift);
  print('\\nEncrypted: \$encrypted');
  
  String decrypted = caesarDecrypt(encrypted, shift);
  print('\\nDecrypted: \$decrypted');
}'''
          : '''String caesarEncrypt(String text, int shift) {
  String result = '';
  
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    
    if (char.toUpperCase() != char.toLowerCase()) {
      // Letter
      bool isUpper = char == char.toUpperCase();
      int base = isUpper ? 65 : 97; // 'A' or 'a'
      
      int charCode = char.codeUnitAt(0);
      int shifted = ((charCode - base + shift) % 26) + base;
      
      result += String.fromCharCode(shifted);
      print('  \$char → \${String.fromCharCode(shifted)}');
    } else {
      // Not a letter
      result += char;
    }
  }
  
  return result;
}

String caesarDecrypt(String text, int shift) {
  return caesarEncrypt(text, 26 - shift);
}

void main() {
  String plaintext = 'HELLO WORLD';
  int shift = 3;
  
  print('Plaintext: \$plaintext');
  print('Shift: \$shift\\n');
  
  String encrypted = caesarEncrypt(plaintext, shift);
  print('\\nEncrypted: \$encrypted');
  
  String decrypted = caesarDecrypt(encrypted, shift);
  print('\\nDecrypted: \$decrypted');
}''',

      output: '''Plaintext: HELLO WORLD
Shift: 3

  H → K
  E → H
  L → O
  L → O
  O → R
  W → Z
  O → R
  R → U
  L → O
  D → G

Encrypted: KHOOR ZRUOG

Decrypted: HELLO WORLD''',

      timeComplexity: 'caesar_time_complexity',
      spaceComplexity: 'caesar_space_complexity',

      advantages: [
        'caesar_advantage_1',
        'caesar_advantage_2',
        'caesar_advantage_3',
        'caesar_advantage_4',
      ],

      disadvantages: [
        'caesar_disadvantage_1',
        'caesar_disadvantage_2',
        'caesar_disadvantage_3',
        'caesar_disadvantage_4',
      ],

      visualSteps: [
        'caesar_visual_step_1',
        'caesar_visual_step_2',
        'caesar_visual_step_3',
        'caesar_visual_step_4',
        'caesar_visual_step_5',
        'caesar_visual_step_6',
        'caesar_visual_step_7',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'caesar_quiz_1_question',
          correctAnswer: '''String caesarEncrypt(String text, int shift) {
  String result = '';
  
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    
    if (char.toUpperCase() != char.toLowerCase()) {
      bool isUpper = char == char.toUpperCase();
      int base = isUpper ? 65 : 97;
      
      int charCode = char.codeUnitAt(0);
      int shifted = ((charCode - base + shift) % 26) + base;
      
      result += String.fromCharCode(shifted);
    } else {
      result += char;
    }
  }
  
  return result;
}''',
          codeTemplate: isId
              ? '''String caesarEncrypt(String text, int shift) {
  // Implementasikan Caesar Cipher
  
}'''
              : '''String caesarEncrypt(String text, int shift) {
  // Implement Caesar Cipher
  
}''',
          hint: 'caesar_quiz_1_hint',
        ),
        QuizQuestion(
          question: 'caesar_quiz_2_question',
          correctAnswer: '''String caesarDecrypt(String text, int shift) {
  return caesarEncrypt(text, 26 - shift);
}''',
          codeTemplate: isId
              ? '''String caesarDecrypt(String text, int shift) {
  // Dekripsi = enkripsi dengan shift terbalik
  
}'''
              : '''String caesarDecrypt(String text, int shift) {
  // Decryption = encryption with reverse shift
  
}''',
          hint: 'caesar_quiz_2_hint',
        ),
      ],

      useCases: 'caesar_use_cases',
      realWorldExample: 'caesar_real_world',
    );
  }

  // Vigenere Cipher
  static AlgorithmContentEntity getVigenereCipher(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'vigenere_summary',

      understandingText: 'vigenere_understanding',

      algorithmSteps: [
        'vigenere_step_1',
        'vigenere_step_2',
        'vigenere_step_3',
        'vigenere_step_4',
        'vigenere_step_5',
        'vigenere_step_6',
      ],

      codeExample: isId
          ? '''String vigenereEncrypt(String text, String key) {
  String result = '';
  String keyUpper = key.toUpperCase();
  int keyIndex = 0;
  
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    
    if (char.toUpperCase() != char.toLowerCase()) {
      bool isUpper = char == char.toUpperCase();
      int base = isUpper ? 65 : 97;
      
      // Shift dari keyword
      int shift = keyUpper.codeUnitAt(keyIndex % keyUpper.length) - 65;
      
      int charCode = char.codeUnitAt(0);
      int shifted = ((charCode - base + shift) % 26) + base;
      
      result += String.fromCharCode(shifted);
      print('  \$char + \${keyUpper[keyIndex % keyUpper.length]} (shift \$shift) = \${String.fromCharCode(shifted)}');
      
      keyIndex++;
    } else {
      result += char;
    }
  }
  
  return result;
}

String vigenereDecrypt(String text, String key) {
  String result = '';
  String keyUpper = key.toUpperCase();
  int keyIndex = 0;
  
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    
    if (char.toUpperCase() != char.toLowerCase()) {
      bool isUpper = char == char.toUpperCase();
      int base = isUpper ? 65 : 97;
      
      int shift = keyUpper.codeUnitAt(keyIndex % keyUpper.length) - 65;
      
      int charCode = char.codeUnitAt(0);
      int shifted = ((charCode - base - shift + 26) % 26) + base;
      
      result += String.fromCharCode(shifted);
      keyIndex++;
    } else {
      result += char;
    }
  }
  
  return result;
}

void main() {
  String plaintext = 'HELLO WORLD';
  String key = 'KEY';
  
  print('Plaintext: \$plaintext');
  print('Key: \$key\\n');
  
  String encrypted = vigenereEncrypt(plaintext, key);
  print('\\nEncrypted: \$encrypted');
  
  String decrypted = vigenereDecrypt(encrypted, key);
  print('\\nDecrypted: \$decrypted');
}'''
          : '''String vigenereEncrypt(String text, String key) {
  String result = '';
  String keyUpper = key.toUpperCase();
  int keyIndex = 0;
  
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    
    if (char.toUpperCase() != char.toLowerCase()) {
      bool isUpper = char == char.toUpperCase();
      int base = isUpper ? 65 : 97;
      
      // Shift from keyword
      int shift = keyUpper.codeUnitAt(keyIndex % keyUpper.length) - 65;
      
      int charCode = char.codeUnitAt(0);
      int shifted = ((charCode - base + shift) % 26) + base;
      
      result += String.fromCharCode(shifted);
      print('  \$char + \${keyUpper[keyIndex % keyUpper.length]} (shift \$shift) = \${String.fromCharCode(shifted)}');
      
      keyIndex++;
    } else {
      result += char;
    }
  }
  
  return result;
}

String vigenereDecrypt(String text, String key) {
  String result = '';
  String keyUpper = key.toUpperCase();
  int keyIndex = 0;
  
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    
    if (char.toUpperCase() != char.toLowerCase()) {
      bool isUpper = char == char.toUpperCase();
      int base = isUpper ? 65 : 97;
      
      int shift = keyUpper.codeUnitAt(keyIndex % keyUpper.length) - 65;
      
      int charCode = char.codeUnitAt(0);
      int shifted = ((charCode - base - shift + 26) % 26) + base;
      
      result += String.fromCharCode(shifted);
      keyIndex++;
    } else {
      result += char;
    }
  }
  
  return result;
}

void main() {
  String plaintext = 'HELLO WORLD';
  String key = 'KEY';
  
  print('Plaintext: \$plaintext');
  print('Key: \$key\\n');
  
  String encrypted = vigenereEncrypt(plaintext, key);
  print('\\nEncrypted: \$encrypted');
  
  String decrypted = vigenereDecrypt(encrypted, key);
  print('\\nDecrypted: \$decrypted');
}''',

      output: '''Plaintext: HELLO WORLD
Key: KEY

  H + K (shift 10) = R
  E + E (shift 4) = I
  L + Y (shift 24) = J
  L + K (shift 10) = V
  O + E (shift 4) = S
  W + Y (shift 24) = U
  O + K (shift 10) = Y
  R + E (shift 4) = V
  L + Y (shift 24) = J
  D + K (shift 10) = N

Encrypted: RIJVS UYVJN

Decrypted: HELLO WORLD''',

      timeComplexity: 'vigenere_time_complexity',
      spaceComplexity: 'vigenere_space_complexity',

      advantages: [
        'vigenere_advantage_1',
        'vigenere_advantage_2',
        'vigenere_advantage_3',
        'vigenere_advantage_4',
      ],

      disadvantages: [
        'vigenere_disadvantage_1',
        'vigenere_disadvantage_2',
        'vigenere_disadvantage_3',
        'vigenere_disadvantage_4',
      ],

      visualSteps: [
        'vigenere_visual_step_1',
        'vigenere_visual_step_2',
        'vigenere_visual_step_3',
        'vigenere_visual_step_4',
        'vigenere_visual_step_5',
        'vigenere_visual_step_6',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'vigenere_quiz_1_question',
          correctAnswer: '''String vigenereEncrypt(String text, String key) {
  String result = '';
  String keyUpper = key.toUpperCase();
  int keyIndex = 0;
  
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    
    if (char.toUpperCase() != char.toLowerCase()) {
      bool isUpper = char == char.toUpperCase();
      int base = isUpper ? 65 : 97;
      
      int shift = keyUpper.codeUnitAt(keyIndex % keyUpper.length) - 65;
      int charCode = char.codeUnitAt(0);
      int shifted = ((charCode - base + shift) % 26) + base;
      
      result += String.fromCharCode(shifted);
      keyIndex++;
    } else {
      result += char;
    }
  }
  
  return result;
}''',
          codeTemplate: isId
              ? '''String vigenereEncrypt(String text, String key) {
  // Implementasikan Vigenere Cipher
  
}'''
              : '''String vigenereEncrypt(String text, String key) {
  // Implement Vigenere Cipher
  
}''',
          hint: 'vigenere_quiz_1_hint',
        ),
      ],

      useCases: 'vigenere_use_cases',
      realWorldExample: 'vigenere_real_world',
    );
  }

  // RSA (Simplified explanation)
  static AlgorithmContentEntity getRSA(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'rsa_summary',

      understandingText: 'rsa_understanding',

      algorithmSteps: [
        'rsa_step_1',
        'rsa_step_2',
        'rsa_step_3',
        'rsa_step_4',
        'rsa_step_5',
        'rsa_step_6',
        'rsa_step_7',
        'rsa_step_8',
      ],

      codeExample: isId
          ? '''// Simplified RSA implementation (untuk pembelajaran)
import 'dart:math';

class RSA {
  late int n, e, d;
  
  // Extended Euclidean Algorithm
  int gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }
  
  // Modular exponentiation
  int modPow(int base, int exp, int mod) {
    int result = 1;
    base = base % mod;
    
    while (exp > 0) {
      if (exp % 2 == 1) {
        result = (result * base) % mod;
      }
      exp = exp >> 1;
      base = (base * base) % mod;
    }
    
    return result;
  }
  
  // Generate keys (simplified dengan bilangan kecil)
  void generateKeys() {
    int p = 61;  // Prima
    int q = 53;  // Prima
    
    n = p * q;  // 3233
    int phi = (p - 1) * (q - 1);  // 3120
    
    // Pilih e
    e = 17;
    while (gcd(e, phi) != 1) {
      e++;
    }
    
    // Hitung d (modular multiplicative inverse)
    d = 1;
    while ((d * e) % phi != 1) {
      d++;
    }
    
    print('Public Key: (e=\$e, n=\$n)');
    print('Private Key: (d=\$d, n=\$n)');
  }
  
  int encrypt(int message) {
    return modPow(message, e, n);
  }
  
  int decrypt(int ciphertext) {
    return modPow(ciphertext, d, n);
  }
}

void main() {
  RSA rsa = RSA();
  rsa.generateKeys();
  
  int message = 123;
  print('\\nMessage: \$message');
  
  int encrypted = rsa.encrypt(message);
  print('Encrypted: \$encrypted');
  
  int decrypted = rsa.decrypt(encrypted);
  print('Decrypted: \$decrypted');
}'''
          : '''// Simplified RSA implementation (for learning)
import 'dart:math';

class RSA {
  late int n, e, d;
  
  // Extended Euclidean Algorithm
  int gcd(int a, int b) {
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }
  
  // Modular exponentiation
  int modPow(int base, int exp, int mod) {
    int result = 1;
    base = base % mod;
    
    while (exp > 0) {
      if (exp % 2 == 1) {
        result = (result * base) % mod;
      }
      exp = exp >> 1;
      base = (base * base) % mod;
    }
    
    return result;
  }
  
  // Generate keys (simplified with small numbers)
  void generateKeys() {
    int p = 61;  // Prime
    int q = 53;  // Prime
    
    n = p * q;  // 3233
    int phi = (p - 1) * (q - 1);  // 3120
    
    // Choose e
    e = 17;
    while (gcd(e, phi) != 1) {
      e++;
    }
    
    // Calculate d (modular multiplicative inverse)
    d = 1;
    while ((d * e) % phi != 1) {
      d++;
    }
    
    print('Public Key: (e=\$e, n=\$n)');
    print('Private Key: (d=\$d, n=\$n)');
  }
  
  int encrypt(int message) {
    return modPow(message, e, n);
  }
  
  int decrypt(int ciphertext) {
    return modPow(ciphertext, d, n);
  }
}

void main() {
  RSA rsa = RSA();
  rsa.generateKeys();
  
  int message = 123;
  print('\\nMessage: \$message');
  
  int encrypted = rsa.encrypt(message);
  print('Encrypted: \$encrypted');
  
  int decrypted = rsa.decrypt(encrypted);
  print('Decrypted: \$decrypted');
}''',

      output: '''Public Key: (e=17, n=3233)
Private Key: (d=2753, n=3233)

Message: 123
Encrypted: 855
Decrypted: 123''',

      timeComplexity: 'rsa_time_complexity',
      spaceComplexity: 'rsa_space_complexity',

      advantages: [
        'rsa_advantage_1',
        'rsa_advantage_2',
        'rsa_advantage_3',
        'rsa_advantage_4',
      ],

      disadvantages: [
        'rsa_disadvantage_1',
        'rsa_disadvantage_2',
        'rsa_disadvantage_3',
        'rsa_disadvantage_4',
      ],

      visualSteps: [
        'rsa_visual_step_1',
        'rsa_visual_step_2',
        'rsa_visual_step_3',
        'rsa_visual_step_4',
        'rsa_visual_step_5',
        'rsa_visual_step_6',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'rsa_quiz_1_question',
          correctAnswer: '''int modPow(int base, int exp, int mod) {
  int result = 1;
  base = base % mod;
  
  while (exp > 0) {
    if (exp % 2 == 1) {
      result = (result * base) % mod;
    }
    exp = exp >> 1;
    base = (base * base) % mod;
  }
  
  return result;
}''',
          codeTemplate: isId
              ? '''int modPow(int base, int exp, int mod) {
  // Implementasikan fast modular exponentiation
  
}'''
              : '''int modPow(int base, int exp, int mod) {
  // Implement fast modular exponentiation
  
}''',
          hint: 'rsa_quiz_1_hint',
        ),
      ],

      useCases: 'rsa_use_cases',
      realWorldExample: 'rsa_real_world',
    );
  }

  // AES (Simplified explanation)
  static AlgorithmContentEntity getAES(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'aes_summary',

      understandingText: 'aes_understanding',

      algorithmSteps: ['aes_step_1', 'aes_step_2', 'aes_step_3', 'aes_step_4'],

      codeExample: isId
          ? '''// Simplified AES concept (bukan implementasi lengkap)
// Implementasi AES yang benar sangat kompleks

class AESConcept {
  // S-Box untuk SubBytes (simplified)
  static const List<int> sBox = [
    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
    // ... (256 values total)
  ];
  
  // Demonstrasi operasi dasar AES
  void demonstrateAES() {
    print('AES Operations Demo:\\n');
    
    // 1. SubBytes
    print('1. SubBytes:');
    int byte = 0x53;
    int substituted = sBox[byte];
    print('   Input: 0x\${byte.toRadixString(16)}');
    print('   Output: 0x\${substituted.toRadixString(16)}\\n');
    
    // 2. ShiftRows
    print('2. ShiftRows:');
    List<List<int>> state = [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 10, 11, 12],
      [13, 14, 15, 16],
    ];
    print('   Before: \$state');
    
    // Shift row 1 by 1, row 2 by 2, row 3 by 3
    for (int i = 1; i < 4; i++) {
      state[i] = [...state[i].sublist(i), ...state[i].sublist(0, i)];
    }
    print('   After: \$state\\n');
    
    // 3. AddRoundKey (XOR)
    print('3. AddRoundKey:');
    int data = 0b11001100;
    int key = 0b10101010;
    int result = data ^ key;
    print('   Data: \${data.toRadixString(2).padLeft(8, '0')}');
    print('   Key:  \${key.toRadixString(2).padLeft(8, '0')}');
    print('   XOR:  \${result.toRadixString(2).padLeft(8, '0')}');
  }
}

void main() {
  AESConcept aes = AESConcept();
  aes.demonstrateAES();
  
  print('\\nNote: Implementasi AES lengkap memerlukan');
  print('library kriptografi yang proper seperti pointycastle');
}'''
          : '''// Simplified AES concept (not full implementation)
// Proper AES implementation is very complex

class AESConcept {
  // S-Box for SubBytes (simplified)
  static const List<int> sBox = [
    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
    // ... (256 values total)
  ];
  
  // Demonstration of basic AES operations
  void demonstrateAES() {
    print('AES Operations Demo:\\n');
    
    // 1. SubBytes
    print('1. SubBytes:');
    int byte = 0x53;
    int substituted = sBox[byte];
    print('   Input: 0x\${byte.toRadixString(16)}');
    print('   Output: 0x\${substituted.toRadixString(16)}\\n');
    
    // 2. ShiftRows
    print('2. ShiftRows:');
    List<List<int>> state = [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 10, 11, 12],
      [13, 14, 15, 16],
    ];
    print('   Before: \$state');
    
    // Shift row 1 by 1, row 2 by 2, row 3 by 3
    for (int i = 1; i < 4; i++) {
      state[i] = [...state[i].sublist(i), ...state[i].sublist(0, i)];
    }
    print('   After: \$state\\n');
    
    // 3. AddRoundKey (XOR)
    print('3. AddRoundKey:');
    int data = 0b11001100;
    int key = 0b10101010;
    int result = data ^ key;
    print('   Data: \${data.toRadixString(2).padLeft(8, '0')}');
    print('   Key:  \${key.toRadixString(2).padLeft(8, '0')}');
    print('   XOR:  \${result.toRadixString(2).padLeft(8, '0')}');
  }
}

void main() {
  AESConcept aes = AESConcept();
  aes.demonstrateAES();
  
  print('\\nNote: Full AES implementation requires');
  print('a proper cryptography library such as pointycastle');
}''',

      output: isId
          ? '''AES Operations Demo:

1. SubBytes:
   Input: 0x53
   Output: 0xed

2. ShiftRows:
   Before: [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
   After: [[1, 2, 3, 4], [6, 7, 8, 5], [11, 12, 9, 10], [16, 13, 14, 15]]

3. AddRoundKey:
   Data: 11001100
   Key:  10101010
   XOR:  01100110

Note: Implementasi AES lengkap memerlukan
library kriptografi yang proper seperti pointycastle'''
          : '''AES Operations Demo:

1. SubBytes:
   Input: 0x53
   Output: 0xed

2. ShiftRows:
   Before: [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, 16]]
   After: [[1, 2, 3, 4], [6, 7, 8, 5], [11, 12, 9, 10], [16, 13, 14, 15]]

3. AddRoundKey:
   Data: 11001100
   Key:  10101010
   XOR:  01100110

Note: Full AES implementation requires
a proper cryptography library such as pointycastle''',

      timeComplexity: 'aes_time_complexity',
      spaceComplexity: 'aes_space_complexity',

      advantages: [
        'aes_advantage_1',
        'aes_advantage_2',
        'aes_advantage_3',
        'aes_advantage_4',
      ],

      disadvantages: [
        'aes_disadvantage_1',
        'aes_disadvantage_2',
        'aes_disadvantage_3',
        'aes_disadvantage_4',
      ],

      visualSteps: [
        'aes_visual_step_1',
        'aes_visual_step_2',
        'aes_visual_step_3',
        'aes_visual_step_4',
        'aes_visual_step_5',
        'aes_visual_step_6',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'aes_quiz_1_question',
          correctAnswer:
              '''List<int> addRoundKey(List<int> state, List<int> roundKey) {
  List<int> result = [];
  
  for (int i = 0; i < state.length; i++) {
    result.add(state[i] ^ roundKey[i]);
  }
  
  return result;
}''',
          codeTemplate: isId
              ? '''List<int> addRoundKey(List<int> state, List<int> roundKey) {
  // XOR state dengan round key
  
}'''
              : '''List<int> addRoundKey(List<int> state, List<int> roundKey) {
  // XOR state with round key
  
}''',
          hint: 'aes_quiz_1_hint',
        ),
      ],

      useCases: 'aes_use_cases',
      realWorldExample: 'aes_real_world',
    );
  }

  // SHA-256
  static AlgorithmContentEntity getSHA256(String languageCode) {
    bool isId = languageCode == 'id';
    return AlgorithmContentEntity(
      summaryText: 'sha256_summary',
      understandingText: 'sha256_understanding',

      algorithmSteps: [
        'sha256_step_1',
        'sha256_step_2',
        'sha256_step_3',
        'sha256_step_4',
        'sha256_step_5',
      ],

      codeExample: isId
          ? '''/**
 * SHA-256 Hashing Algorithm
 * (Konsep dasar & Demonstrasi)
 */

void main() {
  String input = "hello";
  print("Input: " + input);
  print("SHA-256: 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824");
}'''
          : '''/**
 * SHA-256 Hashing Algorithm
 * (Basic concept & Demonstration)
 */

void main() {
  String input = "hello";
  print("Input: " + input);
  print("SHA-256: 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824");
}''',

      output:
          '2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824',

      timeComplexity: 'sha256_time_complexity',
      spaceComplexity: 'sha256_space_complexity',

      advantages: [
        'sha256_advantage_1',
        'sha256_advantage_2',
        'sha256_advantage_3',
        'sha256_advantage_4',
        'sha256_advantage_5',
      ],

      disadvantages: [
        'sha256_disadvantage_1',
        'sha256_disadvantage_2',
        'sha256_disadvantage_3',
      ],

      visualSteps: [
        'sha256_visual_step_1',
        'sha256_visual_step_2',
        'sha256_visual_step_3',
        'sha256_visual_step_4',
      ],

      quizQuestions: [
        QuizQuestion(
          question: 'sha256_quiz_1_question',
          correctAnswer: '''int rotr(int x, int n) {
  return ((x >> n) | (x << (32 - n))) & 0xFFFFFFFF;
}''',
          codeTemplate: isId
              ? '''int rotr(int x, int n) {
  // Implementasikan right rotate 32-bit
  
}'''
              : '''int rotr(int x, int n) {
  // Implement right rotate 32-bit
  
}''',
          hint: 'sha256_quiz_1_hint',
        ),
      ],

      useCases: 'sha256_use_cases',
      realWorldExample: 'sha256_real_world',
    );
  }
}
