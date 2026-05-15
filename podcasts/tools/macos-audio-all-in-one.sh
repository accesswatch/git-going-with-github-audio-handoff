#!/usr/bin/env bash
set -euo pipefail

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  Git Going with GitHub - Mac Audio Generation All-In-One   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Check Homebrew
echo "📋 Step 1: Checking prerequisites..."
if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew is required. Install it from https://brew.sh/ and rerun this script." >&2
  exit 1
fi
echo "  ✓ Homebrew found"

# Step 2: Install system dependencies
echo ""
echo "📋 Step 2: Installing system dependencies (python, ffmpeg, node)..."
brew install python ffmpeg node
echo "  ✓ System dependencies installed"

# Step 3: Setup Python environment
echo ""
echo "📋 Step 3: Setting up Python virtual environment..."
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r podcasts/tts/requirements.txt
echo "  ✓ Python environment ready"

# Step 4: Setup Node environment
echo ""
echo "📋 Step 4: Installing Node dependencies..."
npm ci
echo "  ✓ Node dependencies installed"

# Step 5: Download TTS models
echo ""
echo "📋 Step 5: Downloading Kokoro TTS models..."
python -m podcasts.tts.download_kokoro_samples --english-high-quality-only
echo "  ✓ Models downloaded"

# Step 6: Validate configuration
echo ""
echo "📋 Step 6: Validating podcast configuration..."
npm run validate:podcasts
echo "  ✓ Configuration valid"

# Step 7: Preview generation queue
echo ""
echo "📋 Step 7: Previewing generation queue..."
npm run podcast:audio:queue
echo "  ✓ Queue preview complete"

# Step 8: Generate audio
echo ""
echo "📋 Step 8: Generating MP3 audio (75 episodes)..."
echo "  This may take several minutes..."
npm run build:podcast-audio
echo "  ✓ Audio generation complete"

# Step 9: Tag metadata
echo ""
echo "📋 Step 9: Writing ID3 metadata and chapter markers..."
npm run podcast:metadata:check
npm run podcast:metadata:write
echo "  ✓ Metadata and chapters written"

# Step 10: Build and validate feed
echo ""
echo "📋 Step 10: Building and validating podcast feed..."
npm run build:podcast-site
npm run validate:podcast-feed
echo "  ✓ Feed built and validated"

# Step 11: Verify inventory
echo ""
echo "📋 Step 11: Verifying audio inventory..."
npm run podcast:inventory:check
echo "  ✓ Inventory verified"

# Step 12: Summary
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                  ✅ ALL COMPLETE                           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Generated files to return:"
echo "  • podcasts/audio/kokoro-am_liam-af_jessica/*.mp3"
echo "  • podcasts/audio/segments/**/manifest.json"
echo "  • podcasts/chapters/*.json"
echo "  • podcasts/audio/metadata-touch-report.json"
echo "  • podcasts/logs/audio_inventory_report.json"
echo "  • podcasts/feed.xml"
echo "  • admin/PODCASTS.md"
echo ""
