class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type;
  final String salary;
  final List<String> skills;
  final String applyUrl;
  final DateTime? postedAt;
  final String? logoUrl;

  const JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    this.type = 'Full-time',
    this.salary = 'Not disclosed',
    this.skills = const [],
    this.applyUrl = '',
    this.postedAt,
    this.logoUrl,
  });

  factory JobModel.fromMap(Map<String, dynamic> map) => JobModel(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        company: map['company'] ?? '',
        location: map['location'] ?? '',
        type: map['type'] ?? 'Full-time',
        salary: map['salary'] ?? 'Not disclosed',
        skills: List<String>.from(map['skills'] ?? []),
        applyUrl: map['applyUrl'] ?? '',
        postedAt: map['postedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['postedAt'])
            : DateTime.now(),
        logoUrl: map['logoUrl'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'company': company,
        'location': location,
        'type': type,
        'salary': salary,
        'skills': skills,
        'applyUrl': applyUrl,
        'postedAt': postedAt?.millisecondsSinceEpoch,
        'logoUrl': logoUrl,
      };

  static List<JobModel> get sampleJobs => [
        const JobModel(
          id: '1',
          title: 'Flutter Developer Intern',
          company: 'PhonePe',
          location: 'Bangalore',
          type: 'Internship',
          salary: '₹25k/month',
          skills: ['Flutter', 'Dart', 'Firebase'],
        ),
        const JobModel(
          id: '2',
          title: 'SDE-1 (Backend)',
          company: 'Flipkart',
          location: 'Bangalore',
          type: 'Full-time',
          salary: '₹18-22 LPA',
          skills: ['Java', 'Spring Boot', 'MySQL'],
        ),
        const JobModel(
          id: '3',
          title: 'Frontend Developer',
          company: 'Razorpay',
          location: 'Remote',
          type: 'Full-time',
          salary: '₹12-16 LPA',
          skills: ['React', 'JavaScript', 'CSS'],
        ),
        const JobModel(
          id: '4',
          title: 'ML Engineer Intern',
          company: 'Google',
          location: 'Hyderabad',
          type: 'Internship',
          salary: '₹80k/month',
          skills: ['Python', 'TensorFlow', 'ML'],
        ),
      ];
}
