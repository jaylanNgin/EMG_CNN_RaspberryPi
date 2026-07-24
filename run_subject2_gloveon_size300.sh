#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Installing Raspberry Pi system requirements..."
sudo apt update
sudo apt install -y python3-full python3-venv

if [ ! -d .venv ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
fi

echo "Installing Python dependencies..."
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r requirements.txt

SOURCE_DIR="Subject2GloveOn/ResultClipSizeUp300"
DATASET_DIR="dataset_subject2_gloveon_size300"

echo "Preparing Subject 2 Glove On, ResultClipSizeUp300 split..."
mkdir -p \
    "$DATASET_DIR/train/act1" \
    "$DATASET_DIR/train/act2" \
    "$DATASET_DIR/test/act1" \
    "$DATASET_DIR/test/act2"

for activity in act1 act2; do
    for trial in 1 2 3 4 5 6 7 8 9 10 11 12; do
        cp "$SOURCE_DIR/$activity/trial_$trial.txt" \
            "$DATASET_DIR/train/$activity/trial_$trial.txt"
    done

    for trial in 13 14 15 16; do
        cp "$SOURCE_DIR/$activity/trial_$trial.txt" \
            "$DATASET_DIR/test/$activity/trial_$trial.txt"
    done
done

echo "Training on trials 1-12 and testing on trials 13-16..."
.venv/bin/python main_cnn_emg.py \
    --train-dir "$DATASET_DIR/train" \
    --test-dir "$DATASET_DIR/test" \
    --sampling-rate 1000 \
    --channels ch1 ch2 ch3 \
    --window-ms 300 \
    --stride-ms 50 \
    --normalize-mode per_window \
    --batch-size 32 \
    --epochs 200 \
    --model-path subject2_gloveon_size300_cnn_pi.pth

echo
echo "Finished. Model saved to subject2_gloveon_size300_cnn_pi.pth"
