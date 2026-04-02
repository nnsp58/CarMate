import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class VehicleSetupScreen extends ConsumerStatefulWidget {
  const VehicleSetupScreen({super.key});

  @override
  ConsumerState<VehicleSetupScreen> createState() => _VehicleSetupScreenState();
}

class _VehicleSetupScreenState extends ConsumerState<VehicleSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  String _vehicleType = 'None';
  String? _selectedManufacturer;
  String? _selectedModel;
  String? _selectedColor;
  bool _isLoading = false;

  final List<String> _vehicleTypes = ['None', 'Car', 'Bike', 'Van'];

  // Vehicle manufacturers and models data
  final Map<String, List<String>> _carManufacturers = {
    'Maruti Suzuki': ['Swift', 'Baleno', 'Alto', 'WagonR', 'Dzire', 'Ertiga', 'Brezza', 'Ciaz', 'Vitara', 'Celerio', 'S-Presso', 'Ignis', 'XL6', 'Fronx', 'Jimny', 'Invicto', 'Grand Vitara'],
    'Hyundai': ['i20', 'Creta', 'Venue', 'Verna', 'i10 Nios', 'Tucson', 'Alcazar', 'Aura', 'Exter', 'Ioniq 5'],
    'Tata': ['Nexon', 'Punch', 'Harrier', 'Safari', 'Altroz', 'Tiago', 'Tigor', 'Nano', 'Hexa', 'Curvv'],
    'Mahindra': ['Thar', 'XUV700', 'Scorpio', 'Bolero', 'XUV300', 'XUV400', 'Scorpio-N', 'Marazzo', 'BE 6'],
    'Kia': ['Seltos', 'Sonet', 'Carens', 'Carnival', 'EV6', 'EV9'],
    'Toyota': ['Innova', 'Fortuner', 'Glanza', 'Urban Cruiser', 'Hyryder', 'Camry', 'Vellfire', 'Hilux', 'Innova Hycross'],
    'Honda': ['City', 'Amaze', 'WR-V', 'Jazz', 'Elevate'],
    'MG': ['Hector', 'Astor', 'Gloster', 'ZS EV', 'Comet EV'],
    'Skoda': ['Slavia', 'Kushaq', 'Superb', 'Octavia', 'Kodiaq'],
    'Volkswagen': ['Taigun', 'Virtus', 'Polo', 'Vento', 'Tiguan'],
    'Renault': ['Kwid', 'Triber', 'Kiger', 'Duster'],
    'Nissan': ['Magnite', 'Kicks', 'X-Trail'],
    'Ford': ['Ecosport', 'Endeavour', 'Figo', 'Aspire'],
    'Chevrolet': ['Beat', 'Cruze', 'Spark', 'Tavera'],
    'Other': ['Other'],
  };

  final Map<String, List<String>> _bikeManufacturers = {
    'Hero': ['Splendor', 'HF Deluxe', 'Passion', 'Glamour', 'Xtreme', 'Xpulse', 'Karizma XMR', 'Mavrick'],
    'Honda': ['Activa', 'Shine', 'Unicorn', 'SP125', 'Dio', 'Hornet', 'CB350', 'Highness'],
    'Bajaj': ['Pulsar', 'Platina', 'Avenger', 'Dominar', 'CT100', 'Chetak'],
    'TVS': ['Apache', 'Jupiter', 'Ntorq', 'Raider', 'Star City', 'Ronin', 'iQube'],
    'Royal Enfield': ['Classic 350', 'Bullet 350', 'Meteor 350', 'Hunter 350', 'Himalayan', 'Continental GT', 'Interceptor 650', 'Super Meteor 650', 'Shotgun 650'],
    'Yamaha': ['FZ', 'MT-15', 'R15', 'Fascino', 'Ray ZR', 'Aerox'],
    'Suzuki': ['Gixxer', 'Access', 'Burgman', 'Hayabusa', 'V-Strom'],
    'KTM': ['Duke 200', 'Duke 390', 'RC 200', 'RC 390', 'Adventure 390'],
    'Other': ['Other'],
  };

  final Map<String, List<String>> _vanManufacturers = {
    'Maruti Suzuki': ['Eeco', 'Omni'],
    'Tata': ['Winger', 'Ace', 'Magic'],
    'Mahindra': ['Supro', 'Jeeto', 'Bolero Pickup'],
    'Ashok Leyland': ['Dost', 'Partner', 'Bada Dost'],
    'Force Motors': ['Traveller', 'Trax', 'Gurkha'],
    'Toyota': ['HiAce'],
    'Other': ['Other'],
  };

  final List<String> _colorOptions = [
    'White', 'Black', 'Silver', 'Grey', 'Red', 'Blue', 
    'Green', 'Yellow', 'Orange', 'Brown', 'Maroon', 
    'Beige', 'Gold', 'Purple', 'Navy Blue', 'Other',
  ];

  Map<String, List<String>> get _currentManufacturers {
    switch (_vehicleType) {
      case 'Car': return _carManufacturers;
      case 'Bike': return _bikeManufacturers;
      case 'Van': return _vanManufacturers;
      default: return {};
    }
  }

  List<String> get _currentModels {
    if (_selectedManufacturer == null) return [];
    return _currentManufacturers[_selectedManufacturer] ?? [];
  }

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _saveVehicleInfo(bool skip) async {
    if (!skip && _vehicleType != 'None' && !_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(currentUserProvider).value ??
          await ref.read(authActionsProvider).getCurrentUserDirectly();
      if (user == null) throw Exception('User not found');

      final Map<String, dynamic> data = {
        'setup_complete': true,
      };

      if (!skip && _vehicleType != 'None') {
        final modelStr = _selectedManufacturer != null && _selectedModel != null
            ? '$_selectedManufacturer $_selectedModel'
            : null;
        data.addAll({
          'vehicle_model': modelStr,
          'vehicle_license_plate': _plateController.text.trim().toUpperCase(),
          'vehicle_color': _selectedColor,
          'vehicle_type': _vehicleType,
        });
      }

      await ref.read(authActionsProvider).updateProfile(
        userId: user.id,
        data: data,
      );

      // Refresh user provider to get setup_complete = true
      ref.invalidate(currentUserProvider);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save vehicle info: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showVehicleFields = _vehicleType != 'None';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Setup'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        actions: [
          TextButton(
            onPressed: () => _saveVehicleInfo(true),
            child: const Text('Skip'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Got a vehicle?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your vehicle details to start publishing rides. You can skip this and add later.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Vehicle Type Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: _vehicleType,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        prefixIcon: Icon(_getVehicleIcon(_vehicleType)),
                      ),
                      items: _vehicleTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _vehicleType = value;
                            _selectedManufacturer = null;
                            _selectedModel = null;
                            _selectedColor = null;
                            _plateController.clear();
                          });
                        }
                      },
                    ),

                    // Vehicle Details - only show when a vehicle type is selected
                    if (showVehicleFields) ...[
                      const SizedBox(height: 16),

                      // Manufacturer Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedManufacturer,
                        decoration: InputDecoration(
                          labelText: 'Manufacturer',
                          hintText: 'Select manufacturer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.factory_outlined),
                        ),
                        items: _currentManufacturers.keys.map((mfr) {
                          return DropdownMenuItem(
                            value: mfr,
                            child: Text(mfr),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedManufacturer = value;
                            _selectedModel = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select manufacturer';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Model Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedModel,
                        decoration: InputDecoration(
                          labelText: 'Model',
                          hintText: _selectedManufacturer == null 
                              ? 'Select manufacturer first' 
                              : 'Select model',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.info_outline),
                        ),
                        items: _currentModels.map((model) {
                          return DropdownMenuItem(
                            value: model,
                            child: Text(model),
                          );
                        }).toList(),
                        onChanged: _selectedManufacturer == null 
                            ? null 
                            : (value) {
                                setState(() {
                                  _selectedModel = value;
                                });
                              },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select model';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // License Plate with auto uppercase
                      TextFormField(
                        controller: _plateController,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'License Plate',
                          hintText: 'e.g. DL 01 AB 1234',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.pin_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter license plate';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Color Dropdown
                      DropdownButtonFormField<String>(
                        initialValue: _selectedColor,
                        decoration: InputDecoration(
                          labelText: 'Color',
                          hintText: 'Select color',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          prefixIcon: const Icon(Icons.palette_outlined),
                        ),
                        items: _colorOptions.map((color) {
                          return DropdownMenuItem(
                            value: color,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: _getColorFromName(color),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                ),
                                Text(color),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedColor = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select color';
                          }
                          return null;
                        },
                      ),
                    ],

                    const SizedBox(height: 48),

                    // Save / Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_vehicleType == 'None') {
                            // No vehicle - just mark setup complete and go to home
                            _saveVehicleInfo(true);
                          } else {
                            _saveVehicleInfo(false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _vehicleType == 'None' ? 'Continue Without Vehicle' : 'Finish Setup',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  IconData _getVehicleIcon(String type) {
    switch (type) {
      case 'Car': return Icons.directions_car_outlined;
      case 'Bike': return Icons.two_wheeler_outlined;
      case 'Van': return Icons.airport_shuttle_outlined;
      default: return Icons.no_transfer_outlined;
    }
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'white': return Colors.white;
      case 'black': return Colors.black;
      case 'silver': return Colors.grey[400]!;
      case 'grey': return Colors.grey;
      case 'red': return Colors.red;
      case 'blue': return Colors.blue;
      case 'green': return Colors.green;
      case 'yellow': return Colors.yellow;
      case 'orange': return Colors.orange;
      case 'brown': return Colors.brown;
      case 'maroon': return const Color(0xFF800000);
      case 'beige': return const Color(0xFFF5F5DC);
      case 'gold': return const Color(0xFFFFD700);
      case 'purple': return Colors.purple;
      case 'navy blue': return const Color(0xFF000080);
      default: return Colors.grey[300]!;
    }
  }
}

// Custom formatter to auto uppercase license plate input
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
