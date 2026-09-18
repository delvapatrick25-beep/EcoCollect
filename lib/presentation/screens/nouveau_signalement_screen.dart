import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../data/models/report.dart';
import '../providers/auth_provider.dart';
import '../providers/service_providers.dart';
import '../widgets/report_map.dart';
import 'confirmation_screen.dart';

class NouveauSignalementScreen extends ConsumerStatefulWidget {
  const NouveauSignalementScreen({super.key});

  @override
  ConsumerState<NouveauSignalementScreen> createState() =>
      _NouveauSignalementScreenState();
}

class _NouveauSignalementScreenState
    extends ConsumerState<NouveauSignalementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();

  ReportType? _type;
  Position? _position;
  Uint8List? _photoBytes;
  bool _locating = true;
  bool _submitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPosition();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadPosition() async {
    final position =
        await ref.read(locationServiceProvider).getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _position = position;
      _locating = false;
    });
  }

  Future<void> _pickPhoto() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1280,
      imageQuality: 70,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => _photoBytes = bytes);
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    final uid = ref.read(authStateProvider).value?.uid;
    if (uid == null) {
      setState(() {
        _errorMessage = 'Vous devez être connecté pour signaler un problème';
      });
      return;
    }

    setState(() {
      _submitting = true;
      _errorMessage = null;
    });

    try {
      await ref.read(reportRepositoryProvider).addReport(
        userId: uid,
        type: _type!,
        description: _descriptionController.text.trim(),
        latitude: _position?.latitude,
        longitude: _position?.longitude,
      );

      if (!mounted) return;

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ConfirmationScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorMessage = 'Impossible d\'envoyer le signalement : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau signalement')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Détails du problème',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildTypeField(),
                          const SizedBox(height: 16),
                          _buildDescriptionField(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Preuve visuelle (Facultatif)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildPhotoSection(),
                  const SizedBox(height: 24),
                  Text(
                    'Localisation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildLocationIndicator(),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeField() {
    return DropdownButtonFormField<ReportType>(
      initialValue: _type,
      decoration: const InputDecoration(
        labelText: 'Nature du problème',
        prefixIcon: Icon(Icons.category_outlined),
      ),
      items: [
        for (final type in ReportType.values)
          DropdownMenuItem<ReportType>(
            value: type,
            child: Text(type.label),
          ),
      ],
      validator: (value) => value == null ? 'Sélectionnez un type' : null,
      onChanged: _submitting ? null : (value) => setState(() => _type = value),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      maxLength: 500,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.validateDescription,
      decoration: const InputDecoration(
        labelText: 'Description',
        hintText: 'Précisez le problème rencontré...',
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Card(
      child: InkWell(
        onTap: _submitting ? null : _pickPhoto,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: _photoBytes != null ? 220 : 120,
          padding: const EdgeInsets.all(8),
          child: _photoBytes != null
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        _photoBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton.filled(
                        onPressed: () => setState(() => _photoBytes = null),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_outlined,
                      size: 32,
                      color: AppColors.primary.withOpacity(0.7),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cliquez pour ajouter une photo',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLocationIndicator() {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _locating
                ? const Row(
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Localisation en cours...'),
                    ],
                  )
                : Row(
                    children: [
                      Icon(
                        _position != null ? Icons.location_on : Icons.location_off,
                        color: _position != null ? AppColors.primary : AppColors.textDisabled,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _position != null
                              ? 'Position détectée automatiquement'
                              : 'Position non disponible',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
          ),
          if (!_locating && _position != null)
            ReportMap(
              latitude: _position!.latitude,
              longitude: _position!.longitude,
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton(
      onPressed: _submitting ? null : _submit,
      child: _submitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Envoyer le signalement'),
    );
  }
}