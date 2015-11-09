#include <avr/io.h>
#include <util/delay.h>
 
#define BLINK_DELAY_MS 1000
 
void led_setup(void) {
  DDRB |= _BV(DDB5);
}

void led_on() {
  PORTB |= _BV(PORTB5);
}

void led_off() {
  PORTB &= ~_BV(PORTB5);
}

void delay(int ms) {
  _delay_ms(ms);
}
