#define F_CPU 1000000UL

#include "utils.h"

// Функция инициализации портов ввода/вывода
void PORT_B_Init() {
    // Настройка порта B
    DDRB |= (1 << DDB4);  // Установка PB4 как выход
    PORTB |= (1 << PB0);  // Установка 1 в PB0
    LED_Off();            // Установка низкого уровня на PB0
}

// Функция инициализации таймера
void Timer_Init() {
    // Настройка таймера/счетчика0
    TCCR0B |= (1 << CS02) | (1 << CS00); // Предделитель 1024
    TCCR0A |= (1 << WGM01);              // CTC режим
    OCR0A = 0xff;                        // Загрузка порогового значения
    TIMSK0 |= (1 << OCIE0A);             // Разрешение прерывания по переполнению OCIE0A
}

// Настройка аналогового компаратора
void ANA_Comp_Init() {
    ACSR |= (1 << ACIS1);
    ACSR &= ~(1 << ACBG);
    Enable_ANA_Comp();
}

// Прерывание по компаратору
ISR(ANA_COMP_vect) {
    // Отключение прерывания компаратора
    Disable_ANA_Comp();

    LED_On();
    _delay_ms(500);
    LED_Off();

    Clean_ANA_Comp_Flag();
    Enable_ANA_Comp();
}

int main(void) {
    // Инициализация периферии
    PORT_B_Init();
    // Timer_Init();
    ANA_Comp_Init();

    // Разрешение глобальных прерываний
    sei();

    // Основной цикл программы
    while (1) {}

    return 0;
}
