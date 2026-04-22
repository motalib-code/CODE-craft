class Job {
  final String id, title, company, location;
  final String salary, url, logo, postedAt, source, description;
  final List<String> tags;
  final bool isRemote;
  bool isSaved;
  bool isApplied;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.url,
    required this.logo,
    required this.postedAt,
    required this.source,
    required this.description,
    required this.tags,
    required this.isRemote,
    this.isSaved = false,
    this.isApplied = false,
  });

  String get timeAgo {
    try {
      DateTime dt;
      if (postedAt.contains('T')) {
        dt = DateTime.parse(postedAt);
      } else {
        dt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(postedAt) ?? 0);
      }
      final diff = DateTime.now().difference(dt);
      if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      return 'Just now';
    } catch (e) {
      return 'Recent';
    }
  }

  bool get isNew {
    try {
      DateTime dt;
      if (postedAt.contains('T')) {
        dt = DateTime.parse(postedAt);
      } else {
        dt = DateTime.fromMillisecondsSinceEpoch(int.tryParse(postedAt) ?? 0);
      }
      return DateTime.now().difference(dt).inDays <= 1;
    } catch (e) {
      return false;
    }
  }
}
