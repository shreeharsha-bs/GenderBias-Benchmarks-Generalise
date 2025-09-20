#!/bin/bash
# filepath: run_llama_omni_inference.sh

#SBATCH -A Berzelius-2025-104
#SBATCH --gpus=1
#SBATCH -t 00-08:00:00  # Set time limit for the job
#SBATCH -J llama_omni_stereoset
#SBATCH -o logs/llama_omni_inference_%j.out
#SBATCH -e logs/llama_omni_inference_%j.err

# Script to run Llama-Omni inference on Spoken StereoSet benchmark

set -e  # Exit on error

echo "Starting Llama-Omni inference job at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Running on node: $SLURMD_NODENAME"

# Initialize conda
echo "Initializing conda..."
source ~/miniconda3/etc/profile.d/conda.sh

# Activate conda environment
echo "Activating llama_omni_lora environment..."
conda activate llama_omni_lora

# Read config file (first argument)
CONFIG_FILE="$1"
if [ -z "$CONFIG_FILE" ]; then
  echo "Usage: $0 <inference_config.json>"
  exit 1
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo "jq is required but not installed. Please install jq."
  exit 1
fi


# Parse config variables
input_json=$(jq -r '.input_json' "$CONFIG_FILE")
question_file=$(jq -r '.question_file' "$CONFIG_FILE")
answer_file=$(jq -r '.answer_file' "$CONFIG_FILE")
temperature=$(jq -r '.temperature' "$CONFIG_FILE")
lora_adapter_path=$(jq -r '.lora_adapter_path' "$CONFIG_FILE")

# Create logs directory if it doesn't exist
mkdir -p logs


# Convert JSON for Llama-Omni
echo "Converting JSON for Llama-Omni..."
python convert_for_llama_omni.py --input_json "$input_json" --output_json "$question_file"
# cd /proj/evaluating_afms/users/x_shrbo/ICASSP-NeurIPS_2025_submission/models/llama_omni/LLaMA-Omni
if [ "$lora_adapter_path" == "null" ]; then
  swift infer \
    --model_type llama3_1-8b-omni \
    --do_sample True \
    --model_id_or_path ICTNLP/Llama-3.1-8B-Omni \
    --val_dataset $question_file \
    --result_dir $(dirname $answer_file) \
    --temperature $temperature \
    --max_new_tokens 2048
  echo "Llama-Omni inference completed successfully at $(date)!"
  exit 0
fi

swift infer \
    --model_type llama3_1-8b-omni \
    --do_sample True \
    --model_id_or_path ICTNLP/Llama-3.1-8B-Omni \
    --ckpt_dir $lora_adapter_path \
    --val_dataset $question_file \
    --result_dir $(dirname $answer_file) \
    --temperature $temperature \
    --max_new_tokens 2048 \

echo "Llama-Omni inference completed successfully at $(date)!"