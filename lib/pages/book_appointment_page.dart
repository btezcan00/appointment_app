import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedDoctor;
  String? selectedSpecialty;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final locationController = TextEditingController();
  List<String> doctorNames = [];
  List<String> specialties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final docs = await FirebaseService.getDoctorNames();
      final specs = await FirebaseService.getDoctorSpecialties();
      setState(() {
        doctorNames = docs.isNotEmpty ? docs : _getDefaultDoctorNames();
        specialties = specs.isNotEmpty ? specs : _getDefaultSpecialties();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        doctorNames = _getDefaultDoctorNames();
        specialties = _getDefaultSpecialties();
        isLoading = false;
      });
    }
  }

  List<String> _getDefaultDoctorNames() {
    return [
      'Dr. Sarah Johnson',
      'Dr. Michael Chen',
      'Dr. Emily Williams',
      'Dr. Robert Brown',
      'Dr. Jennifer Davis',
      'Dr. David Miller',
    ];
  }

  List<String> _getDefaultSpecialties() {
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

  @override
  void dispose() {
    locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (_formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null) {
      try {
        final dateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );

        await FirebaseService.addAppointment(
          doctorName: selectedDoctor!,
          specialty: selectedSpecialty!,
          dateTime: dateTime,
          location: locationController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appointment booked successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Clear form
          setState(() {
            selectedDoctor = null;
            selectedSpecialty = null;
            selectedDate = null;
            selectedTime = null;
            locationController.clear();
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error booking appointment: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Book New Appointment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Doctor Selection
              DropdownButtonFormField<String>(
                value: selectedDoctor,
                decoration: const InputDecoration(
                  labelText: 'Select Doctor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: doctorNames
                    .map((name) => DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDoctor = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a doctor' : null,
              ),
              const SizedBox(height: 16),

              // Specialty Selection
              DropdownButtonFormField<String>(
                value: selectedSpecialty,
                decoration: const InputDecoration(
                  labelText: 'Select Specialty',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
                items: specialties
                    .map((specialty) => DropdownMenuItem(
                          value: specialty,
                          child: Text(specialty),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSpecialty = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a specialty' : null,
              ),
              const SizedBox(height: 16),

              // Date Selection
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    selectedDate != null
                        ? DateFormat('MMM dd, yyyy').format(selectedDate!)
                        : 'Tap to select date',
                    style: TextStyle(
                      color: selectedDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Time Selection
              InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Select Time',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  child: Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : 'Tap to select time',
                    style: TextStyle(
                      color: selectedTime != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter location' : null,
              ),
              const SizedBox(height: 24),

              // Book Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Book Appointment',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
