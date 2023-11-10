#!/bin/bash

# Check for NVIDIA GPU using nvidia-smi
nvidia_gpu=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader,nounits | head -n 1)

# Function to get Intel GPU temperature from 'sensors'
get_intel_gpu_temperature() {
  local temperature
  temperature=$(sensors | grep "Package id 0" | awk '{print $4}' | sed 's/+//;s/°C//;s/\.0//')
  echo "$temperature"
}

# Function to define emoji based on temperature
get_temperature_emoji() {
  local temperature="$1"
  if [ "$temperature" -lt 60 ]; then
    echo "❄️" # Ice emoji for less than 60°C
  else
    echo "🔥" # Fire emoji for 60°C or higher
  fi
}

# Check if primary GPU is NVIDIA
if [ -n "$nvidia_gpu" ]; then
  # if nvidia-smi failed, format and exit.
  if [[ $nvidia_gpu == *"NVIDIA-SMI has failed"* ]]; then
    # Print the formatted information in JSON
    echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: Not found\"}"
    exit 0
  fi

  primary_gpu="NVIDIA GPU"
  # Collect GPU information for NVIDIA
  gpu_info=$(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu,clocks.current.graphics,clocks.max.graphics,power.draw,power.max_limit --format=csv,noheader,nounits)
  # Split the comma-separated values into an array
  IFS=',' read -ra gpu_data <<<"$gpu_info"
  # Extract individual values
  temperature="${gpu_data[0]// /}"
  utilization="${gpu_data[1]// /}"
  current_clock_speed="${gpu_data[2]// /}"
  max_clock_speed="${gpu_data[3]// /}"
  power_usage="${gpu_data[4]// /}"
  power_limit="${gpu_data[5]// /}"

  # Get emoji based on temperature
  emoji=$(get_temperature_emoji "$temperature")

  # Print the formatted information in JSON
  echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\n󰾆 Utilization: $utilization%\n Clock Speed: $current_clock_speed/$max_clock_speed MHz\n Power Usage: $power_usage/$power_limit W\"}"
else
  # Check for Intel GPU
  primary_gpu="Intel GPU"
  intel_gpu=$(lspci -nn | grep -i "VGA compatible controller" | grep -i "Intel Corporation" | awk -F' ' '{print $1}')
  if [ -n "$intel_gpu" ]; then
    temperature=$(get_intel_gpu_temperature)
    emoji=$(get_temperature_emoji "$temperature")
    # Print the formatted information in JSON
    echo "{\"text\":\"$temperature°C\", \"tooltip\":\"Primary GPU: $primary_gpu\n$emoji Temperature: $temperature°C\"}"
  else
    primary_gpu="Not found"
    gpu_info=""
    # Print the formatted information in JSON
    echo "{\"text\":\"N/A\", \"tooltip\":\"Primary GPU: $primary_gpu\"}"
  fi
fi
