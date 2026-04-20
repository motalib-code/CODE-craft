import 'package:flutter/material.dart';
import '../models/company.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({super.key, required this.company, this.onTap});

  final Company company;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: ListTile(
          title: Text(company.name),
          subtitle: Text(company.tier),
        ),
      ),
    );
  }
}
