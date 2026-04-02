import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _experienceController = TextEditingController();
  
  // Address Controllers
  final _pincodeController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressDetailsController = TextEditingController();
  
  // New ID & Document Controllers
  final _idNumberController = TextEditingController();
  String? _idType;
  String? _addressDocType;
  File? _idFile;
  File? _addressDocFile;

  // Ride Preferences (Linked to Publish)
  bool _noSmoking = false;
  bool _noMusic = false;
  bool _noHeavyLuggage = false;
  bool _noPets = false;
  bool _negotiation = false;
  
  final _vehiclePlateController = TextEditingController(); 
  final _dlController = TextEditingController();
  final _pucController = TextEditingController();
  final _insController = TextEditingController();
  
  String? _selectedTehsil;
  List<String> _tehsilOptions = [];

  File? _imageFile;
  bool _isLoading = false;

  final List<String> _idTypes = ['Aadhaar Card', 'PAN Card', 'Voter ID', 'Driving License', 'Passport', 'Govt ID'];
  final List<String> _addressDocTypes = ['Electricity Bill', 'Aadhaar Card', 'Voter ID', 'Passport', 'Rent Agreement'];



  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final user = ref.read(currentUserProvider).value;
      if (user != null) {
        setState(() {
          _nameController.text = user.fullName ?? '';
          _phoneController.text = user.phone ?? '';
          _descriptionController.text = user.bio ?? '';
          _experienceController.text = user.drivingExperience ?? '';
          
          _pincodeController.text = user.pincode ?? '';
          _stateController.text = user.state ?? '';
          _cityController.text = user.city ?? '';
          _selectedTehsil = user.tehsil;
          _addressDetailsController.text = user.address ?? '';
          
          // ID Proof
          _idType = user.idType;
          _idNumberController.text = user.idNumber ?? '';
          _addressDocType = user.addressDocType;

          // Preferences
          _noSmoking = user.prefNoSmoking;
          _noMusic = user.prefNoMusic;
          _noHeavyLuggage = user.prefNoHeavyLuggage;
          _noPets = user.prefNoPets;
          _negotiation = user.prefNegotiation;

          if (_selectedTehsil != null) _tehsilOptions = [_selectedTehsil!];

          _vehiclePlateController.text = user.vehicleLicensePlate ?? '';
          _dlController.text = user.drivingLicenseNumber ?? '';
          _pucController.text = user.pucNumber ?? '';
          _insController.text = user.insuranceNumber ?? '';
        });
      }
    });

    _pincodeController.addListener(() {
      if (_pincodeController.text.length == 6) _fetchPincodeDetails(_pincodeController.text);
    });
  }

  Future<void> _fetchPincodeDetails(String pincode) async {
    try {
      final response = await http.get(Uri.parse('https://api.postalpincode.in/pincode/$pincode'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data[0]['Status'] == 'Success') {
          final postOffices = data[0]['PostOffice'] as List;
          setState(() {
            _stateController.text = postOffices[0]['State'];
            _cityController.text = postOffices[0]['District'];
            _tehsilOptions = postOffices.map((po) => po['Name'] as String).toList();
            _selectedTehsil = _tehsilOptions.first;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching pincode: $e');
    }
  }

  Future<void> _pickDocument(bool isId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => isId ? _idFile = File(pickedFile.path) : _addressDocFile = File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) return;
      
      String? photoUrl = user.photoUrl;
      if (_imageFile != null) photoUrl = await StorageService.uploadProfilePhoto(userId: user.id, imageFile: _imageFile!);

      String? idDocUrl = user.idDocUrl;
      if (_idFile != null) idDocUrl = await StorageService.uploadProfilePhoto(userId: "${user.id}_id", imageFile: _idFile!);

      String? addressDocUrl = user.addressDocUrl;
      if (_addressDocFile != null) addressDocUrl = await StorageService.uploadProfilePhoto(userId: "${user.id}_addr", imageFile: _addressDocFile!);

      await ref.read(authActionsProvider).updateProfile(
        userId: user.id,
        data: {
          'full_name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'bio': _descriptionController.text.trim(),
          'driving_experience': _experienceController.text.trim(),
          'pincode': _pincodeController.text.trim(),
          'state': _stateController.text.trim(),
          'city': _cityController.text.trim(),
          'tehsil': _selectedTehsil ?? '',
          'address': _addressDetailsController.text.trim(),
          'id_type': _idType,
          'id_number': _idNumberController.text.trim(),
          'id_doc_url': idDocUrl,
          'address_doc_type': _addressDocType,
          'address_doc_url': addressDocUrl,
          'vehicle_license_plate': _vehiclePlateController.text.trim(),
          'driving_license_number': _dlController.text.trim(),
          'puc_number': _pucController.text.trim(),
          'insurance_number': _insController.text.trim(),
          'photo_url': photoUrl,
          'doc_verification_status': 'pending', // Mark as pending when docs are uploaded
          'pref_no_smoking': _noSmoking,
          'pref_no_music': _noMusic,
          'pref_no_heavy_luggage': _noHeavyLuggage,
          'pref_no_pets': _noPets,
          'pref_negotiation': _negotiation,
        },
      );
      ref.invalidate(currentUserProvider);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile'), actions: [IconButton(onPressed: _isLoading ? null : _saveProfile, icon: const Icon(Icons.check))]),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: _formKey, child: Column(children: [
        GestureDetector(onTap: () async {
          final picker = ImagePicker();
          final pickedFile = await picker.pickImage(source: ImageSource.camera);
          if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
        }, child: CircleAvatar(radius: 50, backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null, child: _imageFile == null ? const Icon(Icons.camera_alt) : null)),
        const SizedBox(height: 24),
        _buildTextField(_nameController, 'Full Name', Icons.person, isRequired: true),
        const SizedBox(height: 16),
        _buildTextField(_phoneController, 'Phone', Icons.phone, isRequired: true),
        
        const SizedBox(height: 32),
        const _SectionHeader(icon: Icons.badge, title: 'ID Proof (Security)'),
        DropdownButtonFormField<String>(initialValue: _idType, decoration: _inputDec('ID Document Type', Icons.description), items: _idTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => _idType = v)),
        const SizedBox(height: 16),
        _buildTextField(_idNumberController, 'ID Document Number', Icons.pin),
        const SizedBox(height: 16),
        _buildDocPicker('Upload ID Proof Front', _idFile, () => _pickDocument(true)),

        const SizedBox(height: 32),
        const _SectionHeader(icon: Icons.location_on, title: 'Address & Proof'),
        _buildTextField(_pincodeController, 'Pincode', Icons.pin_drop, isRequired: true),
        const SizedBox(height: 16),
        Row(children: [Expanded(child: _buildTextField(_stateController, 'State', Icons.map, readOnly: true)), const SizedBox(width: 16), Expanded(child: _buildTextField(_cityController, 'City', Icons.location_city, readOnly: true))]),
        const SizedBox(height: 16),
        if (_tehsilOptions.isNotEmpty) DropdownButtonFormField<String>(initialValue: _tehsilOptions.contains(_selectedTehsil) ? _selectedTehsil : null, decoration: _inputDec('Tehsil/Area', Icons.home_work), items: _tehsilOptions.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => _selectedTehsil = v)),
        const SizedBox(height: 16),
        _buildTextField(_addressDetailsController, 'Street/House No', Icons.home),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(initialValue: _addressDocType, decoration: _inputDec('Address Proof Type', Icons.file_present), items: _addressDocTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setState(() => _addressDocType = v)),
        const SizedBox(height: 16),
        _buildDocPicker('Upload Address Proof', _addressDocFile, () => _pickDocument(false)),

        const SizedBox(height: 32),
        const SizedBox(height: 32),
        const _SectionHeader(icon: Icons.car_rental, title: 'Vehicle & Driver Details'),
        _buildTextField(_vehiclePlateController, 'Vehicle RC Number *', Icons.pin_outlined, textCapitalization: TextCapitalization.characters),
        const SizedBox(height: 16),
        _buildTextField(_dlController, 'Driving License Number *', Icons.badge_outlined, textCapitalization: TextCapitalization.characters),
        const SizedBox(height: 16),
        _buildTextField(_pucController, 'PUC Number (Optional)', Icons.receipt_long_outlined, textCapitalization: TextCapitalization.characters),
        const SizedBox(height: 16),
        _buildTextField(_insController, 'Insurance Number (Optional)', Icons.shield_outlined, textCapitalization: TextCapitalization.characters),
        const SizedBox(height: 12),
        const Text(
          'Note: These details are required for security audit before you can publish rides.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        
        const SizedBox(height: 32),
        const _SectionHeader(icon: Icons.settings, title: 'Ride Rules (Auto-Sync)'),
        _buildPreferenceSwitch('No Smoking', Icons.smoke_free, _noSmoking, (v) => setState(() => _noSmoking = v)),
        _buildPreferenceSwitch('No Music', Icons.music_off, _noMusic, (v) => setState(() => _noMusic = v)),
        _buildPreferenceSwitch('No Heavy Luggage', Icons.backpack, _noHeavyLuggage, (v) => setState(() => _noHeavyLuggage = v)),
        _buildPreferenceSwitch('No Pets', Icons.pets, _noPets, (v) => setState(() => _noPets = v)),
        _buildPreferenceSwitch('Allow Price Negotiation', Icons.handshake, _negotiation, (v) => setState(() => _negotiation = v)),

        const SizedBox(height: 40),
      ]))),
    );
  }

  Widget _buildPreferenceSwitch(String title, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      secondary: Icon(icon, color: AppColors.primary),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
    );
  }

  Widget _buildDocPicker(String label, File? file, VoidCallback onTap) {
    return ListTile(
      tileColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(file == null ? Icons.upload_file : Icons.check_circle, color: file == null ? AppColors.primary : Colors.green),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      subtitle: file != null ? Text(file.path.split('/').last) : const Text('Tap to choose file'),
      onTap: onTap,
    );
  }

  InputDecoration _inputDec(String label, IconData icon) => InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)));
  
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isRequired = false, bool readOnly = false, TextCapitalization textCapitalization = TextCapitalization.none}) {
    return TextFormField(controller: controller, readOnly: readOnly, textCapitalization: textCapitalization, decoration: _inputDec(label, icon), validator: isRequired ? (v) => v!.isEmpty ? 'Required' : null : null);
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon; final String title;
  const _SectionHeader({required this.icon, required this.title});
  @override Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(children: [Icon(icon, color: AppColors.primary), const SizedBox(width: 12), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]));
  }
}
