# Check for RV_ROOT
ifeq (,$(wildcard ${RV_ROOT}/configs/veer.config))
$(error env var RV_ROOT does not point to a valid dir! Exiting!)
endif

# The top directory where environment will be created.
TOP_DIR := ${RV_ROOT}/tools/openroad

# A pip `requirements.txt` file.
REQUIREMENTS_FILE := ${TOP_DIR}/requirements.txt

# A conda `environment.yml` file.
ENVIRONMENT_FILE := ${TOP_DIR}/environment.yml

${RV_ROOT}/third_party/make-env/conda.mk:
	git submodule update --init --recursive ${RV_ROOT}/third_party/make-env

include ${RV_ROOT}/third_party/make-env/conda.mk

# Example make target which runs commands inside the conda environment.
test-command: | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) echo "Python is $$(which python)"
	@$(IN_CONDA_ENV) python --version

clean-env:
	rm -rf ${TOP_DIR}/env
