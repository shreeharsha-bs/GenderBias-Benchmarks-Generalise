#!/bin/bash
# filepath: fine_tune_qwen2.sh

#SBATCH -A Berzelius-2025-104
#SBATCH --gpus=1
#SBATCH -t 00-08:00:00  # Set time limit for the job
#SBATCH -J llama_omni_sage
#SBATCH -o logs/llama_omni_FT_%j.out
#SBATCH -e logs/llama_omni_FT_%j.err

# Script to run Llama Omni FT on SAGE benchmark

set -e  # Exit on error

echo "Starting Llama Omni finetuning job at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Running on node: $SLURMD_NODENAME"

# Initialize conda
echo "Initializing conda..."
source ~/miniconda3/etc/profile.d/conda.sh

# Activate conda environment, this environment should have ms-swift installed, the latest version. For llama-omni, the environment should have ms-swift 2.5.1 installed
echo "Activating llama_omni_lora environment..."
conda activate llama_omni_lora


# Create logs directory if it doesn't exist
mkdir -p logs


CONFIG_FILE="$1"
if [ -z "$CONFIG_FILE" ]; then
  echo "Usage: $0 <config_file.json>"
  exit 1
fi

# Check for jq
if ! command -v jq &> /dev/null; then
  echo "jq is required but not installed. Please install jq."
  exit 1
fi

# Parse config variables
output_dir=$(jq -r '.output_dir' "$CONFIG_FILE")
output_dir=${output_dir/qwen/llama_omni} # Replace 'qwen' with 'llama_omni' in output_dir
lora_rank=$(jq -r '.lora_rank' "$CONFIG_FILE")
dataset=$(jq -r '.dataset' "$CONFIG_FILE")
val_dataset=$(jq -r '.val_dataset' "$CONFIG_FILE")
# model=$(jq -r '.model' "$CONFIG_FILE")

CUDA_VISIBLE_DEVICES=0 \
CUDA_LAUNCH_BLOCKING=1 \
swift sft \
    --model_type llama3_1-8b-omni \
    --model_id_or_path ICTNLP/Llama-3.1-8B-Omni \
    --local_repo_path /proj/evaluating_afms/users/x_shrbo/ICASSP-NeurIPS_2025_submission/models/llama_omni/LLaMA-Omni \
    --sft_type lora \
    --dataset "$dataset" \
    --val_dataset "$val_dataset" \
    --num_train_epochs 7 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --learning_rate 1e-4 \
    --lora_rank "$lora_rank" \
    --lora_alpha 32 \
    --gradient_accumulation_steps 16 \
    --gradient_checkpointing False \
    --eval_steps 50 \
    --save_steps 50 \
    --save_total_limit 7 \
    --logging_steps 5 \
    --output_dir "$output_dir" \
    --system 'You are a helpful assistant.' \
    --warmup_ratio 0.05 \
    --dataloader_num_workers 4 \
    --model_author swift \
    --model_name swift-robot \
    --freeze_parameters '' 