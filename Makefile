.ONESHELL:

PROJECT?=voxel-bayes
VERSION?=3.12
VENV=${PROJECT}-${VERSION}
VENV_DIR=$(shell pyenv root)/versions/${VENV}
PYTHON=${VENV_DIR}/bin/python

VARS = PYDEVD_DISABLE_FILE_VALIDATION=1


SHELL = /bin/bash
CONDA_ACTIVATE = source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate

install-pip:
	@echo "Installing $(VENV)"
	env PYTHON_CONFIGURE_OPTS=--enable-shared pyenv install --skip-existing ${VERSION}
	env PYTHON_CONFIGURE_OPTS=--enable-shared pyenv virtualenv ${VERSION} ${VENV}
	pyenv local ${VENV}
	$(PYTHON) -m pip  install -U pip
	CC=gcc $(PYTHON) -m pip install  -r requirements.txt
#	CC=gcc $(PYTHON) -m pip install --no-deps --ignore-installed git+https://github.com/pymc-devs/pytensor
	PYDEVD_DISABLE_FILE_VALIDATION=1  $(PYTHON) -m ipykernel install --user --name ${VENV}


update:
	$(PYTHON) -m pip install --upgrade -r requirements.txt --upgrade-strategy=eager
#	CC=gcc $(PYTHON) -m pip install --no-deps --ignore-installed git+https://github.com/pymc-devs/pytensor


install:
	$(eval PYTHON := ~/.pyenv/versions/${VENV}/bin/python)
	$(eval PYTHON_DIST := miniconda3-3.12-24.9.2-0)
	$(eval CONDA_BIN := ~/.pyenv/versions/${PYTHON_DIST}/bin/conda)
	$(eval VENV := ${VENV})
	@echo "Installing $(VENV) with $(PYTHON_DIST)"
	env PYTHON_CONFIGURE_OPTS=--enable-shared pyenv install --skip-existing ${PYTHON_DIST}
#	${CONDA_BIN} update -n base -c conda-forge conda
	pyenv uninstall ${VENV} || true
#	${CONDA_BIN} create -n ${VENV}  -c conda-forge python=3.12 pytensor   ipykernel
	${CONDA_BIN} env update -n ${VENV} -f local.yml 
	$(eval CONDA_ENV_PATH := $(shell ${CONDA_BIN} env list | grep '${VENV}' | awk '{print $$2}'))
	@echo "Linking Conda environment to pyenv"
	$(eval PYENV_ROOT := $(shell pyenv root))
	ln -sfn  ~/.pyenv/versions/${PYTHON_DIST}/envs/${VENV} ${PYENV_ROOT}/versions/${VENV}
	@eval "$$(pyenv init -)" && \
	pyenv activate ${VENV}; \
	pyenv local ${VENV}; \
	PYDEVD_DISABLE_FILE_VALIDATION=1 ${PYTHON} -m ipykernel install --user --name ${VENV}


pdf:
	quarto preview draft/draft.qmd

doc:
	@CHAPTER=ch04; \
	quarto render draft/$$CHAPTER.md  --to docx

install-local:
	cd src/Python && flit install --symlink --python ${PYTHON} & cd ../..

python-info:
	echo ${VIRTUAL_ENV}

conda-update:
	$(eval PYTHON_DIST := miniforge3-latest)
	$(eval CONDA_BIN := ~/.pyenv/versions/${PYTHON_DIST}/bin/conda)
	${CONDA_BIN}  update   --prefix ~/.pyenv/versions/${PYTHON_DIST} --all --yes

smk:
	cd scripts/RBA &&   snakemake -s rba.smk  --delete-output  all &&  snakemake -s rba.smk all


ggseg:
	$(eval FOLDER := /Users/daniel/PhD/Projects/python-ggseg)
	echo ${FOLDER}
	$(eval BASE := $(shell pwd))
	echo ${BASE}
	cd ${FOLDER} && flit install --symlink --python ${PYTHON} && cd ${BASE}

install-pip:
	@echo "Installing $(VENV)"
	env PYTHON_CONFIGURE_OPTS=--enable-shared pyenv install --skip-existing ${VERSION}
	env PYTHON_CONFIGURE_OPTS=--enable-shared pyenv virtualenv ${VERSION} ${VENV}
	pyenv local ${VENV}
	$(PYTHON) -m pip  install -U pip
	$(PYTHON) -m pip install  -r requirements.txt
	PYDEVD_DISABLE_FILE_VALIDATION=1  $(PYTHON) -m ipykernel install --user --name ${VENV}

