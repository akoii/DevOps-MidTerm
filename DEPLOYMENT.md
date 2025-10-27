# Step 3 - Cloud/Registry Deployment ✅

## Overview
This document explains the Docker Hub deployment configuration and how to verify it works.

## ✅ Requirements Met

### 1. Push to Docker Hub ✅
- **Implementation**: GitHub Actions workflow Stage 5
- **Location**: `.github/workflows/ci-cd-pipeline.yml` (lines 270-340)
- **Mechanism**: Uses `docker/login-action@v3` and docker push commands

### 2. Secrets Management ✅
- **Secrets Required**:
  - `DOCKER_USERNAME`: Your Docker Hub username
  - `DOCKER_PASSWORD`: Your Docker Hub password or access token
- **Usage**: Securely stored in GitHub and accessed via `${{ secrets.* }}`

### 3. Deployment Logs ✅
- **Detailed Console Output**: Shows image name, tags, branch, commit, timestamp
- **GitHub Step Summary**: Creates formatted markdown summary in Actions UI
- **Accessibility**: Visible in GitHub Actions run details

---

## 🚀 Deployment Workflow

### Stage 5: Deploy to Docker Hub

```yaml
deploy:
  name: Deploy to Docker Hub
  runs-on: ubuntu-latest
  needs: build-docker-image
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
```

### Conditional Execution:
- ✅ Only runs on `main` branch
- ✅ Only runs on direct push (not PRs)
- ✅ Only runs if all previous stages pass

### Steps Executed:

1. **Download Docker Image**
   - Retrieves image artifact from Stage 4
   - Loads compressed tar.gz file

2. **Login to Docker Hub**
   - Uses official `docker/login-action`
   - Authenticates with secrets

3. **Tag Images**
   - Creates `latest` tag
   - Creates commit SHA tag (e.g., `abc123def456`)

4. **Push to Registry**
   - Pushes both tags
   - Updates Docker Hub repository

5. **Display Logs**
   - Shows deployment success message
   - Lists image details
   - Timestamps the deployment

6. **Create Summary**
   - Generates GitHub step summary
   - Provides clickable links
   - Shows deployment status

---

## 🔐 Setting Up GitHub Secrets

### Step 1: Create Docker Hub Access Token

1. Go to Docker Hub: https://hub.docker.com/settings/security
2. Click **"New Access Token"**
3. Configure:
   - **Description**: `github-actions-devops-midterm`
   - **Access permissions**: Read, Write, Delete
4. Click **"Generate"**
5. **IMPORTANT**: Copy the token immediately (you won't see it again!)

### Step 2: Add Secrets to GitHub

1. Navigate to: https://github.com/akoii/DevOps-MidTerm/settings/secrets/actions
2. Click **"New repository secret"**

#### Secret 1: DOCKER_USERNAME
```
Name: DOCKER_USERNAME
Value: your-dockerhub-username
```

#### Secret 2: DOCKER_PASSWORD
```
Name: DOCKER_PASSWORD
Value: dckr_pat_xxxxxxxxxxxxxxxxxxxxx
       (paste the access token you copied)
```

3. Click **"Add secret"** for each

---

## 📊 Deployment Logs Example

### Console Output:
```
============================================
DEPLOYMENT SUCCESSFUL!
============================================
Image: akoii/python-flask-ariadne-api:latest
Tag: cc84fa7f8e9a1b2c3d4e5f6a7b8c9d0e
Branch: refs/heads/main
Commit: cc84fa7f8e9a1b2c3d4e5f6a7b8c9d0e
Pushed at: Mon Oct 28 02:45:23 UTC 2025
============================================
```

### GitHub Step Summary:
```markdown
## 🚀 Deployment Summary

✅ Docker image successfully pushed to Docker Hub!

**Image:** `akoii/python-flask-ariadne-api:latest`

**Tag:** `cc84fa7f8e9a1b2c3d4e5f6a7b8c9d0e`

**Branch:** `refs/heads/main`

**Timestamp:** `Mon Oct 28 02:45:23 UTC 2025`
```

---

## 🧪 Testing the Deployment

### Method 1: Push to Main Branch

```bash
cd "d:\CS\Course Work\DevOps\Midterm\python-flask-ariadne-api-starter"

# Make a small change
echo "# Deployment test" >> DEPLOYMENT_TEST.md

# Commit and push
git add DEPLOYMENT_TEST.md
git commit -m "Test: Trigger deployment to Docker Hub"
git push origin main
```

### Method 2: View Previous Deployment

1. Go to: https://github.com/akoii/DevOps-MidTerm/actions
2. Click on any successful workflow run on `main` branch
3. Click on **"Deploy to Docker Hub"** job
4. View the logs

---

## 🔍 Verifying Deployment Success

### 1. Check GitHub Actions
- Go to: https://github.com/akoii/DevOps-MidTerm/actions
- Latest run should show ✅ for "Deploy to Docker Hub"

### 2. Check Docker Hub
- Go to: https://hub.docker.com/r/YOUR_USERNAME/python-flask-ariadne-api
- Should see:
  - `latest` tag
  - Commit SHA tag
  - Last pushed timestamp

### 3. Pull and Run Image
```bash
# Pull from Docker Hub
docker pull YOUR_USERNAME/python-flask-ariadne-api:latest

# Run the image
docker run -p 5000:5000 YOUR_USERNAME/python-flask-ariadne-api:latest

# Test
curl http://localhost:5000
```

---

## 📈 Deployment Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│              GitHub Actions Trigger                         │
│         (Push to main branch)                               │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  Stage 1-4: Build, Lint, Test, Build Docker Image          │
│  (All must pass)                                            │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
              ┌────────┴────────┐
              │  Conditional    │
              │  Check          │
              └────────┬────────┘
                       │
         ┌─────────────┴─────────────┐
         │                           │
         ▼                           ▼
    Branch = main              Other branch
    All tests pass             or PR
         │                           │
         ▼                           ▼
┌────────────────────┐      ┌───────────────┐
│  Stage 5: Deploy   │      │  Skip Deploy  │
└────────┬───────────┘      └───────────────┘
         │
         ▼
┌────────────────────────────────────────────┐
│  1. Download image artifact                │
│  2. Login to Docker Hub                    │
│  3. Tag image (latest + SHA)               │
│  4. Push to Docker Hub                     │
│  5. Display deployment logs                │
│  6. Create summary                         │
└────────┬───────────────────────────────────┘
         │
         ▼
┌────────────────────────────────────────────┐
│  ✅ Deployment Complete                    │
│  Image available at:                       │
│  docker.io/username/image:latest           │
└────────────────────────────────────────────┘
```

---

## 🎯 Benefits of This Deployment Strategy

### 1. **Automated Deployment** ✅
- No manual intervention required
- Consistent deployment process
- Reduces human error

### 2. **Version Control** ✅
- Every deployment tagged with commit SHA
- Easy to roll back to specific versions
- Audit trail of all deployments

### 3. **Security** ✅
- Secrets never exposed in code
- Access tokens can be revoked
- Fine-grained permissions

### 4. **Visibility** ✅
- Detailed logs in Actions UI
- Deployment summaries
- Easy troubleshooting

### 5. **Quality Gates** ✅
- Only deploys if tests pass
- Only deploys from main branch
- Prevents broken code in production

---

## 🐛 Troubleshooting

### Issue 1: Deploy Stage Skipped
**Symptoms**: Stage 5 shows as "Skipped" in Actions

**Causes**:
- Not on `main` branch
- Pull request (not direct push)
- Previous stage failed

**Solution**:
- Verify you're pushing to `main`: `git branch`
- Check all previous stages passed
- Ensure it's a push, not a PR

---

### Issue 2: Authentication Failed
**Symptoms**: "Error: Cannot perform an interactive login from a non TTY device"

**Causes**:
- `DOCKER_USERNAME` secret not set
- `DOCKER_PASSWORD` secret not set
- Incorrect credentials

**Solution**:
1. Verify secrets exist: https://github.com/akoii/DevOps-MidTerm/settings/secrets/actions
2. Check username is correct (case-sensitive)
3. Regenerate Docker Hub access token
4. Update `DOCKER_PASSWORD` secret

---

### Issue 3: Image Push Failed
**Symptoms**: "denied: requested access to the resource is denied"

**Causes**:
- Repository doesn't exist on Docker Hub
- Username in secret doesn't match image tag
- Insufficient permissions

**Solution**:
1. Verify Docker Hub username in secret
2. Create repository on Docker Hub first (it will auto-create on first push)
3. Check access token has Write permissions

---

### Issue 4: Cannot Find Image
**Symptoms**: "Error response from daemon: reference does not exist"

**Causes**:
- Image artifact not uploaded in Stage 4
- Wrong artifact name

**Solution**:
1. Check Stage 4 completed successfully
2. Verify artifact name is `docker-image`
3. Check artifact retention period (24 hours default)

---

## 📸 Expected Screenshots for Documentation

### 1. GitHub Secrets Configuration
Screenshot showing:
- `DOCKER_USERNAME` secret
- `DOCKER_PASSWORD` secret
- Both marked as "Updated X time ago"

### 2. Successful Deployment Logs
Screenshot showing:
```
✅ Deploy to Docker Hub (success)
  - Checkout code
  - Download Docker image artifact
  - Load Docker image
  - Log in to Docker Hub
  - Tag Docker image
  - Push Docker image to Docker Hub
  - Display deployment logs ⬅️ EXPAND THIS
  - Create deployment summary
```

### 3. Docker Hub Repository
Screenshot showing:
- Repository: `username/python-flask-ariadne-api`
- Tags: `latest`, `cc84fa7...`
- Last pushed: timestamp
- Public/Private status

### 4. GitHub Actions Summary
Screenshot showing:
- All 5 stages complete
- Green checkmarks
- "Deploy to Docker Hub" expanded with logs

---

## ✅ Verification Checklist

- [ ] Docker Hub account created
- [ ] Access token generated
- [ ] `DOCKER_USERNAME` secret added to GitHub
- [ ] `DOCKER_PASSWORD` secret added to GitHub
- [ ] Pushed to `main` branch to trigger deployment
- [ ] Viewed deployment logs in GitHub Actions
- [ ] Verified image on Docker Hub
- [ ] Downloaded and tested image locally
- [ ] Documented with screenshots

---

## 🎓 What You've Accomplished

By completing Step 3, you have:

1. ✅ **Automated Docker Hub deployment** via GitHub Actions
2. ✅ **Implemented secrets management** for secure authentication
3. ✅ **Created deployment logs** visible in pipeline
4. ✅ **Established version control** for Docker images
5. ✅ **Set up quality gates** (only deploy if tests pass)
6. ✅ **Configured conditional deployment** (main branch only)

---

**Status**: ✅ **CONFIGURED** (Awaiting secrets to be fully operational)  
**Next Step**: Add GitHub secrets and test deployment  
**Created**: October 28, 2025  
**Repository**: https://github.com/akoii/DevOps-MidTerm
