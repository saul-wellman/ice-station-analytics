# Publish Ice Station to GitHub (Windows)

Repository: https://github.com/saul-wellman/ice-station-analytics

## 1. Install Git

Install Git for Windows if `git --version` is not recognized:
https://git-scm.com/download/win

## 2. Extract the ZIP

Extract this ZIP. Open the `Ice-Station-Analytics` folder that contains `README.md`.

In File Explorer, click the address bar, type `cmd`, and press Enter to open Command Prompt in that folder.

## 3. Initialize and push the first commit

Run these commands one at a time:

```bash
git init -b main
git add .
git commit -m "chore: initialize Ice Station analytics codebase"
git remote add origin https://github.com/saul-wellman/ice-station-analytics.git
git push -u origin main
```

When prompted, complete GitHub authentication in the browser or credential manager. Do not share your password or access token in chat.

If Git says your name and email are not configured, set them using the name/email you want associated with commits:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-github-noreply-email"
```

Then repeat the `git commit` command.

## 4. Verify

Refresh the repository page. You should see `README.md`, `onboarding/`, `database/`, `documentation/`, `projects/`, `sql/`, and `powerbi/`.

This creates your initial version-controlled commit. Later tickets will result in additional commits.
