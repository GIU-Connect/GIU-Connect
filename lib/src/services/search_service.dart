import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  Future<List<Object?>> search(String major, int currentTutNo, int desiredTutNo,
      String germanLevel, String englishLevel) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await _firestore
        .collection('requests')
        .where('major', isEqualTo: major)
        .where('currentTutNo', isEqualTo: currentTutNo)
        .where('desiredTutNo', isEqualTo: desiredTutNo)
        .where('germanLevel', isEqualTo: germanLevel)
        .where('englishLevel', isEqualTo: englishLevel)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
