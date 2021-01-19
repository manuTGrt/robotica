%metodo de integracion de Euler

function salida=kuta(t,Y,h,qf)

salida=zeros(size(Y));%la salida debe ser un vector columna


k1=h*feval('modelo',t,Y,qf);
k2=h*feval('modelo',t+h/2,Y+(1*k1/2),qf);
k3=h*feval('modelo',t+h/2,Y+(1*k2/2),qf);
k4=h*feval('modelo',t+h,Y+(1*k3),qf);
salida=Y+(k1+2*k2+2*k3+k4)/6;

%se genera la animación
animacion(salida,qf(2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function S=modelo(t,E,conduccion)


velocidad=conduccion(1);

volante=conduccion(2);

teta=E(3);

%distancia entre rudas traseras y delanteras
global l

S=zeros(size(E));


S(1,1)=velocidad*cos(teta);
S(2,1)=velocidad*sin(teta);
S(3,1)=velocidad*tan(volante)/l

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fichero para realizar la animación
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function animacion(salida,conduccion)

global camino
global pose
global punto

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dibujo de los elementos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cla;

vehiculo(salida, conduccion);

% pose
% 
% vehiculo(pose, conduccion);
plot(punto(1),punto(2),'*r');
plot(camino(:,1),camino(:,2))
plot(pose(1,:),pose(2,:),'k');
drawnow;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dibuja un vehiculo con rueda direccional
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function vehiculo(pose, conduccion)

x=pose(1);
y=pose(2);
teta=pose(3);

global l %distancia entre ruedas
%Robot

p1=[5 2 0 1]';
p2=[5 -2 0 1]';
p3=[-1 -2 0 1]';
p4=[-1 2 0 1]';

robot=[p1 p2 p3 p4 p1];

%Rueda derecha

p1=[0.5 -1 0 1]';
p2=[-0.5 -1 0 1]';

ruedad=[p1 p2];

%Rueda izquierda

p1=[0.5 1 0 1]';
p2=[-0.5 1 0 1]';

ruedai=[p1 p2];

%rueda de conduccion

p1=[0.5 0 0 1]';
p2=[-0.5 0 0 1]';

rueda_volante=[p1 p2];



%matrices de transformación

Tras_x=[1 0 0 x;0 1 0 0;0 0 1 0;0 0 0 1];
Tras_y=[1 0 0 0;0 1 0 y;0 0 1 0;0 0 0 1];
Rot_z=[ cos(teta) -sin(teta) 0 0; sin(teta) cos(teta) 0 0; 0 0 1 0; 0 0 0 1];

Transfromacion_1=Tras_x*Tras_y*Rot_z;

robot_0=Transfromacion_1*robot;

ruedad_0=Transfromacion_1*ruedad;

ruedai_0=Transfromacion_1*ruedai;


%matrices de transformación para la rueda del volante

Tras_x=[1 0 0 l;0 1 0 0;0 0 1 0;0 0 0 1];
Rot_z=[ cos(conduccion) -sin(conduccion) 0 0; sin(conduccion) cos(conduccion) 0 0; 0 0 1 0; 0 0 0 1];

Transfromacion_2=Tras_x*Rot_z;

rueda_volante_0=Transfromacion_1*Transfromacion_2*rueda_volante;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dibujo de los elementos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


plot(robot_0(1,:),robot_0(2,:));
hold on

plot(ruedad_0(1,:),ruedad_0(2,:));

plot(ruedai_0(1,:),ruedai_0(2,:));

plot(rueda_volante_0(1,:),rueda_volante_0(2,:));

axis([-10 90 -10 90])

