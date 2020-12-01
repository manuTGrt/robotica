clear all
clc
SR_robot=hgtransform;
SR_cabeza=hgtransform('Parent',SR_robot);

crear_robot(0,0,0,0,SR_robot,SR_cabeza)

distancia=5;
mapa=[];
mapa=load('mapa.dat');

for alfa=0:0.01:pi/2
    mapa=mover_robot_v2(-3,-3,pi/2,alfa,SR_robot,SR_cabeza,distancia,mapa);
    drawnow;
end

save('mapa.dat','mapa','-ascii');