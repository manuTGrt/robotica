function mover_robot(x,y,theta,alfa,robot,cabeza)
%MOVER_ROBOT Summary of this function goes here
%   Detailed explanation goes here

M=makehgtform('translate',[x y 0], 'zrotate',theta);
robot.Matrix=M;

M=makehgtform('translate',[2 0 0],'zrotate',alfa);
cabeza.Matrix=M;

end

