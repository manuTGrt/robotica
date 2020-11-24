function mover_robot_v2(x,y,theta,alfa,robot,cabeza,distancia)
%MOVER_ROBOT Summary of this function goes here
%   Detailed explanation goes here

%muevo robot
M=makehgtform('translate',[x y 0], 'zrotate',theta);
robot.Matrix=M;

%muevo cabeza
M=makehgtform('translate',[2 0 0],'zrotate',alfa);
cabeza.Matrix=M;

mapa=robot.Matrix*cabeza.Matrix;
mapa
end

