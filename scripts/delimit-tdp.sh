#!/bin/bash

sudo ryzenadj \
  --stapm-limit=45000 \
  --fast-limit=45000 \
  --slow-limit=45000

sudo cpupower frequency-set 2.9GHz
sudo cpupower frequency-set -gperformance
echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost
