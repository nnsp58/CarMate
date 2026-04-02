import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../services/sos_service.dart';

/// Floating SOS Button — 2s long-press to trigger emergency alert
/// PRD v2: "SOS button with long-press activation on Home Screen"
class SOSButton extends ConsumerStatefulWidget {
  const SOSButton({super.key});

  @override
  ConsumerState<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends ConsumerState<SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLongPressing = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _triggerSOS();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails _) {
    HapticFeedback.heavyImpact();
    setState(() => _isLongPressing = true);
    _animationController.forward(from: 0);
  }

  void _onLongPressEnd(LongPressEndDetails _) {
    if (!_animationController.isCompleted) {
      _animationController.reset();
      setState(() => _isLongPressing = false);
    }
  }

  Future<void> _triggerSOS() async {
    if (_isSending) return;
    setState(() {
      _isSending = true;
      _isLongPressing = false;
    });

    HapticFeedback.vibrate();

    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) {
        _showSnackBar('Please login first', isError: true);
        return;
      }

      // Get current location
      double lat = 0, lng = 0;
      String? locationName;
      try {
        final position = await Geolocator.getCurrentPosition()
            .timeout(const Duration(seconds: 5));
        lat = position.latitude;
        lng = position.longitude;
      } catch (_) {
        // Use 0,0 if location unavailable — server will handle
      }

      final alertId = await SOSService.triggerSOS(
        userId: user.id,
        userName: user.displayName,
        latitude: lat,
        longitude: lng,
        locationName: locationName,
        emergencyType: 'general',
      );

      if (mounted) {
        _showSOSConfirmation(alertId);
      }
    } catch (e) {
      _showSnackBar('SOS Failed: $e', isError: true);
    } finally {
      if (mounted) {
        _animationController.reset();
        setState(() => _isSending = false);
      }
    }
  }

  void _showSOSConfirmation(String alertId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('SOS Alert Sent! 🆘'),
        content: const Text(
          'Emergency alert has been sent to the admin team.\n'
          'Stay safe — help is on the way.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              // Cancel the SOS
              try {
                await SOSService.cancelSOS(alertId: alertId);
                if (mounted) {
                  _showSnackBar('SOS Alert cancelled');
                }
              } catch (_) {}
            },
            child: const Text('Cancel Alert'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final progress = _animationController.value;

        return GestureDetector(
          onLongPressStart: _isSending ? null : _onLongPressStart,
          onLongPressEnd: _isSending ? null : _onLongPressEnd,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Long press for 2 seconds to trigger SOS 🆘'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing ring when long-pressing
              if (_isLongPressing)
                SizedBox(
                  width: 64 + (progress * 20),
                  height: 64 + (progress * 20),
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(Colors.orange, Colors.red, progress)!,
                    ),
                    backgroundColor: Colors.red.withValues(alpha: 0.15),
                  ),
                ),

              // Main button
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isLongPressing
                        ? [Colors.red.shade700, Colors.red.shade900]
                        : [Colors.red.shade500, Colors.red.shade700],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: _isLongPressing ? 0.5 : 0.3),
                      blurRadius: _isLongPressing ? 20 : 10,
                      spreadRadius: _isLongPressing ? 2 : 0,
                    ),
                  ],
                ),
                child: _isSending
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.sos_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
