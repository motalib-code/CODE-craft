# 🎯 Career Assistant - Quick Reference

## 📍 Entry Points

**From App Home:**
- Button: "Open Portfolio & Career Assistant" 
- Routes to: `/career-assistant`

**Direct Navigation:**
- `/career-assistant` → Main shell (5 tabs)
- `/resume-checker` → Standalone resume analyzer

---

## 4️⃣ Features at a Glance

| Feature | Tab | What It Does | Input | Output |
|---------|-----|-------------|-------|--------|
| **Profile Builder** | Profile | Merge GitHub + LinkedIn data | GitHub URL, LinkedIn URL, College, Location | Combined profile with insights, strength score, connection suggestions |
| **Resume Checker** | (Home) | AI-powered ATS analysis | PDF upload or text paste | Score, feedback per section, missing keywords, suggestions |
| **Roadmap Advisor** | Roadmap | AI career planning | Domain, level, hours/day, timeline | Prioritized tasks, weekly checklist, milestones, job readiness % |
| **Hackathon Finder** | Team | Find ideal teammates | Problem statement, hackathon type, team size | Ranked candidates, team chemistry %, strengths/weaknesses |

---

## 🔑 Required API Keys

Add to `lib/config/api_config.dart`:

1. **Gemini Key** (Required)
   - Get: https://ai.google.dev/
   - Field: `ApiConfig.geminiKey`

2. **GitHub Token** (Optional, improves rate limits)
   - Get: https://github.com/settings/tokens
   - Field: `ApiConfig.githubToken`

3. **RapidAPI LinkedIn Key** (Required)
   - Get: https://rapidapi.com/
   - Search: "linkedin-api8"
   - Field: `ApiConfig.rapidApiKey`

---

## 📦 Key Files Created

### Screens (UI)
- `lib/screens/career_assistant_shell_screen.dart` - Main 5-tab shell
- `lib/screens/career_home_screen.dart` - Feature overview
- `lib/screens/profile_screen.dart` - Smart Profile Builder
- `lib/screens/resume_checker_screen.dart` - AI Resume Checker
- `lib/screens/roadmap_screen.dart` - Roadmap Advisor
- `lib/screens/hackathon_screen.dart` - Hackathon Team Finder

### Providers (State)
- `lib/providers/profile_provider.dart`
- `lib/providers/resume_provider.dart`
- `lib/providers/roadmap_provider.dart`
- `lib/providers/hackathon_provider.dart`

### Services (API)
- `lib/services/gemini_service.dart` - Gemini JSON generation
- `lib/services/github_service.dart` - GitHub API
- `lib/services/linkedin_service.dart` - LinkedIn RapidAPI
- `lib/services/pdf_service.dart` - PDF extraction & generation

### Models (Data)
- `lib/models/user_profile.dart`
- `lib/models/github_profile.dart`
- `lib/models/linkedin_profile.dart`
- `lib/models/resume_report.dart`
- `lib/models/roadmap.dart`
- `lib/models/hackathon_team.dart`

### Widgets (Reusable)
- `lib/widgets/skill_bar_chart.dart`
- `lib/widgets/experience_timeline.dart`
- `lib/widgets/resume_score_card.dart`
- `lib/widgets/roadmap_card.dart`
- `lib/widgets/team_member_card.dart`

### Config
- `lib/config/api_config.dart` - API endpoints & keys

---

## ✅ Validation Status

**All Screens:** ✅ No compile errors
**All Providers:** ✅ No compile errors
**All Services:** ✅ No compile errors
**All Models:** ✅ No compile errors
**All Widgets:** ✅ No compile errors
**Dependencies:** ✅ All packages included in pubspec.yaml
**Routes:** ✅ Registered in app_router.dart
**Home Entry:** ✅ Quick action button added

---

## 🚀 Quick Start

1. **Add API Keys**
   ```dart
   // lib/config/api_config.dart
   static const String geminiKey = 'YOUR_KEY_HERE';
   static const String rapidApiKey = 'YOUR_KEY_HERE';
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run App**
   ```bash
   flutter run
   ```

4. **Access Feature**
   - Home screen → Tap "Open Portfolio & Career Assistant"
   - Or navigate to `/career-assistant`

---

## 🎯 Use Cases

### For Students
- Build impressive LinkedIn + GitHub profile combination
- Get resume ATS-ready before applications
- Plan career roadmap with weekly milestones
- Find hackathon teammates with complementary skills

### For Recent Grads
- Showcase projects and contributions
- Analyze resume gaps before job hunt
- Track progress toward dream role
- Build collaborative hackathon teams

### For Career Changers
- Aggregate profile from multiple platforms
- Get ATS feedback on transition resume
- Follow structured roadmap for new domain
- Network with relevant skill candidates

---

## 🎨 Theme Colors

```dart
Background:    #1A1033 (Deep Purple)
Accent:        #6B5CE7 (Bright Purple)
Surface:       #21184A (Dark Purple)
Input:         #1A1033
Border:        #4A3E99 (with opacity)
```

All UI components use `AppColors` constants.

---

## 📊 Data Flow

```
User Input
    ↓
[Provider] State Management
    ↓
[Service] API Calls (GitHub, LinkedIn, Gemini)
    ↓
[Model] Parse & Structure Data
    ↓
[Widget] Display with UI Components
    ↓
User Sees Results
```

---

## ⚡ Performance Tips

1. **GitHub Token:** Add token to get 5000 req/hour (vs 60 unauthenticated)
2. **Caching:** Results automatically cached in provider state
3. **Weekly Tasks:** Use SharedPreferences for instant persistence
4. **PDF:** Use cached network images for candidate avatars

---

## 🆘 Troubleshooting

| Issue | Solution |
|-------|----------|
| "API error (401)" | Check API keys in `api_config.dart` |
| "Profile not found" | Verify GitHub username is exact (case-sensitive) |
| "No PDF extracted" | Use text-based PDF (not scanned/image) |
| "Team search slow" | GitHub API rate limit — add token |
| "Resume analysis fails" | Ensure Gemini JSON output enabled |

---

## 📚 Full Documentation

See `CAREER_ASSISTANT_SETUP.md` for:
- Detailed feature descriptions
- Step-by-step user flows
- Architecture diagrams
- File structure
- API setup instructions
- Testing checklist

---

**Status: ✅ Ready for API Keys + Testing**
