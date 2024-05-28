# MT Exercise 5: Byte Pair Encoding, Beam Search
This repository is a starting point for the 5th and final exercise. As before, fork this repo to your own account and the clone it into your prefered directory.

## Requirements

- This only works on a Unix-like system, with bash available.
- Python 3 must be installed on your system, i.e. the command `python3` must be available
- Make sure virtualenv is installed on your system. To install, e.g.

    `pip install virtualenv`

## Modifications

### Addition of `preprocess.sh` Script for Data Preprocessing and Subsampling
1. **Functionality**: This script handles the preprocessing of raw data for machine translation training, specifically targeting the tokenization and subsampling of Italian to English dataset. The script ensures consistency across training, validation, and test datasets by applying the same preprocessing steps to all.
2. **Usage**: The script processes files named according to the convention `dev.LANG1-LANG2.LANG` (e.g., `dev.it-en.it` for Italian source and `dev.it-en.en` for English target), tokenizing the text and then subsampling the training dataset to 100,000 pairs to make the data manageable for training on consumer-grade hardware. The script also maintains tokenized versions of the validation and test sets without subsampling for accurate model evaluation.
3. **Execution**: Execute the script from the project root directory. Ensure that `sacremoses` tokenizer is installed in your environment, as the script relies on this tool for tokenization. The script is designed to be run from the Unix-like terminal and requires execution permissions (`chmod +x scripts/preprocess.sh`).

### Addition of `transformer_it_en_word.yaml` File for Word-Level Translation Model
1. **Functionality**: Configures a JoeyNMT model for translating Italian to English at the word level. The setup includes paths to training, development, and test datasets, alongside specific model parameters.
2. **Adjustments**: Modifications were made to disable `tied_embeddings` and `tied_softmax`, accommodating distinct vocabularies for the source and target languages.
3. **Usage and Execution**: The YAML configuration file is used to train the model using JoeyNMT. Ensure that the paths and parameters in the file reflect your project setup and that JoeyNMT is correctly installed.

### Changes to the `train.sh` script for Training Word-Level Model
To train a word-level model, the following changes were made to the training script (`train.sh`, which was renamed as `train_word_level.sh`):
1. **Base:**: Replaced `base=$scripts/..` with `base=$(cd "$scripts"/.. && pwd)` to improve compatibility on macOS.
2. **Model Name:**: The `model_name` variable is set to `iten_transformer_word`, indicating the word-level configuration. This ensures that the correct model directory is used for storing checkpoints and logs for the word-level model.

### Addition of `learn_apply_bpe.sh` Script for Learning and Applying BPE Codes
1. **Functionality**: This script automates the process of learning Byte Pair Encoding (BPE) codes and applying them to the dataset. It handles both the learning of BPE codes from the concatenated Italian and English training data and the application of these codes to the training, validation, and test datasets.
2. **Usage**: The script uses `subword-nmt` to learn and apply BPE codes. It ensures that the learned BPE codes are consistent and that the resulting vocabularies are of the exact size specified.
3. **Execution**: Execute the script from the project root directory. Ensure that `subword-nmt` is installed in your environment. 

### Addition of `iten_transformer_bpe2000.yaml` File for BPE Model with Vocabulary Size of 2000
1. **Functionality**: Configures a JoeyNMT model for translating Italian to English at the word level. The setup includes paths to training, development, and test datasets, alongside specific model parameters.
2. **Adjustments**: Modifications were made as follows:
-- **Data Specifications:**
- **Train Path:** `data/preprocessed/train.sampled`
- **Dev Path:** `data/preprocessed/valid`
- **Test Path:** `data/preprocessed/test`
- **Source Language:** `Italian (it)`
- **Target Language:** `English (en)`
- **Tokenization:** BPE with vocabulary and codes provided (`vocab.2000` and `codes.2000`).
-- **Testing Parameters:**
- **Beam Size:** Adjusted to `5`.
-- **Model Directory:**
- **Directory:** `models/iten_transformer_bpe2000`
3. **Usage and Execution**: The YAML configuration file is used to train the model using JoeyNMT. Ensure that the paths and parameters in the file reflect your project setup and that JoeyNMT is correctly installed.

### Changes to the `train.sh` script for Training BPE Model with Vocabulary Size of 2000
To train a model with BPE data and vocabulary size of 2000, the following changes were made to the training script (`train.sh`, which was renamed as `train_bpe2000.sh`):
1. **Base:**: Replaced `base=$scripts/..` with `base=$(cd "$scripts"/.. && pwd)` to improve compatibility on macOS.
2. **Model Name:**: The `model_name` variable is set to `iten_transformer_bpe2000`, indicating the BPE configuration. This ensures that the correct model directory is used for storing checkpoints and logs for the word-level model.

### Addition of `iten_transformer_bpe5000.yaml` File for BPE Model with Vocabulary Size of 5000
1. **Functionality**: Configures a JoeyNMT model for translating Italian to English at the word level. The setup includes paths to training, development, and test datasets, alongside specific model parameters.
2. **Modifications**: The following modifications were made:
-- **Data Specifications:**
- **Train Path:** `data/preprocessed/train.sampled`
- **Dev Path:** `data/preprocessed/valid`
- **Test Path:** `data/preprocessed/test`
- **Source Language:** `Italian (it)`
- **Target Language:** `English (en)`
- **Tokenization:** BPE with vocabulary and codes provided (`vocab.5000` and `codes.5000`).
-- **Testing Parameters:**
- **Beam Size:** Adjusted to `5`.
-- **Model Directory:**
- **Directory:** `models/iten_transformer_bpe5000`
3. **Usage and Execution**: The YAML configuration file is used to train the model using JoeyNMT. Ensure that the paths and parameters in the file reflect your project setup and that JoeyNMT is correctly installed.

### Changes to the `train.sh` Script for Training BPE Model with Vocabulary Size of 5000
To train a model with BPE data and vocabulary size of 5000, the following changes were made to the training script (`train.sh`, which was renamed as `train_bpe5000.sh`):
1. **Base:**: Replaced `base=$scripts/..` with `base=$(cd "$scripts"/.. && pwd)` to improve compatibility on macOS.
2. **Model Name:**: The `model_name` variable is set to `iten_transformer_bpe5000`, indicating the BPE configuration. This ensures that the correct model directory is used for storing checkpoints and logs for the word-level model.

### Changes to the `evaluate.sh` Script for Evaluating Word-Level Model
To evaluate the word-level model with vocabulary size of 2000, the following changes were made to the evaluation script (`evaluate.sh`, which was renamed as `evaluate_word_level.sh`):
1. **Base:**: Replaced `base=$scripts/..` with `base=$(cd "$scripts"/.. && pwd)` to improve compatibility on macOS.
2. **Data Directory:** Enhanced specificity in data path, set to `data/preprocessed` from `sampled_data`.
3. **Language Configuration:** Defined source and target languages as Italian (`src=it`) and English (`trg=en`).
4. **Model Name Specification:** Established the model name as `iten_transformer_word` to replace the placeholder in the prior script version.
5. **Translation Post-Processing:** Added steps for detokenizing both the translation output and the reference data using the Moses detokenizer, enhancing the quality of translation evaluation.
6. **BLEU Score Calculation:** Expanded the BLEU score calculation process by integrating detokenization, improving the accuracy of translation quality assessment.

### Changes to the `evaluate.sh` Script for Evaluating BPE-Encoded Model with 2000 Vocabulary Size
The following modifications have been made to the script for evaluating models using Byte Pair Encoding (BPE) with a size of 2000 (`evaluate.sh`, which was renamed as `evaluate_bpe2000.sh`):
1. **Base Directory Correction:** Adjusted the base directory resolution to `base=$(cd "$scripts"/.. && pwd)` for better path handling across different operating systems.
2. **Data Directory:** The data directory has been changed from `sampled_data` to `data/preprocessed` to align with the structured directory setup for preprocessed data.
3. **Language Settings:** Defined the source and target languages explicitly as Italian (`src=it`) and English (`trg=en`).
4. **Model Configuration:** Specified the model name as `iten_transformer_bpe2000`, directly referencing its configuration for BPE with a size of 2000, compared to the unspecified model name in the second script.
5. **BPE Usage:** Added the process for translating using BPE-encoded test files, specifying the BPE size directly in the data file name (`test.bpe.$bpe_size.$src`), enhancing translation accuracy with BPE specifics.
6. **Post-Translation Detokenization:** Included steps for detokenizing the translation output and reference data using the Moses detokenizer, which increases the reliability of output readability and evaluation.
7. **BLEU Score Evaluation:** Expanded the BLEU score calculation by including a detokenization step prior to evaluation, which allows for more accurate assessment of translation quality against a detokenized reference.
8. **Translation Directory Setup:** Enhanced the setup for translation subdirectories under `translations/$model_name`, which organizes translation outputs more systematically.

### Changes to the `evaluate.sh` Script for Evaluating BPE-Encoded Model with 5000 Vocabulary Size
The following modifications have been made to the script for evaluating models using Byte Pair Encoding (BPE) with a size of 5000(`evaluate.sh`, which was renamed as `evaluate_bpe5000.sh`):
1. **Base Directory Resolution:** Modified the base directory resolution to `base=$(cd "$scripts"/.. && pwd)`, ensuring robust path handling across various operating systems.
2. **Data Directory:** Updated the data directory from `sampled_data` to `data/preprocessed`, reflecting a move to a more structured environment for preprocessed data which is critical for consistent evaluation.
3. **Language Configuration:** The source (`src=it` for Italian) and target (`trg=en` for English) languages are specifically defined.
4. **Model Name and BPE Size:** The model name is specified as `iten_transformer_bpe5000` and includes the BPE size (`bpe_size=5000`), which directly addresses the configuration needs for models dealing with larger BPE sizes.
5. **Translation Using BPE Encoded Files:** Introduced a process to translate using BPE-encoded test files (`test.bpe.$bpe_size.$src`), ensuring that the model handles BPE transformations effectively and accurately.
6. **Post-Translation Detokenization and BLEU Score Calculation:** Added steps to detokenize the translation output before computing the BLEU score. This involves using the Moses detokenizer, which enhances the readability and comparability of the translation output against a detokenized reference.
7. **Directory Structure for Translations:** Improved the organization by creating specific subdirectories for each model under `translations/$model_name`, aiding in systematic management and retrieval of translation results.

### Addition of the `evaluate_beam_size.sh` Script for Experiments with Beam Size
The script `evaluate_beam_size.sh` introduces several modifications over the original `evaluate.sh` script to cater to the evaluation of translation models using different beam sizes:
1. **Beam Size Parameterization:** Added a parameter to accept beam size (`$1`) from the command line, allowing dynamic adjustment of beam size for translation evaluations.
2. **Base Directory Resolution:** Improved the base directory resolution to `base=$(cd "$scripts"/.. && pwd)`, ensuring consistent path management across various platforms.
3. **Data Directory:** Updated the data directory from `sampled_data` to `data/preprocessed`. 
4. **Language Settings:** The source (`src="it"` for Italian) and target (`trg="en"` for English) languages are explicitly defined.
5. **Translation Output Directory:** Introduced a new directory naming convention for translations (`translations/beam_size_$beam_size`), which organizes outputs by their respective beam sizes for better manageability and retrieval.
6. **Model Configuration:** Specified the model name as `iten_transformer_word`, ensuring the script targets the correct model configuration file for translations.
7. **Update Configuration Dynamically:** Commented out a line that would dynamically update the beam size in the model configuration file (`sed` command). This flexibility allows manual or script-based configuration adjustments to suit specific evaluation needs.
8. **Post-Translation Processing:** Included steps to detokenize the translation and reference outputs using the Moses detokenizer, facilitating a direct and fair comparison of the translation quality by improving the readability of outputs.
9. **BLEU Score Calculation and Display:** Implemented a command to compute and display the BLEU score directly, providing immediate feedback on translation quality in relation to the adjusted beam size.
10. **Performance Metrics Reporting:** Added explicit reporting of the time taken for the translation process, allowing performance analysis over different beam sizes.

### Addition of `create_graphs.py` Script for Visualization
1. **Functionality:** This script is designed to visualize the impact of varying beam sizes on translation quality and computation time. It generates graphs that plot the relationship between beam size, BLEU score, and the time taken for translations, aiding in the optimization of translation models.
2. **Usage:** The script utilizes `matplotlib` to create and save plots demonstrating how beam size affects BLEU scores and the time required to complete translations. Data for the experiments should be pre-defined or calculated prior to running the script.
3. **Execution:** To execute this script, make sure that the `matplotlib` library is installed in your Python environment. The script can be run from any directory that has access to the required data. Ensure the script file has the appropriate execution permissions set (`chmod +x scripts/evaluate_performance.sh`).


## Steps

Clone your fork of this repository in the desired place:

    git clone https://github.com/[your-name]/mt-exercise-5

Create a new virtualenv that uses Python 3.10. Please make sure to run this command outside of any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell script above.

Download and install required software as described in the exercise pdf.

Download data:

    ./download_iwslt_2017_data.sh
    
Before executing any further steps, you need to make the modifications described in the exercise pdf.

Preprocess data and sub-sample training data:

    chmod +x scripts/preprocess.sh
    ./scripts/preprocess.sh

The script is designed to be run from the Unix-like terminal and requires execution permissions (`chmod +x scripts/preprocess.sh`).

Learn and apply BPE: 

    chmod +x scripts/learn_apply_bpe.sh
    ./scripts/learn_apply_bpe.sh

Train a word-level model:

    chmod +x scripts/train_word_level.sh
    ./scripts/train_word_level.sh

Train a model with BPE data (vocabulary size: 2000):

    chmod +x scripts/train_bpe2000.sh
    ./scripts/train_bpe2000.sh

Train a model with BPE data (vocabulary size: 5000):

    chmod +x scripts/train_bpe5000.sh
    ./scripts/train_bpe5000.sh

The training process can be interrupted at any time, and the best checkpoint will always be saved.

Evaluate a word-level model:

    chmod +x scripts/evaluate_word_level.sh
    ./scripts/evaluate_word_level.sh

Evaluate a model with BPE data (vocabulary size: 2000):

    chmod +x scripts/evaluate_bpe2000.sh
    ./scripts/evaluate_bpe2000.sh

Evaluate a model with BPE data (vocabulary size: 5000):

    chmod +x scripts/evaluate_bpe5000.sh
    ./scripts/evaluate_bpe5000.sh

Evaluate a model with different beam size: first, set the beam size in YAML file manually; second run the `evaluate_beam_size.sh` script by passing the desired beam size as an argument:

    chmod +x scripts/evaluate_beam_size.sh
    ./scripts/evaluate_beam_size.sh 5

You can modify the beam size directly in the YAML configuration file and adjust it by passing a different value as an argument when running the `evaluate_beam_size.sh` script at any time.

Visualize the impact of beam size on the BLEU score and time taken to generate the translations:

    python ./scripts/create_graphs.py
