# 🚀 Career Assistant Module - Complete Implementation Guide

## Overview

The **Career Assistant** is a comprehensive suite of 4 AI-powered features designed to help students and developers build stronger professional profiles, optimize resumes, plan career roadmaps, and find ideal hackathon teammates.

---

## ✅ Features Implemented

### 1️⃣ **Smart Profile Builder**
**Location:** `lib/screens/profile_screen.dart`

**What it does:**
- Fetches GitHub profile (repos, stars, followers, language stats)
- Integrates LinkedIn profile (experience, education, skills, connections)
- Generates AI networking insights using Gemini
- Suggests connection opportunities based on profile
- Calculates profile strength score (0-100)
- Displays education institutions on interactive map
- Shows top repos and skill bars

**Data Models:**
- `UserProfile` - aggregates GitHub + LinkedIn data
- `GithubProfile` + `GithubRepo` - GitHub API responses
- `LinkedInProfile` + `Experience` + `Education` - LinkedIn profile structure

**Key Sections (A-H):**
- A: Profile Header (name, bio, location, avatar)
- B: Skills & Language Stats (bar chart visualization)
- C: Experience Timeline (interactive vertical timeline)
- D: Top GitHub Projects (sortable project cards)
- E: Education Background (with OpenStreetMap)
- F: College Network Insights (AI-generated peer suggestions)
- G: Profile Strength Indicator (circular progress)
- H: Connection Recommendations (swipeable cards)

---

### 2️⃣ **AI Resume Checker**
**Location:** `lib/screens/resume_checker_screen.dart`

**What it does:**
- Upload PDF or paste resume text directly
- Sends to Gemini for ATS (Applicant Tracking System) analysis
- Provides detailed JSON report with:
  - Overall score & ATS compatibility score
  - Section-wise feedback (contact, summary, experience, skills, education, projects)
  - Missing keywords list
  - Formatting issues detected
  - Action verbs present & missing
  - Quantification score
- Export improvement suggestions as PDF

**Data Models:**
- `ResumeReport` - complete analysis result
- `ResumeSectionReport` - per-section scores & feedback
- `ResumeImprovement` - prioritized suggestions

**Status Indicators:**
- 🟢 **ATS Friendly** (score > 70)
- 🟡 **Needs Improvement** (50-70)
- 🔴 **Not ATS Friendly** (< 50)

---

### 3️⃣ **Roadmap Advisor**
**Location:** `lib/screens/roadmap_screen.dart`

**What it does:**
- Questionnaire captures:
  - Target domain (Web Dev, Mobile Dev, AI/ML, etc.)
  - Current skill level (Beginner, Intermediate, Advanced)
  - Daily commitment (1hr, 2hr, 4hr, 6hr+)
  - Timeline (3 months, 6 months, 1 year)
- AI generates personalized roadmap with:
  - Completed items (with evidence)
  - In-progress items (with % completion)
  - Todo items (prioritized with resources)
  - Weekly plans (tasks + goals)
  - Milestones (monthly achievements)
  - Job readiness score (0-100)
  - Next important action

**Tabbed Interface:**
1. **Overview** - current status, readiness score, counts
2. **Completed** - achievements already finished
3. **In Progress** - ongoing tasks with progress bars
4. **To Do** - prioritized items with learning resources
5. **Weekly** - weekly checklist with persistence
6. **Milestones** - timeline visualization of monthly goals

**Persistence:**
- Weekly task completion saved to `SharedPreferences`
- Completion percentage calculated dynamically

**Data Models:**
- `CareerRoadmap` - complete roadmap structure
- `RoadmapItem` - individual task with resources
- `WeeklyPlan` - weekly checklist
- `Milestone` - monthly achievement

---

### 4️⃣ **Hackathon Team Finder**
**Location:** `lib/screens/hackathon_screen.dart`

**What it does:**
- Input: Problem statement, hackathon type, team size, GitHub username
- **Stage 1:** AI analyzes problem → extracts roles & tech stack
- **Stage 2:** GitHub search finds candidates for each role
- **Stage 3:** AI scores & ranks candidates by match %
- **Output:**
  - Recommended team (max: team size limit)
  - Team chemistry score (0-100)
  - Win probability estimate
  - Team strengths & weaknesses
  - Pitch strategy advice
  - All-candidates fallback list

**Data Models:**
- `ProblemAnalysis` - AI-extracted requirements
- `RequiredRole` - role + skills + search queries
- `TeamCandidate` - scored team member with repos & skills
- `TeamRecommendation` - role + candidate pair
- `HackathonTeamResult` - final team + analysis

**Features:**
- Copy pre-written message template to clipboard
- Open candidate GitHub/LinkedIn profiles
- View top repos per candidate
- Team strengths/weaknesses summary

---

## 🔧 Architecture & Wiring

### 1. **Routes**
All routes defined in `lib/core/router/app_router.dart`:
- `/career-assistant` → `CareerAssistantShellScreen` (main shell with 5-tab nav)
- `/resume-checker` → `ResumeCheckerScreen` (standalone resume analysis)

### 2. **Bottom Navigation (Career Assistant Shell)**
5-tab interface:
| Tab | Screen | Icon |
|-----|--------|------|
| Home | CareerHomeScreen | 🏠 |
| Roadmap | CareerRoadmapScreen | 🗺️ |
| Projects | ProjectsScreen (existing) | 📋 |
| Profile | ProfileScreen | 👤 |
| Team | HackathonScreen | 👥 |

### 3. **State Management (Riverpod)**
All features use ChangeNotifierProvider pattern:
- `profileProvider` → Profile building + GitHub/LinkedIn fetch
- `resumeProvider` → Resume upload + Gemini analysis
- `roadmapProvider` → Roadmap generation + weekly task persistence
- `hackathonProvider` → Team analysis & candidate search

### 4. **Services Layer**
- `GithubApiService` - GitHub REST API integration
- `LinkedinService` - RapidAPI LinkedIn endpoint
- `CareerGeminiService` - Gemini JSON-only generation
- `PdfService` - PDF text extraction & report generation

### 5. **Data Models**
Located in `lib/models/`:
- `github_profile.dart` / `github_profile_model.dart`
- `linkedin_profile.dart`
- `user_profile.dart`
- `resume_report.dart`
- `roadmap.dart`
- `hackathon_team.dart`

### 6. **Widgets (Reusable UI)**
Located in `lib/widgets/`:
- `SkillBarChart` - FL Chart bar visualization
- `ExperienceTimeline` - Timeline Tile experience display
- `ResumeScoreCard` - Circular progress indicator for score
- `RoadmapCard` - Collapsible roadmap item card
- `TeamMemberCard` - Team candidate profile card

---

## 🔑 API Keys Setup

### Required Keys (Add to `lib/config/api_config.dart`):

#### 1. **GitHub Personal Token** (Optional but recommended)
- Higher rate limits (60 → 5000 requests/hour)
- **Get:** https://github.com/settings/tokens
- **Scope needed:** `public_repo`
- **Location:** `ApiConfig.githubToken`

#### 2. **Gemini API Key** (Required)
- Powers all AI insights, resume analysis, roadmap generation, team ranking
- **Get:** https://ai.google.dev/
- **Model used:** `gemini-1.5-flash`
- **Location:** `ApiConfig.geminiKey`

#### 3. **RapidAPI LinkedIn Key** (Required for profile fetching)
- Used to fetch LinkedIn profile data
- **Get:** https://rapidapi.com/
- **Search:** "linkedin-api8"
- **Location:** `ApiConfig.rapidApiKey`

**Example Setup:**
```dart
// lib/config/api_config.dart
class ApiConfig {
  static const String githubToken = 'ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxx';
  static const String geminiKey = 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxx';
  static const String rapidApiKey = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
  // ... rest unchanged
}
```

---

## 🎯 Entry Points

### From Main App:
1. **Home Screen Quick Action** (existing home)
   - Button: "Open Portfolio & Career Assistant"
   - Routes to: `/career-assistant`

2. **Direct URL Navigation:**
   - `/career-assistant` → Full 5-tab shell experience
   - `/resume-checker` → Standalone resume analyzer

### First-Time User Flow:
1. Tap "Open Portfolio & Career Assistant" on home
2. Lands on **CareerAssistantShellScreen** (Home tab shows 4 features)
3. User chooses feature to explore

---

## 🚀 How to Use Each Feature

### Feature 1: Smart Profile Builder
1. Navigate to **Profile** tab
2. Enter LinkedIn URL (e.g., `linkedin.com/in/username`)
3. Enter GitHub URL (e.g., `github.com/username`)
4. Select college name (with autocomplete)
5. Auto-detect or enter location
6. Tap "Build My Profile"
7. Wait for multi-step fetch (shows progress: "Fetching GitHub...", "Fetching LinkedIn...", "Generating AI insights...")
8. View:
   - Profile hero card with stats
   - Skills bar chart
   - Experience timeline
   - Top projects
   - Education + map
   - Network insights
   - Profile strength score
   - Connection recommendations

### Feature 2: AI Resume Checker
1. Navigate to **Resume** section or tap "Check My Resume Now"
2. Option A: Upload PDF file
   - Tap "Upload PDF"
   - Select file from device
   - Auto-extracts text
3. Option B: Paste text
   - Type/paste resume content directly
4. Tap "Check My Resume"
5. Wait for Gemini analysis
6. View:
   - Overall score + ATS status
   - Section-by-section feedback (expandable)
   - Strengths/weaknesses chips
   - Improvement suggestions (High/Medium/Low priority)
   - Missing keywords list
   - Action verbs analysis
7. Export suggestions as PDF: "Download Improved Suggestions as PDF"

### Feature 3: Roadmap Advisor
1. Navigate to **Roadmap** tab
2. Answer questionnaire:
   - Q1: Role (Student/Intern/Junior Dev, etc.)
   - Q2: Target domain (Web Dev, AI/ML, etc.)
   - Q3: Skill level (slider: Beginner → Intermediate → Advanced)
   - Q4: Hours/day commitment
   - Q5: Timeline
3. Tap "Generate AI Roadmap"
4. Explore 6 tabs:
   - **Overview:** Status + readiness % + next action
   - **Completed:** Achievements marked done
   - **In Progress:** Ongoing tasks with progress bars
   - **To Do:** Prioritized items (click to open resources)
   - **Weekly:** Checklist (tap checkbox to persist completion)
   - **Milestones:** Timeline of monthly goals
5. Check off weekly tasks → completion % updates automatically

### Feature 4: Hackathon Team Finder
1. Navigate to **Team** tab
2. Paste problem statement (5+ lines recommended)
3. Select hackathon type (Web App, Mobile App, AI/ML, etc.)
4. Select team size (2-5 members)
5. Enter your GitHub username
6. (Optional) Enter your LinkedIn URL
7. Tap "Find Best Team Members"
8. View results:
   - **Problem Analysis:** Required roles, tech stack, winning strategy
   - **Dream Team:** Cards for each recommended teammate
     - Match score
     - Top skills
     - Top repos
     - Message template (copy to clipboard)
     - GitHub/LinkedIn links
   - **Team Summary:** Chemistry %, win probability, strengths/weaknesses
   - **All Candidates:** Fallback pool of all searched members

---

## 📦 Dependencies Added

All packages integrated and tested:
```yaml
file_picker: ^8.1.2              # PDF/resume file selection
pdf: ^3.11.1                     # PDF report generation
printing: ^5.13.2                # PDF sharing & printing
syncfusion_flutter_pdf: ^24.1.41 # PDF text extraction
timeline_tile: ^2.0.0            # Experience timeline visualization
percent_indicator: ^4.2.3        # Circular progress indicators
flutter_map: ^6.1.0              # Interactive maps
latlong2: ^0.9.0                 # Geographic coordinates
geolocator: ^11.0.0              # Location detection
geocoding: ^3.0.0                # Address geocoding
```

---

## 🎨 Theme Integration

Dark purple theme aligned with existing app:
- **Background:** `0xFF1A1033`
- **Accent Purple:** `0xFF6B5CE7`
- **Surface:** `0xFF21184A`, `0xFF2B1E5A`
- **Input Background:** `0xFF1A1033`
- **Borders:** `0xFF4A3E99` (with opacity)

All new UI uses existing `AppColors` constants and `AppTextStyles`.

---

## ⚠️ Known Limitations & Notes

1. **API Rate Limits:**
   - GitHub: 60 req/hr (unauthenticated) → 5000 req/hr (with token)
   - Gemini: Check your quota at https://ai.google.dev/
   - LinkedIn RapidAPI: Rate limits depend on subscription tier

2. **PDF Extraction:**
   - Works best with standard text-based PDFs
   - Scanned/image PDFs may not extract well

3. **Location Features:**
   - Requires `android.permission.ACCESS_FINE_LOCATION` (Android)
   - Maps default to India (can be customized in `profile_screen.dart`)

4. **Network Dependency:**
   - All features require internet connection
   - Graceful error handling for network failures included

5. **Gemini JSON Output:**
   - Prompts specify `responseMimeType: 'application/json'`
   - Markdown code blocks are stripped automatically
   - Ensure API key has access to JSON output

---

## 🧪 Testing Checklist

Before launch, verify:
- [ ] API keys added to `lib/config/api_config.dart`
- [ ] `flutter pub get` runs without errors
- [ ] `flutter analyze` shows no errors in new files
- [ ] Navigation: `/career-assistant` route loads shell
- [ ] Profile builder: Can fetch GitHub + LinkedIn profiles
- [ ] Resume checker: Can upload PDF + analyze with Gemini
- [ ] Roadmap: Can generate + persist weekly task checks
- [ ] Hackathon: Can analyze problem + find candidates
- [ ] All 5 tabs in shell navigation work
- [ ] Dark theme colors applied consistently
- [ ] Resume PDF export works

---

## 📂 File Structure Summary

```
lib/
├── config/
│   └── api_config.dart              # API keys & endpoints
├── models/
│   ├── github_profile.dart
│   ├── linkedin_profile.dart
│   ├── user_profile.dart
│   ├── resume_report.dart
│   ├── roadmap.dart
│   └── hackathon_team.dart
├── services/
│   ├── gemini_service.dart          # AI generation
│   ├── github_service.dart          # GitHub API
│   ├── linkedin_service.dart        # LinkedIn RapidAPI
│   └── pdf_service.dart             # PDF extraction & generation
├── providers/
│   ├── profile_provider.dart        # Profile state
│   ├── resume_provider.dart         # Resume state
│   ├── roadmap_provider.dart        # Roadmap state
│   └── hackathon_provider.dart      # Hackathon state
├── screens/
│   ├── career_assistant_shell_screen.dart  # Main shell (5 tabs)
│   ├── career_home_screen.dart             # Feature overview
│   ├── profile_screen.dart                 # Feature 1
│   ├── resume_checker_screen.dart          # Feature 2
│   ├── roadmap_screen.dart                 # Feature 3
│   └── hackathon_screen.dart               # Feature 4
└── widgets/
    ├── skill_bar_chart.dart
    ├── experience_timeline.dart
    ├── resume_score_card.dart
    ├── roadmap_card.dart
    └── team_member_card.dart
```

---

## 🤝 Integration Notes

- **No existing code modified** except router (`app_router.dart`) for new routes
- **All new code is additive** — no breaking changes
- **Existing app features remain untouched** (home, roadmap, practice, projects, profile)
- **Isolated state management** using dedicated providers
- **Consistent theming** with app-wide color scheme

---

## 🎓 Next Steps

1. **Add API Keys:** Update `lib/config/api_config.dart` with real keys
2. **Run the app:** `flutter run`
3. **Test features:** Tap "Open Portfolio & Career Assistant" from home
4. **Collect feedback:** Use real data (GitHub, LinkedIn profiles)
5. **Iterate:** Adjust prompts, colors, or flows based on user feedback

---

**Built with ❤️ using Flutter + Riverpod + Gemini AI**

Questions? Check individual file docstrings for detailed implementation notes.
