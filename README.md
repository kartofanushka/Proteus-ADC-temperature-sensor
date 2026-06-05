# AVR ATmega32 Temperature Monitoring System (LM35 + ADC)

This repository contains the embedded C firmware and hardware simulation for a digital thermometer system. The project reads analog temperature data from an **LM35 sensor**, processes it using the internal Analog-to-Digital Converter (ADC) of an **ATmega32** microcontroller, and displays the temperature value in binary format via a bank of 8 LEDs.

## Features

* **Precise Analog Sampling:** Utilizes the ATmega32's 10-bit successive approximation ADC.
* **Real-Time Binary Display:** Outputs the calculated Celsius temperature in an 8-bit binary format onto PORTB LEDs.
* **Optimized Power & Clocking:** Configured for low-power operation running at an internal clock speed of
 **1.0 MHz** (`F_CPU = 1000000UL`).
* **Hardware Debouncing/Filtering:** Employs a 100ms polling delay to stabilize measurements and prevent LED flickering.

---

## Simulation Preview

https://github.com/user-attachments/assets/9c87f808-836e-4d7b-82b2-6c37d2bfc695

---

## Hardware Architecture & Configuration

The schematic, modeled and tested in Proteus (as shown in `week6_ADC_C.mp4`), consists of the following components:

### 1. Temperature Sensor (LM35)

* **Connection:** Output pin (`VOUT`) is connected to **PA0 (ADC0)**.
* **Characteristics:** The LM35 provides a linear voltage output directly proportional to the Celsius temperature ($10\text{ mV/°C}$). For instance, at $27.0\text{°C}$, the sensor outputs $0.27\text{ V}$.

### 2. Microcontroller Configuration (ATmega32)

* **Voltage Reference ($V_{\text{REF}}$):** Configured to use `AVCC` ($5\text{ V}$) with an external capacitor on the `AREF` pin for noise reduction.
* **ADC Prescaler:** Set to **8** to scale down the $1\text{ MHz}$ system clock to a safe and accurate ADC sampling frequency of $125\text{ kHz}$.

### 3. Visual Output (LED Bank)

* **Connection:** 8 LEDs (`D1` through `D8`) are connected directly to **PORTB (PB0 - PB7)** with current-limiting resistors.
* **Display Logic:** The LEDs display the absolute integer value of the temperature in binary (e.g., $25\text{°C} = \text{0b00011001}$, lighting up LEDs on PB0, PB3, and PB4).

---

## Mathematical Formula

The code translates the 10-bit ADC raw digital value back into an integer temperature using fixed-point math to avoid costly floating-point operations on the 8-bit MCU:

$$\text{Step Voltage} = \frac{5000\text{ mV}}{1024} \approx 4.88\text{ mV / ADC unit}$$

$$\text{Temperature (°C)} = \frac{\text{ADC Value} \times 4.88\text{ mV}}{10\text{ mV/°C}} = \frac{\text{ADC Value} \times 488}{1000}$$

---

## Firmware Overview

The code is modularly structured in C:

* `ADC_Init()`: Configures the reference voltage (`REFS0`) and powers on the ADC circuitry with the correct clock prescaler.
* `ADC_Read()`: Starts a single conversion conversion cycle, polls the `ADSC` flag until completion, and returns the 10-bit result.
* `main()`: Main execution loop that samples the sensor, applies the conversion matrix, updates `PORTB`, and idles for 100ms.



