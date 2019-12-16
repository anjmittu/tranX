#!/bin/bash
set -e

seed=${1:-0}
vocab="data/mined-spanish/vocab.var_str_sep.new_dev.src_freq3.code_freq3.bin"
train_file="data/mined-spanish/train.var_str_sep.bin"
dev_file="data/mined-spanish/dev.var_str_sep.bin"
dropout=0.3
hidden_size=256
embed_size=128
action_embed_size=128
field_embed_size=64
type_embed_size=64
ptrnet_hidden_dim=32
lr=0.001
lr_decay=0.5
beam_size=15
lstm='lstm'  # lstm
lr_decay_after_epoch=15
model_name=model.sup.mined-spanish.${lstm}.hidden${hidden_size}.embed${embed_size}.action${action_embed_size}.field${field_embed_size}.type${type_embed_size}.dr${dropout}.lr${lr}.lr_de${lr_decay}.lr_da${lr_decay_after_epoch}.beam${beam_size}.$(basename ${vocab}).$(basename ${train_file}).glorot.par_state.seed${seed}

echo "**** Writing results to logs/conala/${model_name}.log ****"
mkdir -p logs/mined-spanish
echo commit hash: `git rev-parse HEAD` > logs/mined-spanish/${model_name}.log

python -u exp.py \
    --seed ${seed} \
    --mode train \
    --batch_size 10 \
    --evaluator conala_evaluator \
    --asdl_file asdl/lang/py3/py3_asdl.simplified.txt \
    --transition_system python3 \
    --train_file ${train_file} \
    --dev_file ${dev_file} \
    --vocab ${vocab} \
    --lstm ${lstm} \
    --no_parent_field_type_embed \
    --no_parent_production_embed \
    --hidden_size ${hidden_size} \
    --embed_size ${embed_size} \
    --action_embed_size ${action_embed_size} \
    --field_embed_size ${field_embed_size} \
    --type_embed_size ${type_embed_size} \
    --dropout ${dropout} \
    --patience 5 \
    --max_num_trial 5 \
    --glorot_init \
    --lr ${lr} \
    --lr_decay ${lr_decay} \
    --lr_decay_after_epoch ${lr_decay_after_epoch} \
    --max_epoch 5 \
    --beam_size ${beam_size} \
    --log_every 50 \
    --save_to saved_models/mined-spanish/${model_name} 2>&1 | tee logs/mined-spanish/${model_name}.log

. scripts/mined-spanish/test.sh saved_models/mined-spanish/${model_name}.bin 2>&1 | tee -a logs/mined-spanish/${model_name}.log
