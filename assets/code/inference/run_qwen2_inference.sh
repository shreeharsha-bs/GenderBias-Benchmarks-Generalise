#!/bin/bash
# filepath: run_qwen2_inference.sh

#SBATCH -A Berzelius-2025-104
#SBATCH --gpus=1
#SBATCH -t 00-08:00:00  # Set time limit for the job
#SBATCH -J qwen2_stereoset
#SBATCH -o logs/qwen2_inference_%j.out
#SBATCH -e logs/qwen2_inference_%j.err

# Script to run Qwen2 inference on Spoken StereoSet benchmark

set -e  # Exit on error

echo "Starting Qwen2 inference job at $(date)"
echo "Job ID: $SLURM_JOB_ID"
echo "Running on node: $SLURMD_NODENAME"

# Initialize conda
echo "Initializing conda..."
source ~/miniconda3/etc/profile.d/conda.sh

# Activate conda environment
echo "Activating lora_swift environment..."
conda activate lora_swift

# Navigate to benchmark directory
cd /proj/evaluating_afms/users/x_shrbo/ICASSP-NeurIPS_2025_submission/inference/

# Create logs directory if it doesn't exist
mkdir -p logs

# Run create_spoken_stereoset_json.py
# echo "Creating Spoken StereoSet JSON..."
# python create_spoken_stereoset_json.py

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
model=$(jq -r '.model' "$CONFIG_FILE")
input_json=$(jq -r '.input_json' "$CONFIG_FILE")
output_json=$(jq -r '.output_json' "$CONFIG_FILE")
qwen_temperature=$(jq -r '.qwen_temperature' "$CONFIG_FILE")
lora_adapter_path=$(jq -r '.lora_adapter_path' "$CONFIG_FILE")

# Run inference with qwen2
echo "Running Qwen2 inference with config $CONFIG_FILE..."

python run_SAGE_inference.py \
    --model "$model" \
    --input_json "$input_json" \
    --output_json "$output_json" \
    --qwen_temperature "$qwen_temperature" \
    --lora_adapter_path "$lora_adapter_path"

echo "Qwen2 inference completed successfully at $(date)!"