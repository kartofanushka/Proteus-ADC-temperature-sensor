.include "m32def.inc"

.org 0x0000
    rjmp reset

reset:
    ; --- Set up the Stack Pointer ---
    ldi r16, high(RAMEND)
    out SPH, r16
    ldi r16, low(RAMEND)
    out SPL, r16

    ; --- Configure PORTB as Output ---
    ldi r16, 0xFF      
    out DDRB, r16      

    ; --- Initialize ADC ---
    ldi r16, (1<<REFS0) 
    out ADMUX, r16
    
    ldi r16, (1<<ADEN) | (1<<ADPS1) | (1<<ADPS0)
    out ADCSRA, r16

main_loop:
    ; --- Start ADC Conversion ---
    sbi ADCSRA, ADSC   

wait_adc:
    ; --- Wait for Conversion to Complete ---
    sbic ADCSRA, ADSC
    rjmp wait_adc      

    ; --- Read ---
    in r16, ADCL       
    in r17, ADCH       
    
    ; --- MULTIPLICATION ---
    ldi r20, 125       
    
    
    mul r16, r20       
    mov r24, r0        
    mov r25, r1        
    
    ldi r21, 128
    add r24, r21
    clr r21            
    adc r25, r21       
    mul r17, r20       
    add r25, r0        
    
    ; --- 8. Output Result ---
    out PORTB, r25     
    rcall delay_fast

    rjmp main_loop     

; --- Delay ---
delay_fast:
    ldi r18, 10       
df1: ldi r19, 255
df2: dec r19
    brne df2
    dec r18
    brne df1
    ret
