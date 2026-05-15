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

## One-Command Generation (Recommended)

From the handoff folder root, run everything with one command:

```bash
bash podcasts/tools/macos-audio-all-in-one.sh
```

This does all setup, configuration checks, audio generation, metadata tagging, feed building, and inventory validation in one go.

Time estimate: 30-60 minutes on a fast Mac.

---

## Manual Setup (If Needed)

If you prefer to run steps individually:

```bash
bash podcasts/tools/macos-audio-setup.sh
```

Then after setup completes:

```bash
bash podcasts/tools/macos-audio-generate.sh
```

**Setup includes:**
- Homebrew installation of Python, FFmpeg, Node
- Python venv and package installation
- Node dependency installation (`npm ci`)
- Kokoro TTS model download
- Configuration validation

**Generation includes:**
- Audio MP3 synthesis (all 75 episodes)
- ID3 metadata and chapter frame writing
- Podcast feed generation and validation
- Audio inventory verification

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
