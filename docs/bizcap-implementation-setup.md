# Bizcap Mobile App: Implementation Setup Guide

## Quick Start Implementation

This guide provides the exact commands and steps to set up both web and native versions of the Bizcap mobile app with design and feature parity.

## 1. Project Structure Setup

### 1.1 Create Monorepo Structure

```bash
# Create main project directory
mkdir bizcap-mobile-app
cd bizcap-mobile-app

# Initialize monorepo with pnpm workspaces
pnpm init

# Create workspace structure
mkdir -p packages/{shared,web,native}
mkdir -p packages/shared/{design-tokens,types,utils}
mkdir -p docs
mkdir -p .github/workflows
```

### 1.2 Configure Workspace

```json
// package.json (root)
{
  "name": "bizcap-mobile-app",
  "private": true,
  "workspaces": [
    "packages/*"
  ],
  "scripts": {
    "dev:web": "pnpm --filter web dev",
    "dev:native": "pnpm --filter native start",
    "build:web": "pnpm --filter web build",
    "build:native": "pnpm --filter native build",
    "test": "pnpm --filter \"*\" test",
    "lint": "pnpm --filter \"*\" lint",
    "typecheck": "pnpm --filter \"*\" typecheck"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "typescript": "^5.0.0"
  }
}
```

## 2. Shared Packages Setup

### 2.1 Design Tokens Package

```bash
cd packages/shared/design-tokens
pnpm init
```

```json
// packages/shared/design-tokens/package.json
{
  "name": "@bizcap/design-tokens",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

```typescript
// packages/shared/design-tokens/src/index.ts
export const BizcapTokens = {
  colors: {
    // Primary brand colors
    primary: '#0066FF',
    'primary-dark': '#0052CC',
    'primary-light': '#3385FF',
    
    // Accent colors
    accent: '#00D4FF',
    'accent-dark': '#00A8CC',
    'accent-light': '#33DDFF',
    
    // Semantic colors
    success: '#00C896',
    warning: '#FFB800',
    danger: '#FF3B30',
    info: '#0066FF',
    
    // Neutral colors
    white: '#FFFFFF',
    'gray-50': '#F8F9FF',
    'gray-100': '#F1F3F7',
    'gray-200': '#E4E7EB',
    'gray-300': '#CED4DA',
    'gray-400': '#9AA5B1',
    'gray-500': '#6B7380',
    'gray-600': '#4A5568',
    'gray-700': '#2D3748',
    'gray-800': '#1A202C',
    'gray-900': '#0F1419',
    black: '#000000',
  },
  
  spacing: {
    0: '0px',
    1: '4px',
    2: '8px',
    3: '12px',
    4: '16px',
    5: '20px',
    6: '24px',
    8: '32px',
    10: '40px',
    12: '48px',
    16: '64px',
    20: '80px',
    24: '96px',
  },
  
  typography: {
    fontFamily: {
      sans: ['Inter', '-apple-system', 'BlinkMacSystemFont', 'sans-serif'],
      mono: ['JetBrains Mono', 'SF Mono', 'Monaco', 'monospace'],
    },
    fontSize: {
      xs: ['12px', { lineHeight: '16px' }],
      sm: ['14px', { lineHeight: '20px' }],
      base: ['16px', { lineHeight: '24px' }],
      lg: ['18px', { lineHeight: '28px' }],
      xl: ['20px', { lineHeight: '28px' }],
      '2xl': ['24px', { lineHeight: '32px' }],
      '3xl': ['30px', { lineHeight: '40px' }],
      '4xl': ['36px', { lineHeight: '44px' }],
    },
    fontWeight: {
      normal: '400',
      medium: '500',
      semibold: '600',
      bold: '700',
    },
  },
  
  borderRadius: {
    none: '0',
    sm: '4px',
    base: '8px',
    md: '12px',
    lg: '16px',
    xl: '20px',
    '2xl': '24px',
    full: '9999px',
  },
  
  shadows: {
    sm: '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
    base: '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)',
    md: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
    lg: '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
    xl: '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
  },
  
  animation: {
    duration: {
      fast: '150ms',
      normal: '300ms',
      slow: '500ms',
    },
    easing: {
      ease: 'cubic-bezier(0.4, 0, 0.2, 1)',
      easeIn: 'cubic-bezier(0.4, 0, 1, 1)',
      easeOut: 'cubic-bezier(0, 0, 0.2, 1)',
      easeInOut: 'cubic-bezier(0.4, 0, 0.2, 1)',
    },
  },
  
  breakpoints: {
    sm: '640px',
    md: '768px',
    lg: '1024px',
    xl: '1280px',
  },
};

export type BizcapTokens = typeof BizcapTokens;
```

```json
// packages/shared/design-tokens/tsconfig.json
{
  "extends": "../../tsconfig.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["dist", "node_modules"]
}
```

### 2.2 Shared Types Package

```bash
cd packages/shared/types
pnpm init
```

```json
// packages/shared/types/package.json
{
  "name": "@bizcap/types",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch"
  },
  "dependencies": {
    "@bizcap/design-tokens": "workspace:*"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

```typescript
// packages/shared/types/src/index.ts
export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  avatar?: string;
  phone?: string;
  isVerified: boolean;
  business?: Business;
  preferences: UserPreferences;
  createdAt: string;
  updatedAt: string;
}

export interface Business {
  id: string;
  name: string;
  abn: string;
  industry: string;
  establishedDate: string;
  address: Address;
  isVerified: boolean;
  documents: BusinessDocument[];
}

export interface Address {
  street: string;
  city: string;
  state: string;
  postcode: string;
  country: string;
}

export interface BusinessDocument {
  id: string;
  type: 'abn' | 'registration' | 'financial' | 'identity';
  url: string;
  status: 'pending' | 'verified' | 'rejected';
  uploadedAt: string;
}

export interface UserPreferences {
  notifications: {
    push: boolean;
    email: boolean;
    sms: boolean;
    marketing: boolean;
  };
  appearance: {
    theme: 'light' | 'dark' | 'system';
    language: string;
    currency: string;
    timezone: string;
  };
  security: {
    biometric: boolean;
    twoFactor: boolean;
  };
}

export interface Application {
  id: string;
  userId: string;
  type: 'business_loan' | 'equipment_finance' | 'line_of_credit';
  amount: number;
  purpose: string;
  status: 'draft' | 'submitted' | 'reviewing' | 'approved' | 'rejected' | 'funded';
  progress: ApplicationProgress;
  documents: ApplicationDocument[];
  timeline: ApplicationTimeline[];
  createdAt: string;
  updatedAt: string;
}

export interface ApplicationProgress {
  currentStep: number;
  totalSteps: number;
  completedSteps: string[];
  percentage: number;
}

export interface ApplicationDocument {
  id: string;
  name: string;
  type: string;
  url: string;
  size: number;
  uploadedAt: string;
  status: 'pending' | 'verified' | 'rejected';
}

export interface ApplicationTimeline {
  id: string;
  type: 'status_change' | 'document_uploaded' | 'review_completed' | 'note_added';
  title: string;
  description?: string;
  timestamp: string;
  actor?: string;
}

export interface Loan {
  id: string;
  applicationId: string;
  amount: number;
  interestRate: number;
  term: number;
  status: 'active' | 'completed' | 'defaulted';
  balance: number;
  nextPaymentDate: string;
  paymentAmount: number;
  createdAt: string;
}

export interface Event {
  id: string;
  title: string;
  description: string;
  type: 'workshop' | 'networking' | 'webinar' | 'conference';
  date: string;
  duration: number;
  location?: string;
  isVirtual: boolean;
  maxAttendees?: number;
  currentAttendees: number;
  speakers: Speaker[];
  tags: string[];
  registrationDeadline: string;
  price?: number;
}

export interface Speaker {
  id: string;
  name: string;
  title: string;
  company: string;
  bio: string;
  avatar?: string;
  expertise: string[];
}

export interface Notification {
  id: string;
  userId: string;
  type: 'application_update' | 'payment_reminder' | 'event_reminder' | 'marketing';
  title: string;
  message: string;
  isRead: boolean;
  actionUrl?: string;
  createdAt: string;
}

export interface PaymentMethod {
  id: string;
  userId: string;
  type: 'bank_account' | 'credit_card';
  lastFour: string;
  brand?: string;
  expiryMonth?: number;
  expiryYear?: number;
  isDefault: boolean;
  status: 'active' | 'expired' | 'declined';
  createdAt: string;
}

// API Response types
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// Form types
export interface LoginFormData {
  email: string;
  password: string;
  rememberMe?: boolean;
}

export interface RegisterFormData {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phone?: string;
  acceptTerms: boolean;
}

export interface ApplicationFormData {
  type: 'business_loan' | 'equipment_finance' | 'line_of_credit';
  amount: number;
  purpose: string;
  term?: number;
  collateral?: string;
}
```

### 2.3 Shared Utils Package

```bash
cd packages/shared/utils
pnpm init
```

```json
// packages/shared/utils/package.json
{
  "name": "@bizcap/utils",
  "version": "1.0.0",
  "main": "dist/index.js",
  "types": "dist/index.d.ts",
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch"
  },
  "dependencies": {
    "@bizcap/types": "workspace:*",
    "@bizcap/design-tokens": "workspace:*"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

```typescript
// packages/shared/utils/src/index.ts
import { Application, User, Loan } from '@bizcap/types';
import { BizcapTokens } from '@bizcap/design-tokens';

// Currency formatting
export const formatCurrency = (amount: number, currency = 'AUD'): string => {
  return new Intl.NumberFormat('en-AU', {
    style: 'currency',
    currency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
};

// Date formatting
export const formatDate = (date: string | Date, format = 'medium'): string => {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  
  const options: Intl.DateTimeFormatOptions = {
    year: 'numeric',
    month: format === 'short' ? 'short' : 'long',
    day: 'numeric',
  };
  
  if (format === 'long') {
    options.hour = '2-digit';
    options.minute = '2-digit';
  }
  
  return new Intl.DateTimeFormat('en-AU', options).format(dateObj);
};

// Application status helpers
export const getApplicationStatusColor = (status: Application['status']): string => {
  switch (status) {
    case 'draft':
      return BizcapTokens.colors.gray[500];
    case 'submitted':
      return BizcapTokens.colors.info;
    case 'reviewing':
      return BizcapTokens.colors.warning;
    case 'approved':
      return BizcapTokens.colors.success;
    case 'rejected':
      return BizcapTokens.colors.danger;
    case 'funded':
      return BizcapTokens.colors.success;
    default:
      return BizcapTokens.colors.gray[500];
  }
};

export const getApplicationStatusText = (status: Application['status']): string => {
  switch (status) {
    case 'draft':
      return 'Draft';
    case 'submitted':
      return 'Submitted';
    case 'reviewing':
      return 'Under Review';
    case 'approved':
      return 'Approved';
    case 'rejected':
      return 'Rejected';
    case 'funded':
      return 'Funded';
    default:
      return 'Unknown';
  }
};

// Progress calculation
export const calculateProgress = (application: Application): number => {
  const { currentStep, totalSteps } = application.progress;
  return Math.round((currentStep / totalSteps) * 100);
};

// Validation helpers
export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

export const validatePhone = (phone: string): boolean => {
  const phoneRegex = /^(\+61|0)[2-478]\d{8}$/;
  return phoneRegex.test(phone.replace(/\s/g, ''));
};

export const validateABN = (abn: string): boolean => {
  const abnRegex = /^\d{11}$/;
  if (!abnRegex.test(abn.replace(/\s/g, ''))) return false;
  
  // ABN validation algorithm
  const weights = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19];
  const digits = abn.replace(/\s/g, '').split('').map(Number);
  
  // Subtract 1 from first digit
  digits[0] = digits[0] - 1;
  
  const sum = digits.reduce((acc, digit, index) => acc + digit * weights[index], 0);
  
  return sum % 89 === 0;
};

// User helpers
export const getUserFullName = (user: User): string => {
  return `${user.firstName} ${user.lastName}`.trim();
};

export const getUserInitials = (user: User): string => {
  return `${user.firstName[0]}${user.lastName[0]}`.toUpperCase();
};

// Loan helpers
export const calculateMonthlyPayment = (principal: number, annualRate: number, years: number): number => {
  const monthlyRate = annualRate / 100 / 12;
  const numberOfPayments = years * 12;
  
  if (monthlyRate === 0) {
    return principal / numberOfPayments;
  }
  
  const monthlyPayment = principal * 
    (monthlyRate * Math.pow(1 + monthlyRate, numberOfPayments)) /
    (Math.pow(1 + monthlyRate, numberOfPayments) - 1);
  
  return Math.round(monthlyPayment);
};

export const calculateTotalInterest = (principal: number, annualRate: number, years: number): number => {
  const monthlyPayment = calculateMonthlyPayment(principal, annualRate, years);
  const totalPaid = monthlyPayment * years * 12;
  return Math.round(totalPaid - principal);
};

// File helpers
export const formatFileSize = (bytes: number): string => {
  if (bytes === 0) return '0 Bytes';
  
  const k = 1024;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

export const getFileExtension = (filename: string): string => {
  return filename.slice((filename.lastIndexOf('.') - 1 >>> 0) + 2);
};

export const isImageFile = (filename: string): boolean => {
  const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];
  return imageExtensions.includes(getFileExtension(filename).toLowerCase());
};

export const isPdfFile = (filename: string): boolean => {
  return getFileExtension(filename).toLowerCase() === 'pdf';
};

// Color helpers
export const hexToRgb = (hex: string): { r: number; g: number; b: number } | null => {
  const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
  return result ? {
    r: parseInt(result[1], 16),
    g: parseInt(result[2], 16),
    b: parseInt(result[3], 16)
  } : null;
};

export const rgbToHex = (r: number, g: number, b: number): string => {
  return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
};

// Storage helpers (for localStorage/AsyncStorage)
export const storage = {
  set: async (key: string, value: any): Promise<void> => {
    try {
      const serializedValue = JSON.stringify(value);
      if (typeof window !== 'undefined') {
        localStorage.setItem(key, serializedValue);
      }
      // Native AsyncStorage would be handled differently
    } catch (error) {
      console.error('Error saving to storage:', error);
    }
  },
  
  get: async <T>(key: string, defaultValue?: T): Promise<T | undefined> => {
    try {
      if (typeof window !== 'undefined') {
        const item = localStorage.getItem(key);
        return item ? JSON.parse(item) : defaultValue;
      }
      // Native AsyncStorage would be handled differently
      return defaultValue;
    } catch (error) {
      console.error('Error reading from storage:', error);
      return defaultValue;
    }
  },
  
  remove: async (key: string): Promise<void> => {
    try {
      if (typeof window !== 'undefined') {
        localStorage.removeItem(key);
      }
      // Native AsyncStorage would be handled differently
    } catch (error) {
      console.error('Error removing from storage:', error);
    }
  },
  
  clear: async (): Promise<void> => {
    try {
      if (typeof window !== 'undefined') {
        localStorage.clear();
      }
      // Native AsyncStorage would be handled differently
    } catch (error) {
      console.error('Error clearing storage:', error);
    }
  }
};

// Error handling
export class BizcapError extends Error {
  constructor(
    message: string,
    public code: string,
    public statusCode?: number
  ) {
    super(message);
    this.name = 'BizcapError';
  }
}

export const handleApiError = (error: any): BizcapError => {
  if (error instanceof BizcapError) {
    return error;
  }
  
  if (error.response) {
    // API error
    return new BizcapError(
      error.response.data?.message || 'API request failed',
      error.response.data?.code || 'API_ERROR',
      error.response.status
    );
  }
  
  if (error.request) {
    // Network error
    return new BizcapError(
      'Network error. Please check your connection.',
      'NETWORK_ERROR'
    );
  }
  
  // Unknown error
  return new BizcapError(
    error.message || 'An unexpected error occurred.',
    'UNKNOWN_ERROR'
  );
};

// Debounce utility
export const debounce = <T extends (...args: any[]) => any>(
  func: T,
  wait: number
): ((...args: Parameters<T>) => void) => {
  let timeout: NodeJS.Timeout;
  
  return (...args: Parameters<T>) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => func(...args), wait);
  };
};

// Throttle utility
export const throttle = <T extends (...args: any[]) => any>(
  func: T,
  limit: number
): ((...args: Parameters<T>) => void) => {
  let inThrottle: boolean;
  
  return (...args: Parameters<T>) => {
    if (!inThrottle) {
      func(...args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
};
```

## 3. Web Platform Setup

### 3.1 Initialize Next.js Project

```bash
cd packages/web
pnpm create next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
```

### 3.2 Install Web Dependencies

```bash
# Core dependencies
pnpm add @bizcap/design-tokens @bizcap/types @bizcap/utils
pnpm add @heroui/react @heroui/theme
pnpm add @clerk/nextjs
pnpm add convex zustand
pnpm add @radix-ui/react-toast @radix-ui/react-dialog
pnpm add framer-motion lucide-react

# Development dependencies
pnpm add -D @types/node
```

### 3.3 Configure Tailwind CSS

```javascript
// packages/web/tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
    './node_modules/@heroui/theme/dist/**/*.{js,ts,jsx,tsx}'
  ],
  theme: {
    extend: {
      colors: {
        // Import Bizcap design tokens
        primary: {
          DEFAULT: '#0066FF',
          dark: '#0052CC',
          light: '#3385FF',
        },
        accent: {
          DEFAULT: '#00D4FF',
          dark: '#00A8CC',
          light: '#33DDFF',
        },
        success: '#00C896',
        warning: '#FFB800',
        danger: '#FF3B30',
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      animation: {
        'slideUp': 'slideUp 0.5s ease-out',
        'slideDown': 'slideDown 0.5s ease-out',
        'scaleIn': 'scaleIn 0.3s ease-out',
        'fadeIn': 'fadeIn 0.6s ease-out',
        'shimmer': 'shimmer 2s infinite',
        'float': 'float 3s ease-in-out infinite',
      },
      keyframes: {
        slideUp: {
          '0%': { transform: 'translateY(20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' }
        },
        slideDown: {
          '0%': { transform: 'translateY(-20px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' }
        },
        scaleIn: {
          '0%': { transform: 'scale(0.9)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' }
        },
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' }
        },
        shimmer: {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' }
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' }
        }
      }
    },
  },
  plugins: [require('@heroui/plugin')],
}
```

### 3.4 Configure HeroUI

```typescript
// packages/web/src/providers/heroui-provider.tsx
'use client';

import { HeroUIProvider } from '@heroui/react';
import { ReactNode } from 'react';

interface ProvidersProps {
  children: ReactNode;
}

export function HeroUIProviders({ children }: ProvidersProps) {
  return (
    <HeroUIProvider>
      {children}
    </HeroUIProvider>
  );
}
```

### 3.5 Set Up Convex

```bash
# Initialize Convex
cd packages/web
npx convex dev
```

```typescript
// packages/web/convex/schema.ts
import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    email: v.string(),
    firstName: v.string(),
    lastName: v.string(),
    avatar: v.optional(v.string()),
    phone: v.optional(v.string()),
    isVerified: v.boolean(),
    preferences: v.object({
      notifications: v.object({
        push: v.boolean(),
        email: v.boolean(),
        sms: v.boolean(),
        marketing: v.boolean(),
      }),
      appearance: v.object({
        theme: v.union(v.literal('light'), v.literal('dark'), v.literal('system')),
        language: v.string(),
        currency: v.string(),
        timezone: v.string(),
      }),
      security: v.object({
        biometric: v.boolean(),
        twoFactor: v.boolean(),
      }),
    }),
    clerkId: v.string(),
  })
    .index("by_email", ["email"])
    .index("by_clerk", ["clerkId"]),
    
  applications: defineTable({
    userId: v.id("users"),
    type: v.union(
      v.literal("business_loan"),
      v.literal("equipment_finance"),
      v.literal("line_of_credit")
    ),
    amount: v.number(),
    purpose: v.string(),
    status: v.union(
      v.literal("draft"),
      v.literal("submitted"),
      v.literal("reviewing"),
      v.literal("approved"),
      v.literal("rejected"),
      v.literal("funded")
    ),
    progress: v.object({
      currentStep: v.number(),
      totalSteps: v.number(),
      completedSteps: v.array(v.string()),
      percentage: v.number(),
    }),
    documents: v.array(v.object({
      id: v.string(),
      name: v.string(),
      type: v.string(),
      url: v.string(),
      size: v.number(),
      uploadedAt: v.string(),
      status: v.union(v.literal("pending"), v.literal("verified"), v.literal("rejected")),
    })),
    timeline: v.array(v.object({
      id: v.string(),
      type: v.union(
        v.literal("status_change"),
        v.literal("document_uploaded"),
        v.literal("review_completed"),
        v.literal("note_added")
      ),
      title: v.string(),
      description: v.optional(v.string()),
      timestamp: v.string(),
      actor: v.optional(v.string()),
    })),
  })
    .index("by_user", ["userId"])
    .index("by_status", ["status"]),
    
  loans: defineTable({
    applicationId: v.id("applications"),
    amount: v.number(),
    interestRate: v.number(),
    term: v.number(),
    status: v.union(v.literal("active"), v.literal("completed"), v.literal("defaulted")),
    balance: v.number(),
    nextPaymentDate: v.string(),
    paymentAmount: v.number(),
  })
    .index("by_application", ["applicationId"])
    .index("by_status", ["status"]),
    
  events: defineTable({
    title: v.string(),
    description: v.string(),
    type: v.union(
      v.literal("workshop"),
      v.literal("networking"),
      v.literal("webinar"),
      v.literal("conference")
    ),
    date: v.string(),
    duration: v.number(),
    location: v.optional(v.string()),
    isVirtual: v.boolean(),
    maxAttendees: v.optional(v.number()),
    currentAttendees: v.number(),
    speakers: v.array(v.object({
      id: v.string(),
      name: v.string(),
      title: v.string(),
      company: v.string(),
      bio: v.string(),
      avatar: v.optional(v.string()),
      expertise: v.array(v.string()),
    })),
    tags: v.array(v.string()),
    registrationDeadline: v.string(),
    price: v.optional(v.number()),
  })
    .index("by_date", ["date"])
    .index("by_type", ["type"]),
    
  notifications: defineTable({
    userId: v.id("users"),
    type: v.union(
      v.literal("application_update"),
      v.literal("payment_reminder"),
      v.literal("event_reminder"),
      v.literal("marketing")
    ),
    title: v.string(),
    message: v.string(),
    isRead: v.boolean(),
    actionUrl: v.optional(v.string()),
  })
    .index("by_user", ["userId"])
    .index("unread", ["userId", "isRead"]),
});
```

## 4. Native Platform Setup

### 4.1 Initialize Expo Project

```bash
cd packages/native
npx create-expo-app@latest . --template
```

### 4.2 Install Native Dependencies

```bash
# Core dependencies
npx expo install @bizcap/design-tokens @bizcap/types @bizcap/utils
npx expo install @heroui/react-native
npx expo install @clerk/expo
npx expo install convex zustand
npx expo install react-native-svg react-native-reanimated
npx expo install react-native-gesture-handler react-native-screens
npx expo install expo-linear-gradient expo-blur
npx expo install expo-haptics expo-notifications

# Development dependencies
npx expo install -D @types/react @types/react-native
```

### 4.3 Configure Expo

```json
// packages/native/app.json
{
  "expo": {
    "name": "Bizcap",
    "slug": "bizcap",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "userInterfaceStyle": "automatic",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#0066FF"
    },
    "assetBundlePatterns": [
      "**/*"
    ],
    "ios": {
      "supportsTablet": true,
      "bundleIdentifier": "com.bizcap.mobile"
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png",
        "backgroundColor": "#0066FF"
      },
      "package": "com.bizcap.mobile"
    },
    "web": {
      "favicon": "./assets/favicon.png",
      "bundler": "metro"
    },
    "plugins": [
      "expo-linear-gradient",
      "expo-blur",
      [
        "expo-notifications",
        {
          "sounds": ["./assets/sounds/notification.wav"]
        }
      ]
    ]
  }
}
```

### 4.4 Configure Metro for Shared Packages

```javascript
// packages/native/metro.config.js
const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const projectRoot = __dirname;
const workspaceRoot = path.resolve(projectRoot, '../..');

const config = getDefaultConfig(projectRoot);

// Watch all files within the monorepo
config.watchFolders = [workspaceRoot];

// Let Metro find all files within the monorepo
config.resolver.nodeModulesPaths = [
  path.resolve(projectRoot, 'node_modules'),
  path.resolve(workspaceRoot, 'node_modules'),
];

// Force Metro to resolve (sub)dependencies only from the `node_modules` within the monorepo
config.resolver.disableHierarchicalLookup = true;

module.exports = config;
```

## 5. Development Scripts

### 5.1 Root Package.json Scripts

```json
{
  "scripts": {
    "setup": "pnpm install && pnpm --filter \"@bizcap/*\" build",
    "dev:web": "pnpm --filter web dev",
    "dev:native": "pnpm --filter native start",
    "build:shared": "pnpm --filter \"@bizcap/*\" build",
    "build:web": "pnpm --filter web build",
    "build:native": "pnpm --filter native build",
    "test": "pnpm --filter \"*\" test",
    "lint": "pnpm --filter \"*\" lint",
    "typecheck": "pnpm --filter \"*\" typecheck",
    "clean": "pnpm --filter \"*\" clean && rm -rf node_modules"
  }
}
```

### 5.2 Development Workflow Script

```bash
#!/bin/bash
# scripts/dev.sh

echo "🚀 Starting Bizcap Mobile App Development..."

# Start shared packages in watch mode
echo "📦 Building shared packages..."
pnpm --filter "@bizcap/*" dev &

# Start Convex backend
echo "🔧 Starting Convex backend..."
cd packages/web && npx convex dev &

# Start web development server
echo "🌐 Starting web development server..."
pnpm dev:web &

# Start native development server
echo "📱 Starting native development server..."
pnpm dev:native &

echo "✅ All services started!"
echo "🌐 Web: http://localhost:3000"
echo "📱 Native: Scan QR code in terminal"
echo "🔧 Convex: http://localhost:3001"

wait
```

## 6. Testing Setup

### 6.1 Jest Configuration

```json
// packages/shared/jest.config.json
{
  "preset": "ts-jest",
  "testEnvironment": "node",
  "roots": ["<rootDir>/src"],
  "testMatch": ["**/__tests__/**/*.ts", "**/?(*.)+(spec|test).ts"],
  "collectCoverageFrom": [
    "src/**/*.ts",
    "!src/**/*.d.ts",
    "!src/**/index.ts"
  ]
}
```

### 6.2 Component Testing Setup

```json
// packages/web/jest.config.json
{
  "preset": "next/jest",
  "testEnvironment": "jsdom",
  "setupFilesAfterEnv": ["<rootDir>/jest.setup.js"],
  "moduleNameMapping": {
    "^@/(.*)$": "<rootDir>/src/$1"
  }
}
```

## 7. CI/CD Setup

### 7.1 GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'pnpm'
          
      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 8
          
      - name: Install dependencies
        run: pnpm install
        
      - name: Build shared packages
        run: pnpm build:shared
        
      - name: Run tests
        run: pnpm test
        
      - name: Run linting
        run: pnpm lint
        
      - name: Type check
        run: pnpm typecheck
        
  build-web:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'pnpm'
          
      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 8
          
      - name: Install dependencies
        run: pnpm install
        
      - name: Build web
        run: pnpm build:web
        
  build-native:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'pnpm'
          
      - name: Setup Expo
        uses: expo/expo-github-action@v8
        with:
          expo-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
          
      - name: Install pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 8
          
      - name: Install dependencies
        run: pnpm install
        
      - name: Build native
        run: pnpm build:native
```

## 8. Next Steps

### 8.1 Immediate Actions

1. **Run Setup Script**
   ```bash
   chmod +x scripts/dev.sh
   ./scripts/dev.sh
   ```

2. **Verify All Services**
   - Web: http://localhost:3000
   - Native: Expo Go app
   - Convex: http://localhost:3001

3. **Create First Component**
   - Build shared button component
   - Implement in both platforms
   - Test parity

### 8.2 Development Priorities

1. **Week 1**: Foundation setup and authentication
2. **Week 2**: Core components and navigation
3. **Week 3**: User profile and settings
4. **Week 4**: Loan discovery and applications

This setup ensures complete design and feature parity from the start, with shared infrastructure driving consistency across both platforms.