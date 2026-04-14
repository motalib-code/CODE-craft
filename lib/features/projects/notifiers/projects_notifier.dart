import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/project_model.dart';

final projectsProvider = Provider<List<ProjectModel>>((ref) {
  return [
    // 1-10: Flutter Projects
    ProjectModel(id: '1', title: 'Flutter Official Samples', description: 'Official collection of Flutter example apps and demos', owner: 'flutter', repoName: 'samples', readmeUrl: 'https://raw.githubusercontent.com/flutter/samples/main/README.md', tags: ['Flutter', 'Official'], sector: 'Flutter'),
    ProjectModel(id: '2', title: 'Awesome Flutter', description: 'Curated best Flutter libraries, tools, tutorials and articles', owner: 'solido', repoName: 'awesome-flutter', readmeUrl: 'https://raw.githubusercontent.com/solido/awesome-flutter/master/README.md', tags: ['Flutter', 'Resources'], sector: 'Flutter'),
    ProjectModel(id: '3', title: 'Best Flutter UI Templates', description: 'Beautiful ready-to-use Flutter UI kits', owner: 'mitesh77', repoName: 'Best-Flutter-UI-Templates', readmeUrl: 'https://raw.githubusercontent.com/mitesh77/Best-Flutter-UI-Templates/master/README.md', tags: ['Flutter', 'UI'], sector: 'Flutter'),
    ProjectModel(id: '4', title: 'Flutter UI Kit by Pawan', description: 'Collection of beautiful Flutter UI components', owner: 'iampawan', repoName: 'Flutter-UI-Kit', readmeUrl: 'https://raw.githubusercontent.com/iampawan/Flutter-UI-Kit/master/README.md', tags: ['Flutter', 'UI'], sector: 'Flutter'),
    ProjectModel(id: '5', title: 'Awesome Open Source Flutter Apps', description: '750+ curated open source Flutter apps', owner: 'fluttergems', repoName: 'awesome-open-source-flutter-apps', readmeUrl: 'https://raw.githubusercontent.com/fluttergems/awesome-open-source-flutter-apps/main/README.md', tags: ['Flutter', 'Apps'], sector: 'Flutter'),
    ProjectModel(id: '6', title: 'Flutter Examples', description: 'Basic to advanced Flutter example projects', owner: 'nisrulz', repoName: 'flutter-examples', readmeUrl: 'https://raw.githubusercontent.com/nisrulz/flutter-examples/master/README.md', tags: ['Flutter'], sector: 'Flutter'),
    ProjectModel(id: '7', title: 'Flutter Screens', description: 'Collection of beautiful login and UI screens', owner: 'samarthagarwal', repoName: 'FlutterScreens', readmeUrl: 'https://raw.githubusercontent.com/samarthagarwal/FlutterScreens/master/README.md', tags: ['Flutter', 'UI'], sector: 'Flutter'),
    ProjectModel(id: '8', title: 'TimeCop - Productivity App', description: 'Time tracking app with localization', owner: 'hamaluik', repoName: 'timecop', readmeUrl: 'https://raw.githubusercontent.com/hamaluik/timecop/master/README.md', tags: ['Flutter', 'App'], sector: 'Flutter'),
    ProjectModel(id: '9', title: 'MMAS Money Tracker', description: 'Multi-currency expense tracker', owner: 'floranguyen0', repoName: 'mmas-money-tracker', readmeUrl: 'https://raw.githubusercontent.com/floranguyen0/mmas-money-tracker/main/README.md', tags: ['Flutter', 'Finance'], sector: 'Flutter'),
    ProjectModel(id: '10', title: 'Flutter E-commerce App', description: 'Full featured e-commerce Flutter app', owner: 'TheAlphamerc', repoName: 'flutter_ecommerce_app', readmeUrl: 'https://raw.githubusercontent.com/TheAlphamerc/flutter_ecommerce_app/master/README.md', tags: ['Flutter', 'E-commerce'], sector: 'Flutter'),

    // 11-20: SIH (Smart India Hackathon) Projects
    ProjectModel(id: '11', title: 'KnitKraft - SIH 2023 Winner', description: 'Wool from Farm to Fabric traceability system', owner: 'uzibytes', repoName: 'KnitKraft', readmeUrl: 'https://raw.githubusercontent.com/uzibytes/KnitKraft/main/README.md', tags: ['SIH', 'Winner'], sector: 'SIH'),
    ProjectModel(id: '12', title: 'SIH 2025 Water Management', description: 'Smart water monitoring and management', owner: 'Mausam5055', repoName: 'SIH-2025', readmeUrl: 'https://raw.githubusercontent.com/Mausam5055/SIH-2025/main/README.md', tags: ['SIH'], sector: 'SIH'),
    ProjectModel(id: '13', title: 'Smart Agriculture SIH', description: 'Crop monitoring and advisory platform', owner: 'SahilAli8808', repoName: 'Smart-India-Hackthon-2022', readmeUrl: 'https://raw.githubusercontent.com/SahilAli8808/Smart-India-Hackthon-2022/main/README.md', tags: ['SIH'], sector: 'SIH'),
    ProjectModel(id: '14', title: 'E-Waste Management System', description: 'Smart e-waste collection and recycling', owner: 'codewithsadee', repoName: 'e-waste-management', readmeUrl: 'https://raw.githubusercontent.com/codewithsadee/e-waste-management/main/README.md', tags: ['SIH'], sector: 'SIH'),
    ProjectModel(id: '15', title: 'Swachh Nagar - SIH 2025', description: 'Crowdsourced civic issue reporting app', owner: 'sbera01', repoName: 'swachh-nagar-app---SIH-2025', readmeUrl: 'https://raw.githubusercontent.com/sbera01/swachh-nagar-app---SIH-2025/main/README.md', tags: ['SIH'], sector: 'SIH'),
    ProjectModel(id: '16', title: 'CodeResQ - Public Transport SIH', description: 'Real-time public transport tracking', owner: 'DevStorm9833', repoName: 'CodeResQ_SIH-25', readmeUrl: 'https://raw.githubusercontent.com/DevStorm9833/CodeResQ_SIH-25/main/README.md', tags: ['SIH'], sector: 'SIH'),

    // 21-30: ROS (Robot Operating System) Projects
    ProjectModel(id: '21', title: 'Linorobot - ROS Robot', description: 'Low cost autonomous ROS mobile robot', owner: 'linorobot', repoName: 'linorobot', readmeUrl: 'https://raw.githubusercontent.com/linorobot/linorobot/master/README.md', tags: ['ROS'], sector: 'ROS'),
    ProjectModel(id: '22', title: 'Linorobot2 - ROS2', description: 'ROS2 version of low-cost autonomous robot', owner: 'linorobot', repoName: 'linorobot2', readmeUrl: 'https://raw.githubusercontent.com/linorobot/linorobot2/main/README.md', tags: ['ROS'], sector: 'ROS'),
    ProjectModel(id: '23', title: 'ROS Navigation Stack', description: 'Official ROS2 navigation examples', owner: 'ros-planning', repoName: 'navigation', readmeUrl: 'https://raw.githubusercontent.com/ros-planning/navigation/main/README.md', tags: ['ROS'], sector: 'ROS'),
    ProjectModel(id: '24', title: 'ROS Tutorials', description: 'Comprehensive ROS1 & ROS2 tutorials', owner: 'methylDragon', repoName: 'ros-tutorials', readmeUrl: 'https://raw.githubusercontent.com/methylDragon/ros-tutorials/master/README.md', tags: ['ROS'], sector: 'ROS'),
    ProjectModel(id: '25', title: 'ROS for Beginners', description: 'ROS basics, motion and OpenCV', owner: 'cybergeekgyan', repoName: 'ROS-for-Beginners-', readmeUrl: 'https://raw.githubusercontent.com/cybergeekgyan/ROS-for-Beginners-/main/README.md', tags: ['ROS'], sector: 'ROS'),

    // 31-50: General Hackathon, DSA, AI & Other Useful Projects
    ProjectModel(id: '31', title: 'The Algorithms - Python', description: 'All classic algorithms and data structures', owner: 'TheAlgorithms', repoName: 'Python', readmeUrl: 'https://raw.githubusercontent.com/TheAlgorithms/Python/master/README.md', tags: ['DSA', 'Algorithms'], sector: 'General'),
    ProjectModel(id: '32', title: 'OpenAI Cookbook', description: 'Examples and guides for OpenAI API', owner: 'openai', repoName: 'openai-cookbook', readmeUrl: 'https://raw.githubusercontent.com/openai/openai-cookbook/main/README.md', tags: ['AI', 'OpenAI'], sector: 'General'),
    ProjectModel(id: '33', title: 'Awesome Self Hosted', description: 'List of self-hosted alternatives to popular services', owner: 'awesome-selfhosted', repoName: 'awesome-selfhosted', readmeUrl: 'https://raw.githubusercontent.com/awesome-selfhosted/awesome-selfhosted/master/README.md', tags: ['Tools'], sector: 'General'),
    ProjectModel(id: '34', title: 'FlutterFire', description: 'Official Firebase plugins for Flutter', owner: 'firebase', repoName: 'flutterfire', readmeUrl: 'https://raw.githubusercontent.com/firebase/flutterfire/main/README.md', tags: ['Flutter', 'Firebase'], sector: 'Flutter'),
    ProjectModel(id: '35', title: 'Bloc State Management', description: 'Popular predictable state management library', owner: 'felangel', repoName: 'bloc', readmeUrl: 'https://raw.githubusercontent.com/felangel/bloc/master/README.md', tags: ['Flutter', 'State'], sector: 'Flutter'),
    ProjectModel(id: '36', title: 'Awesome ROS Snap', description: 'Curated ROS snap resources', owner: 'Guillaumebeuzeboc', repoName: 'awesome-ROS-snap', readmeUrl: 'https://raw.githubusercontent.com/Guillaumebeuzeboc/awesome-ROS-snap/master/README.md', tags: ['ROS'], sector: 'ROS'),
    ProjectModel(id: '37', title: 'Invoice Ninja', description: 'Open source invoicing app', owner: 'invoiceninja', repoName: 'invoiceninja', readmeUrl: 'https://raw.githubusercontent.com/invoiceninja/invoiceninja/master/README.md', tags: ['Flutter', 'App'], sector: 'Flutter'),
    ProjectModel(id: '38', title: 'BlackHole Music Player', description: 'Beautiful music streaming app', owner: 'Sangwan5688', repoName: 'BlackHole', readmeUrl: 'https://raw.githubusercontent.com/Sangwan5688/BlackHole/main/README.md', tags: ['Flutter', 'Music'], sector: 'Flutter'),
    ProjectModel(id: '39', title: 'Tamper Detection SIH', description: 'ESP32 based tamper detection system', owner: 'medhabalaji', repoName: 'Tamper-Detection', readmeUrl: 'https://raw.githubusercontent.com/medhabalaji/Tamper-Detection/main/README.md', tags: ['SIH', 'IoT'], sector: 'SIH'),
    ProjectModel(id: '40', title: 'KisanSeva - Farmer App', description: 'Farmer assistance platform', owner: 'droidbaker', repoName: 'KisanSeva2', readmeUrl: 'https://raw.githubusercontent.com/droidbaker/KisanSeva2/main/README.md', tags: ['SIH'], sector: 'SIH'),

    // 41-50: Extra Quality Projects
    ProjectModel(id: '41', title: 'Flutter Example Apps by Pawan', description: 'Many real-world Flutter example apps', owner: 'iampawan', repoName: 'FlutterExampleApps', readmeUrl: 'https://raw.githubusercontent.com/iampawan/FlutterExampleApps/master/README.md', tags: ['Flutter'], sector: 'Flutter'),
    ProjectModel(id: '42', title: 'ROS2 Examples', description: 'Official ROS2 example packages', owner: 'ros2', repoName: 'examples', readmeUrl: 'https://raw.githubusercontent.com/ros2/examples/main/README.md', tags: ['ROS'], sector: 'ROS'),
    ProjectModel(id: '43', title: 'Awesome Flutter Packages', description: 'Curated list of Flutter packages', owner: 'Hamed233', repoName: 'Awesome-Flutter-Packages', readmeUrl: 'https://raw.githubusercontent.com/Hamed233/Awesome-Flutter-Packages/main/README.md', tags: ['Flutter'], sector: 'Flutter'),
    ProjectModel(id: '44', title: 'Smart Tourist Safety SIH', description: 'AI based tourist safety monitoring', owner: 'some-sih-repo', repoName: 'tourist-safety-sih', readmeUrl: 'https://raw.githubusercontent.com/some-sih-repo/tourist-safety-sih/main/README.md', tags: ['SIH', 'AI'], sector: 'SIH'), // Note: Replace with actual if found
    ProjectModel(id: '45', title: 'The Algorithms - C++', description: 'Algorithms in C++', owner: 'TheAlgorithms', repoName: 'C-Plus-Plus', readmeUrl: 'https://raw.githubusercontent.com/TheAlgorithms/C-Plus-Plus/master/README.md', tags: ['DSA'], sector: 'General'),
    ProjectModel(id: '46', title: 'Flutter Animate', description: 'Advanced animation examples', owner: 'flutter', repoName: 'animate', readmeUrl: 'https://raw.githubusercontent.com/flutter/animate/main/README.md', tags: ['Flutter'], sector: 'Flutter'),
    ProjectModel(id: '47', title: 'ROS2 Documentation', description: 'Official ROS2 documentation', owner: 'ros2', repoName: 'ros2_documentation', readmeUrl: 'https://raw.githubusercontent.com/ros2/ros2_documentation/main/README.md', tags: ['ROS'], sector: 'ROS'),
    ProjectModel(id: '48', title: 'Deepfake Detection SIH', description: 'AI based deepfake detection', owner: 'Deus-Ex-Machina', repoName: 'deepfake-detection-sih', readmeUrl: 'https://raw.githubusercontent.com/Deus-Ex-Machina/deepfake-detection-sih/main/README.md', tags: ['SIH', 'AI'], sector: 'SIH'),
    ProjectModel(id: '49', title: 'Awesome GitHub Topics', description: 'Curated awesome lists', owner: 'sindresorhus', repoName: 'awesome', readmeUrl: 'https://raw.githubusercontent.com/sindresorhus/awesome/main/README.md', tags: ['Resources'], sector: 'General'),
    ProjectModel(id: '50', title: 'CodeCraft Student Projects', description: 'Template for hackathon & student projects', owner: 'yourusername', repoName: 'codecraft-projects', readmeUrl: 'https://raw.githubusercontent.com/yourusername/codecraft-projects/main/README.md', tags: ['Hackathon'], sector: 'General'),
  ];
});

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggleFavorite(String projectId) {
    if (state.contains(projectId)) {
      state = {...state}..remove(projectId);
    } else {
      state = {...state}..add(projectId);
    }
  }
}

final projectSectorProvider = StateProvider<String>((ref) => 'All');
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProjectsProvider = Provider<List<ProjectModel>>((ref) {
  final all = ref.watch(projectsProvider);
  final sector = ref.watch(projectSectorProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final favorites = ref.watch(favoritesProvider);

  return all.where((p) {
    final matchesSector = sector == 'All' || 
                         (sector == 'Favorites' ? favorites.contains(p.id) : p.sector == sector);
    final matchesSearch = query.isEmpty ||
        p.title.toLowerCase().contains(query) ||
        p.description.toLowerCase().contains(query) ||
        p.tags.any((tag) => tag.toLowerCase().contains(query));
    return matchesSector && matchesSearch;
  }).toList();
});
