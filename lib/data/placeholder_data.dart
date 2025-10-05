import '../models/appointment.dart';
import '../models/user_profile.dart';

class PlaceholderData {
  static UserProfile getUserProfile() {
    return UserProfile(
      name: 'John Doe',
      age: 35,
      profilePhotoUrl: 'https://via.placeholder.com/150',
    );
  }

  static List<Appointment> getAppointments() {
    return [
      Appointment(
        id: '1',
        doctorName: 'Dr. Sarah Johnson',
        specialty: 'Cardiologist',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        location: 'City Medical Center, Room 305',
        status: 'Confirmed',
      ),
      Appointment(
        id: '2',
        doctorName: 'Dr. Michael Chen',
        specialty: 'Dermatologist',
        dateTime: DateTime.now().add(const Duration(days: 5)),
        location: 'Health Clinic, 2nd Floor',
        status: 'Confirmed',
      ),
      Appointment(
        id: '3',
        doctorName: 'Dr. Emily Williams',
        specialty: 'General Physician',
        dateTime: DateTime.now().add(const Duration(days: 10)),
        location: 'Downtown Hospital, Wing A',
        status: 'Pending',
      ),
    ];
  }

  static List<String> getDoctorSpecialties() {
    return [
      'General Physician',
      'Cardiologist',
      'Dermatologist',
      'Pediatrician',
      'Orthopedic',
      'Neurologist',
      'Psychiatrist',
      'Dentist',
    ];
  }

  static List<String> getDoctorNames() {
    return [
      'Dr. Sarah Johnson',
      'Dr. Michael Chen',
      'Dr. Emily Williams',
      'Dr. Robert Brown',
      'Dr. Jennifer Davis',
      'Dr. David Miller',
    ];
  }
}
