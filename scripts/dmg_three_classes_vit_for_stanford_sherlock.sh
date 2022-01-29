#!/bin/bash
#
#SBATCH --job-name=icshm_dmg_vit
#SBATCH --output=icshm_dmg_vit.out
#SBATCH --error=icshm_dmg_vit.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=liujx@stanford.edu
#SBATCH --time=24:00:00
#SBATCH -p gpu
#SBATCH -c 4
#SBATCH -G 4

date

module load py-pytorch/1.6.0_py36
pip3 install mmcv_full -f https://download.openmmlab.com/mmcv/dist/cu102/torch1.6.0/index.html
pip3 install git+https://github.com/open-mmlab/mmsegmentation.git
pip3 install tqdm

cd ~/research/icshm/ic-shm2021-p1/damage_detection/

python3 -m torch.distributed.launch --nproc_per_node=2 train_3classes_for_stanford_sherlock.py --nw vit --cp ~/research/icshm/ic-shm2021-p1/configs/vit/upernet_vit-b16_mln_512x512_80k_ade20k.py --bs 2