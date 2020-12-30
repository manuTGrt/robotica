# Robótica

<p>En este curso de robótica vamos a crear un robot capaz de identificar si existen objetos delante de él, llegando incluso a crear un mapa del lugar por donde pasa y esquivando los objetos impuestos.

Al comienzo de la asignatura el profesor no recomendó guardar el id de nuestro robot, lo podrás encontrar en el siguiente enlace:</p>
* [ID Robot](https://github.com/manuTGrt/robotica/blob/main/id%20robot.txt)

## Cada Pieza 🧩

1. [Cabeza](https://github.com/manuTGrt/robotica#1-cabeza-)
2. [Cuerpo](https://github.com/manuTGrt/robotica#2-cuerpo-)

### 1. Cabeza 🤖

#### Motor de movimiento ⚙️

<p>Empezamos el experimento comprobando que leíamos correctamente el giro de la rueda que posteriormente usaremos para el movimiento de la cabeza. Este movimiento lo hacemos inicialmente con la mano.</p>

![Movimiento del motor a mano con K=0.3](https://github.com/manuTGrt/robotica/blob/main/fotos/cabeza_k0,3_Movido_M_A_color.jpg)

<p align="center"><img src="https://github.com/manuTGrt/robotica/blob/main/videos/mover_cabeza_con_motor_manual.gif"></p>

<p>Posteriormente, movemos la cabeza unos grados indicados, en los que vemos que, variando la ganancia, la cabeza se movía de forma inestable, llegando a la conclusión de que un buen valor de ganancia para que no sea inestable sea 0,3.

Luego, intentamos mover la cabeza, cambiando la referencia de los grados indicados previamente a un valor variable, el cual variamos con la rueda, teniendo en cuenta el valor de la ganancia para ajustarlo a su mejor valor, en mi caso 0.3.

Esto lo podemos ver con la siguiente gráfica.</p>

![Movimiento de cabeza con K=0.3](https://github.com/manuTGrt/robotica/blob/main/fotos/cabeza_k0%2C3_Movido_sin(90g)_color.jpg)
- En color verde tenemos el movimiento que debería seguir el motor en una simulación en la que el movimiento sería perfecto.
- En color rojo tenemos el movimiento real que ha seguido el motor, con la ganancia en 0.3, como vemos, es casi perfecto.

#### Sensor sonar 👀
<p>Este es el sensor que irá leyendo los obstáculos que se encuentre, para poder esquivarlos sin sufrir un accidente.

Lo primero que hicimos fue hacer el dibujo del robot, haciendo que el dibujo moviera la cabeza de manera simulada.</p>
<p align="center"><img width="350px" height="200px" src="https://github.com/manuTGrt/robotica/blob/main/mi_solucion/Crear_Robot.jpg"></p>

<p>Posteriormente hacemos que se dibuje una simulación de lo que sería la lectura del sonar, a una distancia fija con un giro de la cabeza.</p>
<p align="center"><img width="300px" src="https://github.com/manuTGrt/robotica/blob/main/fotos/lectura_sonic_simulada.jpg"></p>

<p>Luego lo implementamos en el robot y comprobamos que gira la cabeza y va leyendo los obstáculos que se va encontrando.</p>
<p align="center"><img width="300px" src="https://github.com/manuTGrt/robotica/blob/main/fotos/robot_mueve_cabeza_y_lee_sonic.gif"></p>

### 2. Cuerpo 🧠

<p>El cuerpo del robot es su cerebro, el que controla todos los motores y sensores de cada parte del robot.</p>

#### Montaje

<p>El montaje del robot se realiza con piezas lego, con las que poco a poco vamos dandole forma para así acoplar todas y cada una de las partes.

El profesor nos ha dejado un vídeo para que el montaje del robot sea más rápido y sencillo para nosotros.</p>

<p align="center"><a href="http://www.legoengineering.com/the-harvester-a-quick-ev3-robot-build/"><img src="https://github.com/manuTGrt/robotica/blob/main/videos/montaje_robot.gif"></a></p>

<p>La cabeza del robot la hemos modificado de sitio para que esté centrada.

También hemos añadido un pulsador en el frontal, para que si el sensor sonar no detecta ningún objeto, éste se pulse y pueda retroceder y buscar otro camino.</p>

## Puesta en funcionamiento

Para poner en funcionamiento todo el robot, el profesor ha puesto a nuestra disposición una carpeta:

- [**Carpeta**](https://github.com/manuTGrt/robotica/tree/main/mover_robot)

Ésta contiene los siguientes elementos:
- maquina_estado_basica.m: Contiene la programación del robot en su mayoría, para que vaya cambiando de estado según la situación en que se encuentre.
  - Al principio de este fichero limpiamos todas las variables necesarias, luego declaramos e inicializamos las variables necesarias, además de iniciar los motores del robot.
  - Los diferentes estados son:
    - 1- Marchando para delante.
    - 2- Parando.
    - 3- Girando la cabeza con sonar.
    - 4- Girando sobre sí mismo.
    - 5- Marcha atrás.
  - Al final del fichero manda el comando "para", que ejecutará la función "para" para parar por completo el robot.
- para.m: Contiene la programación que se encarga de parar el robot. En caso de tener algún fallo, podemos ejecutarlo desde la línea de comandos y pararemos manualmente el robot.
- Signal_reading_odo.m: Contiene la programación que se encarga de leer las señales del sensor sonar y de los encoders de los motores de la cabeza y las ruedas para evitar oscilaciones en los procesos de control del giro de la cabeza, las consultas al estado de los  motores de tracción solo se hacen en los estados necesarios.
  - Si está en el estado 3:
    - Significa que está girando la cabeza y, por tanto, no lee los encoders de las ruedas pero sí el de la cabeza.
  - Si no está en el estado 3:
    - Significa que la cabeza no está girando y, por tanto, no lee el encoder de la cabeza pero sí los de las ruedas.
- Traction_motor_control.m: Es el encargado de mandar las señales de control a los motores, controlando la velocidad máxima a la que se mueven en cada uno de los sentidos.
- WiFi_connection.m: Es el encargado de realizar la conexión mediante wifi del programa MatLab con el robot.

Mira **Deployment** para conocer como desplegar el proyecto.


## Ejecutando las pruebas ⚙️

_Explica como ejecutar las pruebas automatizadas para este sistema_

### Analice las pruebas end-to-end 🔩

_Explica que verifican estas pruebas y por qué_

```
Da un ejemplo
```

### Y las pruebas de estilo de codificación ⌨️

_Explica que verifican estas pruebas y por qué_

```
Da un ejemplo
```

## Construido con 🛠️

La herramienta utilizada para la programación del robot es MatLab, en general he usado la versión 18, pero en casa para algunas simulaciones he usado la versión 20.

* [MatLab](https://es.mathworks.com/products/matlab.html) - Versión 18

Para la conexión wifi, el profesor nos ha dejado un adaptador wifi de tamaño mini. También nos ha construido la programación de éste.


## Autores ✒️

_Este proyecto ha sido realizado por:_

* **Manuel Tejada Guzmán** - *Todo mi GitHub* - [manuTGrt](https://github.com/manuTGrt)

_Con ayuda del profesor Fernando Gómez Bravo, que ha llevado el seguimiento y resuelto todas las dudas sobre este proyecto_


## Licencia 📄

Este proyecto está bajo la Licencia (Tu Licencia) - mira el archivo [LICENSE.md](LICENSE.md) para detalles

## Expresiones de Gratitud 🎁

* Comenta a otros sobre este proyecto 📢
* Invita una cerveza 🍺 o un café ☕ a alguien del equipo.
* Da las gracias públicamente 🤓.
* etc.



---
⌨️ con ❤️ por [manuTGrt](https://github.com/manuTGrt) 😊
