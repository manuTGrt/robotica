%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Controla el movimiento del robot EV3 mediante una máqunia de estado.
% utiliza el sensor sonar y los encoders de los motores para estimar el heading
% tienes dos dsensores switch, uno para comenzar y terminar  la rutina y otro para
% detectar colisión y dar marcha atrás
% Utiliza los script: 
% Traction_motor_control.m; Signal_reading_odo.m;
% Para.m.
%
% Utiliza las funciones: calculo_referencia_cabeza.m;  
%                        calculo_calculo_odometria.m; pinta_robot_v3.m
%
% Esta versión Controla el giro de la cabeza con un controlador proporcional,
% el giro del robot MEDIANTE TIEMPO 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 28/11/2020. FGB.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear t
%variables control movimiento cabeza
    clear giro_cabeza
    clear referencia_cabeza
    clear distancia;
    clear error_sonar;
    clear referencia;

%variables control angulo del robot
    clear ang_vel;
    clear yaw
    clear error_yaw
    clear referencia_yaw
    clear x y theta
    clear giro_derecho giro_izquierdo

    global radio_rueda
    global l %distancia entre ruedas

%----------------------------------------
% Variables para la representación gráfica
%------------------------------------------

%Crea los sistemas de referencia del robot y de la cabeza para la
%representación utilizando la función pinta_robot_v2
    SR_robot = hgtransform;
    SR_cabeza = hgtransform('Parent',SR_robot);

% %Carga el mapa
    %mapa=load('mapa_1.dat');

%crea el mapa vacío
    mapa=[];
%-----------------------------------------

%------------------------------
%Valores para la odometría
    l=6;
    radio_rueda=3;
%----------------------------

% Declaración de sensores
    Detecta_colision = touchSensor(mi_Robot,1); %Switch conectado al puerto 1.
    Pulsador = touchSensor(mi_Robot,2); %Switch conectado al puerto 2.
    Sonar = sonicSensor(mi_Robot); %definición del sonar

% Declaración de los motores
    motor_cabeza = motor(mi_Robot,'D') %motor de la cabeza
    motor_izquierdo = motor(mi_Robot,'B') %Motor izquierdo
    motor_derecho = motor(mi_Robot,'C') %Motor_derecho

%Activacion de los motores
    start(motor_cabeza);
    start(motor_izquierdo);
    start(motor_derecho);

%inicializa velocidad de motores
    Power1=0;
    Power2=0;
    Power_cabeza=0;


%reset del encoder de motores
    resetRotation(motor_cabeza);
    resetRotation(motor_izquierdo);
    resetRotation(motor_derecho);

%indice inicial
    i=1;

%referencia tiempo inicial
    tstart = tic;

%posición inicial cabeza
    giro_cabeza(i)=readRotation(motor_cabeza);

%valores iniciales de los encoders
    giro_derecho(i)=0;
    giro_izquierdo(i)=0;

%medida incial
    distancia(i) = readDistance(Sonar)*100;

%--------------------
% Valores iniciales
%--------------------
%tiempo inicial
    t(i)=0;
    x(i)=0;
    y(i)=0;
    theta(i)=0;
    yaw(i)=0;
    referencia_yaw=yaw(i);
    estado=1; %estado inicial


    stop_distance=20; %distancia de para ante obstáculo
    t_marcha_atras=2; %tiempo de marcha hacia atrás.
    t_giro=1.5; %tiempo de giro sobre si mismo
    transicion=1;% inicializa la variable que marca el inicio el mov de la cabeza

%Valores para defnir la referencia de la cabeza
    Periodo=5.5;
    Amplitud=100;

%comienza el bucle
disp('pulsa el bumper para comenzar')

while(readTouch(Pulsador)==0) 
end

while(readTouch(Pulsador)==1)
end

disp('comienza el bucle')

while  (readTouch(Pulsador)==0)
  
        i=i+1; %indice global
        t(i)= toc(tstart); %tiempo global del bucle
    
    
    %---------------------
    %lectura señales y calculo del heading
    %-------------------------------
    
        Signal_reading_odo;
      
      %-----------------------------
       %Calcula Odometría
      %--------------------------  
    %calculo odometria
        [x(i) y(i) theta(i)]=calculo_odometria(giro_derecho,giro_izquierdo,x,y,theta,i);
    %para controlar el giro
        yaw(i)=theta(i)*180/pi;
    
    %-----------------------------------------------
    % Representa el robot
    %------------------------------------
    if(distancia(i)<30)
         mapa=pintar_robot_v2(x(i),y(i),theta(i),double(giro_cabeza(i))*pi/180,SR_robot,SR_cabeza,distancia(i),mapa);
         drawnow
    end
        %---------------------------------------

    %muestra el estado del sistema
    estado 
 
   
    
    %--------------------------------------------------------
    % TRANSICIONES DE ESTADO
    %1-> marchando para adelante
    %2-> parando
    %3-> girando cabeza con sonar
    %4-> girando sobre si mismo
    %5-> Marcha atrás

        switch estado
            
            case 1 %andando hacia delante
                 %si la distancia es menor que stop_distance O hay choque para
                 if (distancia(i)<stop_distance)||(readTouch(Detecta_colision)==1) 
                    estado=2; %transición de estado de paro
                    transicion=i; %indice que marca el inicio del estado 2
                end
                
            
            case 2 %parando
                if (vel==0)
                    %si la distancia es Mayor que stop_distance Y NO hay choque
                    %comienza a andar
                    if (distancia(i)>stop_distance)&& (readTouch(Detecta_colision)==0)
                        estado=1; %la transición a estado marcha hacia delante
                        transicion=i; %indice que marca el inicio del estado 1
                    elseif (distancia(i)<stop_distance) %Si la distancia es menor que stop_distance
                        estado=3; %transición a estado girando cabeza
                        transicion=i; %indice que marca el inicio del estado 3
                        desfase=t(transicion)+1;
                    else % Si hay choque
                        estado=5; %la transición a estado marcha hacia delante
                        transicion=i; %indice que marca el inicio del estado 1      
                        
                    end
                end
             
            case 3 %girando cabeza
                if (t(i)>(desfase+Periodo+1.5)) %espera a que pasen el desfase+periodo mas 2 s
                    Power_cabeza=0; %para el giro de la cabeza
                    estado=4; %la transición a estado girando robot
                    angulo_girar=(calculo_referencia(distancia,giro_cabeza,transicion))*1.2; %calculo el ángulo a girar
                    referencia_yaw=(angulo_girar+yaw(i));
                    transicion=i; %indice que marca el inicio del estado 4
                end

                
            case 4 %girando robot
                if (t(i)-t(transicion)>t_giro)                  
                    estado=2; %transición a estado girando cabeza
                    transicion=i; %indice que marca el inicio del estado 2                 
                end
                
           case 5 %marcha atrás
                if (t(i)-t(transicion)>t_marcha_atras)                  
                    estado=2; %transición a estado girando cabeza
                    transicion=i; %indice que marca el inicio del estado 2                 
                end
            
        end %del siwtch
    
   %-----------------------
          
    
    %-------------------------------------------------
    %SALIDAS ASOCIADAS A LOS ESTADOS
    
        switch estado
        
            case 1 %andando hacia delante
            %Error en orientación del robot
                error_yaw(i)=(referencia_yaw-yaw(i));
                
            %Ganancia del controlador
                ky=0.6;
            %Control proporcional
                control_yaw=int8(ky*error_yaw(i));
                vel=20;
                Power1=vel+control_yaw;
                Power2=vel-control_yaw;  
            %establece los valores de control 
                %vel=20;
                %Power1=vel;
                %Power2=vel;
                
             
            case 2 %parando
              %establece los valores de control 
                vel=0;
                Power1=vel;
                Power2=vel;
                         
        
            case 3 %girando cabeza
                %cálculo de la referencia
                   referencia(i)=referencia_cabeza(Amplitud,t(i),Periodo,desfase);
                %cálculo del error
                   error_cabeza(i)=(referencia(i)-giro_cabeza(i));
                %ganacia del controlador proporcional   
                    k=0.35; 
  
                %definición del controlador
                    controlador=k*error_cabeza(i);
    
                %Actuación sobre el motor
                    Power_cabeza =int8(controlador); 
       
            case 4 %girando sobre si mismo
                %error en la orientación del robot
                    error_yaw(i)=(referencia_yaw-yaw(i));
                %Ganancia del controlador
                    k_giro=1.5;
                %Control proporcional
                    vel=int8(k_giro*error_yaw(i));
                    Power1=vel;
                    Power2=-vel;    
          
            case 5 %andando hacia atrás
                %establece los valores de control 
               vel=-20;
               Power1=vel;
               Power2=vel;                          
          
        end %del siwtch
      %---------------------
        %Manda los comandos de control a los motores
      %-------------        
        Traction_motor_control;
        
  
    
end %del while

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Para motores y cierra sensores
%-------------------------------
 Para;
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Guarda el mapa
%-------------------------------
 save('mapa.dat','mapa','-ascii');
