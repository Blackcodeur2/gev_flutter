import 'dart:io';
import 'package:camer_trip/app/models/user_model.dart';
import 'package:camer_trip/app/services/auth_service.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camer_trip/app/services/api_client_service.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends ConsumerStatefulWidget {

  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  String _selectedGender = 'M';
  
  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.user.nom);
    _prenomController = TextEditingController(text: widget.user.prenom);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.telephone);
    _dobController = TextEditingController(text: widget.user.dateNaissance);
    _selectedGender = widget.user.sexe;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.updateProfile(
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        telephone: _phoneController.text,
        dateNaissance: _dobController.text,
        sexe: _selectedGender,
        avatar: _imageFile,
      );

      if (response.success) {
        ref.invalidate(currentUserProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil mis à jour avec succès')),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/main');
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? 'Échec de la mise à jour')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    String getAvatarUrl(String? url) {
      if (url == null || url.isEmpty) return "";
      if (url.startsWith('http')) {
        if (url.contains('localhost')) {
          final serverIp = Uri.parse(ApiClient().baseUrl).host;
          return url.replaceAll('localhost', serverIp);
        }
        return url;
      }
      final base = ApiClient().baseUrl.replaceAll('/api', '');
      return "$base/storage/$url";
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(
              title: 'Modifier le profil',
              trailing: _isLoading 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : IconButton(
                    icon: const Icon(Icons.check_rounded, color: Colors.green, size: 30),
                    onPressed: _handleSave,
                  ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // 📸 Photo de Profil
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cs.primary.withOpacity(0.1),
                              border: Border.all(color: cs.primary.withOpacity(0.2), width: 2),
                              image: _imageFile != null 
                                ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                                : (widget.user.profilUrl != null 
                                    ? DecorationImage(
                                        image: NetworkImage(getAvatarUrl(widget.user.profilUrl)), 
                                        fit: BoxFit.cover
                                      )
                                    : null),
                            ),

                            child: (_imageFile == null && widget.user.profilUrl == null)
                                ? Icon(Icons.person_rounded, size: 60, color: cs.primary.withOpacity(0.5))
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: cs.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 📝 Champs de texte
                      _buildTextField(cs, 'Nom', _nomController, Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildTextField(cs, 'Prénom', _prenomController, Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildTextField(cs, 'Email', _emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      _buildTextField(cs, 'Téléphone', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      
                      // Date de naissance
                      _buildDateField(context, cs),
                      const SizedBox(height: 16),

                      // Sexe
                      _buildGenderField(cs),
                      
                      const SizedBox(height: 40),
                      
                      Text(
                        "Note: Certaines informations comme votre matricule ou votre rôle ne peuvent être modifiées manuellement.",
                        style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 12, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Date de naissance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dobController,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
            filled: true,
            fillColor: cs.surfaceContainerHigh,
            hintText: "AAAA-MM-JJ",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(const Duration(days: 6570)), // ~18 ans
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              setState(() {
                _dobController.text = pickedDate.toString().split(' ')[0];
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildGenderField(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sexe", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text("Masculin")),
                selected: _selectedGender == 'M',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedGender = 'M');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text("Féminin")),
                selected: _selectedGender == 'F',
                onSelected: (selected) {
                  if (selected) setState(() => _selectedGender = 'F');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(ColorScheme cs, String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: cs.surfaceContainerHigh,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Ce champ est requis';
            return null;
          },
        ),
      ],
    );
  }
}
