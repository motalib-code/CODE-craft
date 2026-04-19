import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../models/company_research_model.dart';
import '../../../core/services/groq_service.dart';
import 'package:animate_do/animate_do.dart';

class CompanyResearchScreen extends ConsumerStatefulWidget {
  const CompanyResearchScreen({super.key});

  @override
  ConsumerState<CompanyResearchScreen> createState() => _CompanyResearchScreenState();
}

class _CompanyResearchScreenState extends ConsumerState<CompanyResearchScreen> {
  final _companyController = TextEditingController();
  final _groqService = GroqService();
  bool _isLoading = false;
  CompanyResearchResult? _result;
  String? _error;

  final List<UserInterest> interests = [
    UserInterest(id: 'ai', name: 'AI & Machine Learning', icon: Icons.smart_toy),
    UserInterest(id: 'cloud', name: 'Cloud Computing', icon: Icons.cloud),
    UserInterest(id: 'mobile', name: 'Mobile Development', icon: Icons.phone_iphone),
    UserInterest(id: 'web', name: 'Web Development', icon: Icons.language),
    UserInterest(id: 'security', name: 'Cybersecurity', icon: Icons.security),
    UserInterest(id: 'data', name: 'Data Analytics', icon: Icons.analytics),
    UserInterest(id: 'blockchain', name: 'Blockchain', icon: Icons.link),
    UserInterest(id: 'iot', name: 'IoT', icon: Icons.devices),
  ];

  final List<JobRole> jobRoles = [
    JobRole(id: 'intern', name: 'Intern', description: 'Entry-level internship'),
    JobRole(id: 'junior', name: 'Junior Developer', description: '0-2 years experience'),
    JobRole(id: 'mid', name: 'Mid-level Developer', description: '2-5 years experience'),
    JobRole(id: 'senior', name: 'Senior Developer', description: '5+ years experience'),
    JobRole(id: 'lead', name: 'Tech Lead', description: 'Leadership role'),
    JobRole(id: 'manager', name: 'Engineering Manager', description: 'Management role'),
    JobRole(id: 'architect', name: 'Solutions Architect', description: 'Architecture role'),
  ];

  Set<String> selectedInterests = {};
  Set<String> selectedRoles = {};

  @override
  void dispose() {
    _companyController.dispose();
    _groqService.dispose();
    super.dispose();
  }

  Future<void> _researchCompany() async {
    if (_companyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a company name')),
      );
      return;
    }

    if (selectedInterests.isEmpty || selectedRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one interest and job role')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final response = await _groqService.researchCompany(
        companyName: _companyController.text,
        interests: selectedInterests.toList(),
        jobRoles: selectedRoles.toList(),
      );

      // Parse JSON response
      final jsonData = jsonDecode(response);
      final result = CompanyResearchResult.fromJson(jsonData);

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Research failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.purple.withOpacity(0.3), AppColors.blue.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(
                    child: Text(
                      '🔍 Company Research',
                      style: AppTextStyles.display.copyWith(fontSize: 28),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Verify if a company is real, legitimate, and fit for your career',
                    style: AppTextStyles.body.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Name Input
                  FadeInUp(
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Company Name', style: AppTextStyles.h3),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _companyController,
                            style: AppTextStyles.body,
                            decoration: InputDecoration(
                              hintText: 'Enter company name (e.g., Google, Meta, Startup XYZ)',
                              hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
                              prefixIcon: const Icon(Icons.business, color: AppColors.blue),
                              filled: true,
                              fillColor: AppColors.bgInput,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Interests Selection
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Your Interests', style: AppTextStyles.h3),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: interests.map((interest) {
                            final isSelected = selectedInterests.contains(interest.id);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedInterests.remove(interest.id);
                                  } else {
                                    selectedInterests.add(interest.id);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.blue : AppColors.bgInput,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? AppColors.blue : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      interest.icon,
                                      size: 16,
                                      color: isSelected ? Colors.white : AppColors.textHint,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      interest.name,
                                      style: AppTextStyles.small.copyWith(
                                        color: isSelected ? Colors.white : AppColors.textHint,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Job Roles Selection
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select Job Roles', style: AppTextStyles.h3),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: jobRoles.map((role) {
                            final isSelected = selectedRoles.contains(role.id);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedRoles.remove(role.id);
                                  } else {
                                    selectedRoles.add(role.id);
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.mint : AppColors.bgInput,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? AppColors.mint : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  role.name,
                                  style: AppTextStyles.small.copyWith(
                                    color: isSelected ? Colors.black : AppColors.textHint,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Research Button
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        label: _isLoading ? 'Researching...' : 'Start Research',
                        loading: _isLoading,
                        onTap: _isLoading ? null : _researchCompany,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Results Display
                  if (_result != null) ...[
                    FadeInUp(
                      child: _ResultCard(result: _result!),
                    ),
                  ],

                  if (_error != null)
                    FadeInUp(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Text(
                          _error!,
                          style: AppTextStyles.body.copyWith(color: Colors.red),
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final CompanyResearchResult result;

  const _ResultCard({required this.result});

  Color _getLegitimacyColor() {
    if (result.legitimacyScore > 0.7) return Colors.green;
    if (result.legitimacyScore > 0.4) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Verdict Card
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(result.companyName, style: AppTextStyles.h2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: result.isLegitimate ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: result.isLegitimate ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Text(
                      result.isLegitimate ? '✓ Legitimate' : '⚠ Questionable',
                      style: AppTextStyles.small.copyWith(
                        color: result.isLegitimate ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Verdict',
                style: AppTextStyles.h3.copyWith(color: AppColors.textHint),
              ),
              const SizedBox(height: 8),
              Text(
                result.verdict,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 16),
              Text(
                'Legitimacy Score: ${(result.legitimacyScore * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: result.legitimacyScore,
                  minHeight: 8,
                  backgroundColor: AppColors.bgInput,
                  valueColor: AlwaysStoppedAnimation(_getLegitimacyColor()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Company Info Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _InfoBox(label: 'Industry', value: result.industry),
            _InfoBox(label: 'Founded', value: result.founded),
            _InfoBox(label: 'Headquarters', value: result.headquarters),
            _InfoBox(label: 'Employees', value: result.employees),
          ],
        ),
        const SizedBox(height: 16),

        // Description
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('About', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text(result.description, style: AppTextStyles.body),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Products
        if (result.products.isNotEmpty)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Main Products', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: result.products.map((p) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(p, style: AppTextStyles.small),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),

        // Job Roles
        if (result.jobRoles.isNotEmpty)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available Job Roles', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: result.jobRoles.map((role) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.mint.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(role, style: AppTextStyles.small),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),

        // Detailed Analysis
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detailed Analysis', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text(result.detailedAnalysis, style: AppTextStyles.body),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Opportunities
        if (result.opportunities.isNotEmpty)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('Opportunities', style: AppTextStyles.h3),
                  ],
                ),
                const SizedBox(height: 12),
                ...result.opportunities.map((opp) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Text('✓ ', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(opp, style: AppTextStyles.body),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        const SizedBox(height: 16),

        // Risks
        if (result.risks.isNotEmpty)
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text('Risks & Concerns', style: AppTextStyles.h3),
                  ],
                ),
                const SizedBox(height: 12),
                ...result.risks.map((risk) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Text('⚠ ', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(risk, style: AppTextStyles.body),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.small.copyWith(color: AppColors.textHint)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.h3),
        ],
      ),
    );
  }
}
