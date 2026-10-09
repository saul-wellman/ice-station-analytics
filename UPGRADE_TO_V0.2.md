# Apply the Ice Station v0.2 upgrade

This ZIP contains files laid out relative to the root of your existing local `ice-station-analytics` repository. It does not contain a database dump.

## Apply the files

1. In File Explorer, locate your local repository folder—the one containing `.git/`, `README.md`, `database/`, and `onboarding/`.
2. Download the upgrade ZIP and choose **Extract All**.
3. In the extraction destination box, select that existing repository folder. Do not extract it into a new nested folder inside the repository.
4. When Windows asks whether to replace `README.md` and `CHANGELOG.md`, choose **Replace**. The other files are additions.
5. In Git Bash, make sure your current directory is the repository root, then run:

   ```bash
   git status
   git add .
   git commit -m "feat(data): add large Ice Station training environment"
   git push origin main
   ```

6. Verify that the new files appear on GitHub.
7. Build the large database:

   ```bash
   bash scripts/setup_large_dataset.sh
   ```

The setup command creates `ice_station_v2`, leaving your existing `ice_station` database unchanged. It refuses to overwrite any database that already has the chosen name.

Do not paste the large SQL file into pgAdmin. The committed setup script executes it through PostgreSQL's command-line client.
