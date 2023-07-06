# Check for RV_ROOT
ifeq (,$(wildcard ${RV_ROOT}/configs/veer.config))
$(error env var RV_ROOT does not point to a valid dir! Exiting!)
endif

VEER_NAME ?= el2_veer_wrapper
DESIGN_NAME ?= counter
PLATFORM ?= sky130hd
CONFIG ?= typical_pd

# The top directory where environment will be created.
TOP_DIR := ${RV_ROOT}/tools/openroad

ORFS_SUBMODULE := ${RV_ROOT}/third_party/OpenROAD-flow-scripts
ORFS := ${ORFS_SUBMODULE}/flow
YOSYS_SV_SUBMODULE := ${RV_ROOT}/third_party/yosys-systemverilog
CONFIG_DIR := ${TOP_DIR}/snapshots/$(CONFIG)
SV_HEADERS := $(CONFIG_DIR)/el2_pdef.vh $(CONFIG_DIR)/common_defines.vh $(CONFIG_DIR)/pd_defines.vh $(CONFIG_DIR)/pic_map_auto.h
BUILD_DIR := ${TOP_DIR}/build
BUILD_SRC_DIR := $(BUILD_DIR)/src
BUILD_INC_DIR := $(BUILD_DIR)/inc
OUT_DIR := $(BUILD_DIR)/physical_implementation

# A pip `requirements.txt` file.
REQUIREMENTS_FILE := ${TOP_DIR}/requirements.txt

# A conda `environment.yml` file.
ENVIRONMENT_FILE := ${TOP_DIR}/environment.yml

${RV_ROOT}/third_party/make-env/conda.mk:
	git submodule update --init --recursive ${RV_ROOT}/third_party/make-env

include ${RV_ROOT}/third_party/make-env/conda.mk

configure-veer:
	BUILD_PATH=${CONFIG_DIR} ${RV_ROOT}/configs/veer.config -target=$(CONFIG)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OUT_DIR): $(BUILD_DIR)
	mkdir -p $(OUT_DIR)

# Modify SV sources before reading those in yosys:
# 1. Include el2_param_t structure definition for each file that uses it
# 2. Replace each occurence of '`include "el2_param.vh"' with the contents of this include file
# 3. Remove unused GW_CONFIG local parameter
$(BUILD_SRC_DIR): $(BUILD_DIR) configure-veer
	mkdir -p $(BUILD_SRC_DIR)
	cp -r ${RV_ROOT}/design/* $(BUILD_SRC_DIR)/
	grep -Ir '`include "el2_param.vh"' $(BUILD_SRC_DIR) -l | uniq | xargs sed -i '1 i\`include "el2_pdef.vh"'
	grep -Ir '`include "el2_param.vh"' $(BUILD_SRC_DIR) -l | uniq | xargs sed -i -e "/\`include \"el2_param.vh\"/r $(CONFIG_DIR)/el2_param.vh" -e "/\`include \"el2_param.vh\"/d"
	sed -i '/localparam int GW_CONFIG\[pt.PIC_TOTAL_INT_PLUS1-1:0\]/d' $(BUILD_SRC_DIR)/el2_pic_ctrl.sv
	sed -i '1 i\`include "common_defines.vh"' ${BUILD_SRC_DIR}/lib/beh_lib.sv
	touch $(BUILD_SRC_DIR)

# Modify SV includes before reading those in yosys:
# 1. undefine RV_ASSERT_ON to prevent errors about unrecognised assert statements
# 2. remove el2_param.vh as its contents are now inlined where they suppose to be used (see $(BUILD_SRC_DIR))
$(BUILD_INC_DIR): $(BUILD_DIR) configure-veer
	mkdir -p $(BUILD_INC_DIR)
	cp $(SV_HEADERS) $(BUILD_INC_DIR)
	echo "\`undef RV_ASSERT_ON" >> $(BUILD_INC_DIR)/common_defines.vh
	touch $(BUILD_INC_DIR)

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
	git restore . && \
	git apply ${TOP_DIR}/yosys_sv.patch && \
	git submodule update --init --recursive Surelog yosys yosys-f4pga-plugins && \
	./build_binaries.sh

run-physical-design-flow: clean-physical-design-flow openroad-flow-patch-sv-support $(BUILD_SRC_DIR) $(BUILD_INC_DIR) | $(CONDA_ENV_PYTHON)
	$(IN_CONDA_ENV) make -C $(ORFS) DESIGN_CONFIG=${TOP_DIR}/configs/$(PLATFORM)/config.mk
	mkdir -p $(OUT_DIR)/$(PLATFORM)
	cp -r $(ORFS)/results/$(PLATFORM)/$(VEER_NAME)/base $(OUT_DIR)/$(PLATFORM)/results
	cp -r $(ORFS)/reports/$(PLATFORM)/$(VEER_NAME)/base $(OUT_DIR)/$(PLATFORM)/reports
	cp -r $(ORFS)/logs/$(PLATFORM)/$(VEER_NAME)/base $(OUT_DIR)/$(PLATFORM)/logs

clean-env:
	rm -rf ${TOP_DIR}/env

clean-build-openroad:
	rm -rf $(ORFS)/slpp_all
	rm -rf $(ORFS)/results
	rm -rf $(ORFS)/reports
	rm -rf $(ORFS)/logs

clean-build-src:
	rm -rf $(BUILD_SRC_DIR)
	rm -rf $(BUILD_INC_DIR)

clean-output-physical-design:
	rm -rf $(OUT_DIR)/$(PLATFORM)

clean-physical-design-flow: clean-output-physical-design clean-build-openroad clean-build-src
