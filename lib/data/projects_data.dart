import 'package:codecraft/models/project_model.dart';

/// Static projects data for all 5 categories
class ProjectsData {
  static final List<ProjectCategory> projectCategories = [
    // Category 1: Web & Full Stack
    ProjectCategory(
      id: 'web-fullstack',
      name: 'Web & Full Stack',
      title: 'Web & Full Stack',
      repoUrl: 'https://github.com/bradtraversy/50projects50days',
      description:
          '50+ mini web projects using HTML, CSS and JavaScript from the Traversy Media course',
      tags: const ['HTML', 'CSS', 'JavaScript', 'Web Dev'],
      projectCount: 51,
      projects: _webFullStackProjects,
    ),
    // Category 2: AI Agents
    ProjectCategory(
      id: 'ai-agents',
      name: 'AI Agents',
      title: 'AI Agents',
      repoUrl: 'https://github.com/ashishpatel26/500-AI-Agents-Projects',
      description:
          'A curated collection of AI agent use cases across industries including healthcare, finance, education, retail, and more',
      tags: const ['AI', 'Agents', 'LLM', 'Python'],
      projectCount: 21,
      projects: _aiAgentsProjects,
    ),
    // Category 3: Machine Learning & AI
    ProjectCategory(
      id: 'ml-ai',
      name: 'ML & AI',
      title: 'ML & AI',
      repoUrl:
          'https://github.com/ashishpatel26/500-AI-Machine-learning-Deep-learning-Computer-vision-NLP-Projects-with-code',
      description:
          '500+ Artificial Intelligence Project List with code covering Machine Learning, Deep Learning, Computer Vision and NLP',
      tags: const ['Python', 'ML', 'DL', 'NLP', 'CV'],
      projectCount: 103,
      projects: _mlAiProjects,
    ),
    // Category 4: C++ & DSA
    ProjectCategory(
      id: 'cpp-dsa',
      name: 'C++ & DSA',
      title: 'C++ & DSA',
      repoUrl: 'https://github.com/nragland37/cpp-projects',
      description:
          'Comprehensive collection from Hello World to Self-Balancing AVL Trees',
      tags: const ['C++', 'DSA', 'Algorithms', 'OOP'],
      projectCount: 48,
      hasSubcategories: true,
      projects: _cppDsaProjects,
    ),
    // Category 5: Final Year Projects
    ProjectCategory(
      id: 'final-year',
      name: 'Final Year Projects',
      title: 'Final Year Projects',
      repoUrl:
          'https://github.com/Projects-Developer/50-Final-Year-Projects-with-Source-Code',
      description:
          'Final year projects including Source Code, PPT, Synopsis, Report, Documents, Base Research Paper and Video Tutorials',
      tags: const ['Python', 'Blockchain', 'ML', 'Web', 'Security'],
      projectCount: 50,
      projects: _finalYearProjects,
    ),
  ];

  // Web & Full Stack Projects
  static const List<ProjectItem> _webFullStackProjects = [
    ProjectItem(
        number: 1,
        name: 'Expanding Cards',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 2,
        name: 'Progress Steps',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 3,
        name: 'Rotating Navigation Animation',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 4,
        name: 'Hidden Search Widget',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 5,
        name: 'Blurry Loading',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 6,
        name: 'Scroll Animation',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 7,
        name: 'Split Landing Page',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 8,
        name: 'Form Wave',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 9,
        name: 'Sound Board',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 10,
        name: 'Dad Jokes',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 11,
        name: 'Event Keycodes',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 12,
        name: 'Faq Collapse',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 13,
        name: 'Random Choice Picker',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 14,
        name: 'Animated Navigation',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 15,
        name: 'Incrementing Counter',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 16,
        name: 'Drink Water',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 17,
        name: 'Movie App',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 18,
        name: 'Background Slider',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 19,
        name: 'Theme Clock',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 20,
        name: 'Button Ripple Effect',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 21,
        name: 'Drag N Drop',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 22,
        name: 'Drawing App',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 23,
        name: 'Kinetic Loader',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 24,
        name: 'Content Placeholder',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 25,
        name: 'Sticky Navbar',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 26,
        name: 'Double Vertical Slider',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 27,
        name: 'Toast Notification',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 28,
        name: 'Github Profiles',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 29,
        name: 'Double Click Heart',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 30,
        name: 'Auto Text Effect',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 31,
        name: 'Password Generator',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 32,
        name: 'Good Cheap Fast',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 33,
        name: 'Notes App',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 34,
        name: 'Animated Countdown',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 35,
        name: 'Image Carousel',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 36,
        name: 'Hoverboard',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 37,
        name: 'Pokedex',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 38,
        name: 'Mobile Tab Navigation',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 39,
        name: 'Password Strength Background',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 40,
        name: '3D Background Boxes',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 41,
        name: 'Verify Account UI',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 42,
        name: 'Live User Filter',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 43,
        name: 'Feedback UI Design',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 44,
        name: 'Custom Range Slider',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 45,
        name: 'Netflix Mobile Navigation',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 46,
        name: 'Quiz App',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 47,
        name: 'Testimonial Box Switcher',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 48,
        name: 'Random Image Feed',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 49,
        name: 'Todo List',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 50,
        name: 'Insect Catch Game',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
    ProjectItem(
        number: 51,
        name: 'Simple Timer',
        demoUrl: 'https://bradtraversy.com/50projects50days/'),
  ];

  // AI Agents Projects
  static const List<ProjectItem> _aiAgentsProjects = [
    ProjectItem(
        number: 1,
        name: 'HIA Health Insights Agent',
        industry: 'Healthcare',
        description: 'Analyzes medical reports and provides health insights',
        githubUrl: 'https://github.com/harshhh28/hia.git'),
    ProjectItem(
        number: 2,
        name: 'AI Health Assistant',
        industry: 'Healthcare',
        description: 'Diagnoses and monitors diseases using patient data',
        githubUrl:
            'https://github.com/ahmadvh/AI-Agents-for-Medical-Diagnostics.git'),
    ProjectItem(
        number: 3,
        name: 'Automated Trading Bot',
        industry: 'Finance',
        description: 'Automates stock trading with real-time market analysis',
        githubUrl: 'https://github.com/MingyuJ666/Stockagent.git'),
    ProjectItem(
        number: 4,
        name: 'Virtual AI Tutor',
        industry: 'Education',
        description: 'Provides personalized education tailored to users',
        githubUrl: 'https://github.com/hqanhh/EduGPT.git'),
    ProjectItem(
        number: 5,
        name: '24/7 AI Chatbot',
        industry: 'Customer Service',
        description: 'Handles customer queries around the clock',
        githubUrl: 'https://github.com/NirDiamant/GenAI_Agents'),
    ProjectItem(
        number: 6,
        name: 'Product Recommendation Agent',
        industry: 'Retail',
        description: 'Suggests products based on user preferences',
        githubUrl: 'https://github.com/microsoft/RecAI'),
    ProjectItem(
        number: 7,
        name: 'Self-Driving Delivery Agent',
        industry: 'Transportation',
        description: 'Optimizes routes and autonomously delivers packages',
        githubUrl: 'https://github.com/sled-group/driVLMe'),
    ProjectItem(
        number: 8,
        name: 'Factory Process Monitoring',
        industry: 'Manufacturing',
        description: 'Monitors production lines and ensures quality control',
        githubUrl: 'https://github.com/yuchenxia/llm4ias'),
    ProjectItem(
        number: 9,
        name: 'Property Pricing Agent',
        industry: 'Real Estate',
        description: 'Analyzes market trends to determine property prices',
        githubUrl: 'https://github.com/AleksNeStu/ai-real-estate-assistant'),
    ProjectItem(
        number: 10,
        name: 'Smart Farming Assistant',
        industry: 'Agriculture',
        description: 'Provides insights on crop health and yield predictions',
        githubUrl: 'https://github.com/mohammed97ashraf/LLM_Agri_Bot'),
    ProjectItem(
        number: 11,
        name: 'Energy Demand Forecasting',
        industry: 'Energy',
        description: 'Predicts energy usage to optimize grid management',
        githubUrl: 'https://github.com/yecchen/MIRAI'),
    ProjectItem(
        number: 12,
        name: 'Legal Document Assistant',
        industry: 'Legal',
        description: 'Automates document review and highlights key clauses',
        githubUrl: 'https://github.com/firica/legalai'),
    ProjectItem(
        number: 13,
        name: 'AI Game Companion',
        industry: 'Gaming',
        description: 'Enhances player experience with real-time assistance',
        githubUrl: 'https://github.com/onjas-buidl/LLM-agent-game'),
    ProjectItem(
        number: 14,
        name: 'Threat Detection Agent',
        industry: 'Cybersecurity',
        description: 'Identifies potential threats and mitigates attacks',
        githubUrl:
            'https://github.com/NVISOsecurity/cyber-security-llm-agents'),
    ProjectItem(
        number: 15,
        name: 'CrewAI UseCases',
        industry: 'Framework',
        description:
            '22 items including Email Auto Responder, Meeting Assistant',
        githubUrl: 'https://github.com/crewAIInc/crewAI-examples'),
    ProjectItem(
        number: 16,
        name: 'AutoGen UseCases',
        industry: 'Framework',
        description: '30+ items including Code Execution & Nested Chats',
        githubUrl: 'https://microsoft.github.io/autogen/'),
    ProjectItem(
        number: 17,
        name: 'Agno UseCases',
        industry: 'Framework',
        description: '18 items including Support Agent & Finance Agent',
        githubUrl: 'https://github.com/agno-agi/agno'),
    ProjectItem(
        number: 18,
        name: 'LangGraph UseCases',
        industry: 'Framework',
        description: '20+ items including Agentic RAG & Workflows',
        githubUrl: 'https://github.com/langchain-ai/langgraph'),
  ];

  // ML & AI Projects
  static const List<ProjectItem> _mlAiProjects = [
    ProjectItem(
        number: 1,
        name: '365 Days Computer Vision Learning',
        githubUrl:
            'https://github.com/ashishpatel26/365-Days-Computer-Vision-Learning-Linkedin-Post'),
    ProjectItem(
        number: 2,
        name: '125+ NLP Language Models',
        githubUrl: 'https://github.com/ashishpatel26/Treasure-of-Transformers'),
    ProjectItem(
        number: 3,
        name: 'Andrew NG ML notes',
        githubUrl: 'https://github.com/ashishpatel26/Andrew-NG-Notes'),
    ProjectItem(
        number: 4,
        name: '10 ML Projects on Time Series',
        demoUrl:
            'https://medium.com/coders-camp/10-machine-learning-projects-on-time-series-forecasting-ee0368420ccd'),
    ProjectItem(
        number: 5,
        name: '20 Deep Learning Projects',
        demoUrl:
            'https://thecleverprogrammer.com/2020/11/22/deep-learning-projects-with-python/'),
    ProjectItem(
        number: 6,
        name: '20 Machine Learning Projects',
        demoUrl:
            'https://amankharwal.medium.com/20-machine-learning-projects-for-portfolio-81e3dbd167b1'),
    ProjectItem(
        number: 7,
        name: '30 Python Projects',
        demoUrl:
            'https://amankharwal.medium.com/30-python-projects-solved-and-explained-563fd7473003'),
    ProjectItem(
        number: 8,
        name: 'ML Course Free',
        demoUrl:
            'https://thecleverprogrammer.com/2020/09/24/machine-learning-course/'),
    ProjectItem(
        number: 9,
        name: '5 Web Scraping Projects',
        demoUrl:
            'https://amankharwal.medium.com/5-web-scraping-projects-with-python-4bcc25ff039'),
    ProjectItem(
        number: 10,
        name: '20 ML Projects Future Prediction',
        demoUrl:
            'https://amankharwal.medium.com/20-machine-learning-projects-on-future-prediction-with-python-93932d9a7f7f'),
    ProjectItem(
        number: 11,
        name: '4 Chatbot Projects',
        demoUrl:
            'https://amankharwal.medium.com/4-chatbot-projects-with-python-5b32fd84af37'),
    ProjectItem(
        number: 12,
        name: '7 Python GUI Projects',
        demoUrl:
            'https://amankharwal.medium.com/7-python-gui-projects-for-beginners-87ae2c695d78'),
    ProjectItem(
        number: 13,
        name: 'Unsupervised Learning Projects',
        demoUrl:
            'https://amankharwal.medium.com/all-unsupervised-machine-learning-algorithms-explained-aecf1ba95d8b'),
    ProjectItem(
        number: 14,
        name: '10 ML Projects Regression',
        demoUrl:
            'https://amankharwal.medium.com/10-machine-learning-projects-on-regression-with-python-e5494615a0d0'),
    ProjectItem(
        number: 15,
        name: '10 ML Classification Projects',
        demoUrl:
            'https://medium.datadriveninvestor.com/10-machine-learning-projects-on-classification-with-python-9261add2e8a7'),
    ProjectItem(
        number: 16,
        name: '6 Sentiment Analysis Projects',
        demoUrl:
            'https://amankharwal.medium.com/6-sentiment-analysis-projects-with-python-1fdd3d43d90f'),
    ProjectItem(
        number: 17,
        name: '4 Recommendation Systems',
        demoUrl:
            'https://medium.com/coders-camp/4-recommendation-system-projects-with-python-5934de32ba7d'),
    ProjectItem(
        number: 18,
        name: '20 Deep Learning Projects',
        demoUrl:
            'https://medium.com/coders-camp/20-deep-learning-projects-with-python-3c56f7e6a721'),
    ProjectItem(
        number: 19,
        name: '5 COVID19 Projects',
        demoUrl:
            'https://amankharwal.medium.com/5-covid-19-projects-with-python-and-machine-learning-63d51cde96e2'),
    ProjectItem(
        number: 20,
        name: '9 Computer Vision Projects',
        demoUrl:
            'https://becominghuman.ai/computer-vision-projects-with-python-ecfac58ded18'),
    ProjectItem(
        number: 21,
        name: '8 Neural Network Projects',
        demoUrl:
            'https://medium.datadriveninvestor.com/8-neural-networks-projects-solved-and-explained-a4f142bc10c'),
    ProjectItem(
        number: 22,
        name: '5 ML Healthcare Projects',
        demoUrl:
            'https://medium.datadriveninvestor.com/5-machine-learning-projects-for-healthcare-bbd0eac57b4a'),
    ProjectItem(
        number: 23,
        name: '5 NLP Projects',
        demoUrl:
            'https://medium.datadriveninvestor.com/5-nlp-projects-for-machine-learning-72d3234381d4'),
    ProjectItem(
        number: 24,
        name: '47 ML Projects 2021',
        demoUrl:
            'https://data-flair.training/blogs/machine-learning-project-ideas/'),
    ProjectItem(
        number: 25,
        name: '19 AI Projects',
        demoUrl:
            'https://data-flair.training/blogs/artificial-intelligence-project-ideas/'),
  ];

  // C++ & DSA Projects
  static const List<ProjectItem> _cppDsaProjects = [
    ProjectItem(number: 1, name: 'HelloWorld', industry: 'Programming I'),
    ProjectItem(number: 2, name: 'Recipe', industry: 'Programming I'),
    ProjectItem(number: 3, name: 'Ingredients', industry: 'Programming I'),
    ProjectItem(number: 4, name: 'Grade Calculator', industry: 'Programming I'),
    ProjectItem(number: 5, name: 'Shipping Cost', industry: 'Programming I'),
    ProjectItem(number: 6, name: 'Morra Game', industry: 'Programming I'),
    ProjectItem(
        number: 7, name: 'Morra-Series Game', industry: 'Programming I'),
    ProjectItem(number: 8, name: 'Order Pizza', industry: 'Programming I'),
    ProjectItem(number: 9, name: 'Circle', industry: 'Programming I'),
    ProjectItem(
        number: 10,
        name: 'Grade Calculator-Functions',
        industry: 'Programming I'),
    ProjectItem(number: 11, name: 'Echo List', industry: 'Programming I'),
    ProjectItem(number: 12, name: 'Delete Repeats', industry: 'Programming I'),
    ProjectItem(
        number: 13, name: 'Two Dimensional Array', industry: 'Programming II'),
    ProjectItem(
        number: 14,
        name: 'Linear-Search & Bubble-Sort',
        industry: 'Programming II'),
    ProjectItem(
        number: 15,
        name: 'Binary-Search & Selection-Sort',
        industry: 'Programming II'),
    ProjectItem(number: 16, name: 'Pointers', industry: 'Programming II'),
    ProjectItem(
        number: 17,
        name: 'Dynamic Memory Allocation',
        industry: 'Programming II'),
    ProjectItem(
        number: 18, name: 'C-Strings & Strings', industry: 'Programming II'),
    ProjectItem(number: 19, name: 'Structures', industry: 'Programming II'),
    ProjectItem(
        number: 20,
        name: 'File Streams manual-update',
        industry: 'Programming II'),
    ProjectItem(
        number: 21,
        name: 'File Streams auto-update',
        industry: 'Programming II'),
    ProjectItem(
        number: 22, name: 'File Streams binary', industry: 'Programming II'),
    ProjectItem(
        number: 23, name: 'Classes & Header Files', industry: 'Programming II'),
    ProjectItem(
        number: 24, name: 'Default Arguments', industry: 'Data Structures I'),
    ProjectItem(
        number: 25,
        name: 'Function Overloading',
        industry: 'Data Structures I'),
    ProjectItem(
        number: 26, name: 'Class Template', industry: 'Data Structures I'),
    ProjectItem(number: 27, name: 'Array List', industry: 'Data Structures I'),
    ProjectItem(
        number: 28,
        name: 'Array List Continued',
        industry: 'Data Structures I'),
    ProjectItem(number: 29, name: 'Linked List', industry: 'Data Structures I'),
    ProjectItem(number: 30, name: 'Stack', industry: 'Data Structures I'),
    ProjectItem(number: 31, name: 'Queue', industry: 'Data Structures I'),
    ProjectItem(
        number: 32, name: 'RPN Evaluator', industry: 'Data Structures I'),
    ProjectItem(
        number: 33, name: 'Palindrome Stack', industry: 'Data Structures I'),
    ProjectItem(
        number: 34,
        name: 'Palindrome Stack & Queue',
        industry: 'Data Structures I'),
    ProjectItem(
        number: 35,
        name: 'Operator Overloading',
        industry: 'Data Structures I'),
    ProjectItem(
        number: 36, name: 'DLList Continued', industry: 'Data Structures I'),
    ProjectItem(number: 37, name: 'Recursion', industry: 'Data Structures II'),
    ProjectItem(
        number: 38,
        name: 'Linked List Recursion',
        industry: 'Data Structures II'),
    ProjectItem(
        number: 39,
        name: 'Array List Binary Search',
        industry: 'Data Structures II'),
    ProjectItem(number: 40, name: 'Hash Table', industry: 'Data Structures II'),
    ProjectItem(
        number: 41, name: 'Binary Search Tree', industry: 'Data Structures II'),
    ProjectItem(
        number: 42,
        name: 'Max-Heap Priority Queue',
        industry: 'Data Structures II'),
    ProjectItem(
        number: 43,
        name: 'AVL Self-Balancing BST',
        industry: 'Data Structures II'),
    ProjectItem(
        number: 44, name: 'Huffman Tree', industry: 'Data Structures II'),
    ProjectItem(number: 45, name: 'Quick-Sort', industry: 'Data Structures II'),
    ProjectItem(number: 46, name: 'Heap-Sort', industry: 'Data Structures II'),
    ProjectItem(
        number: 47, name: 'Dijkstra Algorithm', industry: 'Data Structures II'),
    ProjectItem(
        number: 48, name: 'Graph Algorithms', industry: 'Data Structures II'),
  ];

  // Final Year Projects
  static const List<ProjectItem> _finalYearProjects = [
    ProjectItem(
        number: 1,
        name: 'Malware Detection Deep Learning',
        youtubeUrl: 'https://youtu.be/f-JRYJWVKKE?si=GuebwSt9chYyjZzT',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 2,
        name: 'Stock Price Prediction ML',
        youtubeUrl: 'https://youtu.be/nh4BOMuaF_I?si=gT0s5Vl2UyOAuze4',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 3,
        name: 'Face Attendance System',
        youtubeUrl: 'https://youtu.be/tLhFaAurhGw?si=gdsdp8JjlgsAFeos',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 4,
        name: 'Crime Prediction ML',
        youtubeUrl: 'https://youtu.be/4rAoiBh2MH0?si=g6aMlqXYhVDuoKJe',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 5,
        name: 'AI Chatbot NLTK',
        youtubeUrl: 'https://youtu.be/tLormT06XS0?si=Y_eH9tRhpcRwJmBz',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 6,
        name: 'Fake News Detection',
        youtubeUrl: 'https://youtu.be/DQRZHOpU9bU?si=561xPypbVjJyHHIK',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 7,
        name: 'Rainfall Prediction',
        youtubeUrl: 'https://youtu.be/RrMOFPkBg5k?si=q-GyKPZq1DMORZZf',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 8,
        name: 'Credit Card Fraud Detection',
        youtubeUrl: 'https://youtu.be/CiEnP4xE0dY?si=hNJ1Y4dUV_FfEuxG',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 9,
        name: 'Disease Prediction',
        youtubeUrl: 'https://youtu.be/czIgZRyhZks?si=NKVaOUVCQN9MEuaG',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 10,
        name: 'Email Spam Detection',
        youtubeUrl: 'https://youtu.be/KmmZ3uxHTb4?si=ByA4na2VtsAqho85',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 11,
        name: 'Plant Disease Detection',
        youtubeUrl: 'https://youtu.be/VPW8OGHTUrk?si=HXHi9baaT6FQmAmo',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 12,
        name: 'Brain Tumor Detection',
        youtubeUrl: 'https://youtu.be/-uzwKfRt6DU?si=Y8rTmLEqtET3X_Y_',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 13,
        name: 'Heart Disease Prediction',
        youtubeUrl: 'https://youtu.be/b0z32XjpMJ4?si=NOT1Swl-xEeFu4QI',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 14,
        name: 'Network Intrusion Detection',
        youtubeUrl: 'https://youtu.be/fUMWwDYPjOk?si=-Iik7eEaKI6M-AmA',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 15,
        name: 'Face Mask Detection',
        youtubeUrl: 'https://youtu.be/7hLboIeBeTk?si=7Jbtdo1AEvMPm-RP',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 16,
        name: 'Lung Cancer Detection',
        youtubeUrl: 'https://youtu.be/FAwpwldzOq8?si=msno4XDeNcDikp-1',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 17,
        name: 'Movies Recommendation System',
        youtubeUrl: 'https://youtu.be/3_0gWNzBiGQ?si=Ey37uVhTXWQlob-n',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 18,
        name: 'Bank Record Blockchain',
        youtubeUrl: 'https://youtu.be/ZH3ySXHGrPE?si=ASf0r2X_k3STxxE1',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 19,
        name: 'Data Duplication Removal',
        youtubeUrl: 'https://youtu.be/_b_7sjDpuC0?si=bhzLt2HZG8rColc-',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 20,
        name: 'CO2 Emission Prediction',
        youtubeUrl: 'https://youtu.be/G05B-uG6PcY?si=fDRaF1MehLi-N4Xm',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 21,
        name: 'Diabetes Prediction',
        youtubeUrl: 'https://youtu.be/39PUAvOknxw?si=TjqKioAZMkmgj-We',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 22,
        name: 'Big Mart Sale Prediction',
        youtubeUrl: 'https://youtu.be/HgQssKEiWzc?si=Qtki40BtqnlUntv1',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 23,
        name: 'Real Estate Price Prediction',
        youtubeUrl: 'https://youtu.be/bsCIo_bg4UY?si=8uyJpZoajWuEL4Pm',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 24,
        name: 'Road Pavement Detection',
        youtubeUrl: 'https://youtu.be/BEUFt6_UjYM?si=_Tl5XsNny2RWlqDS',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 25,
        name: 'Health Record Blockchain',
        youtubeUrl: 'https://youtu.be/akHpUgWmcE8?si=owLnILV8glVX-SqB',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 26,
        name: 'Land Registry Blockchain',
        youtubeUrl: 'https://youtu.be/0x-fnZXXrD0?si=LWjUy3SyISHygOA8',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 27,
        name: 'Forest Fire Prediction',
        youtubeUrl: 'https://youtu.be/paJ9eQp52TA?si=JKE9Udefj3GPj9cc',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 28,
        name: 'Breast Cancer Detection',
        youtubeUrl: 'https://youtu.be/TzkyqZhNCEo?si=G3Vd9kDRyZNe8EBI',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 29,
        name: 'Cricket Score Prediction',
        youtubeUrl: 'https://youtu.be/6hUSAyxymRA?si=BsskAm-kRQsalIgq',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 30,
        name: 'Blockchain Evidence Mgmt',
        youtubeUrl: 'https://youtu.be/h2naWQ2lFa0?si=5UI9sWkxkp9LdpJG',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 31,
        name: 'Full Stack Blockchain Voting',
        youtubeUrl: 'https://youtu.be/ohc-LvRjfVg?si=kA8ywmT_qGLgIz11',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 32,
        name: 'Fake Product QR Blockchain',
        youtubeUrl: 'https://youtu.be/8nVStd41gxE?si=5VKAWbxy91Hqp4r7',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 33,
        name: 'Blockchain Communication',
        youtubeUrl: 'https://youtu.be/Kt8NHdWnvdk?si=6_0F8z_lcSqoEUT3',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 34,
        name: 'E-Health Record Blockchain',
        youtubeUrl: 'https://youtu.be/akHpUgWmcE8?si=23YZ6GgvuDHHvlEw',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 35,
        name: 'Land Registry Tech',
        youtubeUrl: 'https://youtu.be/0x-fnZXXrD0?si=2EXgO3CZtwv577T3',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 36,
        name: 'Blood Bank Blockchain',
        youtubeUrl: 'https://youtu.be/jVJFHrRVMeE?si=9alGZEaYAlOKkmO7',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 37,
        name: 'Bank Record Storage',
        youtubeUrl: 'https://youtu.be/ZH3ySXHGrPE?si=3Cw8_86L34jAdvNy',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 38,
        name: 'Ethereum Explorer',
        youtubeUrl: 'https://youtu.be/buJ4Sg7At1o?si=SPHNwx24nyGiJplg',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 39,
        name: 'Web3.js Blockchain',
        youtubeUrl: 'https://youtu.be/kWK-T4go0qo?si=aJyiEotBwkwVymvu',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 40,
        name: 'Attendance Blockchain',
        youtubeUrl: 'https://youtu.be/wdtI2qsQptc?si=LzTyv-jDydS64Q0a',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 41,
        name: 'Etherium Explorer',
        youtubeUrl: 'https://youtu.be/buJ4Sg7At1o?si=40tzimbqUBz8PK6B',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 42,
        name: 'React Cryptocurrency',
        youtubeUrl: 'https://youtu.be/HbRmkbOoG0A?si=ANoh7P_0l4j46TkR',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 43,
        name: 'Air Pollution AQI',
        youtubeUrl: 'https://youtu.be/QGF0D7d53i4?si=VUc_BCqRg3BYXVHY',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 44,
        name: 'Fashion Ecommerce',
        youtubeUrl: 'https://youtu.be/TRLH8fG-uyU?si=uTIwULIG4uMDSZaR',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 45,
        name: 'URL Phishing Detection',
        youtubeUrl: 'https://youtu.be/nDxP_lJmVk4?si=0ttLR4zsoJani-ay',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 46,
        name: 'Super Cipher Project',
        youtubeUrl: 'https://youtu.be/mbGBaiqdKnw?si=pKSMqqXdeOdYDH-Q',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 47,
        name: 'Cryptography Communication',
        youtubeUrl: 'https://youtu.be/DcmO-Xe7GVk?si=kQpKfx0JYrZLCIUa',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 48,
        name: 'Steganography Full Stack',
        youtubeUrl: 'https://youtu.be/wVDSMBJMG0Q?si=bHHHdWONtsFTyLY6',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 49,
        name: 'Triple DES Project',
        youtubeUrl: 'https://youtu.be/Z8qna_22WTU?si=8e5hsoFYNdM_xUha',
        description: 'Includes PPT, Code, Video, Documents'),
    ProjectItem(
        number: 50,
        name: 'AES Communication Security',
        youtubeUrl: 'https://youtu.be/KAmrEceJllM?si=YCyvT6C5WOvJp01m',
        description: 'Includes PPT, Code, Video, Documents'),
  ];
}
