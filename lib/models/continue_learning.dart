class ContinueLearningContent {
  final String title;
  final String category; // DSA, AI, ML
  final String videoId;
  final String channelName;
  final String thumbnail;

  ContinueLearningContent({
    required this.title,
    required this.category,
    required this.videoId,
    required this.channelName,
    required this.thumbnail,
  });

  String get watchUrl => 'https://www.youtube.com/watch?v=$videoId';
}

// DSA Learning Path
final List<ContinueLearningContent> dsaLearningContent = [
  ContinueLearningContent(
    title: 'Complete Data Structures & Algorithms',
    category: 'DSA',
    videoId: '8hly31xrwm0',
    channelName: 'Abdul Bari',
    thumbnail: 'https://img.youtube.com/vi/8hly31xrwm0/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'DSA in One Shot - Complete Tutorial',
    category: 'DSA',
    videoId: 'DIjvZgVCfhI',
    channelName: 'Striver (SDE Sheet)',
    thumbnail: 'https://img.youtube.com/vi/DIjvZgVCfhI/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Data Structures & Algorithms Masterclass',
    category: 'DSA',
    videoId: 'c5MJoGbC6OI',
    channelName: 'take U forward',
    thumbnail: 'https://img.youtube.com/vi/c5MJoGbC6OI/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Binary Trees & Graphs Explained',
    category: 'DSA',
    videoId: 'CjVeJpkCHQc',
    channelName: 'NeetCode',
    thumbnail: 'https://img.youtube.com/vi/CjVeJpkCHQc/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Sorting Algorithms Visualized',
    category: 'DSA',
    videoId: 'kgBjYCQf-3s',
    channelName: 'GeeksforGeeks',
    thumbnail: 'https://img.youtube.com/vi/kgBjYCQf-3s/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Dynamic Programming Complete Guide',
    category: 'DSA',
    videoId: 'JqJsrJIIPoY',
    channelName: 'Errichto',
    thumbnail: 'https://img.youtube.com/vi/JqJsrJIIPoY/hqdefault.jpg',
  ),
];

// AI Learning Path
final List<ContinueLearningContent> aiLearningContent = [
  ContinueLearningContent(
    title: 'Artificial Intelligence Full Course 2024',
    category: 'AI',
    videoId: 'I-ZAo6T0KpE',
    channelName: 'FreeCodeCamp',
    thumbnail: 'https://img.youtube.com/vi/I-ZAo6T0KpE/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Deep Learning Specialization Overview',
    category: 'AI',
    videoId: 'CS4cs9xUjv4',
    channelName: 'Deeplearning.AI',
    thumbnail: 'https://img.youtube.com/vi/CS4cs9xUjv4/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Neural Networks From Scratch',
    category: 'AI',
    videoId: 'aircAruvnKk',
    channelName: 'StatQuest with Josh Starmer',
    thumbnail: 'https://img.youtube.com/vi/aircAruvnKk/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Generative AI & Large Language Models',
    category: 'AI',
    videoId: 'N5cjdPjFp_g',
    channelName: 'Jeremy Howard (fast.ai)',
    thumbnail: 'https://img.youtube.com/vi/N5cjdPjFp_g/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Computer Vision Masterclass',
    category: 'AI',
    videoId: 'dNCUqXGIc5M',
    channelName: 'Paul Mooney',
    thumbnail: 'https://img.youtube.com/vi/dNCUqXGIc5M/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Natural Language Processing Explained',
    category: 'AI',
    videoId: 'CMrHM8ab3os',
    channelName: 'Yannic Kilcher',
    thumbnail: 'https://img.youtube.com/vi/CMrHM8ab3os/hqdefault.jpg',
  ),
];

// ML Learning Path
final List<ContinueLearningContent> mlLearningContent = [
  ContinueLearningContent(
    title: 'Machine Learning Complete Course',
    category: 'ML',
    videoId: '9f6BA4_OKZE',
    channelName: 'Andrew Ng (Coursera)',
    thumbnail: 'https://img.youtube.com/vi/9f6BA4_OKZE/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Scikit-learn & Machine Learning with Python',
    category: 'ML',
    videoId: 'EI12u2QBHty',
    channelName: 'FreeCodeCamp',
    thumbnail: 'https://img.youtube.com/vi/EI12u2QBHty/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Feature Engineering for ML',
    category: 'ML',
    videoId: 'A6vpmPNZqL4',
    channelName: 'Krish Naik',
    thumbnail: 'https://img.youtube.com/vi/A6vpmPNZqL4/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Supervised vs Unsupervised Learning',
    category: 'ML',
    videoId: 'e5FYMwCrlOQ',
    channelName: 'StatQuest',
    thumbnail: 'https://img.youtube.com/vi/e5FYMwCrlOQ/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Time Series Forecasting ML',
    category: 'ML',
    videoId: 'cCOUaWaFWm0',
    channelName: 'Krish Naik',
    thumbnail: 'https://img.youtube.com/vi/cCOUaWaFWm0/hqdefault.jpg',
  ),
  ContinueLearningContent(
    title: 'Reinforcement Learning Basics',
    category: 'ML',
    videoId: 'Mut_u40Sqcc',
    channelName: 'Sentdex',
    thumbnail: 'https://img.youtube.com/vi/Mut_u40Sqcc/hqdefault.jpg',
  ),
];

// Get all learning content mixed
List<ContinueLearningContent> getAllLearningContent() {
  final all = [...dsaLearningContent, ...aiLearningContent, ...mlLearningContent];
  all.shuffle();
  return all.take(6).toList();
}

List<ContinueLearningContent> getLearningByCategory(String category) {
  if (category == 'DSA') return dsaLearningContent;
  if (category == 'AI') return aiLearningContent;
  if (category == 'ML') return mlLearningContent;
  return [];
}
