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
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTypeField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 16),
                  _buildPhotoSection(),
                  const SizedBox(height: 12),
                  _buildLocationIndicator(),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ],
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
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
        labelText: 'Type de problème',
        prefixIcon: Icon(Icons.warning_amber_outlined),
        border: OutlineInputBorder(),
      ),
      items: [
        for (final type in ReportType.values)
          DropdownMenuItem<ReportType>(
            value: type,
            child: Text(type.label),
          ),
      ],
      validator: (value) => value == null
          ? 'Choisissez un type de problème'
          : null,
      onChanged: _submitting
          ? null
          : (value) => setState(() => _type = value),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      maxLength: 500,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.validateDescription,
      decoration: const InputDecoration(
        labelText: 'Description du problème',
        hintText: 'Décrivez le problème rencontré...',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _submitting ? null : _pickPhoto,
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text('Ajouter une photo (facultatif)'),
        ),
        if (_photoBytes != null) ...[
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  _photoBytes!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              IconButton.filled(
                onPressed: _submitting
                    ? null
                    : () => setState(() => _photoBytes = null),
                icon: const Icon(Icons.close),
                tooltip: 'Retirer la photo',
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLocationIndicator() {
    if (_locating) {
      return const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text(
            'Recherche de votre position...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      );
    }

    final located = _position != null;
    return Row(
      children: [
        Icon(
          located ? Icons.location_on : Icons.location_off,
          size: 18,
          color: located ? AppColors.primary : AppColors.textDisabled,
        ),
        const SizedBox(width: 8),
        Text(
          located
              ? 'Localisation détectée'
              : 'GPS indisponible — envoi sans localisation',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return FilledButton(
      onPressed: _submitting ? null : _submit,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _submitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Envoyer', style: TextStyle(fontSize: 16)),
    );
  }
}