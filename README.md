# Rayleigh Channel Model

Simulación de un canal de Rayleigh que hace uso de MATLAB. Se simulan un total de 3 escenarios, variando el comportamiento del canal, la distancia de los símbolos pilotos, la modulación utilizada (16QAM, QPSK) y si se hace uso de codificación de canal o no.

El objetivo de la simulación es calcular las curvas de BER vs $\frac{E_b}{N_0}$ para valores de SNR en [-2, 30] dB, cada escenario se simula un total de 21 veces para que sea estadísticamente representativo. 

## Diagrama de flujo de la simulación

![Flujo General](imgs/digital_system.png)

Para ejecutar la simulación hay que hacerlo desde el archivo ```main.m```, escogiendo un escenario a simular.
