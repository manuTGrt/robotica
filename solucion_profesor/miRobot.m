%cuerpo
SR_robot = hgtransform;
R=rectangle('Position', [-1.5 -1.5 4 3],'Parent',SR_robot);
axis([-10 10 -10 10])

x=-5; y=-5
M = makehgtform('translate',[x y 0]);

SR_robot.Matrix=M;

x=4; y=-3;
theta=pi/4;
M=makehgtform('translate',[x y 0], 'zrotate',theta);

SR_robot.Matrix=M;

%ruedas
rueda_size=[-0.5 -0.1 1 0.5];
%rueda derecha
SR_rueda_derecha=hgtransform('Parent',SR_robot);
rueda_derecha=rectangle('Position',rueda_size,'Parent',SR_rueda_derecha);

M=makehgtform('translate',[0 -1.8 0]);
SR_rueda_derecha.Matrix=M;

%rueda izquierda
SR_rueda_izquierda=hgtransform('Parent',SR_robot);
rueda_izquierda=rectangle('Position',rueda_size,'Parent',SR_rueda_izquierda);

M=makehgtform('translate',[0 1.5 0]);
SR_rueda_izquierda.Matrix=M;

%cabeza
SR_cabeza=hgtransform('Parent',SR_robot);
cabeza_size=[-0.25 -0.5 0.5 1];
cabeza=rectangle('Position',cabeza_size,'Parent',SR_cabeza);

alfa=0;
M=makehgtform('translate',[2 0 0],'zrotate',alfa);
SR_cabeza.Matrix=M;

%boton de choque
SR_choque=hgtransform('Parent',SR_robot);
choque_size=[-0.25 -0.25 1 0.25];
choque=rectangle('Position',choque_size,'Parent',SR_choque);

M=makehgtform('translate',[2.2 1 0]);
SR_choque.Matrix=M;