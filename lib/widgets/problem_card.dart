import 'package:flutter/material.dart';
import '../models/lc_problem.dart';

class ProblemCard extends StatelessWidget {
  const ProblemCard({super.key, required this.problem, this.onTap});

  final LCProblem problem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(problem.title),
      subtitle: Text('${problem.difficulty} • ${problem.pattern}'),
      trailing: Text('#${problem.id}'),
    );
  }
}
