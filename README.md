# EMG CNN for Raspberry Pi

PyTorch CNN inference for two EMG activities (`act1` and `act2`) using three
channels (`ch1`, `ch2`, and `ch3`). The included model was trained using
Subject 7 data.

## Raspberry Pi requirements

- Raspberry Pi 4 or 5
- 64-bit Raspberry Pi OS (`uname -m` should print `aarch64`)
- Python 3

## Install

```bash
sudo apt update
sudo apt install -y python3-full python3-venv git

git clone https://github.com/jaylanNgin/EMG_CNN_RaspberryPi.git
cd EMG_CNN_RaspberryPi

python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
```

## One-command Subject 7 run

The complete Subject 7 dataset is included. To install the required packages,
prepare the trial-level split, train on trials 1-8, and test on trials 9-10:

```bash
bash run_subject7.sh
```

The first run downloads PyTorch and can take several minutes. Later runs reuse
the local virtual environment. The trained model is saved as
`subject7_emg_cnn_model_pi.pth`.

## One-command Subject 8 run

The complete Subject 8 dataset is also included. This trains on trials 1-12
and tests on trials 13-16:

```bash
bash run_subject8.sh
```

The trained model is saved as `subject8_emg_cnn_model_pi.pth`.

## One-command Subject 9 run

The complete Subject 9 dataset is included. This trains on trials 1-12 and
tests on trials 13-16:

```bash
bash run_subject9.sh
```

The trained model is saved as `subject9_emg_cnn_model_pi.pth`.

## One-command Subject 2 Glove Off, clip size 200 run

The `Subject2GloveOff/ResultClipSizeUp200` dataset is included. This trains on
trials 1-12 and tests on trials 13-16:

```bash
bash run_subject2_gloveoff_size200.sh
```

The trained model is saved as `subject2_gloveoff_size200_cnn_pi.pth`.

## One-command Subject 2 Glove On, clip size 300 run

The `Subject2GloveOn/ResultClipSizeUp300` dataset is included. This trains on
trials 1-12 and tests on trials 13-16:

```bash
bash run_subject2_gloveon_size300.sh
```

The trained model is saved as `subject2_gloveon_size300_cnn_pi.pth`.

## One-command Subject Fast, clip size 300 run

The `SubjectFast/ResultClipSizeUp300` dataset is included. This trains on trials
1-12 and tests on trials 13-16:

```bash
bash run_subjectfast_size300.sh
```

The trained model is saved as `subjectfast_size300_cnn_pi.pth`.

## One-command Subject Slow, clip size 200 run

The `SubjectSlow/ResultClipSizeUp200` dataset is included. This trains on trials
1-12 and tests on trials 13-16:

```bash
bash run_subjectslow_size200.sh
```

The trained model is saved as `subjectslow_size200_cnn_pi.pth`.

## One-command Subject Norm, clip size 250 run

The `SubjectNorm/ResultClipSizeUp250` dataset is included. This trains on trials
1-12 and tests on trials 13-16:

```bash
bash run_subjectnorm_size250.sh
```

The trained model is saved as `subjectnorm_size250_cnn_pi.pth`.
This runner uses global training-set normalization, which improved the held-out
test accuracy from 50.0% to 87.5% for this dataset.

## One-command Subject 3 Ball, clip size 400 run

The `Subject3Ball/ResultClipSizeUp400` dataset is included. This trains on
trials 1-12 and tests on trials 13-16:

```bash
bash run_subject3ball_size400.sh
```

The trained model is saved as `subject3ball_size400_cnn_pi.pth`.
The 400-sample recordings are segmented with a 200 ms sliding window and 50 ms
stride, producing 120 training windows and 40 test windows.

## One-command Subject 3 Bottle, clip size 200 run

The `Subject3Bottle/ResultClipSizeUp200` dataset is included. This trains on
trials 1-12 and tests on trials 13-16:

```bash
bash run_subject3bottle_size200.sh
```

The 200-sample recordings use a 100 ms sliding window and 25 ms stride,
producing 120 training windows and 40 test windows. The trained model is saved
as `subject3bottle_size200_cnn_pi.pth`.
This runner uses per-window normalization.

## Run a prediction

The input must be a `.txt`, `.csv`, or `.tsv` file with numeric `ch1`, `ch2`,
and `ch3` columns. A `timestamp` column is optional.

```bash
source .venv/bin/activate

python main_cnn_emg.py \
  --predict-csv path/to/recording.txt \
  --model-path subject7_emg_cnn_model_improved.pth
```

The program segments the recording into windows and prints the majority-vote
gesture prediction.

## Model configuration

- Classes: `act1`, `act2`
- EMG channels: `ch1`, `ch2`, `ch3`
- Sampling rate used for training: 1000 Hz
- Window length: 200 ms
- Window stride: 50 ms
- Normalization: per-window

This program performs inference on completed recording files. Reading directly
from a live EMG sensor requires a separate serial/ADC acquisition loop.
