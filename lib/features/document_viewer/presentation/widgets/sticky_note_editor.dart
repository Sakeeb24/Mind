import 'package:flutter/material.dart';
import 'package:mindspace/config/theme.dart';
import 'package:mindspace/core/widgets/app_button.dart';

class StickyNoteEditor extends StatefulWidget {
  const StickyNoteEditor({
    super.key,
    this.initialContent = '',
    required this.onSave,
    this.onDelete,
  });

  final String initialContent;
  final ValueChanged<String> onSave;
  final VoidCallback? onDelete;

  @override
  State<StickyNoteEditor> createState() => _StickyNoteEditorState();
}

class _StickyNoteEditorState extends State<StickyNoteEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialContent.isEmpty ? 'New Note' : 'Edit Note',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (widget.onDelete != null)
                    IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(
                  hintText: 'Type your note...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                onPressed: () {
                  widget.onSave(_controller.text.trim());
                  Navigator.pop(context);
                },
                label: 'Save',
                isExpanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
