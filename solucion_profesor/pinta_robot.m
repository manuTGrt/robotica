function pinta_robot(x,y,theta,alfa,robot,cabeza)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%cuerpo
R=rectangle('Position', [-1.5 -1.5 4 3],'Parent',robot);
axis([-10 10 -10 10])

%M = makehgtform('translate',[x y 0]);
%robot.Matrix=M;

M=makehgtform('translate',[x y 0], 'zrotate',theta);
robot.Matrix=M;

%ruedas
rueda_size=[-0.5 -0.1 1 0.2];
%rueda derecha
SR_rueda_derecha=hgtransform('Parent',robot);
rueda_derecha=rectangle('Position',rueda_size,'Parent',SR_rueda_derecha);

M=makehgtform('translate',[0 -1.8*0 0]);
SR_rueda_derecha.Matrix=M;

%rueda izquierda
SR_rueda_izquierda=hgtransform('Parent',robot);
rueda_izquierda=rectangle('Position',rueda_size,'Parent',SR_rueda_izquierda);

M=makehgtform('translate',[0 1.5*0 0]);
SR_rueda_izquierda.Matrix=M;

%cabeza
cabeza_size=[-0.25 -0.5 0.5 1];
C=rectangle('Position',cabeza_size,'Parent',cabeza);

M=makehgtform('translate',[2 0 0],'zrotate',alfa);
cabeza.Matrix=M;

%boton de choque
SR_choque=hgtransform('Parent',robot);
choque_size=[-0.25 -0.25 1 0.25];
choque=rectangle('Position',choque_size,'Parent',SR_choque);

M=makehgtform('translate',[2.2 1 0]);
SR_choque.Matrix=M;
end

