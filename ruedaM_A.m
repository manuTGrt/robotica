clear all
clc
myev3 = legoev3('usb');
mytouchsensor = touchSensor(myev3);
motor_A=motor(myev3,'A');
start(motor_A);
boton = readTouch(mytouchsensor);
desfase=2;
periodo=5;
t=0:0.01:periodo+desfase+desfase;
%for j=1:length(t)
    %angulo_cabeza(j)=referencia_cabeza(pi/2,t(j),desfase,periodo);
%end
%plot(t,angulo_cabeza)
asterisco=animatedline('Marker','*')
%addpoints(asterisco,1,pi/2*sin(1));
tstart=tic
tiempo(1)=0;
k=1;
resetRotation(motor_A);
while boton==0
    boton = readTouch(mytouchsensor);
end

while boton==1
    boton = readTouch(mytouchsensor);
end

while boton==0 && tiempo(k)<15
    boton = readTouch(mytouchsensor);
    k=k+1;
    tiempo(k)=toc(tstart);
    %y(k)=referencia_cabeza(pi/2,tiempo(k),desfase,periodo);
    y(k)=double(readRotation(motor_A));
    %clearpoints(asterisco);
    addpoints(asterisco,tiempo(k),y(k));
    drawnow
end
