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


Mira **Deployment** para conocer como desplegar el proyecto.


### Pre-requisitos 📋

_Que cosas necesitas para instalar el software y como instalarlas_

```
Da un ejemplo
```

### Instalación 🔧

_Una serie de ejemplos paso a paso que te dice lo que debes ejecutar para tener un entorno de desarrollo ejecutandose_

_Dí cómo será ese paso_

```
Da un ejemplo
```

_Y repite_

```
hasta finalizar
```

_Finaliza con un ejemplo de cómo obtener datos del sistema o como usarlos para una pequeña demo_

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

## Despliegue 📦

_Agrega notas adicionales sobre como hacer deploy_

## Construido con 🛠️

_Menciona las herramientas que utilizaste para crear tu proyecto_

* [MatLab](https://es.mathworks.com/products/matlab.html) - Versión 18

## Contribuyendo 🖇️

Por favor lee el [CONTRIBUTING.md](https://gist.github.com/villanuevand/xxxxxx) para detalles de nuestro código de conducta, y el proceso para enviarnos pull requests.

## Wiki 📖

Puedes encontrar mucho más de cómo utilizar este proyecto en nuestra [Wiki](https://github.com/tu/proyecto/wiki)

## Versionado 📌

Usamos [MatLab](https://es.mathworks.com/products/matlab.html) en su versión 18 para la programación del robot, usándolo como controlador principalmente.

## Autores ✒️

_Menciona a todos aquellos que ayudaron a levantar el proyecto desde sus inicios_

* **Manuel Tejada Guzmán** - *Todo mi GitHub* - [manuTGrt](https://github.com/manuTGrt)

También puedes mirar la lista de todos los [contribuyentes](https://github.com/your/project/contributors) quíenes han participado en este proyecto.

## Licencia 📄

Este proyecto está bajo la Licencia (Tu Licencia) - mira el archivo [LICENSE.md](LICENSE.md) para detalles

## Expresiones de Gratitud 🎁

* Comenta a otros sobre este proyecto 📢
* Invita una cerveza 🍺 o un café ☕ a alguien del equipo.
* Da las gracias públicamente 🤓.
* etc.



---
⌨️ con ❤️ por [Villanuevand](https://github.com/Villanuevand) 😊
