#!/bin/bash
# -*- coding: utf-8 -*-

set -e

# Define directories and parameters
base=$(cd "$(dirname "$0")"/.. && pwd)
data=$base/data
preprocessed=$data/preprocessed
bpe_dir=$data/bpe

mkdir -p $bpe_dir

# BPE parameters
vocab_size_1=2000
vocab_size_2=5000
src=it
tgt=en

# Concatenate source and target files for joint BPE learning
cat $preprocessed/train.sampled.$src $preprocessed/train.sampled.$tgt > $bpe_dir/train.sampled.concat

# Learn BPE codes and joint vocabulary
echo "Learning BPE with vocab size $vocab_size_1..."
subword-nmt learn-bpe -s $vocab_size_1 --total-symbols < $bpe_dir/train.sampled.concat > $bpe_dir/codes.$vocab_size_1
subword-nmt apply-bpe -c $bpe_dir/codes.$vocab_size_1 < $bpe_dir/train.sampled.concat | subword-nmt get-vocab | awk '{print $1}' > $bpe_dir/vocab.$vocab_size_1

echo "Learning BPE with vocab size $vocab_size_2..."
subword-nmt learn-bpe -s $vocab_size_2 --total-symbols < $bpe_dir/train.sampled.concat > $bpe_dir/codes.$vocab_size_2
subword-nmt apply-bpe -c $bpe_dir/codes.$vocab_size_2 < $bpe_dir/train.sampled.concat | subword-nmt get-vocab | awk '{print $1}' > $bpe_dir/vocab.$vocab_size_2

# Function to apply BPE
apply_bpe() {
    subword-nmt apply-bpe -c $1 < $3 > $4
}

# Apply BPE to datasets
echo "Applying BPE with vocab size $vocab_size_1..."
apply_bpe $bpe_dir/codes.$vocab_size_1 $bpe_dir/vocab.$vocab_size_1 $preprocessed/train.sampled.$src $preprocessed/train.bpe.$vocab_size_1.$src
apply_bpe $bpe_dir/codes.$vocab_size_1 $bpe_dir/vocab.$vocab_size_1 $preprocessed/train.sampled.$tgt $preprocessed/train.bpe.$vocab_size_1.$tgt
apply_bpe $bpe_dir/codes.$vocab_size_1 $bpe_dir/vocab.$vocab_size_1 $preprocessed/valid.$src $preprocessed/valid.bpe.$vocab_size_1.$src
apply_bpe $bpe_dir/codes.$vocab_size_1 $bpe_dir/vocab.$vocab_size_1 $preprocessed/valid.$tgt $preprocessed/valid.bpe.$vocab_size_1.$tgt
apply_bpe $bpe_dir/codes.$vocab_size_1 $bpe_dir/vocab.$vocab_size_1 $preprocessed/test.$src $preprocessed/test.bpe.$vocab_size_1.$src
apply_bpe $bpe_dir/codes.$vocab_size_1 $bpe_dir/vocab.$vocab_size_1 $preprocessed/test.$tgt $preprocessed/test.bpe.$vocab_size_1.$tgt

echo "Applying BPE with vocab size $vocab_size_2..."
apply_bpe $bpe_dir/codes.$vocab_size_2 $bpe_dir/vocab.$vocab_size_2 $preprocessed/train.sampled.$src $preprocessed/train.bpe.$vocab_size_2.$src
apply_bpe $bpe_dir/codes.$vocab_size_2 $bpe_dir/vocab.$vocab_size_2 $preprocessed/train.sampled.$tgt $preprocessed/train.bpe.$vocab_size_2.$tgt
apply_bpe $bpe_dir/codes.$vocab_size_2 $bpe_dir/vocab.$vocab_size_2 $preprocessed/valid.$src $preprocessed/valid.bpe.$vocab_size_2.$src
apply_bpe $bpe_dir/codes.$vocab_size_2 $bpe_dir/vocab.$vocab_size_2 $preprocessed/valid.$tgt $preprocessed/valid.bpe.$vocab_size_2.$tgt
apply_bpe $bpe_dir/codes.$vocab_size_2 $bpe_dir/vocab.$vocab_size_2 $preprocessed/test.$src $preprocessed/test.bpe.$vocab_size_2.$src
apply_bpe $bpe_dir/codes.$vocab_size_2 $bpe_dir/vocab.$vocab_size_2 $preprocessed/test.$tgt $preprocessed/test.bpe.$vocab_size_2.$tgt

echo "BPE learning and applying complete!"



