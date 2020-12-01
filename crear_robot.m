function crear_robot(x,y,theta,alfa,robot,cabeza)
%CREAR_ROBOT Summary of this function goes here
%   Detailed explanation goes here
%cuerpo
R=rectangle('Position', [-1.5 -1 4 2],'Parent',robot);
%axis([-10 10 -10 10])

M=makehgtform('translate',[x y 0], 'zrotate',theta);
robot.Matrix=M;

%ruedas
rueda_size=[-0.5 -0.1 1 0.2];
%rueda derecha
SR_rueda_derecha=hgtransform('Parent',robot);
rueda_derecha=rectangle('Position',rueda_size,'Parent',SR_rueda_derecha);

M=makehgtform('translate',[2 -1 0]);
SR_rueda_derecha.Matrix=M;

%rueda izquierda
SR_rueda_izquierda=hgtransform('Parent',robot);
rueda_izquierda=rectangle('Position',rueda_size,'Parent',SR_rueda_izquierda);

M=makehgtform('translate',[2 1 0]);
SR_rueda_izquierda.Matrix=M;

%cabeza
cabeza_size=[-0.25 -0.5 0.5 1];
C=rectangle('Position',cabeza_size,'Parent',cabeza);

M=makehgtform('translate',[2 0 0],'zrotate',alfa);
cabeza.Matrix=M;

%boton de choque
SR_choque=hgtransform('Parent',robot);
choque_size=[0 0 1 0.35];
choque=rectangle('Position',choque_size,'Parent',SR_choque);

M=makehgtform('translate',[2.25 0.5 0]);
SR_choque.Matrix=M;

%sensor de luz
SR_luz=hgtransform('Parent',robot);
luz_size=[0 0 0.5 0.5];
luz=rectangle('Position',luz_size,'Parent',SR_luz);

M=makehgtform('translate',[2.5 -0.75 0]);
SR_luz.Matrix=M;
end

