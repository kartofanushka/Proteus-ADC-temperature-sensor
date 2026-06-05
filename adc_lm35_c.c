#define F_CPU 1000000UL 

#include <avr/io.h>
#include <util/delay.h>

void ADC_Init() {
	ADMUX = (1 << REFS0);
	ADCSRA = (1 << ADEN) | (1 << ADPS1) | (1 << ADPS0);
}

uint16_t ADC_Read() {
	ADCSRA |= (1 << ADSC);
	while (ADCSRA & (1 << ADSC));
	
	// Return the result
	return ADC;
}

int main(void) {
	DDRB = 0xFF;
	ADC_Init();
	
	while (1) {
		// Read the 10-bit analog value from ADC0
		uint16_t adc_value = ADC_Read();
		uint8_t temperature = (adc_value * 488UL) / 1000;
		
		// Output the calculated temperature to the LEDs on PORTB
		PORTB = temperature;
		_delay_ms(100);
	}
	
	return 0;
}
