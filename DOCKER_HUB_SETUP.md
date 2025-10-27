# Quick Setup Guide - Docker Hub Deployment

## 🚀 5-Minute Setup

### Step 1: Get Your Docker Hub Username
Your Docker Hub username (you'll need this for the secrets).

If you don't have a Docker Hub account:
1. Go to: https://hub.docker.com/signup
2. Create a free account
3. Remember your username!

### Step 2: Create Access Token

1. **Login to Docker Hub**: https://hub.docker.com/
2. **Go to Settings**: Click your profile → Account Settings
3. **Security Tab**: https://hub.docker.com/settings/security
4. **Create Token**:
   - Click "New Access Token"
   - Description: `github-actions-cicd`
   - Permissions: **Read, Write, Delete**
   - Click "Generate"
5. **COPY THE TOKEN** ⚠️ You'll only see it once!

### Step 3: Add Secrets to GitHub

1. **Go to Repository Secrets**:
   - URL: https://github.com/akoii/DevOps-MidTerm/settings/secrets/actions
   - Or: Repository → Settings → Secrets and variables → Actions

2. **Add First Secret**:
   - Click "New repository secret"
   - Name: `DOCKER_USERNAME`
   - Value: `your-dockerhub-username` (example: `akoii`)
   - Click "Add secret"

3. **Add Second Secret**:
   - Click "New repository secret" again
   - Name: `DOCKER_PASSWORD`
   - Value: Paste the access token (starts with `dckr_pat_...`)
   - Click "Add secret"

### Step 4: Test Deployment

```bash
cd "d:\CS\Course Work\DevOps\Midterm\python-flask-ariadne-api-starter"

# Create test file
echo "# Test deployment" > DEPLOY_TEST.txt

# Commit and push
git add DEPLOY_TEST.txt
git commit -m "Test: Deploy to Docker Hub"
git push origin main
```

### Step 5: Watch It Deploy

1. Go to: https://github.com/akoii/DevOps-MidTerm/actions
2. Click on the latest workflow run
3. Click on "Deploy to Docker Hub" job
4. Watch the deployment logs! 🎉

---

## ✅ Success Indicators

You'll know it worked when you see:

### In GitHub Actions:
```
✅ Build & Install Dependencies
✅ Lint & Security Scan
✅ Run Tests with PostgreSQL
✅ Build Docker Image
✅ Deploy to Docker Hub  ← This should be green!
```

### In Deployment Logs:
```
============================================
DEPLOYMENT SUCCESSFUL!
============================================
Image: your-username/python-flask-ariadne-api:latest
Tag: abc123...
...
============================================
```

### On Docker Hub:
- Go to: `https://hub.docker.com/r/YOUR_USERNAME/python-flask-ariadne-api`
- You should see your image with tags: `latest` and commit SHA

---

## 🎯 What Happens Next?

Every time you push to `main` branch:
1. ✅ All tests run
2. ✅ Docker image builds
3. ✅ Image pushes to Docker Hub automatically
4. ✅ You can pull and use the image anywhere!

---

**That's it! Step 3 complete once you add the secrets.** 🎉
