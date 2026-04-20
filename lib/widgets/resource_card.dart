import 'package:flutter/material.dart';

class ResourceCard extends StatelessWidget {
  const ResourceCard({super.key, required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(title), onTap: onTap),
    );
  }
}
