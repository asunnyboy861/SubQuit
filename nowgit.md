# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | SubQuit |
| **Git URL** | git@github.com:asunnyboy861/SubQuit.git |
| **Repo URL** | https://github.com/asunnyboy861/SubQuit |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

### Deployed Pages

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/SubQuit/ | ✅ Active |
| Support | https://asunnyboy861.github.io/SubQuit/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/SubQuit/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/SubQuit/terms.html | ✅ Active |

## Repository Structure

### Main App Repository
```
SubQuit/
├── SubQuit/                           # iOS App Source Code
│   ├── SubQuit.xcodeproj/             # Xcode Project
│   ├── SubQuit/                       # Swift Source Files
│   │   ├── Views/
│   │   │   ├── Home/
│   │   │   ├── CancelGuide/
│   │   │   ├── Savings/
│   │   │   ├── AddSubscription/
│   │   │   ├── Settings/
│   │   │   └── Components/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── ViewModels/
│   │   ├── Utils/
│   │   └── Resources/
│   └── ...
├── docs/                              # Policy Pages (GitHub Pages)
│   ├── index.html                     # Landing Page
│   ├── support.html                   # Support Page
│   ├── privacy.html                   # Privacy Policy
│   └── terms.html                     # Terms of Use
├── SubQuit-pic/                       # App Store Screenshots
│   ├── iphone/                        # iPhone screenshots
│   └── ipad/                          # iPad screenshots
├── .github/workflows/
│   └── deploy.yml                     # GitHub Pages deployment
├── us.md                              # English Development Guide
├── keytext.md                         # App Store Metadata
├── capabilities.md                    # Capabilities Configuration
├── icon.md                            # App Icon Details
├── price.md                           # Pricing Configuration
└── nowgit.md                          # This File
```
