function varargout = Project_3(varargin)
% PROJECT_3 MATLAB code for Project_3.fig
%      PROJECT_3, by itself, creates a new PROJECT_3 or raises the existing
%      singleton*.
%
%      H = PROJECT_3 returns the handle to a new PROJECT_3 or the handle to
%      the existing singleton*.
%
%      PROJECT_3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT_3.M with the given input arguments.
%
%      PROJECT_3('Property','Value',...) creates a new PROJECT_3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Project_3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Project_3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Project_3

% Last Modified by GUIDE v2.5 01-Dec-2019 16:35:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project_3_OpeningFcn, ...
                   'gui_OutputFcn',  @Project_3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Project_3 is made visible.
function Project_3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Project_3 (see VARARGIN)

% Choose default command line output for Project_3
handles.output = hObject;

%{ 
creates an object of the robot class and stores it in handles.rc
struct property.
%}
handles.rc = Robot_class();

clc
% This code is needed to make sure our variables retain there values
% in other functions 
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Project_3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Joint_1_Callback(hObject, eventdata, handles)
% This code will grab the value of our slider position and store it to our
% class variable theta(1)
handles.rc.theta(1) = get(hObject,'Value');
y = handles.rc.map_fn(handles.rc.theta(1),-0.261799388,3.18522588, 0, 1); 
handles.rc.movePosition(handles.rc.s1,y)

% with the new theta value we will plot our robot with the new angle 
handles.rc.robot.plot(-handles.rc.theta);
% The code below will be used to update end effector x position in 
% real time as we move the slider
T = handles.rc.robot.fkine(-handles.rc.theta);
X = sprintf('X = %f', T.t(1));
set(handles.x_func,'String',X);
drawnow();

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Joint_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joint_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Joint_2_Callback(hObject, eventdata, handles)

% This code will grab the value of our slider position and store it to our
% class variable theta(2)
handles.rc.theta(2) = get(hObject,'Value');
y  = handles.rc.map_fn(handles.rc.theta(2),-3.18522588,0.261799388, 0, 1); 
handles.rc.movePosition(handles.rc.s2,y)

% with the new theta value we will plot our robot with the new angle 
handles.rc.robot.plot(-handles.rc.theta);

% The code below will be used to update end effector x position in 
% real time as we move the slider
T = handles.rc.robot.fkine(handles.rc.theta);
Y = sprintf('Y = %f', T.t(2));
set(handles.y_func,'String',Y);
drawnow();

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Joint_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Joint_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes on slider movement.
function End_Effector_Callback(hObject, eventdata, handles)

% This code will grab the value of our slider position and store it to our
% class variable theta(3)
handles.rc.theta(3) = get(hObject,'Value');
handles.rc.movePosition(handles.rc.s3,handles.rc.theta(3))

% with the new theta value we will plot our robot with the new angle 
handles.rc.robot.plot(handles.rc.theta);

% The code below will be used to update end effector x position in 
% real time as we move the slider
T = handles.rc.robot.fkine(handles.rc.theta);
Z = sprintf('Z = %f', T.t(3));
set(handles.z_func,'String',Z);
drawnow();
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function End_Effector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to End_Effector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in Create_Robot.
function Create_Robot_Callback(hObject, eventdata, handles)

% Specify the axes to use 
axes(handles.axes1);
% value of our work space to change the floor titles
W = [-5 13.5 0 17.5 -5 5];

% deg will be used to convert degrees to radians 
deg = pi/180;
% By inputting our dh parameters as an argument we will generate each link
L(1) = Link('a', 3.8490,'alpha', 0.0030, 'd', 1.0303, 'offset', 0.1864, 'qlim', [15 -182.5]*deg);
L(2) = Link('a', 3.7936, 'alpha', -0.6883, 'd', 0.7163, 'offset', -0.1017, 'qlim', [182.5 -15]*deg);
L(3) = Link('a', 0.0016  , 'alpha', -0.0008, 'd', 0.2595, 'offset', 0.0087, 'qlim', [0, pi]);
% serial link will be used to help create the robot 
handles.rc.robot = SerialLink(L, 'name', 'robot');

% robotic base that is 8 inches in y direction from universial coordinate 
% to robotic base, similarly for the tool tip  
handles.rc.robot.base = [1 0 0 0; 0 1 0 8; 0 0 1 0; 0 0 0 1];
handles.rc.robot.tool = [1 0 0 0; 0 1 0 0;0 0 1 -2.5; 0 0 0 1];

% below code will plot our robot with the theta values and update
% the floor of our robot with the 'workspace' command 
handles.rc.robot.plot (handles.rc.theta, 'workspace', W);

% create an arduino object and store it to robot class property a
%handles.rc.a = arduino('COM3', 'Uno', 'Libraries', 'Servo');
% this code is used to make the pin an input opposed to an output
handles.rc.a.configurePin('D2','DigitalInput');
handles.rc.a.configurePin('D4','DigitalInput');

% create a servo object for each of the motors and inputting its pulse 
% duration range from tech specs from website
handles.rc.s1 = servo(handles.rc.a, 'D9', 'MinPulseDuration', 575*10^-6, 'MaxPulseDuration', 2460*10^-6);
handles.rc.s2 = servo(handles.rc.a, 'D10', 'MinPulseDuration', 575*10^-6, 'MaxPulseDuration', 2460*10^-6);
handles.rc.s3 = servo(handles.rc.a, 'D11', 'MinPulseDuration', 640*10^-6, 'MaxPulseDuration', 2250*10^-6);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Reset_fn.
function Reset_fn_Callback(hObject, eventdata, handles)

% reset the robot back to starting postion by making theta values 0
handles.rc.robot.plot ([0 0 0]);

% choose the physical starting postion of our hardware robot
handles.rc.movePosition(handles.rc.s1,0.1)
handles.rc.movePosition(handles.rc.s2,0.9)

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Key_press.
function Key_press_Callback(hObject, eventdata, handles)
% ignore this function 


% --- Executes on key press with focus on Key_press and none of its controls.
function Key_press_KeyPressFcn(hObject, eventdata, handles)

% this code will get the current graphic figure

f= gcf;

% m matrix specfies the axis (x,y,and z) and if there are any yaw, pitch, and row
m = [1 1 0 0 0 0];

% val will get the current arrow key from the keyboard, note computer can
% only recongnize numbers so the ascii table assigns a number to each
% keyboard key and this number is what is stored in the val variable

val=double(get(f,'CurrentCharacter'));

%do a forward kinematics
T = handles.rc.robot.fkine([handles.rc.theta(1), handles.rc.theta(2), handles.rc.theta(3)]);
 
% depending on the val value it will run the switch case based on it.
switch (val)

    case 28 % right
        
        T.t(1) = T.t(1) + .1;
        
    case 29  %left
        
        T.t(1) = T.t(1) - .1;
        
    case 30 %up
        
        T.t(2) = T.t(2) + .1;
        
    case 31  %down
        
        T.t(2) = T.t(2) - .1;
        
    otherwise
        
        disp ('unrecognized key');
        
end

% inverse kinematics is used here to get the joint angles which are theta 1
% theta 2 and theta 3. 
q = handles.rc.robot.ikine(T,'q0', handles.rc.theta,'mask', m);

% if q is not empty meaning there is some value in it then we will plot the
% robot and store the new joint angles in our theta values. This is good to
% prevent self assignment and decrease the time complexity of our program. 
if ~isempty(q)
    handles.rc.robot.plot([-q(1) -q(2) q(3)]);
    
    handles.rc.theta(1) = q(1);
    
    handles.rc.theta(2) = q(2);
    
    handles.rc.theta(3) = q(3);
else
    disp ('no solution');
end

% these will call the Robot_class mapping function which will make each of
% our theta values a range between 0 - 1 because the movePosition function
% can only take values between 0 and 1. 
y1 = handles.rc.map_fn(handles.rc.theta(1),-0.261799388,3.18522588, 0, 1); 
y2 = handles.rc.map_fn(handles.rc.theta(2),-3.18522588,0.261799388, 0, 1); 

% move position is a Robot_class function that calls a servo pre-defined
% function writePosition to move the specfied motor based on s used and
% given a theta value that is mapped between 0 and 1. 
handles.rc.movePosition(handles.rc.s1,y1)
handles.rc.movePosition(handles.rc.s2,y2)

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Pen_Up.
function Pen_Up_Callback(hObject, eventdata, handles)
% function to move pen up by calling class function and inputting the end 
% effector servo motor. 
handles.rc.movePosition(handles.rc.s3,1)
guidata(hObject, handles);


% --- Executes on button press in Pen_Down.
function Pen_Down_Callback(hObject, eventdata, handles)
% function to move pen down by calling class function and inputting the end 
% effector servo motor. 
handles.rc.movePosition(handles.rc.s3,0.5)
guidata(hObject, handles);


% --- Executes on selection change in Path_Fn.
function Path_Fn_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject, 'String')); % grab value of string clicked
Choice = contents(get(hObject,'Value')); % get the value of it

if (strcmp(Choice, 'Path 1')) % Path 1 was selected
    tic; % keep a count of run time of function
    goal = [48;32]; % this is to set our goal x = 48 y = 32
    start=[48;55]; % assigns a start postion x = 48 y = 55 
    handles.rc.vision.plan(goal); % create the cost map to the goal
    p = handles.rc.vision.query(start); % find a path
    figure('Name','DSTAR Path 1', 'NumberTitle', 'off') % open in another figure
    handles.rc.vision.plot(p); % call vision object to plot path
    handles.rc.x = p(:,1); % get the x values of path 
    handles.rc.y = p(:,2); % get the y values of path
    axes(handles.axes1); % plot the new figure to our GUI axes
    handles.rc.dstar_fn(handles.rc.x,handles.rc.y); % run Dstar algorithm,
    % stored in the Robot_class object. 
    handles.rc.penUp(); % call the pen up. 
    toc; % return the time to finish the algorithm 
    disp(toc); 
elseif (strcmp(Choice, 'Path 2')) % Path 2 was selected
    tic; % keep a count of run time of function
    goal = [21;54]; % this is to set our goal x = 21 y = 54
    start=[48;55]; % this is to set our goal x = 48 y = 55
    handles.rc.vision.plan(goal); % create the cost map to the goal
    p = handles.rc.vision.query(start); % find a path
    figure('Name','DSTAR Path 2', 'NumberTitle', 'off') % open in another figure
    handles.rc.vision.plot(p); % call vision object to plot path
    handles.rc.x = p(:,1); % get the x values of path 
    handles.rc.y = p(:,2);% get the y values of path
    axes(handles.axes1); % plot the new figure to our GUI axes
    handles.rc.dstar_fn(handles.rc.x,handles.rc.y); % run Dstar algorithm
    handles.rc.penUp();% call the pen up.
    toc; % return the time to finish the algorithm 
    disp(toc);
elseif (strcmp(Choice,'Path 3')) % Path 3 was selected
    tic; % keep a count of run time of function
    goal = [48,76]; % this is to set our goal x = 48 y = 76
    start=[48;55];  % this is to set our goal x = 48 y = 55
    handles.rc.vision.plan(goal); % create the cost map to the goal
    p = handles.rc.vision.query(start); % find a path
    figure('Name','DSTAR Path 3', 'NumberTitle', 'off') % open in another figure
    handles.rc.vision.plot(p);  % call vision object to plot path
    handles.rc.x = p(:,1); % get the x values of path 
    handles.rc.y = p(:,2); % get the y values of path
    axes(handles.axes1); % plot the new figure to our GUI axes
    handles.rc.dstar_fn(handles.rc.x,handles.rc.y); % run the Dstar algorithm
    handles.rc.penUp(); % call the pen up.
    toc; % return the time to finish the algorithm
    disp(toc);
else % Path 4 was selected
    tic; % keep a count of run time of function
    goal = [71;55];  % this is to set our goal x = 21 y = 54
    start=[48;55]; % assigns a start postion (don't put it inside obstacle)
    handles.rc.vision.plan(goal); % create the cost map to the goal
    p = handles.rc.vision.query(start); % find a path
    figure('Name','DSTAR Path 4', 'NumberTitle', 'off') % open in another figure
    handles.rc.vision.plot(p); % call vision object to plot path
    handles.rc.x = p(:,1); % get the x values of path 
    handles.rc.y = p(:,2); % get the y values of path
    axes(handles.axes1); % plot the new figure to our GUI axes
    handles.rc.dstar_fn(handles.rc.x,handles.rc.y); % run the Dstar algorithm
    handles.rc.penUp(); % call the pen up.
    toc; % return the time to finish the algorithm
    disp(toc);
end 

% --- Executes during object creation, after setting all properties.
function Path_Fn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Path_Fn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Draw_Maze.
function Draw_Maze_Callback(hObject, eventdata, handles)

% load grid x y map from external notepad
ld = load('Grid1.txt');

% call pen up function from robot class
handles.rc.penUp();

% holds the x and y values of the selcted grid map
handles.rc.x_pos = ld(:,2);
handles.rc.y_pos = ld(:,1);

% call drawMaze function from robot class to draw the maze on hardware
handles.rc.drawMaze(handles.rc.x_pos,handles.rc.y_pos); 

% load grid x y map from external notepad
ld = load('Grid2.txt');

% call pen up function from robot class
handles.rc.penUp();

% holds the x and y values of the selcted grid map
handles.rc.x_pos = ld(:,2);
handles.rc.y_pos = ld(:,1);

% call drawMaze function from robot class to draw the maze on hardware
handles.rc.drawMaze(handles.rc.x_pos,handles.rc.y_pos); 

% load grid x y map from external notepad
ld = load('Grid3.txt');

% call pen up function from robot class
handles.rc.penUp();

% holds the x and y values of the selcted grid map
handles.rc.x_pos = ld(:,2);
handles.rc.y_pos = ld(:,1);

% call drawMaze function from robot class to draw the maze on hardware
handles.rc.drawMaze(handles.rc.x_pos,handles.rc.y_pos); 

% load grid x y map from external notepad
ld = load('Grid4.txt');

% call pen up function from robot class
handles.rc.penUp();

% holds the x and y values of the selcted grid map
handles.rc.x_pos = ld(:,2);
handles.rc.y_pos = ld(:,1);

% call drawMaze function from robot class to draw the maze on hardware
handles.rc.drawMaze(handles.rc.x_pos,handles.rc.y_pos); 

% load grid x y map from external notepad
ld = load('Grid5.txt');

% call pen up function from robot class
handles.rc.penUp();

% holds the x and y values of the selcted grid map
handles.rc.x_pos = ld(:,2);
handles.rc.y_pos = ld(:,1);

% call drawMaze function from robot class to draw the maze on hardware
handles.rc.drawMaze(handles.rc.x_pos,handles.rc.y_pos); 

% call pen up function from robot class
handles.rc.penUp();

guidata(hObject, handles);

% --- Executes on selection change in PRM_PATH_FN.
function PRM_PATH_FN_Callback(hObject, eventdata, handles)
% function to call the PRM algorithm in the robot class and cause our
% robot to physically move on hardware and GUI

% grab the string value of the menu box selected
contents = cellstr(get(hObject, 'String'));
% grab the value of the selected box 
Choice = contents(get(hObject,'Value'));

if (strcmp(Choice, 'Path 1')) % Path 1 selected continue down 
     tic; % start a timer for the algortithm 
     goal = [48;32]; % this is to set our goal x = 48 y = 32
     start=[48;55]; % assigns a start postion x = 48 y = 55
     handles.rc.PRM.plan(goal); % create cost map 
     q = handles.rc.PRM.query(start,goal); % find a path from start to goal
     figure('Name','PRM Path 1', 'NumberTitle', 'off') % plot in this fig
     handles.rc.PRM.plot(q);% plot the path taken 
     handles.rc.x = q(:,1); % grab the x path values 
     handles.rc.y = q(:,2); % grab the y path values 
     axes(handles.axes1); % plot on GUI graph
     handles.rc.PRM_fn(handles.rc.x,handles.rc.y) %Call PRM algorithm
     handles.rc.penUp(); % move the up by calling pen up function of class
     toc; % return the time taken to complete the algorithm 
     disp(toc);
elseif (strcmp(Choice, 'Path 2')) % Path 2 selected continue down 
    tic; % start a timer for the algortithm 
    goal = [22;55]; % this is to set our goal x = 22 y = 55
    start=[48;55]; % assigns a start postion x = 48 y = 55
    handles.rc.PRM.plan(goal); % create cost map 
    q = handles.rc.PRM.query(start,goal); % find a path from start to goal
    figure('Name','PRM Path 2', 'NumberTitle', 'off') % plot in this fig
    handles.rc.PRM.plot(q);% plot the path taken
    handles.rc.x = q(:,1); % grab the x path values 
    handles.rc.y = q(:,2); % grab the y path values 
    axes(handles.axes1); % plot on GUI graph
    handles.rc.PRM_fn(handles.rc.x,handles.rc.y) % Call PRM algorithm
    handles.rc.penUp();  % move the up by calling pen up function of class
    toc; % return the time taken to complete the algorithm
    disp(toc);
elseif (strcmp(Choice,'Path 3')) % Path 3 selected continue down
    tic; % start a timer for the algortithm 
    goal = [48;75]; % this is to set our goal x = 48 y = 75
    start=[48;55]; % assigns a start postion x = 48 y = 55
    handles.rc.PRM.plan(goal); % create cost map 
    q = handles.rc.PRM.query(start,goal); % find a path from start to goal
    figure('Name','PRM Path 3', 'NumberTitle', 'off') % plot in this fig
    handles.rc.PRM.plot(q); % plot the path taken
    handles.rc.x = q(:,1); % grab the x path values
    handles.rc.y = q(:,2); % grab the y path values 
    axes(handles.axes1); % plot on GUI graph
    handles.rc.PRM_fn(handles.rc.x,handles.rc.y) % Call PRM algorithm
    handles.rc.penUp();% move the up by calling pen up function of class
    toc; % return the time taken to complete the algorithm
    disp(toc);
else % Path 4 selected continue down
    tic; % start a timer for the algortithm 
    goal = [71;53]; % this is to set our goal x = 71 y = 53
    start=[48;55]; % assigns a start postion x = 48 y = 55
    handles.rc.PRM.plan(goal); % create cost map 
    q = handles.rc.PRM.query(start,goal); % find a path from start to goal
    figure('Name','PRM Path 4', 'NumberTitle', 'off') % plot in this fig
    handles.rc.PRM.plot(q);  % plot the path taken
    handles.rc.x = q(:,1); % grab the x path values
    handles.rc.y = q(:,2);  % grab the y path values
    axes(handles.axes1); % plot on GUI graph
    handles.rc.PRM_fn(handles.rc.x,handles.rc.y) % Call PRM algorithm
    handles.rc.penUp(); % move the up by calling pen up function of clas
    toc; % return the time taken to complete the algorithm
    disp(toc);
end

% --- Executes during object creation, after setting all properties.
function PRM_PATH_FN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PRM_PATH_FN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
