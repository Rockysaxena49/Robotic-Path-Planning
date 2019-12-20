classdef Robot_class % Name of our class
        properties
            % These are all the variables of the robot class, this is what
            % will be used in the handles structure of the GUI to
            % manipulate data around with the functions of this class. 
            robot; %robot class object called composition (aggregation)           
            theta; % joint angle variables 
            x; % variable to store x values 
            y; % variables to store the y values 
            s1; % servo motor 1
            s2; % servo motor 2
            s3; % servo motor 3
            a; % used to create arduino object
            b; % temp variable 
            x_pos; % hold x position 
            y_pos; % hold y position 
            PRM; % PRM class object composition (aggregation) 
            vision; % PRM class object composition (aggregation)  
            
        end
        methods
            function obj = Robot_class()
                % This function is called the default constructor it is
                % used to intialize all of the properties of the
                % Robot_class, the purpose of this is that if values are
                % not intialized then there will be some arbitrary values
                % stored in each variable which can cause the program to
                % misbehave. 
                obj.x = [];
                obj.y = [];
                obj.s1 = 1;
                obj.s2 = 1;
                obj.s3 = 1;
                obj.a = arduino('COM3', 'Uno', 'Libraries', 'Servo');
                obj.b = [];
                obj.theta = [0 0 0];
                obj.robot = [];
                obj.x_pos = [];
                obj.y_pos = [];
                % Grid is used to create the maze, since it is assigned to
                % one than it means that there is an obstacle there.
  
                Grid = zeros(100,100); % creates a map of 100X100 

                Grid(38:40,41:55) = 1; % (y,x) this creates the map of our
                Grid(25:40,41:43) = 1; % robot
                Grid(25:40,53:55) = 1;
                
                Grid(58:60,15:30) = 1;
                Grid(48:50,15:30) = 1;
                Grid(48:57,28:30) = 1;
                
                Grid(58:60,40:55) = 1;
                Grid(48:50,40:55) = 1;
                Grid(48:57,53:55) = 1;
                
                Grid(68:70,41:55) = 1;
                Grid(70:82,41:43) = 1;
                Grid(70:82,53:55) = 1;
                
                Grid(48:60,63:65) = 1;
                Grid(58:60,63:78) = 1;
                Grid(48:50,63:78) = 1;
                obj.vision = Dstar(Grid); % create DSTAR object
                obj.PRM = PRM(Grid); % create PRM object 
                 
            end
            
            function penUp(obj)
                % function move pen up
                obj.movePosition(obj.s3,1)
            end 
            
            function penDown(obj)
                % function move pen down 
                obj.movePosition(obj.s3,0.5)
            end 
            
            function obstacle(obj, x,y)
                % The function is going to create a new obstacle when
                % either of our Dstar or PRM algorithm is running 
                
                Grid = zeros(100,100); 

                Grid(38:40,41:55) = 1; 
                Grid(25:40,41:43) = 1;
                Grid(25:40,53:55) = 1;
                
                Grid(58:60,15:30) = 1;
                Grid(48:50,15:30) = 1;
                Grid(48:57,28:30) = 1;
                
                Grid(58:60,40:55) = 1;
                Grid(48:50,40:55) = 1;
                Grid(48:57,53:55) = 1;
                
                Grid(68:70,41:55) = 1;
                Grid(70:82,41:43) = 1;
                Grid(70:82,53:55) = 1;
                
                Grid(48:60,63:65) = 1;
                Grid(58:60,63:78) = 1;
                Grid(48:50,63:78) = 1;
                
                Grid(y:y+2,x:x+2) = 1; 
                obj.vision = Dstar(Grid); 
                figure(10) % plot the new obstacle in figure 10
                obj.vision.plot(); 
            end
            
            function drawMaze(obj,x, y)
                m = [1 1 0 0 0 0];
                
                % create the transformation matrix 
                transformation = eye(4);
                % map the x and y values of the grid to our board 
                mapX = obj.map_fn(x, 15, 100, 1, 6);
                mapY = obj.map_fn(y, 0, 90, 2.5, 11);
                
                for i = 1:length(x)
                    % each iteration add the mapped valued to our
                    % transformation matrix 
                    transformation(1,4) = mapX(i);
                    transformation(2,4)= mapY(i);
                    % use inverse kinematics to get the joint angles 
                    q = obj.robot.ikine(transformation,'q0', obj.theta,'mask', m);
                    
                    if ~isempty(q) % if there is something in q then continue 
                        % plot the robot with updated joint angles 
                       
                        obj.robot.plot([-q(1) -q(2) 0]);
                        % forward kinematics to get transformation matrix
                        % to plot on GUI 
                        
                        t = obj.robot.fkine ([-q(1), -q(2), 0]);
                        hold on; % need to plot simultaneously 
                        plot3(t.t(1), t.t(2), t.t(3), '--r.');
                        
                        % update all the joint angles  
                        obj.theta(1) = q(1);
                        
                        obj.theta(2) = q(2);
                        
                        obj.theta(3) = q(3);
                    else
                        disp ('joint angle failed'); % q is empty  
                    end
                    % map to get the servo motor value that are between 0
                    % and 1
                    joint1 = obj.map_fn(obj.theta(1),-0.261799388,3.18522588, 0.1, 0.9);
                    joint2 = obj.map_fn(obj.theta(2),-3.18522588,0.261799388, 0.1, 0.9);
                    
                    % function to move physical robot with mapped values 
                    obj.movePosition(obj.s1,joint1)
                    obj.movePosition(obj.s2,joint2)
                    
                    % move the pen down
                    obj.penDown();
                end
                
                
            end 
            
            function dstar_fn(obj,x,y)
                % function to run the Dstar algorithm 
                m = [1 1 0 0 0 0];
                
                % create the transformation matrix 
                transformation = eye(4);
                
                % map the x y grid values to the clipboard values 
                mapX = obj.map_fn(x, 15, 100, 1, 6);
                mapY = obj.map_fn(y, 0, 90, 2.5, 11);
                
                for i = 1:length(x)
                    % each iteration store the mapped grid values in
                    % rotation matrix 
                    transformation(1,4) = mapX(i);
                    transformation(2,4)= mapY(i);
                    
                    % do inverse kinematics to get the joint angles from
                    % the transformation matrix 
                    q = obj.robot.ikine(transformation,'q0', obj.theta,'mask', m);
                    
                    % if either arduino buttons pushed excute if statments 
                    if ((readDigitalPin(obj.a,'D2')) || (readDigitalPin(obj.a,'D4')))
                        if readDigitalPin(obj.a,'D2') == 1 % D2 pressed, obstacle planted
                            disp('Obstacle thrown')
                            % obstacle will be place in front of current
                            % position of the robot 
                            obstacley = y(i) + 1;
                            obstaclex = x(i) + 1;
                            % call the obstacle function to plant the
                            % obstacle in our map
                            obj.obstacle(obstaclex,obstacley)  
                            % get new starting position
                            start = [x(i); y(i)]; 
                            % get new ending goal 
                            goal =[x(length(x));y(length(x))];
                            % make a new plan based of new goal and start 
                            obj.vision.plan(goal);
                            % get x y values of plan 
                            o = obj.vision.query(start);
                            % store new x and y values of plan 
                            f = o(:,1);
                            g = o(:,2);
                            % call the draw maze function to excute the new
                            % path 
                            obj.drawMaze(f, g)
                            return
                    
                            
                        elseif readDigitalPin(obj.a,'D4') == 1 % D4 pressed, go back to start
                                disp('D4 was pressed');
                                goal = [48;55]; % create new goal position 
                                start=[x(i);y(i)]; % create new start position 
                                obj.vision.plan(goal); % create the cost map to the goal
                                p = obj.vision.query(start,goal); % get 
                                %the new path 
                                % store the new x and y values of the new
                                % path 
                                f = p(:,1);
                                g = p(:,2);
                                % call drawMaze function to cause robot to
                                % move back to start 
                                obj.drawMaze(f, g)
                                return
                                        
                        end
                    end
                    
                    
                    if ~isempty(q) % if there is values in q enter if
                        % plot the robot with new joint angles 
                        obj.robot.plot([-q(1) -q(2) 0]);
                        % get the transformation matrix with the new joint
                        % angles 
                        t = obj.robot.fkine ([-q(1), -q(2), 0]);
                        hold on;
                        % draw the path in the GUI 
                        plot3(t.t(1), t.t(2), t.t(3), '--r.');
                        % update all the theta values 
                        obj.theta(1) = q(1);
                        
                        obj.theta(2) = q(2);
                        
                        obj.theta(3) = q(3);
                    else
                        disp ('q is empty '); % nothing stored in q 
                    end
                    % map joint angles to servo values 0 to 1 
                    joint1 = obj.map_fn(obj.theta(1),-0.261799388,3.18522588, 0.1, 0.9);
                    joint2 = obj.map_fn(obj.theta(2),-3.18522588,0.261799388, 0.1, 0.9);
                    % move the physical robot via mapped values 
                    obj.movePosition(obj.s1,joint1)
                    obj.movePosition(obj.s2,joint2)
                    % move the pen down 
                    obj.penDown();
                   
                end
            end 
            
            function PRM_fn(obj,x,y)
                % function to carry out the PRM algorithm 
                for i = 0:5
                    % create a buffer to make sure pin working correctly
                    readDigitalPin(obj.a,'D2')
                    readDigitalPin(obj.a,'D4')
                end
                
                m = [1 1 0 0 0 0];
                % graph work space
                W = [-5 13.5 0 17.5 -5 5];
                % initalize empty joint vectors 
                joint1Array = []; 
                joint2Array = []; 
                % create a transformation matrix 
                transformation = eye(4);
                % map the values to board values 
                mapX = obj.map_fn(x, 15, 100, 1, 6);
                mapY = obj.map_fn(y, 0, 90, 2.5, 11);
              
                for i = 1:length(x)
                    %insert the x and y mapped values in transformation 
                    transformation(1,4) = mapX(i);
                    transformation(2,4)= mapY(i);
                    % inverse kinematic to get joint angles based on
                    % transformation matrix 
                    q = obj.robot.ikine(transformation,'q0', obj.theta,'mask', m);
                    
                    
                    if ~isempty(q) % if there are values in q 
                        %obj.robot.plot([-q(1) -q(2) 0]);
                        % tranformation matrix obtained 
                        t = obj.robot.fkine ([-q(1), -q(2), 0]);
                        hold on;
                        %plot on GUI the path 
                        plot3(t.t(1), t.t(2), t.t(3), '--r.');
                        % update the joint angles 
                        obj.theta(1) = q(1);
                        
                        obj.theta(2) = q(2);
                        
                        obj.theta(3) = q(3);
                    else
                        disp ('q is empty ');
                    end
                    % map the values to servo values between 0 and 1 
                    joint1 = obj.map_fn(obj.theta(1),-0.261799388,3.18522588, 0.1, 0.9);
                    % store mapped values in vector to be called later 
                    joint1Array(i)= joint1; 
                    % store mapped values in vector to be called later 
                    joint2 = obj.map_fn(obj.theta(2),-3.18522588,0.261799388, 0.1, 0.9);
                    joint2Array(i) = joint2;                  
                end
                for i = 1:length(joint1Array) -1
                    % this code is used so tpoly can draw out smoother lines between the
                    % current angle and the angle to come by iterating through each step.
                    [P1,SD1,SDD1] = tpoly(joint1Array(i), joint1Array(i+1),50);
                    [P2,SD2,SDD2] = tpoly(joint2Array(i), joint2Array(i+1),50);
                    for j = 1:length(P1)
                        obj.penDown(); % move pen up 
                        % physically move robot smoothly with t-poly 
                        obj.movePosition(obj.s1,P1(j))
                        obj.movePosition(obj.s2,P2(j))
                        if ((readDigitalPin(obj.a,'D2')) || (readDigitalPin(obj.a,'D4')))
                            if readDigitalPin(obj.a,'D2') == 1 %  obstacle planted
                                
                               % um1 and um2 are the unmapped values of our
                               % current path                        
                                um1 = obj.map_fn(P1(j), 0.1, 0.9,-0.261799388,3.18522588);
                                um2 = obj.map_fn(P2(j), 0.1, 0.9 ,-3.18522588,0.261799388);
                                
                                v = obj.robot.fkine ([um1, um2, 0]);
                                e= v.t(1); % variable to store x position of end effector 
                                l= v.t(2); % variable to store y position of end effector 
                                % map the um1 and um2 to the cost map grid 
                                lX = obj.map_fn(e, 1, 6, 15, 100);
                                lY = obj.map_fn(l, 2.5, 11, 0, 90);
                                % thrown and obstacle in front of current
                                % position of the robot
                                obstacley = lY + 1;
                                obstaclex = lX + 1;
                                % call the obstacle function 
                                obj.obstacle(obstaclex,obstacley)
                                start = [lX; lY]; % new values of start 
                                goal =[x(length(x));y(length(x))]; % new value of goal 
                                figure('Name','PRM Path (obsticle)', 'NumberTitle', 'off')
                                obj.PRM.plan(goal); % create cost path of new path 
                                p = obj.PRM.query(start,goal); % get x and y values of new map 
                                f = p(:,1); % store new x values of path 
                                g = p(:,2); % store new y values of path 
                                obj.go_start(f, g) % function to carry out new path avoiding obstacle 
                                
                            elseif readDigitalPin(obj.a,'D4') == 1 % go back to start
                                disp('D4 was pressed');
                                % get the unmapped values from servo to
                                % joint limits 
                                um1 = obj.map_fn(P1(j), 0.1, 0.9,-0.261799388,3.18522588);
                                um2 = obj.map_fn(P2(j), 0.1, 0.9 ,-3.18522588,0.261799388);
                                
                                % forward kinematics to get transformation
                                % matrix 
                                v = obj.robot.fkine ([um1, um2, 0]);
                                e= v.t(1); % store x position of end effector 
                                l= v.t(2); % store y position of end effector 
                                
                                % mao the board values to the grid map 
                                lX = obj.map_fn(e, 1, 6, 15, 100);
                                lY = obj.map_fn(l, 2.5, 11, 0, 90);
                                goal = [48;55]; % set our new goal 
                                start=[lX;lY]; %set our new start 
                                obj.PRM.plan(goal); % create the cost map to the nw goal
                                p = obj.PRM.query(start,goal); % get new x and y values of new path 
                                f = p(:,1); % store new x path values 
                                g = p(:,2); % store new y path values 
                                obj.go_start(f, g) % call function to carry out new path goal 
                                
                                
                                return
                            end
                            
                        end
                    end
                end
                
            end
            
            
            function go_start(obj,x,y)
                % function to carry out new path plan 
                m = [1 1 0 0 0 0];
                % graph work space
                W = [-5 13.5 0 17.5 -5 5];
                % initalize array 
                joint1Array = []; 
                joint2Array = []; 
                % create transformation matrix 
                transformation = eye(4);
                % map grid values to board values
                mapX = obj.map_fn(x, 15, 100, 1, 6);
                mapY = obj.map_fn(y, 0, 90, 2.5, 11);
              
                for i = 1:length(x)
                    % store mapped values in transformation matrix 
                    transformation(1,4) = mapX(i);
                    transformation(2,4)= mapY(i);
                    % do inverse kinematic to get joint angles 
                    q = obj.robot.ikine(transformation,'q0', obj.theta,'mask', m);
                   
                    if ~isempty(q) % if values are in q enter if 
                       %obj.robot.plot([-q(1) -q(2) 0]);
                       % forward kinematics to get the transformation
                       % matricx of joint angles 
                        t = obj.robot.fkine ([-q(1), -q(2), 0]);
                        hold on;
                        % plot path in GUI 
                        plot3(t.t(1), t.t(2), t.t(3), '--r.');
                        % update values of our joint angles 
                        obj.theta(1) = q(1);
                        
                        obj.theta(2) = q(2);
                        
                        obj.theta(3) = q(3);
                    else
                        disp ('q is empty ');
                    end
                    % map the values of servo values between 0 and 1 
                    joint1 = obj.map_fn(obj.theta(1),-0.261799388,3.18522588, 0.1, 0.9);
                    % store the mapped values in a vector 
                    joint1Array(i)= joint1; 
                    % map the values of servo values between 0 and 1 
                    joint2 = obj.map_fn(obj.theta(2),-3.18522588,0.261799388, 0.1, 0.9);
                    % store the mapped values in a vector
                    joint2Array(i) = joint2; 
                    
                    
                end
                for i = 1:length(joint1Array) -1
                    % this code is used so tpoly can draw out smoother lines between the
                    % current angle and the angle to come by iterating through each step.
                    [P1,SD1,SDD1] = tpoly(joint1Array(i), joint1Array(i+1),30);
                    [P2,SD2,SDD2] = tpoly(joint2Array(i), joint2Array(i+1),30);
                    for j = 1:length(P1)
                        obj.penDown(); % moved the pen down 
                        % physically move robot smoothly with t-poly values
                        obj.movePosition(obj.s1,P1(j))
                        obj.movePosition(obj.s2,P2(j))
                        %obj.robot.plot([P1(j), P2(j),z], 'workspace', W)
                    end
                end
                
            end
            
            
            function y = map_fn(obj, vector,gridMin,gridMax,boardMin,boardMax)
                % gridMin is the minimum value of our grid (0)
                % gridMax is the maximum value of the grid (100)
                % boardMin is the minimum value of our board depends on if we map x or y
                % boardMax is the maximum value of our board depends on if we map x or y
                % vector is the x vector or y vector of our grid depending on arugment
                % y is our output converting a grid value into our board value
                % linear equation y = w1x + wo
                wo = (boardMax - boardMin)/(gridMax - gridMin);
                w1 = boardMin - wo*gridMin;
                y = wo*vector + w1;
                
            end
            
            function movePosition(obj, joint,temp)
            % The function will move the robot based on which joint
            % selected and which value (temp) used. the obj is treated as a
            % pointer to the object of Robot_class
               writePosition(joint,temp)
               
            end
            
            function temp = getPosition(obj, joint)
                %This function will get the actual values of the hardware
                % movement of the robot.
                temp = readPosition(joint);
            end             
            
        end
end

  
