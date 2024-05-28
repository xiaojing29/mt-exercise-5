#! /bin/bash

scripts=$(dirname "$0")
base=$(cd "$scripts"/.. && pwd)

data=$base/data/preprocessed
configs=$base/configs

translations=$base/translations

mkdir -p $translations

src=it  # Italian
trg=en  # English


num_threads=4
device=0

# measure time

SECONDS=0

model_name=iten_transformer_word

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.tok.$src > $translations_sub/test.$model_name.$trg

# Detokenize the output using Moses detokenizer
perl $base/tools/moses-scripts/scripts/tokenizer/detokenizer.perl -l en < $translations_sub/test.$model_name.$trg > $translations_sub/detokenized_test.$model_name.$trg

# Detokenize the reference data as well
perl $base/tools/moses-scripts/scripts/tokenizer/detokenizer.perl -l en < $data/test.$trg > $data/detokenized_test.$trg

# Compute case-sensitive BLEU score
cat $translations_sub/detokenized_test.$model_name.$trg | sacrebleu $data/detokenized_test.$trg

echo "time taken:"
echo "$SECONDS seconds"