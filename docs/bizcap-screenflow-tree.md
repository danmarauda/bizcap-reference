# Bizcap App Screenflow Tree

## Main Navigation Structure

```
📱 Bizcap Mobile App
├── 🔐 Authentication Flow
│   ├── Splash Screen
│   ├── Onboarding
│   │   ├── Welcome
│   │   ├── Business Info
│   │   └── Verification
│   └── Login/Register
│       ├── Login
│       └── Register
├── 🏠 Main App (Tab Navigation)
│   ├── 🏠 Home Tab
│   │   ├── Dashboard
│   │   │   ├── Search Bar
│   │   │   ├── Featured Scenario
│   │   │   ├── Use Case Pills
│   │   │   └── Metrics Strip
│   │   └── Quick Actions
│   │       ├── Start Application
│   │       └── Compare Options
│   ├── 📊 Scopes Tab
│   │   ├── Active Scopes
│   │   ├── Scope Details
│   │   │   ├── Scope Overview
│   │   │   ├── Requirements
│   │   │   ├── Timeline
│   │   │   └── Documents
│   │   └── Create New Scope
│   │       ├── Business Assessment
│   │       ├── Funding Needs
│   │       └── Scope Generation
│   ├── 🎯 Events Tab
│   │   ├── Upcoming Events
│   │   ├── Event Details
│   │   │   ├── Event Info
│   │   │   ├── Registration
│   │   │   └── Event Resources
│   │   └── Past Events
│   └── 👤 Account Tab
│       ├── Profile
│       │   ├── Personal Info
│       │   ├── Business Details
│       │   └── Preferences
│       ├── Funding History
│       ├── Documents
│       └── Settings
│           ├── Notifications
│           ├── Security
│           └── Support
└── 🔄 Cross-App Flows
    ├── 💬 Support Chat
    ├── 📋 Document Upload
    ├── 📊 Application Process
    │   ├── Pre-qualification
    │   ├── Document Collection
    │   ├── Under Review
    │   ├── Approved/Denied
    │   └── Funding Disbursement
    └── 🔍 Search & Filter
        ├── Global Search
        └── Advanced Filters
```

## User Journey Flows

### 1. New User Onboarding Flow
```
Splash → Welcome → Business Info → Verification → Login/Register → Dashboard
```

### 2. Funding Application Flow
```
Dashboard → Featured Scenario → Start Application → Business Assessment → Document Upload → Pre-qualification → Under Review → Approval → Funding
```

### 3. Scope Creation Flow
```
Scopes Tab → Create New Scope → Business Assessment → Funding Needs → AI Scope Generation → Scope Details → Application Start
```

### 4. Event Participation Flow
```
Events Tab → Event List → Event Details → Registration → Event Resources → Post-Event Follow-up
```

### 5. Account Management Flow
```
Account Tab → Profile/Settings → Update Info → Confirmation → Dashboard
```

## Screen States & Interactions

### Home Dashboard States
- **Default**: Shows featured content and metrics
- **Search Active**: Search bar expanded with suggestions
- **Filtered**: Shows filtered results based on use case selection
- **Loading**: Shows skeleton loaders during data fetch

### Scope States
- **Empty**: No active scopes, shows CTA to create first scope
- **Active**: Shows current scopes with progress indicators
- **Completed**: Shows completed scopes with outcomes

### Application States
- **Draft**: Incomplete application
- **Submitted**: Under review
- **Approved**: Ready for funding
- **Rejected**: Shows reasons and next steps

## Navigation Patterns

### Bottom Tab Navigation
- **Home**: Central hub for all activities
- **Scopes**: Funding scope management
- **Events**: Business events and webinars
- **Account**: User profile and settings

### Modal Overlays
- **Quick Actions**: Start application, compare options
- **Filters**: Advanced search and filtering
- **Notifications**: In-app notifications and updates

### Deep Linking Support
- **Direct Scope Access**: `/scope/{id}`
- **Event Registration**: `/event/{id}/register`
- **Application Status**: `/application/{id}/status`

## Error & Edge Case Handling

### Network States
- **Offline**: Cached content with offline indicators
- **Slow Connection**: Progressive loading with placeholders
- **Connection Restored**: Auto-refresh and sync

### Error Screens
- **404 Not Found**: Friendly error with navigation options
- **Server Error**: Retry options and support contact
- **Validation Errors**: Inline form validation with guidance

### Empty States
- **No Scopes**: Encouraging CTA to create first scope
- **No Events**: Upcoming events teaser
- **No Applications**: Quick start guide

## Performance Considerations

### Loading Strategies
- **Skeleton Screens**: For initial loads
- **Progressive Loading**: Content appears as it loads
- **Lazy Loading**: Images and non-critical content

### Caching Strategy
- **Static Assets**: Logo, icons cached indefinitely
- **User Data**: Profile and preferences cached
- **Dynamic Content**: Recent scopes and events cached

### Offline Capability
- **Read-Only Mode**: View cached content offline
- **Queue Actions**: Store actions for when online
- **Sync Indicators**: Show sync status and pending actions