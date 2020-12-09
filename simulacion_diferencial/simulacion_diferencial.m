
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulación del movimiento de un robot móvil
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

camino=load('camino.dat');

l=3.5; %semidistancia entre rudas delanteras y traseras, tambien definido en modelo
radio_rueda=1;

%Condiciones iniciales 
pose0=[0; 0; 0];

t0=0;

%final de la simulación
tf=15;

%paso de integracion
h=0.1;
%vector tiempo
t=0:h:tf;
%indice de la matriz
k=0;

%inicialización valores iniciales
pose(:,k+1)=pose0;

t(k+1)=t0;

while (t0+h*k) < tf,
    %actualización
    k=k+1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %valores de los parámetros de control
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %v0=0;
    %W=2;
    
    %Lectura joystick
    %W=-axis(joy,1);
    %V0=-axis(joy,2);
    
    V0=5;
    R=10;
    rho=1/R;
    W=V0*rho;
    
    %--------------
    %Modelo inverso
    velocidad_derecha=(1/radio_rueda)*(V0+W*l);
    velocidad_izquierda=(1/radio_rueda)*(V0-W*l);
    %--------------
%velocidad_derecha=2.1;
%velocidad_izquierda=2.1;


 


 
 conduccion=[velocidad_derecha velocidad_izquierda];
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %para representar el punto onjetivo sobre la trayectoria
 
 punto=[30 30];

    
%metodo de integración ruge-kuta

pose(:,k+1)=kuta_diferencial(t(k),pose(:,k),h,conduccion);

end




