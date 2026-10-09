# GitHub workflow for Ice Station

The initial repository has already been created. On your current computer, the local folder should have `origin` pointing to `https://github.com/saul-wellman/ice-station-analytics.git`.

## Get the latest company code

From the repository root in Git Bash:

```bash
git pull origin main
```

## Save your work

```bash
git status
git add path/to/your/changed/file
git commit -m "feat(sql): describe the business change"
git push origin main
```

Stage only the files related to your ticket. Never commit passwords, credentials, private data, or generated bulk data exports.

## New computer onboarding

```bash
git clone https://github.com/saul-wellman/ice-station-analytics.git
cd ice-station-analytics
```

Then read `README.md` and `onboarding/README.md`. For a fresh PostgreSQL environment, follow the large-data setup steps in `documentation/v0.2-large-data-environment.md`.
