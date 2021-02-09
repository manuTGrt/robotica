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
