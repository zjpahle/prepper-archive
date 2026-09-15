# Verified Sources (checked 2026-09-14)

All ZIM file listings were pulled live from `https://lb.download.kiwix.org/zim/<category>/` (Kiwix's own
load-balanced mirror). Filenames are date-stamped and change roughly monthly — if a URL below 404s, browse
the category folder above (or https://hub.kiwix.org/downloads/) for the current filename and update
`manifest.json`.

## Tier 1 — Core (~202GB)

| # | Item | File | Size | URL |
|---|------|------|------|-----|
| 1 | Wikipedia (en, text only) | `wikipedia_en_all_nopic_2026-06.zim` | 49G | https://lb.download.kiwix.org/zim/wikipedia/wikipedia_en_all_nopic_2026-06.zim |
| 2 | Wikipedia Medicine (en, with images) | `wikipedia_en_medicine_maxi_2026-04.zim` | 2.1G | https://lb.download.kiwix.org/zim/wikipedia/wikipedia_en_medicine_maxi_2026-04.zim |
| 3 | Wiktionary (en) | `wiktionary_en_all_nopic_2026-08.zim` | 8.5G | https://lb.download.kiwix.org/zim/wiktionary/wiktionary_en_all_nopic_2026-08.zim |
| 4 | Wikibooks (en) — DIY/how-to reference | `wikibooks_en_all_nopic_2026-04.zim` | 3.3G | https://lb.download.kiwix.org/zim/wikibooks/wikibooks_en_all_nopic_2026-04.zim |
| 5a | Gutenberg — Agriculture (LCC-S) | `gutenberg_en_lcc-s_2026-03.zim` | 4.2G | https://lb.download.kiwix.org/zim/gutenberg/gutenberg_en_lcc-s_2026-03.zim |
| 5b | Gutenberg — Technology (LCC-T) | `gutenberg_en_lcc-t_2026-03.zim` | 12G | https://lb.download.kiwix.org/zim/gutenberg/gutenberg_en_lcc-t_2026-03.zim |
| 5c | Gutenberg — Medicine (LCC-R) | `gutenberg_en_lcc-r_2026-03.zim` | 1.9G | https://lb.download.kiwix.org/zim/gutenberg/gutenberg_en_lcc-r_2026-03.zim |
| 6 | Stack Overflow (en, full) | `stackoverflow.com_en_all_2026-07.zim` | 107G | https://lb.download.kiwix.org/zim/stack_exchange/stackoverflow.com_en_all_2026-07.zim |
| 7 | iFixit repair guides (en) | `ifixit_en_all_2025-12.zim` | 3.3G | https://lb.download.kiwix.org/zim/ifixit/ifixit_en_all_2025-12.zim |
| 8 | Appropedia (off-grid/sustainability wiki) | `appropedia_en_all_maxi_2026-02.zim` | 555M | https://lb.download.kiwix.org/zim/other/appropedia_en_all_maxi_2026-02.zim |
| 9 | WikEM (emergency medicine reference) | `wikem_en_all_maxi_2026-07.zim` | 357M | https://lb.download.kiwix.org/zim/other/wikem_en_all_maxi_2026-07.zim |
| 10 | Hesperian — Where There Is No Doctor | PDF | 253K (verified) | https://hesperian.org/wp-content/uploads/pdf/en_wwhnd_2023/en_wwhnd_2023_ob.pdf |
| 11 | US Army FM 4-25.11 First Aid | PDF (Internet Archive, public domain) | ~15M | https://archive.org/download/FM4-25.11/FM4-25.11.pdf |
| 12 | US Army FM 3-05.70 Survival | PDF (Internet Archive, public domain) | 20M | https://archive.org/download/fm-3-05.70-survival-2002/FM%203-05.70%20Survival%20%202002.pdf |
| 13 | Ubuntu 24.04 LTS Desktop (amd64) | `ubuntu-24.04.4-desktop-amd64.iso` | 6.2G | https://releases.ubuntu.com/24.04/ubuntu-24.04.4-desktop-amd64.iso |
| 14 | Debian 13 netinst (amd64) | `debian-13.7.0-amd64-netinst.iso` | 756M | https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.7.0-amd64-netinst.iso |
| 15 | Raspberry Pi OS (arm64, latest, stable alias) | image.img.xz | ~1G | https://downloads.raspberrypi.org/raspios_arm64_latest |
| 16 | Ventoy (multi-ISO bootable USB tool) v1.1.17 | `ventoy-1.1.17-windows.zip` | 16.7M | https://github.com/ventoy/Ventoy/releases/download/v1.1.17/ventoy-1.1.17-windows.zip |
| 17 | VLC 3.0.23 (win64) | `vlc-3.0.23-win64.exe` | 44M | https://get.videolan.org/vlc/last/win64/vlc-3.0.23-win64.exe |
| 18 | Sysinternals Suite (always-current link) | `SysinternalsSuite.zip` | ~50M | https://download.sysinternals.com/files/SysinternalsSuite.zip |
| 19 | 7-Zip, Notepad++, LibreOffice, GIMP | Installers | ~1.5G | vendor download pages — versioned filenames change often, see note below |

**Note on #12:** originally sourced from `irp.fas.org`, but that host sits behind an AWS WAF bot-challenge that
blocks scripted downloads entirely (returns HTTP 202 forever). Swapped to the Internet Archive copy instead.

**Note on #10:** Hesperian's server doesn't send a `Content-Length` header (likely due to on-the-fly
compression behind Cloudflare), which BITS can't handle — it needs a plain HTTP client instead. The file
itself is genuinely small (253KB), not a partial/broken download.

**Note on #19:** 7-Zip (https://www.7-zip.org/download.html), Notepad++ (https://notepad-plus-plus.org/downloads/),
LibreOffice (https://www.libreoffice.org/download/download-libreoffice/), and GIMP (https://www.gimp.org/downloads/)
don't publish stable "latest" URLs the way VLC/Sysinternals do — their installer filenames embed a version
number that changes with every release. Grab the current installer manually from each page when running the
script, or hardcode the current version's URL into `manifest.json` and expect to refresh it occasionally.

Running total: **~202GB**, leaving **~300GB of headroom** in the 500GB budget for Tier 2 items below.

## Tier 2 — Optional expansion

| Item | Notes |
|------|-------|
| Wikipedia full w/ images (`wikipedia_en_all_maxi`, ~119G) | Replaces #1; richer but eats most of the remaining headroom |
| Full Gutenberg (`gutenberg_en_all_2025-11.zim`, 206G) | Replaces #5a-c; the entire ~70k book library instead of 3 subjects |
| Snappy Driver Installer offline packs | https://sdi-tool.org/download/ — realistically **20-37GB** for full hardware coverage (much larger than a first guess), and most of it will be for hardware you don't own. Better run as a targeted "lite" scan on the specific PC that needs drivers, rather than pre-downloaded in bulk. |
| Extra language Wikipedias | e.g. Spanish/French, ~10-30GB each, from `lb.download.kiwix.org/zim/wikipedia/` |
| Khan Academy / TED Talks (video) | ~100GB+ each, only worth it if video content matters |
| Offline maps | Organic Maps / OsmAnd offline region packs — separate viewer app, not a Kiwix ZIM |
