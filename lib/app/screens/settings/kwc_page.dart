import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';

class KwcPage extends StatefulWidget {
  const KwcPage({super.key});

  @override
  State<KwcPage> createState() => _KwcPageState();
}

class _KwcPageState extends State<KwcPage> {
  File? _selectedFile;
  String? _fileName;
  bool _isPdf = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
        _fileName = image.name;
        _isPdf = false;
      });
    }
  }

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
        _isPdf = true;
      });
    }
  }

  void _submit() {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un fichier')),
      );
      return;
    }

    // TODO: Relier au backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Soumission envoyée avec succès (Simulation)'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            const MyAppBar(title: 'Vérification KWC'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Veuillez soumettre une copie lisible de votre CNI pour vérifier votre identité.',
                      style: TextStyle(color: cs.onSurface.withOpacity(0.7), fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    
                    // -- Options de sélection
                    Row(
                      children: [
                        Expanded(
                          child: _buildUploadOption(
                            cs, 
                            isDark, 
                            Icons.camera_alt_rounded, 
                            'Photo', 
                            () => _pickImage(ImageSource.camera)
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildUploadOption(
                            cs, 
                            isDark, 
                            Icons.picture_as_pdf_rounded, 
                            'PDF', 
                            _pickPdf
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    _buildSectionTitle(cs, 'Aperçu du document'),
                    const SizedBox(height: 12),
                    
                    // -- Zone d'aperçu
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: isDark ? cs.surfaceContainerHigh : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: cs.primary.withOpacity(0.1)),
                      ),
                      child: _selectedFile == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined, size: 48, color: cs.primary.withOpacity(0.3)),
                                  const SizedBox(height: 8),
                                  Text('Aucun fichier sélectionné', style: TextStyle(color: cs.onSurface.withOpacity(0.4))),
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                Center(
                                  child: _isPdf
                                      ? Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.picture_as_pdf, size: 64, color: Colors.red),
                                            const SizedBox(height: 8),
                                            Text(_fileName ?? 'document.pdf', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          ],
                                        )
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(18),
                                          child: Image.file(_selectedFile!, fit: BoxFit.cover, width: double.infinity),
                                        ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: IconButton.filled(
                                    onPressed: () => setState(() => _selectedFile = null),
                                    icon: const Icon(Icons.close),
                                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                                  ),
                                )
                              ],
                            ),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // -- Bouton de soumission
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text('SOUMETTRE POUR VÉRIFICATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(ColorScheme cs, bool isDark, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainerHigh : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.primary.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: cs.primary),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ColorScheme cs, String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
    );
  }
}
