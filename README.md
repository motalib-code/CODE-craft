# CodeCraft 🚀

**AI-powered coding platform for Indian students**

A complete, production-ready Flutter app that runs on Android phones and all major web browsers (Chrome, Edge, Firefox).

---

## ✨ Features

### 📚 Learning Paths
- **Structured Roadmap**: Visual DSA learning roadmap with progress tracking
- **1000+ Problems**: Easy/Medium/Hard problems across all topics
- **YouTube Integration**: Curated video tutorials for each topic and problem
- **Syllabus Parser**: Upload college syllabus → Auto-generated learning plan

### 💻 Code Practice  
- **Live Code Editor**: Write code with syntax highlighting
- **Judge0 Execution**: Run code and see real-time output
- **Multiple Languages**: Java, Python, C++, JavaScript, Dart, C
- **Test Cases**: Auto-run against hidden + visible test cases
- **AI Debugging**: When solution fails → Get AI explanation of the bug

### 🤖 AI Mentor
- **Chat Interface**: WhatsApp-style conversation with AI tutor
- **Concept Breakdown**: Ask hard questions → Get step-by-step hints
- **Code Review**: Share code → Get improvement suggestions
- **Camera Scanner**: Snap picture of code → Extract + Analyze

### 🎮 Gamification
- **Streak Tracking**: 7-day activity calendar with rewards
- **Coin System**: Earn coins per problem solved → Redeem in swag store
- **Badges**: Unlock achievements (Elite Coder, Speedrunner, etc)
- **Leaderboard**: Compete globally / by city / by college
- **Swag Store**: Redeem coins for digital badges & certificates

### 🎤 Mock Interviews
- **AI Interviewer**: HR / Technical / System Design rounds
- **Real Interview Questions**: From actual companies (Google, Microsoft, etc)
- **Performance Analysis**: Get score + feedback after interview
- **Company Specific**: Practice for your target companies

### 📊 Profile & Analytics
- **Activity Heatmap**: GitHub-style contribution calendar
- **Stats Dashboard**: Problems solved, accuracy, ranking
- **Resume Generator**: Auto-generated resume from profile
- **Progress Tracking**: Visual charts showing skill improvement

---

## 🏗️ Tech Stack

- **Flutter 3.x** - Cross-platform UI
- **Dart 3.2+** - Programming language
- **Riverpod** - State management
- **Firebase** - Backend (Auth, Firestore, Storage)
- **Gemini API** - AI Mentor & Debugging
- **Judge0** - Code Execution
- **GoRouter** - Navigation
- **Hive** - Local caching

---

## 🎨 Design System

### Colors
```
Primary:     #7C3AED (Purple)
Secondary:   #2563EB (Blue)
Success:     #10B981 (Green)
Accent:      #EC4899 (Pink)
Background:  #0D0B1F (Dark)
```

### Components
- GlassCard (Material design cards)
- GradientButton (Animated buttons)
- CustomBottomNav (5-tab navigation)
- LoadingShimmer (Skeleton screens)

---

## 📱 Platform Support

| Platform | Status | Min Requirements |
|----------|--------|------------------|
| Android | ✅ Full | API 21+ |
| Chrome | ✅ Full | Latest |
| Edge | ✅ Full | Latest |
| Firefox | ✅ Full | Latest |

---

## 🔑 API Keys (Setup Required)

```
Gemini:   YOUR_GEMINI_API_KEY
Groq:     YOUR_GROQ_API_KEY
Cohere:   YOUR_COHERE_API_KEY
YouTube:  YOUR_YOUTUBE_API_KEY
```

**Only Firebase needs setup** (see SETUP.md)

---

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get
flutter pub run build_runner build

# Setup Firebase
flutterfire configure

# Run on Android
flutter run

# Run on web
flutter run -d chrome
```

See **[SETUP.md](./SETUP.md)** for detailed setup instructions including:
- ✅ Firebase configuration
- ✅ Android build & deployment
- ✅ Web deployment (Firebase Hosting / Netlify)
- ✅ Troubleshooting
- ✅ Production checklist

---

## 📊 App Structure

### Screens
```
1. Splash → Auth Check
2. Login / Signup / Onboarding
3. Home (5 tabs)
   ├─ 🏠 Home (dash)
   ├─ 📚 Roadmap
   ├─ 💻 Practice
   ├─ 📁 Projects
   └─ 👤 Profile
4. Extra Screens
   ├─ 🤖 AI Chat
   ├─ 📸 Camera Scanner
   ├─ 🎤 Mock Interview
   ├─ 🏆 Leaderboard
   └─ 🎁 Swag Store
```

### State Management (Riverpod)
```
Providers for:
- Authentication
- User data
- Problems list
- Leaderboard
- Chat history
- Badges
- Interview sessions
```

---

## 🎓 Learning Progression

### Topics Covered
- Arrays & Strings
- Linked Lists
- Trees & Graphs
- Sorting & Searching
- Dynamic Programming
- Greedy Algorithms
- Backtracking
- System Design

### Gamification
- **Coins**: Earn per problem (10/20/50)
- **Badges**: 30+ achievements
- **Streak**: Daily activity tracking
- **Leaderboard**: Global/City/College ranks

---

## 💾 Data Storage

### Firebase
- User profiles → Firestore
- Problems database → Firestore
- Chat history → Firestore
- Authentication → Firebase Auth

### Local (Hive)
- Downloaded problems
- Chat cache
- User preferences
- Offline queue

---

## 📸 Screenshots

[Coming soon after first deployment]

---

## 🛠️ Development

### Run Development
```bash
flutter run                    # Android
flutter run -d chrome         # Web
flutter run -d edge -d chrome # Multiple browsers
```

### Build Release
```bash
flutter build apk --release   # Android APK
flutter build web --release   # Web (build/web)
```

### Deploy Web
```bash
# Firebase Hosting (free)
firebase deploy

# OR Netlify
netlify deploy --prod --dir=build/web
```

---

## 📞 Resources

- [Setup Guide](./SETUP.md) - Detailed instructions
- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs/flutter)
- [Gemini API](https://ai.google.dev/)
- [Judge0 Docs](https://judge0.com/docs)

---

## 🎯 What's Complete

✅ Complete app architecture
✅ All 20+ screens
✅ Authentication (Google + Email)
✅ AI Mentor chatbot
✅ Code execution engine
✅ Problem database
✅ Gamification system
✅ Leaderboard
✅ Mock interviews
✅ Resume generator
✅ Works on Android + Web
✅ Offline caching
✅ Zero TODOs

---

## 🚀 Next Steps

1. **Setup Firebase** (see SETUP.md)
2. **Run on Android or Web**
3. **Create account & explore**
4. **Try code execution**
5. **Deploy to Play Store / Firebase Hosting**

---

## 📄 License

Open-source for educational purposes.

---

**Built with ❤️ for Indian students. Start learning today! 🎓**
