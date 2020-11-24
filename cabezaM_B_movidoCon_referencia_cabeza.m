clear all
clc
%conexión con lego, sensor y motores
myev3 = legoev3('usb');
mytouchsensor = touchSensor(myev3);
%motor_A=motor(myev3,'A');
motor_B=motor(myev3,'D');

%inicio de motores
%start(motor_A);
start(motor_B);

%reseteo de encoders
%resetRotation(motor_A);
resetRotation(motor_B);

%boton = readTouch(mytouchsensor);
giro(1)=readRotation(motor_B);
grados=90;
tiempo(1)=0;
desfase=4;
periodo=8;
referencia(1)=referencia_cabeza(grados,tiempo(1),desfase,periodo);
error(1)=referencia(1)-giro(1);
k=0.8;
i=1;

%grafica
t=0:0.01:periodo+desfase+desfase;
for j=1:length(t)
    angulo_cabeza(j)=referencia_cabeza(grados,t(j),desfase,periodo);
end
plot(t,angulo_cabeza)

asterisco=animatedline('Marker','*','Color','r');
ref=animatedline('Marker','.','Color','g');
tstart=tic;

while readTouch(mytouchsensor)==0
end

while readTouch(mytouchsensor)==1
end

grid on;
while readTouch(mytouchsensor)==0
    i=i+1;
    giro(i)=readRotation(motor_B);
    tiempo(i)=toc(tstart);
    referencia(i)=referencia_cabeza(grados,tiempo(i),desfase,periodo);
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
    %tiempo(i)=toc(tstart);
    y(i)=double(readRotation(motor_B));
    x(i)=double(referencia(i));
    addpoints(asterisco,tiempo(i),y(i));
    addpoints(ref,tiempo(i),x(i));
    drawnow
end

stop(motor_B);
