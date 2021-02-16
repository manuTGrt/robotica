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

<p>Posteriormente, movemos la cabeza unos grados indicados, en los que vemos que, variando la ganancia, la cabeza se movía de forma inestable, llegando a la conclusión de que un buen valor de ganancia para que no sea inestable sea 0.3.

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

<p>Luego lo implementamos en el robot y comprobamos que gira la cabeza y va leyendo los obstáculos que se va encontrando. En las pruebas muestro cómo lo hace.</p>

### 2. Cuerpo 🧠

<p>El cuerpo del robot es su cerebro, el que controla todos los motores y sensores de cada parte del robot.</p>

#### Montaje

<p>El montaje del robot se realiza con piezas lego, con las que poco a poco vamos dandole forma para así acoplar todas y cada una de las partes.

El profesor nos ha dejado un vídeo para que el montaje del robot sea más rápido y sencillo para nosotros.</p>

<p align="center"><a href="http://www.legoengineering.com/the-harvester-a-quick-ev3-robot-build/"><img src="https://github.com/manuTGrt/robotica/blob/main/videos/montaje_robot.gif"></a></p>

<p>La cabeza del robot la hemos modificado de sitio para que esté centrada y pueda moverse.

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
- Signal_reading_odo.m: Contiene la programación que se encarga de leer las señales del sensor sonar y de los encoders de los motores de la cabeza y las ruedas para evitar oscilaciones en los procesos de control del giro de la cabeza y las ruedas, las consultas al estado de los  motores de tracción solo se hacen en los estados necesarios.
  - Si está en el estado 3:
    - Significa que está girando la cabeza y, por tanto, no lee los encoders de las ruedas pero sí el de la cabeza.
  - Si no está en el estado 3:
    - Significa que la cabeza no está girando y, por tanto, no lee el encoder de la cabeza pero sí los de las ruedas.
- Traction_motor_control.m: Es el encargado de mandar las señales de control a los motores, controlando la velocidad máxima a la que se mueven en cada uno de los sentidos.
- WiFi_connection.m: Es el encargado de realizar la conexión mediante wifi del programa MatLab con el robot.
- calculo_odometria.m: Es la función que se encarga de calcular la odometría del robot teniendo en cuenta la distancia entre las ruedas y el radio de ellas. Ésta devuelve un vector con los ángulos calculados.
- calculo_referencia.m: Ésta se encarga de calcular la referencia que tiene que seguir la cabeza.
- mapa.dat: Es el fichero que generamos con la lectura del sonar, para formar un mapa de los obstáculos que ha ido encontrando y así ser conscientes de por qué gira el robot en los casos necesarios.
- pintar_robot_v2.m: Esta función es la que se encarga de pintar el robot y actualizar su posición cuando éste se mueve.
- referencia_cabeza.m: Es la función que devuelve el ángulo que tiene que girar la cabeza según la amplitud, el tiempo, el periodo y el desfase que le indiquemos por parámetros.



## Ejecutando las pruebas ⚙️

<p>Como menciono anteriormente, lo primero que hicimos fue mover la cabeza, después hicimos que la cabeza reconociera los obstáculos, posteriormente movíamos el robot sin tener en cuenta la cabeza, luego movimos el robot y, cuando la cabeza encontraba un obstáculo, éste se paraba y giraba la cabeza, moviendo el robot después 90º a la izquierda, y, por ultimo, al girar la cabeza generaba un mapa de los obstáculos que se encontraba y decidía hacia qué lado girar, pudiendo así completar un recorrido.</p>

<p>También hicimos que el robot siguiera un camino generado mediante una spline, de manera que hicimos tres caminos, uno corto, otro mediano, y otro largo en el que se quedaba aparcado. 19 enero 2021</p>

### Mover cabeza y lectura sonar 🤖

<p>Para mover la cabeza ejecutamos el siguiente script, en el que posteriormente fuimos modificando diferentes parámetros para que se comportara de la forma que nos interesase.</p>

```MATLAB
clear all
clc
%conexión con lego, sensor y motores
myev3 = legoev3('usb');
mytouchsensor = touchSensor(myev3);
motor_A=motor(myev3,'A');
motor_B=motor(myev3,'B');

%inicio de motores
start(motor_A);
start(motor_B);

%reseteo de encoders
resetRotation(motor_A);
resetRotation(motor_B);

%boton = readTouch(mytouchsensor);
t(1)=0;
giro(1)=readRotation(motor_B);
grados=90;
referencia(1)=grados;
error(1)=referencia(1)-giro(1);
k=0.12;
i=0;

asterisco=animatedline('Marker','*','Color','r');
ref=animatedline('Marker','.','Color','g');
tstart=tic;
tiempo(1)=0;

while readTouch(mytouchsensor)==0
end

while readTouch(mytouchsensor)==1
end

grid on;
while readTouch(mytouchsensor)==0
    i=i+1;
    giro(i)=readRotation(motor_B);
    referencia(i)=grados;
    error(i)=referencia(i)-giro(i);

    %definicion del controlador
    controlador=k*error(i);

    %actuación sobre el motor
    power=int8(controlador);
    if power>100
        power=100;
    else
        if power <-100
            power=-100;
        end
    end

    %actuación de los motores
    motor_B.Speed=power;

    %pintando gráfica
    tiempo(i)=toc(tstart);
    y(i)=double(readRotation(motor_B));
    x(i)=double(referencia(i));
    addpoints(asterisco,tiempo(i),y(i));
    addpoints(ref,tiempo(i),x(i));

end
drawnow
stop(motor_B);
```
<p>Primero la movemos, como vemos en este código, unos grados concretos, en este caso 90º.</p>

<p>Posteriormente modificamos las líneas necesarias expuestas en el siguiente código para moverla mediante el giro manual de otro motor.</p>

```MATLAB
%grados=90;
referencia(1)=readRotation(motor_A);
```

<p>Luego hicimos que moviera la cabeza de un lado a otro y por último al centro.</p>

```MATLAB
%con esto inicializamos las variables
grados=90;
tiempo(1)=0;
desfase=4;
periodo=8;
referencia(1)=referencia_cabeza(grados,tiempo(1),desfase,periodo);

%grafica que seguirá la cabeza
t=0:0.01:periodo+desfase+desfase;
for j=1:length(t)
    angulo_cabeza(j)=referencia_cabeza(grados,t(j),desfase,periodo);
end
plot(t,angulo_cabeza)
```

<p>En el bucle de funcionamiento, tendremos que indicar también que gire tomando como referencia la función generada.</p>

```MATLAB
  tiempo(i)=toc(tstart);
  referencia(i)=referencia_cabeza(grados,tiempo(i),desfase,periodo);
  error(i)=referencia(i)-giro(i);
```

<p>Aquí muestro una demostración de cómo la cabeza gira</p>

<p align="center"><img width="300px" src="https://github.com/manuTGrt/robotica/blob/main/videos/movimiento_cabeza.gif"></p>

<p>Es entonces cuando implementamos la lectura del sonar, donde mapa es el vector en el que se encuentran todos y cada uno de los objetos dibujados.</p>

```MATLAB
%leo la distancia
distancia(i) = double(readDistance(mysonicsensor))*100;

%muevo la cabeza del robot y apunto la distancia a la que se encuentran
%los objetos
mapa=pintar_robot_v2(0,0,0,double(readRotation(motor_B))*pi/180,SR_robot,SR_cabeza,double(distancia(i)),mapa);
```

<p>Así reconoce el entorno mientras está moviendo la cabeza</p>

<p align="center"><img width="300px" src="https://github.com/manuTGrt/robotica/blob/main/videos/robot_mueve_cabeza_y_lee_sonic.gif"></p>


### Moviemiento del robot :robot:

<p>Para mover el robot ya hemos hecho una máquina de estados en la que según el estado en el que se encuentre el robot podrá hacer diferentes cosas como:</p>
1. marchando para adelante
2. parando
3. girando cabeza con sonar
4. girando sobre si mismo
5. Marcha atrás

<p>Con esta máquina de estados comprobamos que, mientras no haya problemas, el robot seguirá andando recto, en cambio, cuando se encuentre un obstáculo, éste pasa al estado 2, el cual lo para y comprueba que, si no se ha chocado ni hay un obstáculo cerca, vuelve al estado 1 para avanzar hacia adelante, si ha detectado un obstáculo cerca pasa al estado 3, en el que gira la cabeza para decidir el giro necesario, y, si se ha chocado, pasa al estado 5, el cual da marcha atrás y vuelve al estado 2 y decidir en qué situación está.</p>

_Explica que verifican estas pruebas y por qué_

```
Da un ejemplo
```

## Construido con 🛠️

La herramienta utilizada para la programación del robot es MatLab, en general he usado la versión 18, pero en casa para algunas simulaciones he usado la versión 20.

* [MatLab](https://es.mathworks.com/products/matlab.html) - Versión 18

Para la conexión wifi, el profesor nos ha dejado un adaptador wifi de tamaño mini. También nos ha construido la programación de éste.

El robot ha sido construido con piezas lego, utilizando el ladrillo ev3.

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
