import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  File? _dlFront;
  File? _dlBack;
  File? _rcBook;
  bool _isLoading = false;

  Future<void> _pickDocument(String type) async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (type == 'dl_front') _dlFront = File(pickedFile.path);
        if (type == 'dl_back') _dlBack = File(pickedFile.path);
        if (type == 'rc_book') _rcBook = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForVerification() async {
    if (_dlFront == null || _dlBack == null || _rcBook == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload all required documents')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) return;

      final dlFrontUrl = await StorageService.uploadDocument(userId: user.id, imageFile: _dlFront!, docType: 'driving_license_front');
      final dlBackUrl = await StorageService.uploadDocument(userId: user.id, imageFile: _dlBack!, docType: 'driving_license_back');
      final rcBookUrl = await StorageService.uploadDocument(userId: user.id, imageFile: _rcBook!, docType: 'vehicle_rc');

      await ref.read(authActionsProvider).updateProfile(
        userId: user.id,
        data: {
          'doc_driving_license_front': dlFrontUrl,
          'doc_driving_license_back': dlBackUrl,
          'doc_vehicle_rc': rcBookUrl,
          'doc_verification_status': 'pending',
        },
      );

      ref.invalidate(currentUserProvider);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Submitted!'),
            content: const Text(
                'Your documents have been submitted for verification. We will notify you once reviewed.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final status = user?.docVerificationStatus ?? 'not_submitted';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Account'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBanner(status, user?.docRejectionReason),
                  const SizedBox(height: 32),
                  const Text('Required Documents',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Upload clear photos of your documents',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),
                  _buildDocCard('Driving License (Front)', _dlFront, () => _pickDocument('dl_front')),
                  _buildDocCard('Driving License (Back)', _dlBack, () => _pickDocument('dl_back')),
                  _buildDocCard('Vehicle RC Book', _rcBook, () => _pickDocument('rc_book')),
                  const SizedBox(height: 48),
                  if (status == 'not_submitted' || status == 'rejected')
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitForVerification,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Submit for Verification',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBanner(String status, String? reason) {
    Color color;
    IconData icon;
    String text;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        text = 'Review Pending: Your documents are being reviewed.';
        break;
      case 'approved':
        color = Colors.green;
        icon = Icons.verified;
        text = 'Verified: You can now publish rides!';
        break;
      case 'rejected':
        color = Colors.red;
        icon = Icons.error_outline;
        text = 'Rejected: ${reason ?? "Please re-upload documents."}';
        break;
      default:
        color = AppColors.primary;
        icon = Icons.info_outline;
        text = 'Upload documents to unlock ride publishing.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text,
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCard(String title, File? file, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              image: file != null ? DecorationImage(image: FileImage(file), fit: BoxFit.cover) : null,
            ),
            child: file == null ? const Icon(Icons.description, color: Colors.grey) : null,
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
          TextButton(onPressed: onTap, child: Text(file == null ? 'Upload' : 'Change')),
        ],
      ),
    );
  }
}
