# Bizcap Mobile App: Comprehensive CI/CD Pipeline

## Overview

This document outlines the complete CI/CD strategy for Bizcap mobile applications using GitLab/Harness for orchestration, Railway for backend services, Vercel for web deployment, and EAS for native deployment.

## Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   GitLab/Harness │───▶│    Railway      │───▶│   Vercel (Web)  │
│   CI/CD Pipeline│    │  Backend Services│    │  Next.js 16     │
│                 │    │                 │    │  AI SDK 6       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Testing       │    │   Convex DB     │    │   EAS (Native)  │
│   Coverage      │    │   Real-time     │    │   Expo 54       │
│   90%+ Target    │    │   Database      │    │   App Stores    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Environment Strategy

### Environments
- **Development**: `dev` - Feature branches and PR testing
- **Staging**: `staging` - Pre-production validation
- **Production**: `prod` - Live customer-facing applications

### Deployment Targets
- **Web**: Vercel (dev/staging/prod preview deployments)
- **Native**: EAS Build (development builds, TestFlight, App Stores)
- **Backend**: Railway (Convex functions, API services)
- **AI Services**: Railway (AI SDK 6 integration)

## 1. GitLab CI/CD Configuration

### 1.1 Main GitLab CI Pipeline

```yaml
# .gitlab-ci.yml
stages:
  - validate
  - test
  - build
  - security
  - deploy-dev
  - integration-test
  - deploy-staging
  - e2e-test
  - deploy-prod

variables:
  NODE_VERSION: "20"
  PNPM_VERSION: "8"
  CACHE_KEY: "$CI_COMMIT_REF_SLUG"

# Cache configuration
cache:
  key: $CACHE_KEY
  paths:
    - .pnpm-store/
    - node_modules/
    - packages/*/node_modules/
    - .next/cache/

# Base image
image: node:20-slim

before_script:
  - corepack enable
  - corepack prepare pnpm@latest --activate
  - pnpm config set store-dir .pnpm-store

# Validation Stage
validate:code:
  stage: validate
  script:
    - pnpm install --frozen-lockfile
    - pnpm lint
    - pnpm typecheck
    - pnpm format:check
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

validate:dependencies:
  stage: validate
  script:
    - pnpm audit --audit-level moderate
    - pnpm outdated
  allow_failure: true
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

# Testing Stage
test:unit:
  stage: test
  coverage: '/Lines\s*:\s*(\d+\.\d+)%/'
  script:
    - pnpm install --frozen-lockfile
    - pnpm test:unit --coverage --ci
    - pnpm test:coverage:report
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - coverage/
    expire_in: 1 week
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

test:integration:
  stage: test
  script:
    - pnpm install --frozen-lockfile
    - pnpm test:integration
  services:
    - name: postgres:15
      alias: postgres
    - name: redis:7
      alias: redis
  variables:
    POSTGRES_DB: test_db
    POSTGRES_USER: test_user
    POSTGRES_PASSWORD: test_pass
    DATABASE_URL: postgresql://test_user:test_pass@postgres:5432/test_db
    REDIS_URL: redis://redis:6379
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

test:visual:
  stage: test
  script:
    - pnpm install --frozen-lockfile
    - pnpm test:visual
  artifacts:
    paths:
      - visual-tests/
    expire_in: 1 week
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

# Build Stage
build:web:
  stage: build
  script:
    - pnpm install --frozen-lockfile
    - pnpm build:web
    - pnpm build:analyze
  artifacts:
    paths:
      - packages/web/.next/
      - packages/web/out/
      - build-analysis/
    expire_in: 1 hour
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

build:native:
  stage: build
  script:
    - pnpm install --frozen-lockfile
    - pnpm build:native
  artifacts:
    paths:
      - packages/native/dist/
    expire_in: 1 hour
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

build:shared:
  stage: build
  script:
    - pnpm install --frozen-lockfile
    - pnpm build:shared
  artifacts:
    paths:
      - packages/shared/*/dist/
    expire_in: 1 hour
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

# Security Stage
security:scan:
  stage: security
  script:
    - pnpm audit --audit-level moderate
    - npm install -g @vercel/ncc
    - pnpm security:scan
  artifacts:
    paths:
      - security-reports/
    expire_in: 1 week
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

security:dependencies:
  stage: security
  script:
    - pnpm install --frozen-lockfile
    - pnpm audit --audit-level moderate --json > audit-report.json
  artifacts:
    paths:
      - audit-report.json
    expire_in: 1 week
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

# Deploy to Development
deploy:dev:web:
  stage: deploy-dev
  environment:
    name: development/web
    url: https://bizcap-dev.vercel.app
    on_stop: stop:dev:web
  script:
    - pnpm vercel:deploy --prebuilt --token $VERCEL_TOKEN
  dependencies:
    - build:web
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"

deploy:dev:native:
  stage: deploy-dev
  environment:
    name: development/native
  script:
    - pnpm eas:build --profile development --non-interactive
    - pnpm eas:submit --platform all --non-interactive
  dependencies:
    - build:native
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"

deploy:dev:backend:
  stage: deploy-dev
  environment:
    name: development/backend
    url: https://bizcap-dev.up.railway.app
  script:
    - railway login --token $RAILWAY_TOKEN
    - railway up --service $RAILWAY_SERVICE_ID -e dev
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"

# Integration Tests
test:integration:dev:
  stage: integration-test
  script:
    - pnpm test:e2e:dev
  environment:
    name: development
  dependencies:
    - deploy:dev:web
    - deploy:dev:native
    - deploy:dev:backend
  rules:
    - if: $CI_COMMIT_BRANCH == "develop"

# Deploy to Staging
deploy:staging:web:
  stage: deploy-staging
  environment:
    name: staging/web
    url: https://bizcap-staging.vercel.app
    on_stop: stop:staging:web
  script:
    - pnpm vercel:deploy --prebuilt --token $VERCEL_TOKEN
  dependencies:
    - test:integration:dev
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy:staging:native:
  stage: deploy-staging
  environment:
    name: staging/native
  script:
    - pnpm eas:build --profile preview --non-interactive
    - pnpm eas:submit --platform all --non-interactive
  dependencies:
    - test:integration:dev
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy:staging:backend:
  stage: deploy-staging
  environment:
    name: staging/backend
    url: https://bizcap-staging.up.railway.app
  script:
    - railway login --token $RAILWAY_TOKEN
    - railway up --service $RAILWAY_SERVICE_ID -e staging
  dependencies:
    - test:integration:dev
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

# E2E Tests
test:e2e:staging:
  stage: e2e-test
  script:
    - pnpm test:e2e:staging
  environment:
    name: staging
  dependencies:
    - deploy:staging:web
    - deploy:staging:native
    - deploy:staging:backend
  artifacts:
    paths:
      - e2e-results/
      - e2e-screenshots/
    expire_in: 1 week
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

# Deploy to Production
deploy:prod:web:
  stage: deploy-prod
  environment:
    name: production/web
    url: https://bizcap.vercel.app
  script:
    - pnpm vercel:deploy --prod --prebuilt --token $VERCEL_TOKEN
  dependencies:
    - test:e2e:staging
  rules:
    - if: $CI_COMMIT_TAG
    - when: manual

deploy:prod:native:
  stage: deploy-prod
  environment:
    name: production/native
  script:
    - pnpm eas:build --profile production --non-interactive
    - pnpm eas:submit --platform all --non-interactive
  dependencies:
    - test:e2e:staging
  rules:
    - if: $CI_COMMIT_TAG
    - when: manual

deploy:prod:backend:
  stage: deploy-prod
  environment:
    name: production/backend
    url: https://bizcap.up.railway.app
  script:
    - railway login --token $RAILWAY_TOKEN
    - railway up --service $RAILWAY_SERVICE_ID -e production
  dependencies:
    - test:e2e:staging
  rules:
    - if: $CI_COMMIT_TAG
    - when: manual

# Stop Development Environments
stop:dev:web:
  stage: deploy-dev
  environment:
    name: development/web
    action: stop
  script:
    - pnpm vercel:remove $VERCEL_DEPLOYMENT_URL --token $VERCEL_TOKEN
  when: manual

stop:staging:web:
  stage: deploy-staging
  environment:
    name: staging/web
    action: stop
  script:
    - pnpm vercel:remove $VERCEL_DEPLOYMENT_URL --token $VERCEL_TOKEN
  when: manual
```

## 2. Harness CI/CD Configuration

### 2.1 Harness Pipeline YAML

```yaml
# .harness/pipeline.yml
pipeline:
  name: Bizcap Mobile App Pipeline
  identifier: bizcap_mobile_app
  projectIdentifier: bizcap
  orgIdentifier: default
  tags:
    bizcap: mobile
    type: fullstack

  stages:
    - stage:
        name: Validate and Test
        identifier: validate_test
        type: CI
        spec:
          cloneCodebase: true
          platform:
            os: Linux
            arch: Amd64
          runtime:
            type: Cloud
            spec: {}
          execution:
            steps:
              - step:
                  type: Run
                  name: Install Dependencies
                  identifier: install_deps
                  spec:
                    connectorRef: account.dockerhub
                    image: node:20-slim
                    shell: Sh
                    command: |-
                      corepack enable
                      corepack prepare pnpm@latest --activate
                      pnpm install --frozen-lockfile

              - step:
                  type: Run
                  name: Lint and Type Check
                  identifier: lint_typecheck
                  spec:
                    connectorRef: account.dockerhub
                    image: node:20-slim
                    shell: Sh
                    command: |-
                      pnpm lint
                      pnpm typecheck
                      pnpm format:check

              - step:
                  type: Run
                  name: Unit Tests
                  identifier: unit_tests
                  spec:
                    connectorRef: account.dockerhub
                    image: node:20-slim
                    shell: Sh
                    command: |-
                      pnpm test:unit --coverage --ci
                      pnpm test:coverage:report
                  reports:
                    type: JUnit
                    spec:
                      paths:
                        - coverage/junit.xml

    - stage:
        name: Build Applications
        identifier: build_apps
        type: CI
        spec:
          cloneCodebase: true
          platform:
            os: Linux
            arch: Amd64
          runtime:
            type: Cloud
            spec: {}
          execution:
            steps:
              - step:
                  type: Run
                  name: Build Web
                  identifier: build_web
                  spec:
                    connectorRef: account.dockerhub
                    image: node:20-slim
                    shell: Sh
                    command: |-
                      pnpm build:web
                  artifacts:
                    name: web_build
                    paths:
                      - packages/web/.next/
                      - packages/web/out/

              - step:
                  type: Run
                  name: Build Native
                  identifier: build_native
                  spec:
                    connectorRef: account.dockerhub
                    image: node:20-slim
                    shell: Sh
                    command: |-
                      pnpm build:native
                  artifacts:
                    name: native_build
                    paths:
                      - packages/native/dist/

    - stage:
        name: Deploy to Development
        identifier: deploy_dev
        type: Deployment
        spec:
          serviceConfig:
            serviceRef: bizcap_web_service
            environmentRef: bizcap_dev
          deploymentType: Custom
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Deploy Web to Vercel
                  identifier: deploy_web_vercel
                  spec:
                    shell: Sh
                    source:
                      type: Inline
                      spec:
                        script: |-
                          pnpm vercel:deploy --prebuilt --token $VERCEL_TOKEN

              - step:
                  type: ShellScript
                  name: Deploy Native to EAS
                  identifier: deploy_native_eas
                  spec:
                    shell: Sh
                    source:
                      type: Inline
                      spec:
                        script: |-
                          pnpm eas:build --profile development --non-interactive
                          pnpm eas:submit --platform all --non-interactive

              - step:
                  type: ShellScript
                  name: Deploy Backend to Railway
                  identifier: deploy_backend_railway
                  spec:
                    shell: Sh
                    source:
                      type: Inline
                      spec:
                        script: |-
                          railway login --token $RAILWAY_TOKEN
                          railway up --service $RAILWAY_SERVICE_ID -e dev

    - stage:
        name: Integration Tests
        identifier: integration_tests
        type: CI
        spec:
          cloneCodebase: true
          platform:
            os: Linux
            arch: Amd64
          runtime:
            type: Cloud
            spec: {}
          execution:
            steps:
              - step:
                  type: Run
                  name: Run E2E Tests
                  identifier: e2e_tests
                  spec:
                    connectorRef: account.dockerhub
                    image: node:20-slim
                    shell: Sh
                    command: |-
                      pnpm test:e2e:dev
                  reports:
                    type: JUnit
                    spec:
                      paths:
                        - e2e-results/junit.xml

    - stage:
        name: Deploy to Staging
        identifier: deploy_staging
        type: Deployment
        spec:
          serviceConfig:
            serviceRef: bizcap_web_service
            environmentRef: bizcap_staging
          deploymentType: Custom
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Deploy Web to Vercel
                  identifier: deploy_web_vercel_staging
                  spec:
                    shell: Sh
                    source:
                      type: Inline
                      spec:
                        script: |-
                          pnpm vercel:deploy --prebuilt --token $VERCEL_TOKEN

              - step:
                  type: ShellScript
                  name: Deploy Native to EAS
                  identifier: deploy_native_eas_staging
                  spec:
                    shell: Sh
                    source:
                      type: Inline
                      spec:
                        script: |-
                          pnpm eas:build --profile preview --non-interactive
                          pnpm eas:submit --platform all --non-interactive

    - stage:
        name: Deploy to Production
        identifier: deploy_prod
        type: Deployment
        spec:
          serviceConfig:
            serviceRef: bizcap_web_service
            environmentRef: bizcap_production
          deploymentType: Custom
          execution:
            steps:
              - step:
                  type: ShellScript
                  name: Deploy Web to Vercel
                  identifier: deploy_web_vercel_prod
                  spec:
                    shell: Sh
                    source:
                      type: Inline
                      spec:
                        script: |-
                          pnpm vercel:deploy --prod --prebuilt --token $VERCEL_TOKEN

              - step:
                  type: ShellScript
                  name: Deploy Native to EAS
                  identifier: deploy_native_eas_prod
                  spec:
                    shell: Sh
                    source:
                      type: Inline
                      spec:
                        script: |-
                          pnpm eas:build --profile production --non-interactive
                          pnpm eas:submit --platform all --non-interactive
```

## 3. Railway Configuration

### 3.1 Railway Service Configuration

```toml
# railway.toml
[build]
builder = "NIXPACKS"

[deploy]
healthcheckPath = "/api/health"
healthcheckTimeout = 100
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 10

[[services]]
name = "bizcap-api"
source = "."
[services.variables]
NODE_ENV = "production"
PORT = "8080"

[[services]]
name = "bizcap-convex"
source = "./convex"
[services.variables]
CONVEX_DEPLOYMENT = "${CONVEX_DEPLOYMENT}"
CONVEX_URL = "${CONVEX_URL}"

[[services]]
name = "bizcap-ai-service"
source = "./ai-service"
[services.variables]
OPENAI_API_KEY = "${OPENAI_API_KEY}"
ANTHROPIC_API_KEY = "${ANTHROPIC_API_KEY}"
```

### 3.2 Railway Dockerfile

```dockerfile
# Dockerfile
FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy package files
COPY package.json pnpm-lock.yaml ./
COPY packages/shared/package.json ./packages/shared/
COPY packages/web/package.json ./packages/web/
COPY packages/native/package.json ./packages/native/

# Install dependencies
RUN pnpm install --frozen-lockfile

# Build the application
FROM base AS builder
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@latest --activate

COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build shared packages
RUN pnpm build:shared

# Build web application
RUN pnpm build:web

# Production image
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built application
COPY --from=builder /app/packages/web/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/packages/web/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/packages/web/.next/static ./.next/static

USER nextjs

EXPOSE 8080

ENV PORT 8080
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
```

## 4. Vercel Configuration

### 4.1 Vercel Configuration

```json
// vercel.json
{
  "version": 2,
  "name": "bizcap",
  "buildCommand": "pnpm build:web",
  "outputDirectory": "packages/web/out",
  "installCommand": "pnpm install",
  "framework": "nextjs",
  "regions": ["syd1", "hkg1"],
  "functions": {
    "packages/web/app/api/**/*.ts": {
      "maxDuration": 30
    }
  },
  "env": {
    "NEXT_PUBLIC_APP_URL": "@app-url",
    "NEXT_PUBLIC_CONVEX_URL": "@convex-url",
    "CONVEX_DEPLOYMENT": "@convex-deployment"
  },
  "build": {
    "env": {
      "NEXT_PUBLIC_APP_URL": "@app-url",
      "NEXT_PUBLIC_CONVEX_URL": "@convex-url",
      "CONVEX_DEPLOYMENT": "@convex-deployment"
    }
  },
  "alias": [
    {
      "domain": "bizcap.vercel.app"
    },
    {
      "domain": "www.bizcap.com.au"
    }
  ],
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "s-maxage=60, stale-while-revalidate"
        }
      ]
    },
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ],
  "rewrites": [
    {
      "source": "/api/webhooks/:path*",
      "destination": "/api/webhooks/:path*"
    }
  ]
}
```

### 4.2 Next.js Configuration with AI SDK 6

```javascript
// packages/web/next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    serverActions: true,
    serverComponentsExternalPackages: ['@convex-dev/auth'],
  },
  images: {
    domains: ['images.unsplash.com', 'avatars.githubusercontent.com'],
    formats: ['image/webp', 'image/avif'],
  },
  async rewrites() {
    return [
      {
        source: '/dashboard',
        destination: '/dashboard/overview',
      },
    ];
  },
  async redirects() {
    return [
      {
        source: '/home',
        destination: '/dashboard',
        permanent: true,
      },
    ];
  },
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
      };
    }
    return config;
  },
  env: {
    NEXT_PUBLIC_CONVEX_URL: process.env.NEXT_PUBLIC_CONVEX_URL,
    NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY: process.env.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY,
  },
  // AI SDK 6 Configuration
  async headers() {
    return [
      {
        source: '/api/ai/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'no-store, must-revalidate',
          },
        ],
      },
    ];
  },
};

module.exports = nextConfig;
```

## 5. EAS Configuration

### 5.1 EAS Configuration

```json
// app.json (Expo)
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
      "bundleIdentifier": "com.bizcap.mobile",
      "buildNumber": "1.0.0",
      "infoPlist": {
        "NSCameraUsageDescription": "Bizcap needs access to your camera to scan documents",
        "NSPhotoLibraryUsageDescription": "Bizcap needs access to your photo library to upload documents",
        "NSFaceIDUsageDescription": "Bizcap uses Face ID to secure your account"
      }
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png",
        "backgroundColor": "#0066FF"
      },
      "package": "com.bizcap.mobile",
      "versionCode": 1,
      "permissions": [
        "CAMERA",
        "READ_EXTERNAL_STORAGE",
        "WRITE_EXTERNAL_STORAGE"
      ]
    },
    "web": {
      "favicon": "./assets/favicon.png",
      "bundler": "metro"
    },
    "plugins": [
      "expo-linear-gradient",
      "expo-blur",
      "expo-secure-store",
      [
        "expo-notifications",
        {
          "sounds": ["./assets/sounds/notification.wav"],
          "icon": "./assets/notification-icon.png",
          "color": "#0066FF"
        }
      ],
      [
        "expo-camera",
        {
          "cameraPermission": "Allow Bizcap to access your camera"
        }
      ],
      [
        "expo-file-system",
        {
          "newFileIntentAction": "VIEW"
        }
      ]
    ],
    "extra": {
      "eas": {
        "projectId": "your-project-id"
      }
    },
    "owner": "danmarauda",
    "runtimeVersion": {
      "policy": "sdkVersion"
    },
    "updates": {
      "url": "https://u.expo.dev/your-project-id"
    },
    "hooks": {
      "postPublish": [
        {
          "file": "sentry-expo/upload-sourcemaps",
          "config": {
            "organization": "bizcap",
            "project": "mobile-app"
          }
        }
      ]
    }
  }
}
```

### 5.2 EAS Build Profiles

```json
// eas.json
{
  "cli": {
    "version": ">= 3.0.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal",
      "channel": "development",
      "ios": {
        "resourceClass": "m1-medium"
      },
      "android": {
        "resourceClass": "medium"
      }
    },
    "preview": {
      "distribution": "internal",
      "channel": "preview",
      "ios": {
        "resourceClass": "m1-medium"
      },
      "android": {
        "resourceClass": "medium"
      }
    },
    "production": {
      "channel": "production",
      "ios": {
        "resourceClass": "m1-medium"
      },
      "android": {
        "resourceClass": "medium",
        "buildType": "apk"
      }
    },
    "storybook": {
      "developmentClient": true,
      "distribution": "internal",
      "channel": "storybook"
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "your-apple-id",
        "ascAppId": "your-app-id",
        "appleTeamId": "your-team-id"
      },
      "android": {
        "serviceAccountKeyPath": "./google-service-account.json",
        "track": "production"
      }
    }
  }
}
```

## 6. Testing Configuration

### 6.1 Jest Configuration

```javascript
// jest.config.js
const nextJest = require('next/jest');

const createJestConfig = nextJest({
  dir: './packages/web',
});

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  testEnvironment: 'jest-environment-jsdom',
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/*.stories.{js,jsx,ts,tsx}',
    '!src/**/index.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  testMatch: [
    '<rootDir>/src/**/__tests__/**/*.{js,jsx,ts,tsx}',
    '<rootDir>/src/**/*.{test,spec}.{js,jsx,ts,tsx}',
  ],
  transform: {
    '^.+\\.(js|jsx|ts|tsx)$': ['babel-jest', { presets: ['next/babel'] }],
  },
};

module.exports = createJestConfig(customJestConfig);
```

### 6.2 Playwright E2E Configuration

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html'],
    ['junit', { outputFile: 'e2e-results/junit.xml' }],
    ['json', { outputFile: 'e2e-results/results.json' }],
  ],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
    {
      name: 'Mobile Chrome',
      use: { ...devices['Pixel 5'] },
    },
    {
      name: 'Mobile Safari',
      use: { ...devices['iPhone 12'] },
    },
  ],
  webServer: {
    command: 'pnpm dev:web',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

## 7. AI SDK 6 Integration

### 7.1 AI Service Configuration

```typescript
// packages/ai-service/src/index.ts
import { OpenAI } from '@openai/openai';
import { Anthropic } from '@anthropic-ai/sdk';
import { streamText } from 'ai';

// OpenAI Configuration
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Anthropic Configuration
const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

// AI SDK 6 Configuration
export const aiConfig = {
  models: {
    openai: {
      'gpt-4-turbo': 'gpt-4-turbo-preview',
      'gpt-3.5-turbo': 'gpt-3.5-turbo-0125',
    },
    anthropic: {
      'claude-3-opus': 'claude-3-opus-20240229',
      'claude-3-sonnet': 'claude-3-sonnet-20240229',
    },
  },
  settings: {
    temperature: 0.7,
    maxTokens: 2000,
    topP: 0.9,
    frequencyPenalty: 0.5,
    presencePenalty: 0.5,
  },
};

// AI Functions for Bizcap
export const aiFunctions = {
  // Loan Application Analysis
  analyzeApplication: async (applicationData: any) => {
    const prompt = `Analyze this loan application for Bizcap: ${JSON.stringify(applicationData)}`;
    
    const result = await streamText({
      model: openai(aiConfig.models.openai['gpt-4-turbo']),
      prompt,
      maxTokens: aiConfig.settings.maxTokens,
      temperature: aiConfig.settings.temperature,
    });

    return result;
  },

  // Financial Advice
  getFinancialAdvice: async (userProfile: any, query: string) => {
    const prompt = `Provide financial advice for this user profile: ${JSON.stringify(userProfile)}\nQuery: ${query}`;
    
    const result = await streamText({
      model: anthropic(aiConfig.models.anthropic['claude-3-sonnet']),
      prompt,
      maxTokens: aiConfig.settings.maxTokens,
      temperature: aiConfig.settings.temperature,
    });

    return result;
  },

  // Document Analysis
  analyzeDocument: async (documentText: string, documentType: string) => {
    const prompt = `Analyze this ${documentType} document for loan application: ${documentText}`;
    
    const result = await streamText({
      model: openai(aiConfig.models.openai['gpt-4-turbo']),
      prompt,
      maxTokens: aiConfig.settings.maxTokens,
      temperature: aiConfig.settings.temperature,
    });

    return result;
  },

  // Risk Assessment
  assessRisk: async (applicationData: any, businessData: any) => {
    const prompt = `Assess risk for this loan application: ${JSON.stringify(applicationData)}\nBusiness data: ${JSON.stringify(businessData)}`;
    
    const result = await streamText({
      model: anthropic(aiConfig.models.anthropic['claude-3-opus']),
      prompt,
      maxTokens: aiConfig.settings.maxTokens,
      temperature: aiConfig.settings.temperature,
    });

    return result;
  },
};
```

### 7.2 Next.js AI API Routes

```typescript
// packages/web/src/app/api/ai/analyze/route.ts
import { aiFunctions } from '@bizcap/ai-service';
import { NextRequest } from 'next/server';

export async function POST(req: NextRequest) {
  try {
    const { applicationData } = await req.json();

    if (!applicationData) {
      return Response.json(
        { error: 'Application data is required' },
        { status: 400 }
      );
    }

    const result = await aiFunctions.analyzeApplication(applicationData);

    return Response.json(result);
  } catch (error) {
    console.error('AI analysis error:', error);
    return Response.json(
      { error: 'Failed to analyze application' },
      { status: 500 }
    );
  }
}

// packages/web/src/app/api/ai/advice/route.ts
import { aiFunctions } from '@bizcap/ai-service';
import { NextRequest } from 'next/server';

export async function POST(req: NextRequest) {
  try {
    const { userProfile, query } = await req.json();

    if (!userProfile || !query) {
      return Response.json(
        { error: 'User profile and query are required' },
        { status: 400 }
      );
    }

    const result = await aiFunctions.getFinancialAdvice(userProfile, query);

    return Response.json(result);
  } catch (error) {
    console.error('AI advice error:', error);
    return Response.json(
      { error: 'Failed to get financial advice' },
      { status: 500 }
    );
  }
}
```

## 8. Monitoring and Analytics

### 8.1 Sentry Configuration

```typescript
// packages/shared/monitoring/sentry.ts
import * as Sentry from '@sentry/nextjs';
import { ConvexHttpClient } from 'convex/browser';

export const initSentry = () => {
  Sentry.init({
    dsn: process.env.SENTRY_DSN,
    environment: process.env.NODE_ENV,
    tracesSampleRate: 1.0,
    debug: false,
    replaysOnErrorSampleRate: 1.0,
    replaysSessionSampleRate: 0.1,
    integrations: [
      new Sentry.Replay({
        maskAllText: true,
        blockAllMedia: true,
      }),
    ],
  });
};

// Custom error tracking
export const trackError = (error: Error, context?: any) => {
  Sentry.captureException(error, {
    contexts: { custom: context },
  });
};

// Performance tracking
export const trackPerformance = (name: string, value: number) => {
  Sentry.metrics.increment(name, value);
};
```

### 8.2 Analytics Configuration

```typescript
// packages/shared/analytics/index.ts
import { getAnalytics } from 'firebase/analytics';
import { initializeApp } from 'firebase/app';

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig);
export const analytics = getAnalytics(app);

// Custom analytics events
export const trackEvent = (eventName: string, parameters?: any) => {
  if (typeof window !== 'undefined') {
    import('firebase/analytics').then(({ logEvent }) => {
      logEvent(analytics, eventName, parameters);
    });
  }
};

// Business-specific events
export const analyticsEvents = {
  // Application events
  applicationStarted: (applicationType: string) => 
    trackEvent('application_started', { type: applicationType }),
  
  applicationCompleted: (applicationId: string, amount: number) => 
    trackEvent('application_completed', { applicationId, amount }),
  
  // User events
  userRegistered: (userId: string) => 
    trackEvent('user_registered', { userId }),
  
  userLoggedIn: (userId: string) => 
    trackEvent('user_logged_in', { userId }),
  
  // Loan events
  loanApproved: (loanId: string, amount: number) => 
    trackEvent('loan_approved', { loanId, amount }),
  
  loanDisbursed: (loanId: string, amount: number) => 
    trackEvent('loan_disbursed', { loanId, amount }),
  
  // AI events
  aiAnalysisRequested: (analysisType: string) => 
    trackEvent('ai_analysis_requested', { type: analysisType }),
  
  aiAdviceGenerated: (adviceType: string) => 
    trackEvent('ai_advice_generated', { type: adviceType }),
};
```

## 9. Security Configuration

### 9.1 Security Headers and Middleware

```typescript
// packages/web/src/middleware.ts
import { createMiddleware } from 'next-intl/middleware';
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // Security headers
  const response = NextResponse.next();
  
  response.headers.set('X-Content-Type-Options', 'nosniff');
  response.headers.set('X-Frame-Options', 'DENY');
  response.headers.set('X-XSS-Protection', '1; mode=block');
  response.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
  response.headers.set('Permissions-Policy', 'camera=(), microphone=(), geolocation=()');
  
  // Rate limiting headers
  response.headers.set('X-RateLimit-Limit', '100');
  response.headers.set('X-RateLimit-Remaining', '99');
  response.headers.set('X-RateLimit-Reset', new Date(Date.now() + 3600000).toISOString());
  
  // Content Security Policy
  const csp = [
    "default-src 'self'",
    "script-src 'self' 'unsafe-eval' 'unsafe-inline' https://vercel.live",
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
    "font-src 'self' https://fonts.gstatic.com",
    "img-src 'self' data: https: blob:",
    "connect-src 'self' https://api.convex.dev https://clerk.bizcap.com.au",
    "frame-src 'none'",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
  ].join('; ');
  
  response.headers.set('Content-Security-Policy', csp);
  
  return response;
}

export const config = {
  matcher: [
    '/((?!api|_next/static|_next/image|favicon.ico).*)',
  ],
};
```

### 9.2 Environment Variables Management

```bash
# .env.example
# Database
CONVEX_DEPLOYMENT=your-convex-deployment
CONVEX_URL=your-convex-url

# Authentication
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=your-clerk-publishable-key
CLERK_SECRET_KEY=your-clerk-secret-key

# AI Services
OPENAI_API_KEY=your-openai-api-key
ANTHROPIC_API_KEY=your-anthropic-api-key

# Deployment
VERCEL_TOKEN=your-vercel-token
RAILWAY_TOKEN=your-railway-token
EAS_TOKEN=your-eas-token

# Monitoring
SENTRY_DSN=your-sentry-dsn
NEXT_PUBLIC_FIREBASE_API_KEY=your-firebase-api-key
NEXT_PUBLIC_FIREBASE_PROJECT_ID=your-firebase-project-id

# Security
NEXT_PUBLIC_APP_URL=https://bizcap.vercel.app
ALLOWED_ORIGINS=https://bizcap.vercel.app,https://bizcap-staging.vercel.app
```

## 10. Deployment Scripts

### 10.1 Package.json Scripts

```json
{
  "scripts": {
    "dev": "concurrently \"pnpm dev:web\" \"pnpm dev:native\" \"pnpm dev:backend\"",
    "dev:web": "pnpm --filter web dev",
    "dev:native": "pnpm --filter native start",
    "dev:backend": "pnpm --filter backend dev",
    
    "build": "pnpm build:shared && pnpm build:web && pnpm build:native",
    "build:shared": "pnpm --filter \"@bizcap/*\" build",
    "build:web": "pnpm --filter web build",
    "build:native": "pnpm --filter native build",
    
    "test": "pnpm test:unit && pnpm test:integration && pnpm test:e2e",
    "test:unit": "jest",
    "test:integration": "jest --config jest.integration.config.js",
    "test:e2e": "playwright test",
    "test:visual": "playwright test --config playwright.visual.config.ts",
    "test:coverage": "jest --coverage",
    "test:coverage:report": "codecov",
    
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx",
    "lint:fix": "eslint . --ext .ts,.tsx,.js,.jsx --fix",
    "typecheck": "tsc --noEmit",
    "format": "prettier --write .",
    "format:check": "prettier --check .",
    
    "deploy:dev": "pnpm deploy:dev:web && pnpm deploy:dev:native && pnpm deploy:dev:backend",
    "deploy:dev:web": "vercel --token $VERCEL_TOKEN",
    "deploy:dev:native": "eas build --profile development --non-interactive",
    "deploy:dev:backend": "railway up --service $RAILWAY_SERVICE_ID -e dev",
    
    "deploy:staging": "pnpm deploy:staging:web && pnpm deploy:staging:native && pnpm deploy:staging:backend",
    "deploy:staging:web": "vercel --token $VERCEL_TOKEN",
    "deploy:staging:native": "eas build --profile preview --non-interactive",
    "deploy:staging:backend": "railway up --service $RAILWAY_SERVICE_ID -e staging",
    
    "deploy:prod": "pnpm deploy:prod:web && pnpm deploy:prod:native && pnpm deploy:prod:backend",
    "deploy:prod:web": "vercel --prod --token $VERCEL_TOKEN",
    "deploy:prod:native": "eas build --profile production --non-interactive",
    "deploy:prod:backend": "railway up --service $RAILWAY_SERVICE_ID -e production",
    
    "security:audit": "pnpm audit --audit-level moderate",
    "security:scan": "npm audit --json > security-report.json",
    
    "vercel:deploy": "vercel deploy --prebuilt --token $VERCEL_TOKEN",
    "vercel:remove": "vercel remove $VERCEL_DEPLOYMENT_URL --token $VERCEL_TOKEN",
    
    "eas:build": "eas build --non-interactive",
    "eas:submit": "eas submit --platform all --non-interactive",
    "eas:update": "eas update --non-interactive",
    
    "railway:login": "railway login --token $RAILWAY_TOKEN",
    "railway:up": "railway up --service $RAILWAY_SERVICE_ID"
  }
}
```

## 11. Quality Gates and Policies

### 11.1 Branch Protection Rules

```yaml
# .github/branch-protection.yml
protection_rules:
  main:
    required_status_checks:
      strict: true
      contexts:
        - "validate/code"
        - "test/unit"
        - "test/integration"
        - "security/scan"
        - "build/web"
        - "build/native"
    enforce_admins: true
    required_pull_request_reviews:
      required_approving_review_count: 2
      dismiss_stale_reviews: true
      require_code_owner_reviews: true
    restrictions:
      users: []
      teams: ["bizcap-developers"]
```

### 11.2 Quality Gates Configuration

```yaml
# quality-gates.yml
quality_gates:
  code_coverage:
    minimum: 80
    target: 90
    
  performance_budget:
    web:
      first_contentful_paint: 1500
      largest_contentful_paint: 2500
      cumulative_layout_shift: 0.1
      first_input_delay: 100
    native:
      app_launch_time: 2000
      screen_transition: 300
      memory_usage: 150
      
  security_scan:
    max_vulnerabilities: 0
    allowed_severity: ["low"]
    
  accessibility:
    minimum_score: 95
    tools: ["lighthouse", "axe"]
    
  bundle_size:
    web_max: 500KB
    native_max: 100MB
```

This comprehensive CI/CD setup ensures:
- ✅ Full testing coverage (unit, integration, E2E, visual)
- ✅ Multi-environment deployment (dev, staging, prod)
- ✅ Cross-platform parity (web + native)
- ✅ AI/ML integration with SDK 6
- ✅ Security scanning and monitoring
- ✅ Performance optimization
- ✅ Automated quality gates
- ✅ Railway backend integration
- ✅ Vercel web deployment
- ✅ EAS native deployment

The pipeline follows best practices from Expo, Software Mansion, and modern DevOps practices.