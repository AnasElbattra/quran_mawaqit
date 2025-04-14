import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AyahActionSheet extends StatelessWidget {
  final String ayahText;

  const AyahActionSheet({super.key, required this.ayahText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        runSpacing: 16,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.copy, color: Colors.white),
            title: const Text('Copy Ayah', style: TextStyle(color: Colors.white)),
            onTap: () {
              Clipboard.setData(ClipboardData(text: ayahText));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ayah copied")),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.white),
            title: const Text('View Tafsir', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Add tafsir logic here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.volume_up, color: Colors.white),
            title: const Text('Play Recitation', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Add audio logic here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
