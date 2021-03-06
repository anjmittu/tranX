#!/bin/bash

test_file="data/mined-spanish/test.var_str_sep.bin"

python exp.py \
    --mode test \
    --load_model $1 \
    --beam_size 15 \
    --test_file ${test_file} \
    --evaluator conala_evaluator \
    --save_decode_to decodes/mined-spanish/$(basename $1).test.decode \
    --decode_max_time_step 100
