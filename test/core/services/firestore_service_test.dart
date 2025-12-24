import 'package:algo_lab/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'firestore_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late FirestoreService firestoreService;
  late MockFirebaseFirestore mockFirestore;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    firestoreService = FirestoreService(firestore: mockFirestore);
  });

  group('FirestoreService Tests', () {
    test('Service can be instantiated', () {
      expect(firestoreService, isNotNull);
    });
  });
}
