## Curso de Microprocesadores
#PROYECTO FINAL

##Comunicación serial
Objetivo general: Implementar un sistema de comunicación serial de un solo hilo (sin señal de reloj).
Materiales:  Placa de desarrollo ATmega328P Xplained Mini, módulo multifunción para Arduino, cable micro usb y herramienta de desarrollo Microchip Studio. 

##Introducción
Un protocolo de transmisión serie transmite datos por ejemplo de un CPU a un periférico de 1 bit a la vez. En el caso de protocolos de 1 solo cable (o 1 hilo), no hay una señal de reloj dedicada, sino que los bits van uno a continuación siguiendo alguna convención y eventualmente el reloj se puede recuperar después. Por supuesto la comunicación de 1 hilo, necesita una referencia a tierra común entre los dos dispositivos. Antes que se desarrollaran los protocolos modernos como USB en sus distintas versiones, Ethernet, el SPI más simple, la mayoría de los procesadores y ordenadores disponían de puertos de este estilo, asíncronos, según el estándar RS232.

##Implementación
Implemente en la placa de desarrollo del curso un sistema de comunicación serial con las siguientes características:

Parte 1: Realizar un algoritmo que genere números pseudo-aleatorios en lenguaje ensamblador. Puede utilizar el algoritmo que desee para la tarea, cuidar que sea simple. La rutina a desarrollar, cada vez que se llama debe guardar un buffer en memoria RAM de 512 bytes. Muestre a modo de verificación, la suma de los 512 números por el display de la placa (últimos dígitos Hexa).

Parte 2: Desarrollar algún método de transmisión de datos entre dos placas con 1 solo cable (por ahora unidireccional, una placa transmite (maestro), otra recibe), el cable será provisto por los docentes del curso.  Pruebe transmitir los 512 bytes. Despliegue en el display de la placa receptora la suma de los 512 bytes a modo de verificación. Se sugiere que el mecanismo de transmisión se inicie luego de pulsar un botón en la placa maestro. 

Parte 3: Estudiar códigos de Hamming, empezando por el código de longitud 7 (pero puede usar otros códigos para la tarea). Implemente un código en lenguaje ensamblador en la placa maestro capaz de codificar en Hamming los datos a transmitir. Implemente en la placa receptora el algoritmo de detección y corrección de errores simples.  Transmita ahora los datos codificados. Simule introducir algunos errores en el mensaje a transmitir, y verifique la capacidad de su algoritmo de corregir y detectar errores en la placa receptora.

Parte 4: Agregue ahora al final del mensaje los 4 bytes de la suma de los 512 números generados de manera de verificar en el receptor, la integridad del mensaje en su conjunto. En informática lo habitual es utilizar no sumas (checksum) sino códigos de otro tipo como por ejemplo CRC para esta tarea (por ejemplo para verificar la integridad de un archivo en disco). De manera opcional puede implementar un CRC en este trabajo para chequear la integridad de su mensaje completo, estudie cuáles son las ventajas de un CRC frente a transmitir solamente la suma. 

Desafío: Pruebe transmitir a la máxima velocidad posible, datos entre una placa y otra.


