import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/appointment.dart';
import '../models/user_profile.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth methods
  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  static Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  static Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // User Profile methods
  static Future<UserProfile?> getUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return UserProfile(
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      profilePhotoUrl: data['profilePhotoUrl'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
    );
  }

  static Future<void> updateUserProfile(UserProfile profile) async {
    final user = currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'name': profile.name,
      'age': profile.age,
      'profilePhotoUrl': profile.profilePhotoUrl,
      'email': profile.email,
      'phone': profile.phone,
      'address': profile.address,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Appointment methods
  static Stream<List<Appointment>> getAppointmentsStream() {
    final user = currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('appointments')
        .where('userId', isEqualTo: user.uid)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Appointment(
          id: doc.id,
          doctorName: data['doctorName'] ?? '',
          specialty: data['specialty'] ?? '',
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          location: data['location'] ?? '',
          status: data['status'] ?? 'Pending',
        );
      }).toList();
    });
  }

  static Future<List<Appointment>> getAppointments() async {
    final user = currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('appointments')
        .where('userId', isEqualTo: user.uid)
        .orderBy('dateTime', descending: false)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Appointment(
        id: doc.id,
        doctorName: data['doctorName'] ?? '',
        specialty: data['specialty'] ?? '',
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        location: data['location'] ?? '',
        status: data['status'] ?? 'Pending',
      );
    }).toList();
  }

  static Future<void> addAppointment({
    required String doctorName,
    required String specialty,
    required DateTime dateTime,
    required String location,
  }) async {
    final user = currentUser;
    if (user == null) return;

    await _firestore.collection('appointments').add({
      'userId': user.uid,
      'doctorName': doctorName,
      'specialty': specialty,
      'dateTime': Timestamp.fromDate(dateTime),
      'location': location,
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> updateAppointment(String appointmentId,
      {String? status}) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      if (status != null) 'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> deleteAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).delete();
  }

  // Doctors/Specialties methods
  static Future<List<String>> getDoctorSpecialties() async {
    final snapshot = await _firestore.collection('specialties').get();
    return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  }

  static Future<List<String>> getDoctorNames() async {
    final snapshot = await _firestore.collection('doctors').get();
    return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
  }
}
