import 'package:flutter/material.dart';

class CompanyResearchResult {
  final String companyName;
  final String industry;
  final String founded;
  final String headquarters;
  final String employees;
  final String description;
  final bool isVerified;
  final bool isLegitimate;
  final List<String> products;
  final List<String> jobRoles;
  final String verdict;
  final String detailedAnalysis;
  final List<String> risks;
  final List<String> opportunities;
  final double legitimacyScore;

  CompanyResearchResult({
    required this.companyName,
    required this.industry,
    required this.founded,
    required this.headquarters,
    required this.employees,
    required this.description,
    required this.isVerified,
    required this.isLegitimate,
    required this.products,
    required this.jobRoles,
    required this.verdict,
    required this.detailedAnalysis,
    required this.risks,
    required this.opportunities,
    required this.legitimacyScore,
  });

  factory CompanyResearchResult.fromJson(Map<String, dynamic> json) {
    return CompanyResearchResult(
      companyName: json['companyName'] ?? 'Unknown',
      industry: json['industry'] ?? 'N/A',
      founded: json['founded'] ?? 'N/A',
      headquarters: json['headquarters'] ?? 'N/A',
      employees: json['employees'] ?? 'N/A',
      description: json['description'] ?? 'No description available',
      isVerified: json['isVerified'] ?? false,
      isLegitimate: json['isLegitimate'] ?? false,
      products: List<String>.from(json['products'] ?? []),
      jobRoles: List<String>.from(json['jobRoles'] ?? []),
      verdict: json['verdict'] ?? 'Unable to determine',
      detailedAnalysis: json['detailedAnalysis'] ?? '',
      risks: List<String>.from(json['risks'] ?? []),
      opportunities: List<String>.from(json['opportunities'] ?? []),
      legitimacyScore: (json['legitimacyScore'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'companyName': companyName,
    'industry': industry,
    'founded': founded,
    'headquarters': headquarters,
    'employees': employees,
    'description': description,
    'isVerified': isVerified,
    'isLegitimate': isLegitimate,
    'products': products,
    'jobRoles': jobRoles,
    'verdict': verdict,
    'detailedAnalysis': detailedAnalysis,
    'risks': risks,
    'opportunities': opportunities,
    'legitimacyScore': legitimacyScore,
  };
}

class UserInterest {
  final String id;
  final String name;
  final IconData icon;

  UserInterest({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class JobRole {
  final String id;
  final String name;
  final String? description;

  JobRole({
    required this.id,
    required this.name,
    this.description,
  });
}
