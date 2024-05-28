#!/bin/bash
# -*- coding: utf-8 -*-

set -e

# Define the base directory relative to the script location
base=$(cd "$(dirname "$0")"/.. && pwd)

src=it
tgt=en
data=$base/data/

# Create directory for preprocessed data if it does not exist
mkdir -p $data/preprocessed/

# Function to tokenize data
tokenize() {
    sacremoses -l $1 tokenize < $2 > $3
}

# Tokenize entire dataset for training, development, and test
tokenize $src $data/train.$src-$tgt.$src $data/preprocessed/train.tok.$src
tokenize $tgt $data/train.$src-$tgt.$tgt $data/preprocessed/train.tok.$tgt
tokenize $src $data/dev.$src-$tgt.$src $data/preprocessed/valid.tok.$src
tokenize $tgt $data/dev.$src-$tgt.$tgt $data/preprocessed/valid.tok.$tgt
tokenize $src $data/test.$src-$tgt.$src $data/preprocessed/test.tok.$src
tokenize $tgt $data/test.$src-$tgt.$tgt $data/preprocessed/test.tok.$tgt

# Subsample training data to the first 100,000 lines
head -n 100000 $data/preprocessed/train.tok.$src > $data/preprocessed/train.sampled.$src
head -n 100000 $data/preprocessed/train.tok.$tgt > $data/preprocessed/train.sampled.$tgt

# Copy tokenized validation and test data to their final destination
cp $data/preprocessed/valid.tok.$src $data/preprocessed/valid.$src
cp $data/preprocessed/valid.tok.$tgt $data/preprocessed/valid.$tgt
cp $data/preprocessed/test.tok.$src $data/preprocessed/test.$src
cp $data/preprocessed/test.tok.$tgt $data/preprocessed/test.$tgt

echo "Preprocessing complete!"

