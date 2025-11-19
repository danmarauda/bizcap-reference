# Bizcap Mobile App Screen Planning with HTML Prototype

## 🎯 Strategy: HTML-First Development

Use the existing HTML mobile preview as a **rapid prototyping and design system** to plan all screens before React Native implementation. This allows for:

- **Fast iteration**: Change designs instantly without recompilation
- **Visual consistency**: Ensure all screens match the design system
- **User testing**: Share clickable prototypes with stakeholders
- **Component library**: Build reusable HTML components for RN migration

## 📱 Screen Planning Workflow

### 1. Master Screen Template
```html
<!-- Copy this structure for each new screen -->
<div class="phone-shell">
  <!-- Status Bar -->
  <div class="status-bar">
    <span id="bizcap-time">09:41</span>
    <div class="status-icons">📶 📡 🔋</div>
  </div>

  <!-- Custom Header (varies per screen) -->
  <header class="app-header">
    <!-- Screen-specific header content -->
  </header>

  <!-- Main Content Area -->
  <div class="screen-scroll">
    <!-- Screen-specific content -->
  </div>

  <!-- Tab Bar (consistent across screens) -->
  <nav class="tab-bar">
    <!-- Tab navigation -->
  </nav>
</div>
```

### 2. Screen Inventory & Status

| Screen | Status | Priority | Complexity | Notes |
|--------|--------|----------|------------|-------|
| 🏠 Home Dashboard | ✅ Complete | High | Medium | Base template |
| 🔍 Search Results | 📝 Planned | High | Medium | Filter & sort |
| 📊 Scope Details | 📝 Planned | High | High | Interactive timeline |
| 🎯 Event Details | 📝 Planned | Medium | Medium | Registration flow |
| 👤 Profile Edit | 📝 Planned | Medium | Low | Form validation |
| ⚙️ Settings | 📝 Planned | Low | Low | Toggle switches |
| 💬 Support Chat | 📝 Planned | Medium | High | Real-time messaging |
| 📋 Application Form | 📝 Planned | High | High | Multi-step wizard |

### 3. Component Library

#### Navigation Components
```html
<!-- Back Button -->
<button class="nav-back-btn">← Back</button>

<!-- Close Button -->
<button class="nav-close-btn">✕</button>

<!-- Action Button -->
<button class="nav-action-btn">⋮</button>
```

#### Content Components
```html
<!-- Card Component -->
<article class="content-card">
  <div class="card-header">
    <h3>Card Title</h3>
    <span class="card-badge">Status</span>
  </div>
  <div class="card-content">
    <!-- Card content -->
  </div>
  <div class="card-actions">
    <!-- Action buttons -->
  </div>
</article>

<!-- List Item Component -->
<div class="list-item">
  <div class="list-item-icon">○</div>
  <div class="list-item-content">
    <h4>Item Title</h4>
    <p>Item description</p>
  </div>
  <div class="list-item-action">→</div>
</div>
```

#### Form Components
```html
<!-- Input Field -->
<div class="form-field">
  <label>Label Text</label>
  <input type="text" placeholder="Placeholder">
  <span class="field-error">Error message</span>
</div>

<!-- Select Dropdown -->
<div class="form-field">
  <label>Select Option</label>
  <select>
    <option>Option 1</option>
    <option>Option 2</option>
  </select>
</div>

<!-- Radio Group -->
<div class="radio-group">
  <label>Choose Option</label>
  <label class="radio-option">
    <input type="radio" name="option" value="1">
    <span>Option 1</span>
  </label>
</div>
```

## 🚀 Rapid Prototyping Process

### Step 1: Create New Screen File
```bash
# Create new screen HTML file
cp bizcap-mobile-preview/index.html bizcap-mobile-preview/screens/scope-details.html
```

### Step 2: Modify Content
```html
<!-- Change title -->
<title>Scope Details – Bizcap</title>

<!-- Update header -->
<header class="app-header">
  <button class="nav-back-btn">←</button>
  <div class="app-title-block">
    <h1>Scope Details</h1>
    <p>Funding scope overview</p>
  </div>
</header>

<!-- Update main content -->
<div class="screen-scroll">
  <article class="content-card">
    <div class="card-header">
      <h3>Business Loan Scope</h3>
      <span class="card-badge status-active">Active</span>
    </div>
    <!-- Card content -->
  </article>
</div>
```

### Step 3: Add Interactions
```javascript
// Add screen-specific JavaScript
document.querySelector('.nav-back-btn').addEventListener('click', () => {
  // Navigate back logic
  alert('Navigate back to previous screen');
});

document.querySelector('.card-action-btn').addEventListener('click', () => {
  // Action logic
  alert('Perform card action');
});
```

### Step 4: Test & Iterate
- Open in browser: `http://localhost:5174/screens/scope-details.html`
- Test interactions and visual design
- Gather feedback and iterate quickly

## 📋 Screen Development Checklist

### For Each New Screen:
- [ ] **Layout**: Phone shell structure maintained
- [ ] **Navigation**: Appropriate header with back/close actions
- [ ] **Content**: Clear information hierarchy
- [ ] **Interactions**: Click handlers for all interactive elements
- [ ] **States**: Loading, empty, error states considered
- [ ] **Responsive**: Works on different screen sizes
- [ ] **Accessibility**: Proper labels and keyboard navigation

### Design System Compliance:
- [ ] **Colors**: Uses Bizcap design tokens
- [ ] **Typography**: Consistent font sizes and weights
- [ ] **Spacing**: Follows spacing scale
- [ ] **Icons**: Uses approved icon set
- [ ] **Components**: Reuses existing component patterns

## 🔄 HTML to React Native Migration

### Component Mapping:
```javascript
// HTML Card → React Native Component
<article class="content-card"> → <Card>
// HTML Button → React Native Component
<button class="btn-primary"> → <Button>
// HTML Input → React Native Component
<input type="text"> → <TextInput>
```

### Style Migration:
```javascript
// CSS Classes → StyleSheet
.content-card: {
  borderRadius: 12,
  padding: 16,
  backgroundColor: '#FFFFFF',
  shadowOpacity: 0.1,
}
```

### Interaction Migration:
```javascript
// HTML Event Listener → React Handler
document.querySelector('.btn').addEventListener('click', handler)
// ↓
<Button onPress={handler}>
```

## 📁 File Organization

```
bizcap-mobile-preview/
├── index.html                 # Home dashboard
├── screens/
│   ├── search-results.html    # Search & filter
│   ├── scope-details.html     # Scope overview
│   ├── event-details.html     # Event information
│   ├── profile-edit.html      # Profile management
│   ├── settings.html          # App settings
│   ├── support-chat.html      # Customer support
│   └── application-form.html  # Funding application
├── components/
│   ├── card.html             # Reusable card component
│   ├── form-field.html       # Form input component
│   ├── list-item.html        # List item component
│   └── modal.html            # Modal overlay component
└── assets/                   # Images, icons, etc.
```

## 🎯 Next Steps

1. **Create Screen Inventory**: List all required screens with priorities
2. **Build Component Library**: Create reusable HTML components
3. **Prototype Key Screens**: Start with high-priority screens
4. **User Testing**: Share prototypes with stakeholders
5. **Iterate & Refine**: Incorporate feedback quickly
6. **Migration Planning**: Map HTML components to React Native

This HTML-first approach allows for rapid iteration and ensures design consistency before investing in React Native development!