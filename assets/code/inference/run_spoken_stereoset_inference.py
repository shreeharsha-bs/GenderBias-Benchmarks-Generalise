'''
This file runs inference on the Spoken StereoSet benchmark. It takes in the model and a json file containing the Spoken StereoSet data,
and outputs the results in a specified format. I also assume that the code is run in the correct environment with all dependencies installed.

'''

import json
import argparse
import torch
from transformers import AutoProcessor, Qwen2AudioForConditionalGeneration
import librosa
import pandas as pd
import os

def run_qwen2_inference(model, processor, audio_path, prompt, temperature=0.7):
    """
    Runs inference using the Qwen2-Audio-7B-Instruct model.
    """
    conversation = [
        {"role": "user", "content": [
            {"type": "audio", "audio": audio_path},
            {"type": "text", "text": prompt}
        ]}
    ]
    
    text = processor.apply_chat_template(conversation, add_generation_prompt=True, tokenize=False)
    audio_data, sample_rate = librosa.load(audio_path, sr=processor.feature_extractor.sampling_rate)
    
    inputs = processor(
        text=text, 
        audio=[audio_data], 
        return_tensors="pt",
        padding=True
    ).to(model.device)

    generate_ids = model.generate(**inputs, max_new_tokens=512, do_sample=True, temperature=temperature)
    
    output_ids = generate_ids[:, inputs['input_ids'].shape[1]:]
    response = processor.batch_decode(output_ids, skip_special_tokens=True, clean_up_tokenization_spaces=False)[0]
    return response

def run_inference(model_name, input_json_path, output_json_path, qwen_temperature=0.7):
    """
    Runs inference on the Spoken StereoSet benchmark with the specified model.
    """
    with open(input_json_path, 'r') as f:
        benchmark_data = json.load(f)

    results = []

    if model_name == 'qwen2':
        model_id = 'Qwen/Qwen2-Audio-7B-Instruct'
        processor = AutoProcessor.from_pretrained(model_id, trust_remote_code=True)
        model = Qwen2AudioForConditionalGeneration.from_pretrained(
            model_id,
            device_map="auto",
            torch_dtype=torch.bfloat16
        )
        model.eval()

    # --- 3. Run Inference on each item ---
    for item in benchmark_data:
        audio_path = item['Audio Path']
        prompt = item['Text prompt']

        if not os.path.exists(audio_path):
            print(f"Warning: Audio file not found at {audio_path}. Skipping.")
            continue

        model_answer = ""
        if model_name == 'qwen2':
            model_answer = run_qwen2_inference(model, processor, audio_path, prompt, temperature=qwen_temperature)

        results.append({
            'Audio path': audio_path,
            'Text prompt': prompt,
            'Model Answer': model_answer,
            'Stereotypical option': item['Stereotypical option'],
            'Anti-stereo option': item['Anti-Stereo option'],
            'irrelevant option': item['Irrelevant option']
        })

        # Save intermediate results
        with open(output_json_path, 'w') as f:
            json.dump(results, f, indent=4)

    print(f"Inference complete. Results saved to {output_json_path}")


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Run inference on the Spoken StereoSet benchmark.")
    parser.add_argument('--model', type=str, required=True, choices=['qwen2', 'llama-omni', 'ltu-as'],
                        help="The model to run inference with.")
    parser.add_argument('--input_json', type=str, default='spoken_stereoset_test.json',
                        help="Path to the input JSON file for the benchmark.")
    parser.add_argument('--output_json', type=str, default='spoken_stereoset_results.json',
                        help="Path to save the output JSON file with results.")
    parser.add_argument('--qwen_temperature', type=float, default=0.7,
                        help="Temperature for sampling in the Qwen2 model. Default is 0.7.")

    
    args = parser.parse_args()

    run_inference(args.model, args.input_json, args.output_json, args.qwen_temperature)

