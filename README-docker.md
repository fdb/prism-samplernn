# Running Prism-SampleRNN with Docker

This is a big mess, but currently you can do this on my custom branch:

## Download the code

```shell
git clone https://github.com/fdb/prism-samplernn.git
cd prism-samplernn
git checkout dockerify
```

## Build the Docker image

```shell
docker build -t prism-samplernn .
```
## Training Prism-SampleRNN

Make sure you're in the correct directory:

```shell
cd prism-samplernn
```

Start the Docker image and bind the current directory to the "app" directory.

On your Mac:

```shell
docker run -it -v "$(pwd):/app" prism-samplernn
```

On a Linux machine with a GPU:

```shell
docker run --gpus all -it -v "$(pwd):/app" prism-samplernn
```

In the Docker container, start the training:

```shell
python train.py --id techno --data_dir ./chunks/techno --num_epochs 100 --batch_size 128 --checkpoint_every 1 --early_stopping_patience 100 --output_file_dur 3 --sample_rate 16000 --resume True
```

## Generating results

Make sure you're in the correct directory:

```shell
cd prism-samplernn
```

Make sure to have the model ready. You need 3 files, normally they're in the `logdir/yourproject/10.12.2020_11.02.35` folder. This path will be different for you!

- `model.ckpt-60.data-00000-of-00001`
- `model.ckpt-60.index`

The number depends on the epoch, and will be different as well.

Start the Docker image and bind the current directory to the "app" directory:

On your Mac:

```shell
docker run -it -v "$(pwd):/app" prism-samplernn
```

On a Linux machine with a GPU:

```shell
docker run --gpus all -it -v "$(pwd):/app" prism-samplernn
```

In the Docker container, start generating output files:


```shell
python generate.py --output_path generated/birds/ --checkpoint_path logdir/birds/12.12.2020_14.08.01/model.ckpt-60 --config_file default.config.json --num_seqs 5 --dur 5 --sample_rate 16000 --temperature 1.0
```

Note the `checkpoint_path`: this should point to the `model.ckpt-60.index`, without the `.index` at the end.

If you have a seed file (starting file) you can supply that as well:

```shell
python generate.py --output_path generated/techno_samples/ --checkpoint_path logdir/yourproject/10.12.2020_11.02.35/model.ckpt-60 --config_file default.config.json --num_seqs 5 --dur 5 --sample_rate 16000 --seed chunks/techno/classics-90_chunk_1  --temperature 1.0
```

**Make sure the output directory exists:**

```shell
mkdir -p generated/birds
```

Experiment with the temperature parameter to get different results.

## Generating new chunks

If you're running locally you need to install dependencies:

```shell
pip3 install pydub
```

You might have to prepend sudo to install these globally.

```shell
python3 chunk_audio.py  --input_file data/classics-90.wav --output_dir chunks/new_techno --chunk_length 8000 --overlap 7000
```
