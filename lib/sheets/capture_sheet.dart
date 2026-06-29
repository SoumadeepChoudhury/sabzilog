import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_widgets.dart';

class CaptureSheet extends StatefulWidget {
  const CaptureSheet({
    required this.pickImage,
    required this.onSave,
    super.key,
  });

  final Future<File?> Function() pickImage;
  final void Function(double amount, String weight, File photo) onSave;

  @override
  State<CaptureSheet> createState() => _CaptureSheetState();
}

class _CaptureSheetState extends State<CaptureSheet> {
  final _amountController = TextEditingController(text: '58');
  final _weightController = TextEditingController(text: '500g');
  late bool _hasPhoto = false;
  File? _photo;

  final List<String> _weightPresets = [
    '125g',
    '250g',
    '500g',
    '1kg',
    '1.5kg',
    '2kg',
  ];

  void initializeCamera() async {
    File? image = await widget.pickImage();
    setState(() {
      _hasPhoto = image != null;
      _photo = image;
    });
  }

  @override
  void initState() {
    initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.page,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'New purchase',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Fast logging: proof photo, price, and weight.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withValues(alpha: .58),
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => setState(() => _hasPhoto = !_hasPhoto),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: .08),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Photo Background
                      if (_photo != null && _photo!.path.isNotEmpty)
                        Image.file(_photo!, fit: BoxFit.cover)
                      else
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6BAF62), Color(0xFFE35D42)],
                            ),
                          ),
                        ),

                      // Dark overlay for readability
                      if (_photo != null && _photo!.path.isNotEmpty)
                        Container(color: Colors.black.withValues(alpha: 0.35)),

                      // Existing Icon + Text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _hasPhoto
                                ? Icons.check_circle
                                : Icons.add_a_photo_outlined,
                            color: Colors.white,
                            size: 36,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _hasPhoto
                                ? 'Photo attached'
                                : 'Tap to capture photo',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.currency_rupee),
                  labelText: 'Price',
                  hintText: 'Amount paid',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _weightController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.scale_outlined),
                  labelText: 'Weight',
                  hintText: 'e.g. 500g',
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _weightPresets.map((preset) {
                  return ChoiceChip(
                    label: Text(preset),
                    selected: _weightController.text == preset,
                    onSelected: (selected) {
                      setState(() => _weightController.text = preset);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              // DropdownButtonFormField<String>(
              //   initialValue: _category,
              //   decoration: const InputDecoration(
              //     prefixIcon: Icon(Icons.category_outlined),
              //     labelText: 'Category',
              //   ),
              //   items: const [
              //     DropdownMenuItem(
              //       value: 'Vegetables',
              //       child: Text('Vegetables'),
              //     ),
              //     DropdownMenuItem(value: 'Greens', child: Text('Greens')),
              //     DropdownMenuItem(value: 'Staples', child: Text('Staples')),
              //     DropdownMenuItem(value: 'Other', child: Text('Other')),
              //   ],
              //   onChanged: (value) {
              //     if (value != null) setState(() => _category = value);
              //   },
              // ),
              const SizedBox(height: 14),
              const AlertStrip(
                icon: Icons.info_outline,
                text: 'Owner will see this as pending until checked.',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _hasPhoto ? _save : null,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save log'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) return;
    if (_photo == null) return;

    widget.onSave(
      amount,
      _weightController.text.trim().isEmpty
          ? 'N/A'
          : _weightController.text.trim(),
      _photo!,
    );
    Navigator.of(context).pop();
  }
}
