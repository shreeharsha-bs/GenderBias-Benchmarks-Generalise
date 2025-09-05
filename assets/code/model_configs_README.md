# Model Configurations

This directory contains configuration files and model specifications used in the paper.

## Configuration Files:

### `speech_llm_configs/`
- Whisper model configurations
- GPT-based speech model configs
- Fine-tuning parameters

### `evaluation_configs/`
- Benchmark evaluation settings
- Metric calculation parameters
- Cross-validation configurations

### `dataset_configs/`
- Dataset preprocessing settings
- Augmentation parameters
- Split configurations

## Model Specifications:

### Supported Models:
- Whisper (OpenAI)
- SpeechT5 (Microsoft)
- Custom SpeechLLM variants
- Fine-tuned models

### Configuration Format:
All configurations are in YAML format for easy modification and reproducibility.

## Usage:
```bash
python evaluate.py --config speech_llm_configs/whisper_large.yaml
```

## Customization:
Copy and modify existing configuration files to create custom evaluation setups.