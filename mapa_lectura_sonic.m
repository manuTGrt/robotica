clear all
clc
SR_robot=hgtransform;
SR_cabeza=hgtransform('Parent',SR_robot);

crear_robot(0,0,0,0,SR_robot,SR_cabeza)

distancia=5;
mapa=[];

for alfa=0:0.01:pi/2
    mover_robot_v2(0,0,0,alfa,SR_robot,SR_cabeza,distancia);
    drawnow;
end