AS  = avr-as
FLASH_TARGET = attiny13
ASFLAGS = -mmcu=attiny13 -g

TARGET = out.hex
Sources = out.s 

SourcePrefix = src/
BuildPrefix = build/
BuildFolder = build

Source = $(addprefix $(SourcePrefix), $(Sources))
Objects = $(patsubst $(SourcePrefix)%.s, $(BuildPrefix)%.o, $(Source))
HexFile = $(addprefix $(BuildPrefix), $(TARGET))

.PHONY: all clean flash

all: hexing 

$(BuildPrefix)%.o : $(SourcePrefix)%.s
	@echo [AS] $< "-->" $@
	@$(AS) $(ASFLAGS) $< -o $@

hexing : $(Objects)
	@echo [HEX] $(Objects) "-->" $(HexFile)
	@avr-objcopy -j .text -O ihex $(Objects) $(HexFile)
	@echo Hexing complete!

flash : hexing
	@echo [FLASH] $(FLASH_TARGET) "-->" flash:w:$(HexFile):i
	@avrdude -p $(FLASH_TARGET) -c usbasp -U flash:w:$(HexFile):i -F -P usb

clean:
	@echo [CLEAN]
	mkdir -p $(BuildFolder)
	rm -rf ./$(BuildFolder)/*.o 
	rm -rf ./$(BuildFolder)/*.hex 