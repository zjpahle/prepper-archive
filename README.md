# Prepper Archive — Personal Offline Knowledge Base

A self-hosted alternative to products like PrepperDisk: offline Wikipedia and reference wikis,
medical/survival guides, and useful software, served from the Synology NAS via
[Kiwix](https://www.kiwix.org/) so any phone/laptop on the home network can browse it
even with no internet.

## Layout

```
prepper-archive/
  README.md          <- this file
  sources.md          <- exact, verified download URLs + sizes (checked 2026-09-14)
  manifest.json        <- machine-readable version of sources.md, consumed by the script below
  scripts/
    Get-Archive.ps1     <- PowerShell downloader; fetches everything in manifest.json
  docker/
    docker-compose.yml   <- Kiwix server for Synology Container Manager
  content/             <- created by the script: zim/, docs/, software/ (not committed anywhere, just local storage)
```

## Quick start

1. **Download the content** (run on this PC, or directly on the NAS if it has PowerShell/SSH+curl access):
   ```powershell
   cd C:\Users\zjpah\prepper-archive
   .\scripts\Get-Archive.ps1
   ```
   This pulls everything listed in `manifest.json` into `content/zim`, `content/docs`, and `content/software`,
   skipping files that already exist and resuming partial downloads where possible.
   Total size: **~215GB** (fits comfortably in the 500GB budget, leaving room for Tier 2 upgrades — see `sources.md`).

2. **Copy `content/` to the NAS**, e.g. into a new shared folder `/volume1/archive/` (via File Station,
   `robocopy` to a mapped NAS drive, or `rsync`/`scp` if SSH is enabled), preserving the `zim/docs/software`
   subfolder structure.

3. **Run Kiwix on the Synology NAS:**
   - Install **Container Manager** from Synology Package Center (if not already installed).
   - Open Container Manager → **Project** → **Create**, point it at `docker/docker-compose.yml`
     (edit the volume path inside it first to match your actual share path).
   - Start the project. Kiwix will index every `.zim` file under `/volume1/archive/zim`.
   - Browse to `http://<nas-ip>:8081` from any device on the network (8080 is left free for Pi-hole).

4. **Non-ZIM content** (`docs/` — PDFs, `software/` — ISOs/installers) is just a normal folder on the NAS
   share — browse/download it via File Station or any SMB file browser, no server needed.

## Notes

- ZIM filenames are date-stamped and Kiwix republishes them periodically (roughly monthly for Wikipedia).
  `sources.md` has the exact filenames verified working as of **2026-09-14** — if a URL 404s later, check
  https://hub.kiwix.org/downloads/ or browse https://lb.download.kiwix.org/zim/&lt;category&gt;/ for the current one
  and update `manifest.json`.
- WikiHow is **not** included — Kiwix removed it from distribution in January 2025 at WikiHow's own request
  (copyright concerns over AI scraping of their content). Wikibooks is included instead as the how-to/DIY
  reference source.
- All sources are official/original publishers (Kiwix's own mirror, Hesperian, archive.org for public-domain
  US Army field manuals, and each software vendor's own site) — nothing routed through third-party mirrors.
