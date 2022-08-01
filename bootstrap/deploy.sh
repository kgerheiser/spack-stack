#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# inputs
stack_git="https://github.com/kgerheiser/spack-stack.git"
stack_tag="feature/hpc-dev-env"
tag_abbrev="hpc-stack-test"
stack_dir="/Users/KIG/dev/spack-stack"
template="hpc-stack-dev"
env_name="hpc-stack-dev"

env_dir="${stack_dir}/envs/${tag_abbrev}"
install_dir="${env_dir}/${name}"
modules_install_dir="${install_dir}/modulefiles"

source ${SCRIPT_DIR}/detect_machine.sh
site=${MACHINE_ID}
site="macos.default"

if [[ ! -d stack_dir ]]; then
    mkdir ${stack_dir} && cd ${stack_dir}
fi

mkdir -p ${env_dir} && cd ${env_dir}
git clone --recursive -b ${stack_tag} ${stack_git} src
cd src

source setup.sh
spack stack create env --site ${site} --template ${template} --name ${env_name}
spack env activate -d envs/${env_name}

spack config add "config:install_tree:root:${install_dir}"
spack config add "modules:default:roots:lmod:${modules_install_dir}"
spack config add "modules:default:roots:tcl:${modules_install_dir}"

# case ${site} in
#     cheyenne)
#         module purge
#         module unuse /glade/u/apps/ch/modulefiles/default/compilers
#         export MODULEPATH_ROOT=/glade/work/jedipara/cheyenne/spack-stack/modulefiles
#         module use /glade/work/jedipara/cheyenne/spack-stack/modulefiles/compilers
#         module use /glade/work/jedipara/cheyenne/spack-stack/modulefiles/misc
#         module load miniconda/3.9.12
#     gaea)
#         module purge
#         module use /scratch1/NCEPDEV/jcsda/jedipara/spack-stack/modulefiles
#         module load miniconda/3.9.12
#         ;;
#     jet)
#         module purge
#         module use /lfs4/HFIP/hfv3gfs/spack-stack/modulefiles
#         module load miniconda/3.9.12
#         ;;
#     orion)
#         module purge
#         module use module use /work/noaa/da/jedipara/spack-stack/modulefiles
#         module load miniconda/3.9.7
#         ;;
#     hera)
#         module purge
#         module use /scratch1/NCEPDEV/global/spack-stack/modulefiles
#         module load miniconda/3.9.12
#         ;;
#     s4)
#         module purge
#         module use /data/prod/jedi/spack-stack/modulefiles
#         module load miniconda/3.9.7
#         ;;
# esac
