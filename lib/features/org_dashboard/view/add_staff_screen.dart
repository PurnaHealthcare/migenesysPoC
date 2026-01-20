import 'package:flutter/material.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isMedicalProfessional = false;
  bool _isPharmacist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Staff Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text('Is Medical Professional?'),
                subtitle: const Text('Enable access to edit Clinical Information (Vitals, Lab Results).'),
                value: _isMedicalProfessional,
                onChanged: (val) {
                  setState(() {
                    _isMedicalProfessional = val;
                    if (val) _isPharmacist = false; // Mutually exclusive (simplification)
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Is Pharmacist?'),
                subtitle: const Text('Enable access to Pharmacy Order Queue.'),
                value: _isPharmacist,
                onChanged: (val) {
                  setState(() {
                    _isPharmacist = val;
                    if (val) _isMedicalProfessional = false;
                  });
                },
              ),
              if (_isMedicalProfessional || _isPharmacist)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Text(
                    'License verification will be required.',
                    style: TextStyle(color: Colors.orange[800], fontSize: 12),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Logic to invite
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invitation sent!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Send Invite'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
