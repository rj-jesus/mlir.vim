#!/bin/bash

set -eu

LLVM_GIT=${LLVM_GIT:-$HOME/llvm-project}
LLVM_URL=${LLVM_URL:-https://github.com/llvm/llvm-project}
MLIR_TMP=${MLIR_TMP:-`mktemp -du`}
MLIR_VIM=${MLIR_VIM:-$HOME/mlir.vim}

[ -d $LLVM_GIT ] || git clone $LLVM_URL $LLVM_GIT

cd $LLVM_GIT
git pull

mkdir -p $MLIR_TMP
cp -a .git $MLIR_TMP/
cp -a --parents mlir/utils/vim $MLIR_TMP/

cd $MLIR_TMP
git filter-repo --subdirectory-filter mlir/utils/vim --force

cd $MLIR_VIM
git pull --no-edit $MLIR_TMP
git log -1 --pretty=oneline | grep -q $MLIR_TMP && git commit --amend -m "Merge upstream into main"
git push origin main
rm -rf $MLIR_TMP
