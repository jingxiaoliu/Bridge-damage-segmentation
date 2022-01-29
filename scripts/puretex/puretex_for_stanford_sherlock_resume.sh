#!/bin/bash
#
#SBATCH --job-name=icshm_puretex_resnest_%J
#SBATCH --output=icshm_puretex_resnest_%J.out
#SBATCH --error=icshm_puretex_resnest_%J.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=liujx@stanford.edu
#SBATCH --time=48:00:00
#SBATCH -p gpu
#SBATCH -c 2
#SBATCH -G 2
#SBATCH --gpus-per-node 2

set -x

date

module load py-pytorch/1.6.0_py36
pip3 install mmcv_full -f https://download.openmmlab.com/mmcv/dist/cu102/torch1.6.0/index.html
pip3 install git+https://github.com/open-mmlab/mmsegmentation.git
pip3 install tqdm

cd ~/research/icshm/ic-shm2021-p1/damage_detection/

python3 -m torch.distributed.launch --nproc_per_node=2 --master_port=$RANDOM train_3classes_puretex.py --nw resnest --cp ~/research/icshm/ic-shm2021-p1/configs/resnest/deeplabv3_s101-d8_512x1024_80k_cityscapes.py --bs 8 --distributed --multi_loss --ohem --job_name resnest_puretex --resume_from /home/groups/noh/icshm_data/checkpoints/puretex/resnest_puretex_resnest_20220115-155453_resnest/latest.pth