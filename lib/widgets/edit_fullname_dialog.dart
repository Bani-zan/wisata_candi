
import 'package:material_ui/material_ui.dart';

class EditFullNameDialog extends StatefulWidget {
  final String initialName;

  const EditFullNameDialog({super.key, required this.initialName});

  @override
  State<EditFullNameDialog> createState() => _EditFullNameDialogState();
}

class _EditFullNameDialogState extends State<EditFullNameDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Nama Lengkap'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Nama Lengkap',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(controller.text.trim());
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}