%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%% --------------------Initialize Kinect v2 -------------------
% Acquire data streams form Kinect v2
% Save Color and depth images to file
% Filenames are timestamp of the images
% No IR images for now.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%

function varargout = Kinectv2DAQ(varargin)
% FIGURE1 MATLAB code for figure1.fig

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Kinectv2DAQ_OpeningFcn, ...
                       'gui_OutputFcn',  @Kinectv2DAQ_OutputFcn, ...
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


% --- Executes just before figure1 is made visible.
function Kinectv2DAQ_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for figure1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes figure1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Kinectv2DAQ_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.


% function Kinectv2DAQ_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to density (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: popupmenu controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
% --------------------------------------------------------------------
function initialize_gui(~, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

% set(handles.options, 'SelectedObject', handles.radio_both);

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes during object creation, after setting all properties.
function frameSlider_CreateFcn(hObject, ~, ~)


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function txt_numFrame_CreateFcn(hObject, ~, ~)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% ==========================================================
% ######### ######### Edited Functions ######### #########%
% ==========================================================

function figure1_CreateFcn(hObject, ~, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes during object creation, after setting all properties.
    var_Options = 2;
    handles.var_Options = var_Options;
    OrigPath = pwd;
    handles.OrigPath = OrigPath;
    guidata(hObject, handles);

% --- Executes on button press in btn_SavePath.
function btn_SavePath_Callback(hObject, ~, handles)
    % >>>>>>>>>>Define Global Variables>>>>>>>>>>>>>>>>>>>>>>
    % numFrames: Number of frames to capture
    % chkbox_Preview: To enable or disable the preview
    % RGBpath:  Path or 'rgb' folder (assumed to be inside DatasetPath by default)
    % DepthPath:  Path or 'depth' folder (assumed to be inside DatasetPath by default)

    % Get path to dataset folder
    SavePath = uigetdir(pwd);
    % Create the folder if it doesn't exist already.
    RGBpath = sprintf('%s\\RGB', SavePath);
    if ~exist(RGBpath, 'dir')
      mkdir(RGBpath);
    end
    % Create the folder if it doesn't exist already.
    DepthPath = sprintf('%s\\Depth', SavePath);
    % Create the folder if it doesn't exist already.
    if ~exist(DepthPath, 'dir')
      mkdir(DepthPath);
    end

    % FOR PASSING GLOBAL VARIABLES
    % Pass data to GUI using handles
    % and update at end using guidata function
    handles.RGBpath = RGBpath;
    handles.DepthPath = DepthPath;
    guidata(hObject, handles);



% ==========================================================
% --- Executes when selected object changed in options.
function options_SelectionChangedFcn(hObject, ~, handles)
% Selection whether to capture both data or Just the Depth (to speed up the process)

    if (hObject == handles.rb_both)
        var_Options = 2;
    elseif (hObject == handles.rb_depth)
        var_Options = 1;
    elseif (hObject == handles.rb_none)
        var_Options = 0;
    end
            
    % Pass on options as global variables
    handles.var_Options = var_Options;
    guidata(hObject, handles);

% ==========================================================
% --- Executes on button press in checkbox_Preview.
function checkbox_Preview_Callback(~, ~, ~)
% To display or not to display  - that is the question!

% Hint: get(hObject,'Value') returns toggle state of checkbox_Preview


% ==========================================================
% --- Executes on slider movement.
function frameSlider_Callback(hObject, ~, handles)
%   Manimum number of frames to capture

    hObject.Min=1;
    hObject.Max=250;
    numFrames = get(hObject,'Value');       % get value of slider
    numFrames = round(numFrames);            % round off
    set(handles.txt_numFrame, 'String', num2str(numFrames));

% ==========================================================
function txt_numFrame_Callback(hObject, ~, handles)
  % Manually enter number of frames

    numFrames = round(str2double(get(hObject,'String')));
    % Set the slider to the typed value
    if numFrames > 1 && numFrames < 250
        set(handles.frameSlider,'Value', numFrames);
    end

% ==========================================================
% --- Executes on button press in chkbox_Preview.
function chkbox_Preview_Callback(hObject, ~, ~)

    chkbox_Preview = get(hObject,'Value');


%% ======================================
%           Data Acquisition            %
% =======================================
% --- Executes on button press in btn_StartDAQ.
function btn_StartDAQ_Callback(~, ~, handles)

    % Enters debug mode and pauses execution at the first executable line.
    dbstop if error

    % deletes any image acquisition objects that exsist in memory
    % Image acquisition hardware is reset
    imaqreset;
    % Initializing Kinect
    % The Kinect for Windows Sensor shows up as two separate devices
    hwInfo = imaqhwinfo('kinect');
    rgbcam = hwInfo.DeviceInfo(1);                  % DISPLAY RGB
    depthcam = hwInfo.DeviceInfo(2);                  % DISPLAY Depth
    %% --------------------------------------------------- %%
    a = struct2cell(rgbcam);
    str = sprintf('%s\n','KINECT COLOUR CAMERA DETECTED:', char(a(1)),char(a(3)),char(a(5)),char(a(6)));
    set(handles.uipanel_KinectInfo, 'String', str);

    a = struct2cell(depthcam);
    str = sprintf('%s\n','KINECT DEPTH CAMERA DETECTED:', char(a(1)),char(a(3)),char(a(5)),char(a(6)));
    set(handles.uipanel_KinectInfo2, 'String', str);
    % ----------------------------------------------------
    colourVid = videoinput('kinect',1); % RGB camera
    depthVid = videoinput('kinect',2); % Depth camera
%     srcRGB = getselectedsource(colourVid);
    srcD = getselectedsource(depthVid);
    % Turn off skeletal tracking to reduce CPU load
    srcD.EnableBodyTracking = 'off';

    % Set the frames per trigger for both devices to 1.
    colourVid.FramesPerTrigger = 1;
    depthVid.FramesPerTrigger = 1;
    % numFrames = number of frames to capture
    numFrames = round(get(handles.frameSlider,'Value'));
    colourVid.TriggerRepeat = numFrames;
    depthVid.TriggerRepeat = numFrames;
    % manual triggering for frame capture
    triggerconfig([colourVid depthVid],'manual');
    % >> Only if preview is enabled then figure is created
    var_Options = handles.var_Options;
    if var_Options == 2 || var_Options == 1
        % preview([colourVid depthVid]);
        % Create a figure window
        % Two subplots for displaying RGB and Depth frames
        scrsz = get(groot,'ScreenSize');
        figPlot = figure('Name','Kinect Data Streams','NumberTitle','off');
        % set position to dual monitor >> For single monitor, comment this line
       %  set(figPlot,'Position',[-1920+(1920/4) scrsz(4)/4 scrsz(3)/2 scrsz(4)/2]);
        set(figPlot,'Position',[(1680/4) scrsz(4)/4 scrsz(3)/2 scrsz(4)/2]);
        set(groot,'CurrentFigure',figPlot);
        subplot(1,2,1);
        title('Kinect: RGB','FontSize',14,'FontWeight','Bold');
        box off;
        % Hide ticks and borders
        set(gca,'xcolor',get(gcf,'color'),'xtick',[],'ytick',[],'color',get(gcf,'color'));
        subplot(1,2,2);
        title('Kinect: Depth','FontSize',14,'FontWeight','Bold');
        % Hide ticks and borders
        set(gca,'xcolor',get(gcf,'color'),'xtick',[],'ytick',[],'color',get(gcf,'color'));
    end

    %% ------------- Vid Capture -------------- %%

% Start data acquisition ; not data logging
start([colourVid depthVid]);
% Start Time
tic;
% pause(3); %allow time for both streams to start
filenameRGB='RGB'; % File name for video and also data file
filenameDepth='Depth'; % File name for video and also data file
for i=1:numFrames
   FramesPerTrigger
    
    % <<<<<<<<<<<< DEPTH >>>>>>>>>>>>>>>>
    % If preview, then display depth
    if var_Options == 2 || var_Options == 1
        subplot(1,2,2);
        imagesc(depthFrameData);
        % Display colorbar
        x=colorbar('southoutside');
        x.Label.String = 'Depth in Meters';
        set(gca,'xtick',[],'ytick',[],'color',get(gcf,'color'));
    end
    % Create filename with timestamp
    frameNum = depthMetaData.FrameNumber;
    combinedStr = strcat(filenameDepth,'_',num2str(frameNum),'_',num2str(depthTimeData),'.png');
    cd(handles.DepthPath);                % Change current directory to Depth
    % Write RGB file
    imwrite(depthFrameData,combinedStr);
    %   axis image; drawnow;
    %     colormap(gray);
end
% End time
elapsedTime = toc;
cd(handles.OrigPath);
% Display Time Elapsed
% [cdata,map] = imread('icon.png'); 
str = sprintf('Operation Completed Successfully.\n\nElapsed Time: %.4f Seconds',elapsedTime);
msgbox(str,'Success');

% Cleanup
stop ([colourVid depthVid]);
delete(imaqfind);
% Image acquisition hardware is reset
imaqreset;


