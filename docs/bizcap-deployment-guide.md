# Bizcap Deployment Guide

## Overview

This guide covers deploying the Bizcap S-Tier mobile app and web platform using our comprehensive CI/CD pipeline.

## Prerequisites

### Required Accounts
- **GitHub**: Repository hosting (already set up)
- **Railway**: Backend services (API, Convex, AI Service)
- **Vercel**: Web frontend deployment
- **Expo/EAS**: Native mobile app deployment
- **Clerk**: Authentication service
- **Convex**: Real-time backend database

### CLI Tools Installation
```bash
# Install all required CLI tools
npm install -g @railway/cli vercel-cli eas-cli

# Verify installations
railway --version    # Should be 4.11.1+
vercel --version     # Should be latest
eas --version        # Should be latest
```

## 1. Railway Backend Setup

### 1.1 Initialize Railway Project
```bash
# Navigate to project root
cd /Users/alias/bizcap-reference

# Link to Railway (requires interactive login)
railway link

# Or create new project
railway new
```

### 1.2 Configure Environment Variables
```bash
# Set up environment variables in Railway dashboard
# Copy from .env.railway.example and fill in actual values

# Required variables:
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
CONVEX_DEPLOYMENT=convex:...
CONVEX_URL=https://convex.site.com
```

### 1.3 Deploy Services
```bash
# Deploy all services
railway up

# Monitor deployment
railway status
railway logs
```

### 1.4 Railway Services Structure
- **bizcap-api**: Main API service (Express.js)
- **bizcap-convex**: Convex real-time backend
- **bizcap-ai-service**: AI integration service

## 2. Vercel Web Frontend Setup

### 2.1 Connect Repository to Vercel
```bash
# Install Vercel CLI and login
vercel login

# Connect project
vercel link

# Deploy for first time
vercel --prod
```

### 2.2 Configure Environment Variables
```bash
# Set environment variables in Vercel dashboard
# Copy from .env.vercel.example

# Required variables:
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_...
CLERK_SECRET_KEY=sk_...
DATABASE_URL=postgresql://...
NEXT_PUBLIC_CONVEX_URL=https://convex.site.com
```

### 2.3 Vercel Configuration
- **Build Command**: `npm run build`
- **Output Directory**: `.next`
- **Install Command**: `npm install`
- **Framework Preset**: Next.js

## 3. Expo/EAS Native Mobile Setup

### 3.1 Initialize EAS Project
```bash
# Login to Expo
eas login

# Initialize EAS project
eas project:init

# Configure build profiles
eas build:configure
```

### 3.2 Set Up Environment Variables
```bash
# Configure environment variables
# Copy from .env.eas.example

# Required variables:
EXPO_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_...
EXPO_PUBLIC_API_URL=https://your-api.railway.app
EAS_PROJECT_ID=your_eas_project_id
```

### 3.3 Build for Development
```bash
# Development build
eas build --profile development --platform all

# Preview build
eas build --profile preview --platform all
```

### 3.4 Production Deployment
```bash
# Production build for App Store
eas build --profile production --platform all

# Submit to stores
eas submit --platform ios
eas submit --platform android
```

## 4. Convex Backend Setup

### 4.1 Initialize Convex Project
```bash
# Navigate to web directory
cd packages/web

# Initialize Convex
npx convex dev

# Deploy to production
npx convex deploy
```

### 4.2 Configure Convex Environment
```bash
# Set Convex deployment variables
# In Railway and Vercel dashboards:
CONVEX_DEPLOYMENT=convex:your-deployment-id
NEXT_PUBLIC_CONVEX_URL=https://your-deployment.convex.cloud
```

## 5. Clerk Authentication Setup

### 5.1 Configure Clerk Application
```bash
# Create Clerk application at https://dashboard.clerk.com
# Configure OAuth providers (Google, Apple, etc.)
# Set up redirect URLs:
# - Web: https://your-app.vercel.app
# - Mobile: exp://your-expo-account
```

### 5.2 Environment Variables
```bash
# Copy Clerk keys to all platforms:
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_...
CLERK_SECRET_KEY=sk_...
EXPO_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_...
```

## 6. CI/CD Pipeline Monitoring

### 6.1 GitLab CI/CD
- **Pipeline URL**: https://gitlab.com/your-username/bizcap-reference/-/pipelines
- **Stages**: Test → Security → Build → Deploy
- **Environment Promotion**: dev → staging → prod

### 6.2 Monitoring Commands
```bash
# Railway monitoring
railway status
railway logs --service bizcap-api

# Vercel monitoring
vercel logs

# EAS monitoring
eas build:list
eas submit:list
```

## 7. Quality Gates & Testing

### 7.1 Automated Testing
```bash
# Run tests locally
npm run test          # Unit tests
npm run test:e2e      # End-to-end tests
npm run test:visual   # Visual regression tests

# Coverage reports
npm run test:coverage
```

### 7.2 Security Scanning
```bash
# Security audit
npm audit
npm run security:scan

# Dependency check
npm run deps:check
```

## 8. Environment Promotion Workflow

### 8.1 Development Environment
```bash
# Deploy to development
git push origin develop

# Automatic triggers:
# - GitLab CI pipeline runs
# - Railway deploys to dev
# - Vercel creates preview deployment
# - EAS creates development build
```

### 8.2 Staging Environment
```bash
# Deploy to staging
git push origin staging

# Manual approval required for production promotion
```

### 8.3 Production Environment
```bash
# Deploy to production
git push origin main

# Requires:
# - All tests passing
# - Security scan approval
# - Manual approval in GitLab
# - EAS submission to app stores
```

## 9. Rollback Procedures

### 9.1 Railway Rollback
```bash
# View deployment history
railway deployments

# Rollback to previous deployment
railway rollback <deployment-id>
```

### 9.2 Vercel Rollback
```bash
# View deployment history
vercel deployments

# Rollback to previous deployment
vercel rollback <deployment-url>
```

### 9.3 EAS Rollback
```bash
# View build history
eas build:list

# Rollback (requires new build with previous commit)
eas build --profile rollback
```

## 10. Troubleshooting

### 10.1 Common Issues
- **Railway deployment fails**: Check environment variables and logs
- **Vercel build errors**: Verify Next.js configuration and dependencies
- **EAS build fails**: Check Expo configuration and certificates
- **Clerk auth issues**: Verify redirect URLs and API keys

### 10.2 Debug Commands
```bash
# Railway debugging
railway logs --service bizcap-api --tail
railway status

# Vercel debugging
vercel logs --follow
vercel inspect

# EAS debugging
eas build:view <build-id>
eas submit:history
```

## 11. Performance Monitoring

### 11.1 Key Metrics
- **API Response Time**: <200ms target
- **Mobile App Load Time**: <3s target
- **Web Vitals**: LCP <2.5s, FID <100ms
- **Error Rate**: <1% target

### 11.2 Monitoring Tools
- **Railway**: Built-in metrics and logs
- **Vercel**: Analytics and performance insights
- **EAS**: Build and crash analytics
- **Clerk**: Authentication metrics

## 12. Next Steps

### 12.1 Immediate Actions
1. **Set up Railway account** and configure services
2. **Connect Vercel** to GitHub repository
3. **Initialize EAS project** and configure builds
4. **Set up Convex** backend deployment
5. **Configure Clerk** authentication

### 12.2 Post-Deployment
1. **Monitor CI/CD pipelines** for successful execution
2. **Set up alerts** for failures and performance issues
3. **Configure analytics** and monitoring dashboards
4. **Test all environments** (dev, staging, prod)
5. **Document team workflows** and access procedures

## Support & Documentation

- **Railway Docs**: https://docs.railway.app
- **Vercel Docs**: https://vercel.com/docs
- **Expo/EAS Docs**: https://docs.expo.dev/build/introduction/
- **Clerk Docs**: https://clerk.com/docs
- **Convex Docs**: https://docs.convex.dev

For issues or questions, refer to the CI/CD pipeline configuration in `.gitlab-ci.yml` and environment-specific documentation.