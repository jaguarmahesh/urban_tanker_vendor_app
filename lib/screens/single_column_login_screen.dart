import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../config/vendor_client_config.dart';
import '../providers/vendor_app_state.dart';

class SingleColumnLoginScreen extends StatefulWidget {
  const SingleColumnLoginScreen({Key? key}) : super(key: key);

  @override
  State<SingleColumnLoginScreen> createState() => _SingleColumnLoginScreenState();
}

class _SingleColumnLoginScreenState extends State<SingleColumnLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientCodeController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _mpinController;

  bool _obscurePassword = true;
  bool _useMpinLogin = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _clientCodeController = TextEditingController();
    _emailController = TextEditingController(text: 'vendor@balajiwater.in');
    _passwordController = TextEditingController(text: 'vendor@2026');
    _mpinController = TextEditingController(text: '1234');
  }

  @override
  void dispose() {
    _clientCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mpinController.dispose();
    super.dispose();
  }

  void _selectPresetClient(VendorClientConfig client) {
    setState(() {
      _clientCodeController.text = client.clientCode;
      _emailController.text = client.allowedEmails.first;
      _passwordController.text = 'vendor@2026';
      _mpinController.text = '1234';
      _errorMessage = null;
    });
  }

  Future<void> _handlePasswordLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMessage = null);

    try {
      await context.read<VendorAppState>().loginVendor(
            _emailController.text.trim(),
            _passwordController.text,
            _clientCodeController.text.trim(),
          );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _handleMpinLogin() async {
    final mpin = _mpinController.text.trim();
    if (mpin.length < 4) {
      setState(() => _errorMessage = 'Please enter 4-digit MPIN.');
      return;
    }
    setState(() => _errorMessage = null);

    try {
      await context.read<VendorAppState>().loginWithMpin(
            email: _emailController.text.trim(),
            mpin: mpin,
            clientCode: _clientCodeController.text.trim(),
          );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _handleBiometricLogin() async {
    setState(() => _errorMessage = null);
    try {
      await context.read<VendorAppState>().loginWithBiometrics(
            email: _emailController.text.trim(),
            clientCode: _clientCodeController.text.trim(),
          );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<VendorAppState>();
    final isBusy = appState.isLoading;
    final clientsList = VendorClientRegistry.clients.values.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Brand Icon & Top Badges ---
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Center(
                    child: Text(
                      'URBAN TANKER',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),

                  const Center(
                    child: Text(
                      'Distributed Multi-Client Vendor App',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Security & Encryption Pill
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.shield, color: Color(0xFF16A34A), size: 13),
                          SizedBox(width: 4),
                          Text(
                            'SQLite Local Pre-Verify • AES-256 Encrypted Session',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF166534),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // --- Distributed Customer / Client Preset Quick-Select ---
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.business, size: 14, color: Color(0xFF2563EB)),
                            SizedBox(width: 6),
                            Text(
                              'Distributed Client Selector (Tap to Switch):',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: clientsList.map((client) {
                              final isSelected = _clientCodeController.text.toUpperCase() ==
                                      client.clientCode.toUpperCase() ||
                                  _emailController.text == client.allowedEmails.first;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                  avatar: CircleAvatar(
                                    backgroundColor: client.accentColor,
                                    radius: 6,
                                  ),
                                  label: Text(
                                    '${client.name.split(" ")[0]} (${client.clientCode})',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? Colors.white : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: const Color(0xFF2563EB),
                                  backgroundColor: const Color(0xFFF1F5F9),
                                  onSelected: (_) => _selectPresetClient(client),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // --- Single Column Sign-in Card ---
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Toggle Login Mode (Password vs MPIN)
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _useMpinLogin = false),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: !_useMpinLogin
                                        ? const Color(0xFFEFF6FF)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: !_useMpinLogin
                                          ? const Color(0xFF2563EB)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Password / Firebase',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: !_useMpinLogin
                                            ? const Color(0xFF2563EB)
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _useMpinLogin = true),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _useMpinLogin
                                        ? const Color(0xFFEFF6FF)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _useMpinLogin
                                          ? const Color(0xFF2563EB)
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Quick 4-Digit MPIN',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _useMpinLogin
                                            ? const Color(0xFF2563EB)
                                            : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        if (_errorMessage != null || appState.authError != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFFECACA)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage ?? appState.authError ?? '',
                                    style: const TextStyle(
                                      color: Color(0xFFB91C1C),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Client Code Field
                        TextFormField(
                          controller: _clientCodeController,
                          decoration: const InputDecoration(
                            labelText: 'Organization / Client Code (Optional)',
                            hintText: 'e.g. BALAJI, AQUA, METRO',
                            prefixIcon: Icon(Icons.apartment_outlined, size: 20),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Enter vendor email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Vendor Account Email',
                            hintText: 'vendor@client.com',
                            prefixIcon: Icon(Icons.email_outlined, size: 20),
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Password or MPIN Input
                        if (!_useMpinLogin)
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Enter password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Account Password',
                              prefixIcon: const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  size: 18,
                                ),
                                onPressed: () {
                                  setState(() => _obscurePassword = !_obscurePassword);
                                },
                              ),
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                          )
                        else
                          TextFormField(
                            controller: _mpinController,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Enter 4-Digit MPIN',
                              hintText: '1234',
                              prefixIcon: Icon(Icons.pin_outlined, size: 20),
                              border: OutlineInputBorder(),
                              counterText: '',
                              isDense: true,
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Primary Sign-in Button
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            onPressed: isBusy
                                ? null
                                : () {
                                    if (_useMpinLogin) {
                                      _handleMpinLogin();
                                    } else {
                                      _handlePasswordLogin();
                                    }
                                  },
                            child: isBusy
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _useMpinLogin ? 'Sign In with MPIN' : 'Sign In to Portal',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Biometric Fingerprint Button
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: isBusy ? null : _handleBiometricLogin,
                          icon: const Icon(Icons.fingerprint, color: Color(0xFF2563EB), size: 22),
                          label: const Text(
                            'Quick Fingerprint / Biometric Login',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bottom info
                  const Center(
                    child: Text(
                      'Universal Multi-Customer Engine • Distributed Silos',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
