%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controla la convertgencia del robot EV3 a un punto mediante una estrategia de control geométrico.
% utiliza los encoders de los motores para estimar calcular la odometría
% utiliz un  switch, para comenzar y terminar  la rutina
%
% Utiliza los script: 
% Traction_motor_control_laboratorio.m; Signal_reading_odo_path_following.m;  Para.m.
%
% Utiliza las funciones: calculo_calculo_odometria.m; 
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 29/11/2020. FGB.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
%clear all

%variables control angulo del robot
    clear yaw
    clear x y theta
    clear giro_derecho giro_izquierdo

    global radio_rueda
    global l %distancia entre ruedas
    
    %mi_Robot = legoev3('USB')

%----------------------------------------
% Variables para la representación gráfica
%------------------------------------------

% %Crea los sistemas de referencia del robot y de la cabeza para la
% %representación utilizando la función pinta_robot_v2
%     SR_robot = hgtransform;
%     SR_cabeza = hgtransform('Parent',SR_robot);
%-----------------------------------------

%------------------------------
%Valores para la odometría
      l=5.8;
      radio_rueda=2.85

%----------------------------


% Declaración de sensores
    Detecta_colision = touchSensor(mi_Robot,1); %Switch conectado al puerto 1.
    Pulsador = touchSensor(mi_Robot,2); %Switch conectado al puerto 2.
    Sonar = sonicSensor(mi_Robot); %definición del sonar

% Declaración de los motores
    motor_cabeza = motor(mi_Robot,'A') %motor de la cabeza
    motor_izquierdo = motor(mi_Robot,'B') %Motor izquierdo
    motor_derecho = motor(mi_Robot,'C') %Motor_derecho

%Activacion de los motores
    start(motor_cabeza);
    start(motor_izquierdo);
    start(motor_derecho);

%inicializa velocidad de motores
    Power1=0;
    Power2=0;
    Power_cabeza=0;


%reset del encoder de motores
    resetRotation(motor_cabeza);
    resetRotation(motor_izquierdo);
    resetRotation(motor_derecho);

%indice inicial
    i=1;

%valores iniciales de los encoders
    giro_derecho(i)=0;
    giro_izquierdo(i)=0;


%--------------------
% Valores iniciales
%--------------------
%tiempo inicial
    t(i)=0;
    x(i)=0;
    y(i)=0;
    theta(i)=0;
    yaw(i)=0;
    

%comienza el bucle
disp('pulsa el bumper para comenzar')

%camino_x=0:1:40;
%camino_y=0*camino_x;
%camino=[camino_x' camino_y'];

%definir camino
dd=5;
da=dd;

posicion_despegue=[x(i)+(dd*cos(theta(i))) y(i)+(dd*sin(theta(i)))];
posicion_aterriza=[100-(da*cos(pi/2)) 115-(da*sin(pi/2))];

xc=[0 posicion_despegue(1) 30 60 posicion_aterriza(1) 100];
yc=[0 posicion_despegue(2) 30 60 posicion_aterriza(2) 115];

ds=1; %distancia entre puntos en cm.
camino=funcion_spline_cubica_varios_puntos(xc,yc,ds)';
%--------------------------------


while(readTouch(Pulsador)==0) 
end

while(readTouch(Pulsador)==1)
end


disp('comienza el bucle')
tf=60;
%referencia tiempo inicial
    tstart = tic;

while  (readTouch(Pulsador)==0) & (t(i)<tf)
  
        i=i+1; %indice global
        t(i)= toc(tstart); %tiempo global del bucle
    %---------------------
    %lectura señales y calculo del heading
    %-------------------------------
    
        Signal_reading_odo_path_following;
      
      %-----------------------------
       %Calcula Odometría
      %--------------------------  
    %calculo odometria
        [x(i) y(i) theta(i)]=calculo_odometria(giro_derecho,giro_izquierdo,x,y,theta,i);
    %para controlar el giro
        yaw(i)=theta(i)*180/pi;
   
    
%----------------------------
% Control Geométrico

%para converger a un punto
%punto más cercano
 orden_minimo= minima_distancia_new (camino, [x(i) y(i)]);
 
 %para representar el punto onjetivo sobre la trayectoria
 %hay que corregir el Look_ahead
 Look_ahead=10;
 seguir=orden_minimo+Look_ahead;
 if(orden_minimo+Look_ahead>length(camino))
     seguir=length(camino);
 end
 punto=[camino(seguir,1), camino(seguir, 2)];

 %punto=[0 40];    


 delta= (x(i)-punto(1))*sin(theta(i))-(y(i)-punto(2))*cos(theta(i));
 
 LH=sqrt((x(i)-punto(1))^2+(y(i)-punto(2))^2);
 
 rho=2*delta/LH^2;
 
 

%Control proporcional de la velocidad
 Kp=1.1;
 %final=[camino(end,1) camino(end,2)]; %para converger al final del camino
 final=punto; %para converger a un punto
 Distance_to_end=sqrt((x(i)-final(1))^2+(y(i)-final(2))^2);
 velocidad=Kp*Distance_to_end;
 
 
 if velocidad>17
     velocidad=17;
 end
 
 if Distance_to_end<3
     break
 end

 
 %-------------------------------------
 % modelo Inverso
 %-------------------------------------
 
    velocidad_derecha=velocidad*(1+l*rho)/radio_rueda;
 
    velocidad_izquierda=velocidad*(1-l*rho)/radio_rueda;
    
%---------------------------------------------------
% Cversión de velocidad a potencia
    potencia_equivalente=7.0;

    Power1_a(i)=velocidad_derecha*potencia_equivalente;
    Power2_a(i)=velocidad_izquierda*7.0;

    Power1=Power1_a(i);
    Power2=Power2_a(i);
    
    

      %---------------------
        %Manda los comandos de control a los motores
      %-------------        
        Traction_motor_control_laboratorio;
        
  
    
end %del while

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Para motores y cierra sensores
%-------------------------------
 Para;

% plot(t,giro_izquierdo)
% hold on 
% plot(t,giro_derecho)

velocidad_izquierda
giro_izquierdo(end)/t(end)

velocidad_derecha
giro_derecho(end)/t(end)

figure

plot(x,y)
hold on;
plot(camino(:,1),camino(:,2));

axis equal

%axis([0 90 0 90]);
