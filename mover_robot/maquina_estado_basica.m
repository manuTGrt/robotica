%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% controla el movimiento del robot mediante una m�qunia de estado.
% Utiliza los script: 
% Traction_motro_control.m; Signal_reading_odo.m;
% Para_Cierra.m.
% 28/11/2020. FGB.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clc
    clear t
%variables control movimiento cabeza
    clear giro_cabeza
    clear referencia_cabeza
    clear distancia;
    clear error_sonar;

%variables control angulo del robot
    clear ang_vel;
    clear yaw
    clear error_yaw
    clear referencia_yaw
    clear x y theta
    clear giro_derecho giro_izquierdo

    global radio_rueda
    global l %distancia entre ruedas

    l=6;
    radio_rueda=3;

% Declaraci�n de sensores
    Detecta_colision = touchSensor(mi_Robot,1); %Switch conectado al puerto 1.
    Pulsador = touchSensor(mi_Robot,2); %Switch conectado al puerto 2.
    Sonar = sonicSensor(mi_Robot); %definici�n del sonar

% Declaraci�n de los motores
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
    resetRotation(motor_cabeza);
    resetRotation(motor_derecho);

%indice inicial
    i=1;

%referencia tiempo inicial
    tstart = tic;

%posici�n inicial cabeza
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
    
    Amplitud=100;
    Periodo=6;
    t_giro=2;

    estado=1; %estado inicial

    mapa = [];
    
    stop_distance=35; %distancia de para ante obst�culo
    t_marcha_atras=1.5; %tiempo de marcha hacia atr�s.
    transicion=1;% inicializa la variable que marca el inicio el mov de la cabeza

%-----------------------------------------
%Variables para la representaci�n gr�fica
%-----------------------------------------

%Crea los sistemas de referencia del robot y de la cabeza para la
%representaci�n utilizando la funci�n pinta_robot_v2
    SR_robot = hgtransform;
    SR_cabeza = hgtransform('parent',SR_robot);

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
    %lectura se�ales y calculo del heading
    %-------------------------------
    
        Signal_reading_odo;
        
        %---------------------
        %Calcula Odometr�a
        %---------------------
       %calculo odometria
        [x(i) y(i) theta(i)]=calculo_odometria(giro_derecho,giro_izquierdo,x,y,theta,i);
       %para controlar el giro
        yaw(i)=theta(i)*180/pi;
        %--------------------------------------------------------------------
        
        %----------------------------
        %Representa el robot
        %----------------------------
            %mapa=pintar_robot_v2(x(i),y(i),theta(i),double(giro_cabeza(i))*pi/180,SR_robot,SR_cabeza,distancia,mapa);
        %--------------------------------------------------------------------
        %drawnow


        estado %muestra el estado del sistema
 
   
    
    %--------------------------------------------------------
    % TRANSICIONES DE ESTADO
    %1-> marchando para adelante
    %2-> parando
    %3-> girando cabeza con sonar
    %4-> girando sobre si mismo
    %5-> Marcha atr�s

        switch estado
            
            case 1 %andando hacia delante
                %if (readDistance(Sonar)<stop_distance) %si la distancia es menor que 35 para
                 if (distancia(i)<stop_distance) || (readTouch(Detecta_colision)==1)%si la distancia es menor que 35 o choca para
                    estado=2; %transici�n de estado de paro
                    transicion=i; %indice que marca el inicio del estado 2
                end
                
            
            case 2 %parando
                if (vel==0)
                    if (distancia(i)>stop_distance) && (readTouch(Detecta_colision)==0)
                        estado=1; %la transici�n a estado marcha hacia delante
                        transicion=i; %indice que marca el inicio del estado 1
                    elseif (distancia(i) < stop_distance)       
                        estado=3; %transici�n a estado girando cabeza
                        transicion=i; %indice que marca el inicio del estado 3
                        desfase=t(transicion)+1;
                    else %Si hay choque
                        estado=5; %la transici�n a estado marcha hacia delante
                        transicion=i; %indice que marca el inicio del estado 1
                    end
                end
             
            case 3 %girando cabeza    
                if(t(i)>(desfase+Periodo+1.5)) %espera a que pasen el desfase+periodo mas 2s
                    Power_cabeza=0; %para el giro de la cabeza
                    estado=4; %la transici�n a estado girando robot
                    transicion=i; %indice que marca el inicio del estado 4
                end
                
            case 4 %girando robot
                if(t(i)-t(transicion)>t_giro)
                    estado=2;
                    transicion=i;
                end
                %estado=5; %la transici�n a estado marcha atr�s
                %transicion=i; %indice que marca el inicio del estado 5
                
           case 5 %marcha atr�s
                if (t(i)-t(transicion)>t_marcha_atras)                  
                    estado=2; %transici�n a estado girando cabeza
                    transicion=i; %indice que marca el inicio del estado 2                 
                end
            
        end %del siwtch
    
   %-----------------------
          
    
    %-------------------------------------------------
    %SALIDAS ASOCIADAS A LOS ESTADOS
    
        switch estado
        
            case 1 %andando hacia delante
            %establece los valores de control 
                vel=20;
                Power1=vel;
                Power2=vel;
                
              %---------------------
              %Manda los comandos de control a los motores
              %-------------
                %Traction_motor_control;

            case 2 %parando
              %establece los valores de control 
                vel=0;
                Power1=vel;
                Power2=vel;
                
              %---------------------
              %Manda los comandos de control a los motores
              %-------------
               %Traction_motor_control;
        
            case 3 %girando cabeza
                %c�lculo de la referencia
                    referencia(i)=referencia_cabeza(Amplitud,t(i),Periodo,desfase);
                %c�lculo del error
                    error_cabeza(i)=(referencia(i)-giro_cabeza(i));
                %ganancia del controlador proporcional
                    k=0.35;
                    
                %Definici�n del controlador
                    controlador=k*error_cabeza(i);
                    
                %Actuaci�n sobre el motor
                    Power_cabeza=int8(controlador);
        
            case 4 %girando sobre si mismo
                vel=20;
                Power1=vel;
                Power2=-vel;
               
            case 5 %andando hacia atr�s
                %establece los valores de control 
               vel=-20;
               Power1=vel;
               Power2=vel;
                
              %---------------------
              %Manda los comandos de control a los motores
              %-------------
               %Traction_motor_control;      
          
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
