#!/bin/bash
# filepath: fine_tune_qwen2.sh

#SBATCH -A Berzelius-2025-104
#SBATCH --gpus=1
#SBATCH -t 00-08:00:00  # Set time limit for the job
#SBATCH -J qwen2_stereoset
#SBATCH -o logs/qwen2_inference_%j.out
#SBATCH -e logs/qwen2_inference_%j.err

# Script to run Qwen2 inference on Spoken StereoSet benchmark

set -e  # Exit on error

echo "Starting Qwen2 finetuning job at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Running on node: $SLURMD_NODENAME"

# Initialize conda
echo "Initializing conda..."
source ~/miniconda3/etc/profile.d/conda.sh

# Activate conda environment, this environment should have ms-swift installed, the latest version. For llama-omni, the environment should have ms-swift 2.5.1 installed 
echo "Activating lora_swift environment..."
conda activate lora_swift


# Create logs directory if it doesn't exist
mkdir -p logs

# Read config file (first argument)
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
lora_rank=$(jq -r '.lora_rank' "$CONFIG_FILE")
dataset=$(jq -r '.dataset' "$CONFIG_FILE")
val_dataset=$(jq -r '.val_dataset' "$CONFIG_FILE")
model=$(jq -r '.model' "$CONFIG_FILE")

# Run inference with qwen2
echo "Fine-tuning Qwen2 with config $CONFIG_FILE..."
CUDA_VISIBLE_DEVICES=0 \
swift sft \
    --model "$model" \
    --train_type lora \
    --dataset "$dataset" \
    --val_dataset "$val_dataset" \
    --torch_dtype bfloat16 \
    --num_train_epochs 7 \
    --per_device_train_batch_size 1 \
    --per_device_eval_batch_size 1 \
    --learning_rate 1e-4 \
    --lora_rank "$lora_rank" \
    --lora_alpha 32 \
    --target_modules all-linear \
    --gradient_accumulation_steps 16 \
    --eval_steps 50 \
    --save_steps 50 \
    --save_total_limit 7 \
    --logging_steps 5 \
    --max_length 2048 \
    --output_dir "$output_dir" \
    --system 'You are a helpful assistant.' \
    --warmup_ratio 0.05 \
    --dataloader_num_workers 4 \
    --model_author swift \
    --model_name swift-robot \
    --use_hf True \
    --load_from_cache_file False \
    --freeze_parameters '' \
