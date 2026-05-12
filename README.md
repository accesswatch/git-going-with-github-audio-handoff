# Git Going with GitHub Audio Handoff

This is a minimal audio-only package for generating the Git Going with GitHub podcast MP3 files on a fast Mac.

It contains only the files needed to generate, tag, validate, and return podcast audio:

- `podcasts/scripts/` - source scripts for 75 episodes.
- `podcasts/transcripts/` - transcript segment JSON.
- `podcasts/config/listening-order.json` - canonical generation order.
- `podcasts/tts/` - Kokoro and Piper generation code, lexicon, and requirements.
- `podcasts/audio/` - empty output folder for generated MP3 files and segment manifests.
- `podcasts/chapters/` - output folder for chapter JSON sidecars.
- `admin/PODCASTS.md` and `podcasts/feed.xml` - regenerated after audio exists.

## Mac Setup

```bash
bash podcasts/tools/macos-audio-setup.sh
```

Or manually:

```bash
brew install python ffmpeg node
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r podcasts/tts/requirements.txt
python -m podcasts.tts.download_kokoro_samples --english-high-quality-only
npm run validate:podcasts
npm run podcast:audio:queue
```

No `npm install` is required. The Node scripts use built-in Node modules only.

## Trial Run

```bash
source .venv/bin/activate
python -m podcasts.tts.generate_audio --start 0 --end 0 --force --audio-format mp3
python podcasts/tag-audio-metadata.py --audio-dir podcasts/audio/kokoro-am_liam-af_jessica --expected-count 1 --allow-missing --write --no-touch
```

## Full Run

```bash
bash podcasts/tools/macos-audio-generate.sh
```

That command generates MP3s, writes ID3 metadata, rebuilds the podcast page and feed, validates the feed, and runs the inventory check.

## Return These Files

After the full run, return:

```text
podcasts/audio/kokoro-am_liam-af_jessica/*.mp3
podcasts/audio/segments/**/manifest.json
podcasts/chapters/*.json
podcasts/audio/metadata-touch-report.json
podcasts/logs/audio_inventory_report.json
podcasts/feed.xml
admin/PODCASTS.md
```

Segment WAV files can be omitted unless we need debugging evidence.
