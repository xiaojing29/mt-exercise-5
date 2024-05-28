#! /bin/bash

beam_size=$1

scripts=$(dirname "$0")
base=$(cd "$scripts"/.. && pwd)

data=$base/data/preprocessed
configs=$base/configs

translations=$base/translations/beam_size_$beam_size

mkdir -p $translations

src="it"  # Italian
trg="en"  # English

num_threads=4
device=0

# Start timing
SECONDS=0

model_name="iten_transformer_word"

echo "###############################################################################"
echo "Running model: $model_name with beam size: $beam_size"

# Update config file to set beam size, if not manually set
# sed -i "s/beam_size: [0-9]\+/beam_size: $beam_size/" $configs/$model_name.yaml

# Perform translation
CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.tok.$src > $translations/test.$model_name.$trg

# Detokenize the output using Moses detokenizer
perl $base/tools/moses-scripts/scripts/tokenizer/detokenizer.perl -l en < $translations/test.$model_name.$trg > $translations/detokenized_test.$model_name.$trg

# Detokenize the reference data as well
perl $base/tools/moses-scripts/scripts/tokenizer/detokenizer.perl -l en < $data/test.$trg > $data/detokenized_test.$trg

# Compute case-sensitive BLEU score
BLEU_SCORE=$(cat $translations/detokenized_test.$model_name.$trg | sacrebleu $data/detokenized_test.$trg)

echo "BLEU Score: $BLEU_SCORE"

# Output the time taken
echo "Time taken: $SECONDS seconds"