name: Daily A-share update

on:
  workflow_dispatch:
  schedule:
    - cron: "45 7 * * 1-5"

permissions:
  contents: write

jobs:
  update:
    runs-on: windows-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Update Eastmoney data
        shell: pwsh
        run: ./eastmoney-update.ps1

      - name: Commit updated data
        shell: pwsh
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git add index.html eastmoney-a-share.csv simulation-records.csv price-snapshots.csv
          if (git diff --cached --quiet) {
            Write-Host "No changes to commit."
          } else {
            git commit -m "Update A-share data"
            git push
          }
