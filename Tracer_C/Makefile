AS  = avr-gcc
FLASH_TARGET = attiny13
ASFLAGS = -mmcu=attiny13 -g -O1 -Iinclude

TARGET = tracer.hex
Sources = main.c utils.c init.c custom_delay.c
LinkedFile = linked.elf

SourcePrefix = src/
BuildPrefix = build/
BuildFolder = build

LinkedObject = $(addprefix $(BuildPrefix), $(LinkedFile))
Source = $(addprefix $(SourcePrefix), $(Sources))
Objects = $(patsubst $(SourcePrefix)%.c, $(BuildPrefix)%.o, $(Source))
HexFile = $(addprefix $(BuildPrefix), $(TARGET))

.PHONY: all clean flash

all: hexing 

$(BuildPrefix)%.o : $(SourcePrefix)%.c
	@echo [AS] $< "-->" $@
	@$(AS) $(ASFLAGS) -c $< -o $@

compile: $(Source)
	@echo [AS] $(Source) "-->" $(LinkedObject)
	@$(AS) $(ASFLAGS) $(Source) -o $(LinkedObject)
 
hexing : compile
	@echo [HEX] $(LinkedObject) "-->" $(HexFile)
	avr-objcopy -j .text -O ihex $(LinkedObject) $(HexFile)
	@echo Hexing complete!

flash : hexing
	@echo [FLASH] $(FLASH_TARGET) "-->" flash:w:$(HexFile):i
	@avrdude -p $(FLASH_TARGET) -c usbasp -U flash:w:$(HexFile):i -F -P usb

objdump: 
	@echo [OBJDUMP] $(LinkedObject)
	@avr-objdump -d $(LinkedObject)

clean:
	@echo [CLEAN]
	mkdir -p $(BuildFolder)
	rm -rf ./$(BuildFolder)/*.o 
	rm -rf ./$(BuildFolder)/*.hex 