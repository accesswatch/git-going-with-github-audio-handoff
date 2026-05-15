# Git Going with GitHub Audio Handoff

This handoff is for generating the Git Going with GitHub podcast MP3 files on a fast Mac. Kokoro is the default production engine.

**Latest update:** Episode 79 "What Comes Next" final episode added with 27 chapter markers and metadata.

## What Is Included

- `podcasts/scripts/chapters/` - 57 main course episode scripts with `[ALEX]`, `[JAMIE]`, and `[PAUSE]` markers
- `podcasts/scripts/appendices/` - reference episode scripts (agents, security, desktop, CLI, etc.)
- `podcasts/transcripts/` - transcript segments and chapter references as JSON
- `podcasts/chapters/` - episode metadata with chapter markers (timestamps and titles)
- `podcasts/config/listening-order.json` - canonical generation and feed order (75 total episodes)
- `podcasts/manifest.json` - episode catalog with metadata
- `podcasts/tts/` - Kokoro TTS generation code, lexicon, and Python requirements
- `podcasts/audio/` - empty output folder for generated MP3 files
- `admin/PODCASTS.md` and `podcasts/feed.xml` - regenerated after audio exists

## Mac Prerequisites

Install once (requires Homebrew):

```bash
brew install python ffmpeg node
```

Requires Python 3.10+. Apple Silicon Macs work well with default wheels.

## Setup

From the handoff folder root:

```bash
bash podcasts/tools/macos-audio-setup.sh
```

Or manually:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r podcasts/tts/requirements.txt
npm ci
python -m podcasts.tts.download_kokoro_samples --english-high-quality-only
npm run podcast:audio:queue
```

**Note:** `npm ci` is required to install Node dependencies for metadata writing and feed generation.

The TTS model downloads write to `podcasts/tts/models/` (intentionally local, not committed).

## Preview the Generation Queue

```bash
npm run podcast:audio:queue
```

Should show 75 episodes in listening order with challenges interleaved.

## Trial Run (Single Episode)

```bash
source .venv/bin/activate
python -m podcasts.tts.generate_audio --start 0 --end 0 --force --audio-format mp3
python podcasts/tag-audio-metadata.py --audio-dir podcasts/audio/kokoro-am_liam-af_jessica --expected-count 1 --allow-missing --write --no-touch
```

## Full Production Generation

After trial sounds good:

```bash
bash podcasts/tools/macos-audio-generate.sh
```

This generates all 75 MP3s, writes ID3 metadata (including chapter frames), rebuilds the podcast feed, and validates the inventory.

MP3s are written to `podcasts/audio/kokoro-am_liam-af_jessica/`.

## Return These Files

After full generation, return:

```text
podcasts/audio/kokoro-am_liam-af_jessica/*.mp3
podcasts/audio/segments/**/manifest.json
podcasts/chapters/*.json
podcasts/audio/metadata-touch-report.json
podcasts/logs/audio_inventory_report.json
podcasts/feed.xml
admin/PODCASTS.md
```

Segment WAV files are large—return only if debugging is needed.
