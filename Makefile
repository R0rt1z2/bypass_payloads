CC := arm-none-eabi-gcc
AS := arm-none-eabi-as
LD := arm-none-eabi-gcc
OBJCOPY := arm-none-eabi-objcopy

SOCS := mt8173 mt8163 mt8695
PAYLOADS := $(SOCS:%=payloads/%_payload.bin)

CFLAGS := -std=gnu99 -Os -mthumb -mcpu=cortex-a9 -fno-builtin-printf -fno-strict-aliasing -fno-builtin-memcpy -mno-unaligned-access -Wall -Wextra
LDFLAGS := -nodefaultlibs -nostdlib -lgcc

COMMON_OBJ = payloads/common.o payloads/start.o

all: $(PAYLOADS)

payloads/%_payload.bin: payloads/%.elf
	$(OBJCOPY) -O binary $^ $@

payloads/%.elf: payloads/%.o $(COMMON_OBJ) %.ld
	$(LD) -o $@ payloads/$*.o $(COMMON_OBJ) $(LDFLAGS) -T $*.ld

payloads/%.o: %.c
	mkdir -p $(@D)
	$(CC) -c -o $@ $< $(CFLAGS)

payloads/%.o: %.S
	mkdir -p $(@D)
	$(AS) -o $@ $<

clean:
	-rm -rf payloads
