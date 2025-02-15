
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
global pose2
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

%Carga el fichero  BMP

MAPA = imread('micuadro.bmp');

%Transformaci�n para colocar correctamente el origen del Sistema de
%Referencia
MAPA(1:end,:,:)=MAPA(end:-1:1,:,:);
%image(MAPA);
%axis xy

delta=50;

%genera la ruta �ptima
Optimal_path=A_estrella(MAPA, delta);

%Condiciones iniciales 
pose0=[Optimal_path(1,1); Optimal_path(1,2); pi/2];
posef=[Optimal_path(end,1); Optimal_path(end,2); 3*pi/2];
%pose0=[camino(end,1); camino(end,2); pi/2]; %el �ltimo punto es el mismo
%que el primero
%pose0=[10;10;pi];

%Condiciones iniciales con camino A_estrella
%pose0=[camino(1,1); camino(1,1); 0];
%posef=[camino(end,end); camino(end,end); 0];

%definir camino
dd=5;
da=dd;

posicion_despegue=[pose0(1)+(dd*cos(pose0(3))) pose0(2)+(dd*sin(pose0(3)))];
posicion_aterriza=[posef(1)-(da*cos(posef(3))) posef(2)-(da*sin(posef(3)))];

xc=[pose0(1) posicion_despegue(1) Optimal_path(2:end-1,1)' posicion_aterriza(1) posef(1)];
yc=[pose0(2) posicion_despegue(2) Optimal_path(2:end-1,2)' posicion_aterriza(2) posef(2)];

ds=1; %distancia entre puntos en cm.
camino=funcion_spline_cubica_varios_puntos(xc,yc,ds)';
%camino=A_estrella(MAPA, 50);
%--------------------------------


t0=0;

%final de la simulaci�n
tf=70;

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
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %punto m�s cercano
 orden_minimo= minima_distancia_new (camino, pose(1:2,k));
 
 %para representar el punto onjetivo sobre la trayectoria
 %hay que corregir el Look_ahead
 Look_ahead=20;
 seguir=orden_minimo+Look_ahead;
 if(orden_minimo+Look_ahead>length(camino))
     seguir=length(camino);
 end
 punto=[camino(seguir,1), camino(seguir, 2)];

    delta = (pose(1,k)-punto(1))*sin(pose(3,k))-(pose(2,k)-punto(2))*cos(pose(3,k));
    LH=sqrt((pose(1,k)-punto(1))^2 + (pose(2,k)-punto(2))^2);
    rho=2*delta/LH^2;
    
    %V0=10;
    Distancia_al_final=sqrt((pose(1,k)-camino(end,1))^2 + (pose(2,k)-camino(end,2))^2);
    
    V0=1*LH;
    if(V0>50)
        V0=50;
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

%pose(:,k+1)=kuta_diferencial(t(k),pose(:,k),h,conduccion);
pose(:,k+1)=kuta_diferencial_mapa(t(k),pose(:,k),h,conduccion,MAPA);

end

%PROGRAMO EL APARCAMIENTO
%genero el camino del aparcamiento
Optimal_path2=[posef(1) posef(2);posicion_aterriza(1) posicion_aterriza(2);375 75;325 75];
camino=funcion_spline_cubica_varios_puntos(Optimal_path2(:,1)',Optimal_path2(:,2)',ds)';

%ahora, la posici�n inicial de este bucle es la final del anterior
pose0=[posef(1); posef(2); posef(3)];

%t0=0; Esta variable no cambia

%final de la simulaci�n -- amplio en 3 segundos el tiempo de finalizaci�n
tf=tf+30;

%paso de integracion -- Da igual si lo dejo, ya que no cambia
%h=0.1;
%vector tiempo -- Tengo que aumentarlo ya que el tiempo de finalizaci�n ha
%cambiado
t=0:h:tf;
%indice de la matriz -- Lo comento porque tene que continuar con el mismo
%valor del bucle anterior
%k=0;

%inicializaci�n valores iniciales
pose(:,k+1)=pose0;

t(k+1)=t0;

while (t0+h*k) < tf,
     %actualizaci�n
    k=k+1;
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 %punto m�s cercano
 orden_minimo= minima_distancia_new (camino, pose(1:2,k));
 
 %para representar el punto onjetivo sobre la trayectoria
 %hay que corregir el Look_ahead
 Look_ahead=10; %para el aparcamiento necesitamos m�s precisi�n en el seguimiento de la l�nea
 seguir=orden_minimo+Look_ahead;
 if(orden_minimo+Look_ahead>length(camino))
     seguir=length(camino);
 end
 punto=[camino(seguir,1), camino(seguir, 2)];

    delta = (pose(1,k)-punto(1))*sin(pose(3,k))-(pose(2,k)-punto(2))*cos(pose(3,k));
    LH=sqrt((pose(1,k)-punto(1))^2 + (pose(2,k)-punto(2))^2);
    rho=2*delta/LH^2;
    
    Distancia_al_final=sqrt((pose(1,k)-camino(end,1))^2 + (pose(2,k)-camino(end,2))^2);
    
    V0=1*LH;
    if(V0>20)
        V0=20;
    end
    
    W=V0*rho;
    %Modelo inverso
    velocidad_derecha=(1/radio_rueda)*(V0+W*l);
    %velocidad_derecha=velocidad*(1+1*rho)/radio_rueda;
    velocidad_izquierda=(1/radio_rueda)*(V0-W*l);
    %velocidad_izquierda=velocidad*(1+1*rho)/radio_rueda;
    %--------------
    
    conduccion=[-velocidad_derecha -velocidad_izquierda]; %le cambio el signo a los motores para que el robot vaya marcha atr�s
    
%metodo de integraci�n ruge-kuta

%pose(:,k+1)=kuta_diferencial(t(k),pose(:,k),h,conduccion);
pose(:,k+1)=kuta_diferencial_mapa(t(k),pose(:,k),h,conduccion,MAPA);
end