clear all
clc
SR_robot=hgtransform;
SR_cabeza=hgtransform('Parent',SR_robot);

crear_robot(3,3,0,0,SR_robot,SR_cabeza)

for alfa=0:0.001:0
    mover_robot(3,3,alfa,alfa,SR_robot,SR_cabeza);
    drawnow;
end