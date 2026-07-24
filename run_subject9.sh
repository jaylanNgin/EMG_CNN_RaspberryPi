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

echo "Preparing Subject 9 trial-level train/test split..."
mkdir -p \
    dataset_subject9/train/act1 \
    dataset_subject9/train/act2 \
    dataset_subject9/test/act1 \
    dataset_subject9/test/act2

for activity in act1 act2; do
    for trial in 1 2 3 4 5 6 7 8 9 10 11 12; do
        cp "Subject9/ResultClipSizeUp400/$activity/trial_$trial.txt" \
            "dataset_subject9/train/$activity/trial_$trial.txt"
    done

    for trial in 13 14 15 16; do
        cp "Subject9/ResultClipSizeUp400/$activity/trial_$trial.txt" \
            "dataset_subject9/test/$activity/trial_$trial.txt"
    done
done

echo "Training on trials 1-12 and testing on trials 13-16..."
.venv/bin/python main_cnn_emg.py \
    --train-dir dataset_subject9/train \
    --test-dir dataset_subject9/test \
    --sampling-rate 1000 \
    --channels ch1 ch2 ch3 \
    --window-ms 200 \
    --stride-ms 50 \
    --normalize-mode per_window \
    --batch-size 32 \
    --epochs 200 \
    --model-path subject9_emg_cnn_model_pi.pth

echo
echo "Finished. Model saved to subject9_emg_cnn_model_pi.pth"
