function mapa_out=mover_robot_v2(x,y,theta,alfa,robot,cabeza,distancia,mapa)
%MOVER_ROBOT Summary of this function goes here
%   Detailed explanation goes here

%muevo robot
M=makehgtform('translate',[x y 0], 'zrotate',theta);
robot.Matrix=M;

%muevo cabeza
M=makehgtform('translate',[2 0 0],'zrotate',alfa);
cabeza.Matrix=M;

Mt=robot.Matrix*cabeza.Matrix;
punto=Mt*[distancia 0 0 1]';

axis([-10 10 -10 10]);

mapa_out=[mapa; punto(1) punto(2)];

d=animatedline(mapa_out(:,1),mapa_out(:,2),'Marker','*','LineStyle','none');
end

