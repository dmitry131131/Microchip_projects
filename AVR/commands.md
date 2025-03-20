
## Компиляция

```sh
    avr-as -mmcu=attiny13 -o test.o -g test.s
```

## Компоновка для отладки

Полученный образ мы используем для отладки нашего теста. 

```sh
    avr-ld -m avr4 -o test.elf test.o
```

## Компоновки в HEX

Из него же можно сгенерировать и hex-файл

явно указывая ключем -j включаемые в прошивку секции, ключем -O ihex формат вывода (intel HEX). Получаем тот же файл, что и в предыдущем случае:

```sh
    avr-objcopy -j .text -j .data -O ihex test.elf test.hex
```

## Прошивка

https://fornk.ru/5252-kak-skompilirovat-i-zapisat-kod-na-mikrosxemu-avr-v-linux-macosx-windows/?ysclid=m6q8xr0wdr912487591

Утилитa пoд нaзвaниeм avrdude мoжeт прoгрaммирoвaть микрoпрoцeccoры, иcпoльзуя coдeржимoe фaйлoв .HEX, укaзaнных в кoмaнднoй cтрoкe.

С пoмoщью привeдeннoй нижe кoмaнды фaйл main.hex будeт зaпиcaн вo флэш-пaмять. Пaрaмeтр -p attiny13 пoзвoляeт avrdude узнaть, чтo мы рaбoтaeм c микрoкoнтрoллeрoм ATtiny13. Другими cлoвaми — этa oпция oпрeдeляeт уcтрoйcтвo.

https://www.nongnu.org/avrdude/user-manual/avrdude_4.html - Список поддерживаемых МК

```sh
    avrdude -p attiny13 -c usbasp -U flash:w:main.hex:i -F -P usb
```