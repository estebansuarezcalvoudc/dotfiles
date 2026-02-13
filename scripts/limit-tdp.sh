#!/bin/bash

sudo ryzenadj \
  --stapm-limit=10000 \
  --fast-limit=10000 \
  --slow-limit=10000

sudo cpupower frequency-set -g powersave
echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost
