# Check for RV_ROOT
ifeq (,$(wildcard ${RV_ROOT}/configs/veer.config))
$(error env var RV_ROOT does not point to a valid dir! Exiting!)
endif

DESIGN_NAME ?= counter
PLATFORM ?= sky130hd

ORFS_SUBMODULE := ${RV_ROOT}/third_party/OpenROAD-flow-scripts
ORFS := ${ORFS_SUBMODULE}/flow
YOSYS_SV_SUBMODULE := ${RV_ROOT}/third_party/yosys-systemverilog

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
test-command: synthesis-tools | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) echo "Python is $$(which python)"
	@$(IN_CONDA_ENV) python --version
	@$(IN_CONDA_ENV) openroad -help
	@$(IN_CONDA_ENV) klayout -h
	surelog --version
	yosys --version
	yosys -p "plugin -i systemverilog; plugin -l"

# OpenROAD-flow-scripts flow Makefile has hardcoded absolute
# path to `/usr/bin/time` which does not work in conda env.
# Replace the path with absolute path to time installed in conda env.
openroad-flow-fixup-time:
	git submodule update --init --recursive ${ORFS_SUBMODULE} && \
	cd $(ORFS) && \
	git restore . && \
	sed -i 's,TIME_CMD = \/usr\/bin\/time,TIME_CMD = $(CONDA_ENVS_DIR)\/$(CONDA_ENV_NAME)\/bin\/time,g' Makefile

# Patch OpenROAD-flow-scripts synthesis script for yosys
# so that it would use systemverilog plugin and would
# read SV sources of VeeR EL2
openroad-flow-patch-sv-support: openroad-flow-fixup-time
	cd $(ORFS) && \
	git apply ${TOP_DIR}/orfs.patch

test-openroad-flow: openroad-flow-fixup-time | $(CONDA_ENV_PYTHON)
	$(IN_CONDA_ENV) make -C $(ORFS)

test-physical-design-flow: openroad-flow-fixup-time | $(CONDA_ENV_PYTHON)
	$(IN_CONDA_ENV) make -C $(ORFS) DESIGN_CONFIG=${RV_ROOT}/$(DESIGN_NAME)/$(PLATFORM)/config.mk

synthesis-tools:
	git submodule update --init ${YOSYS_SV_SUBMODULE} && \
	cd ${YOSYS_SV_SUBMODULE} && \
	git submodule update --init --recursive Surelog yosys yosys-f4pga-plugins && \
	./build_binaries.sh

clean-env:
	rm -rf ${TOP_DIR}/env

clean-build-openroad:
	rm -rf $(ORFS)/results
	rm -rf $(ORFS)/reports
	rm -rf $(ORFS)/logs

clean-output-physical-design:
	rm -rf $(OUT_DIR)/$(PLATFORM)

clean-physical-design-flow: clean-output-physical-design clean-build-openroad
