PROJECT_NAME     := f334-discovery-dev
TARGETS          := debug release
OUTPUT_DIRECTORY := _build

PROJ_DIR  := .
SDK_ROOT  := $(PROJ_DIR)/STM32Cube_FW_F3_V1.9.0
CMSIS_DIR := $(SDK_ROOT)/Drivers/CMSIS
#RTOS_DIR := $(PROJ_DIR)/FreeRTOS/FreeRTOSv9.0.0

LINKER_SCRIPT := $(SDK_ROOT)/Projects/STM32F3348-Discovery/Templates/SW4STM32/STM32F3348-Discovery/STM32F334C8Tx_FLASH.ld

# Source files common to all targets
SRC_FILES += \
  $(CMSIS_DIR)/Device/ST/STM32F3xx/Source/Templates/gcc/startup_stm32f334x8.s \
  $(CMSIS_DIR)/Device/ST/STM32F3xx/Source/Templates/system_stm32f3xx.c \
  $(PROJ_DIR)/Source/main.c \

# Include folders common to all targets
INC_FOLDERS += \
  $(CMSIS_DIR)/Include \
  $(CMSIS_DIR)/Device/ST/STM32F3xx/Include \
  $(PROJ_DIR)/Include \

# Libraries common to all targets
LIB_FILES += \

# C flags common to all targets
CFLAGS += -mcpu=cortex-m4
CFLAGS += -mthumb -mabi=aapcs --std=gnu99
CFLAGS +=  -Wall -Werror -Wno-unused-const-variable
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16 
# keep every function in a separate section, this allows linker to discard unused ones
CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
CFLAGS += -fno-builtin -fshort-enums
CFLAGS += -DSTM32F334x8

# Assembler flags common to all targets
ASMFLAGS += -mcpu=cortex-m4
ASMFLAGS += -mthumb -mabi=aapcs
ASMFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
ASMFLAGS += -DSTM32F334x8

# Linker flags
LDFLAGS += -mthumb -mabi=aapcs -T $(LINKER_SCRIPT)
LDFLAGS += -mcpu=cortex-m4
LDFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
# let linker dump unused sections
LDFLAGS += -Wl,--gc-sections
# use newlib in nano version
LDFLAGS += --specs=nano.specs


# Target flags
debug: CFLAGS += -O0 -g3 -DDEBUG -DDEBUG_NRF_USER
debug: ASMFLAGS += -g3
release: CFLAGS += -O3 -DNDEBUG


.PHONY: $(TARGETS) all clean help

all: $(TARGETS)

# Print all targets that can be built
help:
	@echo The following targets are available:
	@echo $(TARGETS)
	@echo Programming:
	@echo flash_debug flash_release erase


include Makefile.common
$(foreach target, $(TARGETS), $(call define_target, $(target)))

.PHONY: flash erase

# Flash the program
flash_debug: $(OUTPUT_DIRECTORY)/debug.hex
	@echo Flashing: $<
	nrfjprog -f nrf52 --program $< --sectorerase
	nrfjprog -f nrf52 --reset

flash_release: $(OUTPUT_DIRECTORY)/release.hex
	@echo Flashing: $<
	nrfjprog -f nrf52 --program $< --sectorerase
	nrfjprog -f nrf52 --reset

erase:
	nrfjprog -f nrf52 --eraseall

