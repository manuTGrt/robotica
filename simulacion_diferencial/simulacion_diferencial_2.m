%ESTA ES LA ACTIVIDAD 6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulaci�n del movimiento de un robot m�vil
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
clc

j=1;

%joy = vrjoystick(1);

global l
global radio_rueda
global camino
global pose
global punto
%cargamos el camino

%camino=load('camino.dat');

%x=10:0.5:80;
%y=10*ones(size(x));
%xd=70;
%yd=80;
%ds=1;
%phi=atan(yd/xd);

%x=0:ds*cos(phi):xd;
%y=0:ds*sin(phi):yd;



%camino=[x' y'];




l=3.5; %semidistancia entre rudas delanteras y traseras, tambien definido en modelo
radio_rueda=1;

%Condiciones iniciales 
pose0=[0; 0; -pi/4];
posef=[80; 80; -pi/4];
%pose0=[camino(end,1); camino(end,2); pi/2]; %el �ltimo punto es el mismo
%que el primero
%pose0=[10;10;pi];


%definir camino
dd=5;
da=dd;

posicion_despegue=[pose0(1)+(dd*cos(pose0(3))) pose0(2)+(dd*sin(pose0(3)))];
posicion_aterriza=[posef(1)+(da*cos(posef(3))) posef(2)+(da*sin(posef(3)))];

xc=[0 posicion_despegue(1) 10 40 60 70 posicion_aterriza(1) 80];
yc=[0 posicion_despegue(2) 0 40 40 60 posicion_aterriza(2) 80];

ds=1; %distancia entre puntos en cm.
camino=funcion_spline_cubica_varios_puntos(xc,yc,ds)';
%--------------------------------


t0=0;

%final de la simulaci�n
tf=30;

%paso de integracion
h=0.1;
%vector tiempo
t=0:h:tf;
%indice de la matriz
k=0;

%inicializaci�n valores iniciales
pose(:,k+1)=pose0;

t(k+1)=t0;

while (t0+h*k) < tf,
    %actualizaci�n
    k=k+1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %valores de los par�metros de control
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %v0=0;
    %W=2;
    
    %Lectura joystick
    %W=-axis(joy,1);
    %V0=-axis(joy,2);
    
    %V0=5;
    %R=10;
    %rho=1/R;
    %W=V0*rho;
    
    %--------------
    %Modelo inverso
    %velocidad_derecha=(1/radio_rueda)*(V0+W*l);
    %velocidad_izquierda=(1/radio_rueda)*(V0-W*l);
    %--------------
%velocidad_derecha=2.1;
%velocidad_izquierda=2.1;


 


 
 %conduccion=[velocidad_derecha velocidad_izquierda];
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %punto m�s cercano
 orden_minimo= minima_distancia_new (camino, pose(1:2,k));
 
 %para representar el punto onjetivo sobre la trayectoria
 %hay que corregir el Look_ahead
 Look_ahead=5;
 seguir=orden_minimo+Look_ahead;
 if(orden_minimo+Look_ahead>length(camino))
     seguir=length(camino);
 end
 punto=[camino(seguir,1), camino(seguir, 2)];
 
 %punto=[70 40];

    delta = (pose(1,k)-punto(1))*sin(pose(3,k))-(pose(2,k)-punto(2))*cos(pose(3,k));
    LH=sqrt((pose(1,k)-punto(1))^2 + (pose(2,k)-punto(2))^2);
    rho=2*delta/LH^2;
    
    %V0=10;
    Distancia_al_final=sqrt((pose(1,k)-camino(end,1))^2 + (pose(2,k)-camino(end,2))^2);
    
    V0=1*LH;
    if(V0>10)
        V0=10;
    end
    
    W=V0*rho;
    %-----------------------------------------
    %V0=-V0;
    %--------------
    %Modelo inverso
    velocidad_derecha=(1/radio_rueda)*(V0+W*l);
    %velocidad_derecha=velocidad*(1+1*rho)/radio_rueda;
    velocidad_izquierda=(1/radio_rueda)*(V0-W*l);
    %velocidad_izquierda=velocidad*(1+1*rho)/radio_rueda;
    %--------------
    
    conduccion=[velocidad_derecha velocidad_izquierda];
    
%metodo de integraci�n ruge-kuta

pose(:,k+1)=kuta_diferencial(t(k),pose(:,k),h,conduccion);

end




