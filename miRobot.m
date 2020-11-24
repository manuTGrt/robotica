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

rueda_size=[-0.5 -0.1 1 0.5];

SR_rueda_derecha=hgtransform('Parent',SR_robot);
rueda_derecha=rectangle('Position',rueda_size,'Parent',SR_robot);

M=makehgtform('translate',[0 -2 0]);
SR_rueda_derecha.Matrix=M;