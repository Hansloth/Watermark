    %原始host picture: host
    %原始watermark picture: watermark
    %縮小到適當大小的watermark picture: swatermark
    %最終藏入的watermark picture: finalwatermark
    %watermark藏入且壓縮過的圖片:compress 
    %取出後的watermark picture: extwatermark
    %host image which size eauals finalwatermark: imghost
    %因為會有小數點大小問題 所以盡量把所有大小resize成imghost

    function varargout = watermark(varargin)
    % WATERMARK MATLAB code for watermark.fig
    %      WATERMARK, by itself, creates a new WATERMARK or raises the existing
    %      singleton*.
    %
    %      H = WATERMARK returns the handle to a new WATERMARK or the handle to
    %      the existing singleton*.
    %
    %      WATERMARK('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in WATERMARK.M with the given input arguments.
    %
    %      WATERMARK('Property','Value',...) creates a new WATERMARK or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before watermark_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to watermark_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help watermark

    % Last Modified by GUIDE v2.5 28-Jun-2020 00:57:04

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @watermark_OpeningFcn, ...
                       'gui_OutputFcn',  @watermark_OutputFcn, ...
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


    % --- Executes just before watermark is made visible.
    function watermark_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to watermark (see VARARGIN)

    % Choose default command line output for watermark
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes watermark wait for user response (see UIRESUME)
    % uiwait(handles.figure1);


    % --- Outputs from this function are returned to the command line.
    function varargout = watermark_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;

    %Chose Host image
    % --- Executes on button press in pushbutton1.
    function pushbutton1_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [filename, pathname] = uigetfile({'*.jpg';'*.png'},'Select an image');
    global host;
    host=imread([pathname,filename]);
    axes(handles.axes1);
    imshow(host);


    %Chose watermark image
    % --- Executes on button press in pushbutton3.
    function pushbutton3_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    [filename, pathname] = uigetfile({'*.jpg';'*.png'},'Select an image');
    global watermark;
    watermark=imread([pathname,filename]);
    axes(handles.axes2);
    imshow(watermark);



    function edit1_Callback(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit1 as text
    %        str2double(get(hObject,'String')) returns contents of edit1 as a double


    % --- Executes during object creation, after setting all properties.
    function edit1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


    % --- Executes on button press in pushbutton4.
    %Hide鍵
    function pushbutton4_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    %取得n*n的n
    global n;
    global host;
    global watermark;

    %取得壓縮
    global QV;
    QV = get(handles.edit3,'String');
    QV=str2double(QV);

    %取得n*n
    global n;
    n=get(handles.edit1,'String');
    n=str2double(n);

    %取得要藏在哪個channel
    global channel;
    channel= get(handles.edit4,'String');
    channel=str2double(channel);

    %把所有watermark拼接成新的多小個的finalwatermark
    global swatermark;

    [y,x,z]=size(host);
    swatermark = imresize(watermark,[x/n y/n]);
    rowwatermark=[];

    global finalwatermark;
    finalwatermark=[];

    for m=1:1:n
    rowwatermark = cat(2,rowwatermark,swatermark);
    end
    for m=1:1:n
    finalwatermark = cat(1,finalwatermark,rowwatermark);
    end
    axes(handles.axes2);
    imshow(finalwatermark);

    %解決小數點問題
    [p,o,h]=size(finalwatermark);
    global imghost;
    imghost=imresize(host,[p,o]);

    %把watermark藏入host
    watermarkR=im2bw(finalwatermark(:,:,1));
    watermarkG=im2bw(finalwatermark(:,:,2));
    watermarkB=im2bw(finalwatermark(:,:,3));

    hided_img=imghost;

    for i = 1:y
        for j = 1:x
            %define host RGB
            hostR=dec2bin(imghost(i,j,1),8);
            hostG=dec2bin(imghost(i,j,2),8);
            hostB=dec2bin(imghost(i,j,3),8);


            %hide watermark in host in channel
            hostR(channel)=num2str(watermarkR(i,j));
            hostG(channel)=num2str(watermarkG(i,j));
            hostB(channel)=num2str(watermarkB(i,j));

            %transform hided image back into dec form
            hided_img(i,j,1)=bin2dec(hostR);
            hided_img(i,j,2)=bin2dec(hostG);
            hided_img(i,j,3)=bin2dec(hostB);
        end
    end

    imwrite(hided_img,'hided_img.jpg','jpg','Quality',QV);
    global compress;
    compress=imread('hided_img.jpg');
    axes(handles.axes3);
    imshow(compress);


    function edit3_Callback(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit3 as text
    %        str2double(get(hObject,'String')) returns contents of edit3 as a double


    % --- Executes during object creation, after setting all properties.
    function edit3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



    function edit4_Callback(hObject, eventdata, handles)
    % hObject    handle to edit4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit4 as text
    %        str2double(get(hObject,'String')) returns contents of edit4 as a double


    % --- Executes during object creation, after setting all properties.
    function edit4_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


    % --- Executes on button press in pushbutton6.
    function pushbutton6_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global channel;
    global compress;
    global imghost;

    [y,x,z]=size(imghost);

    compressR=compress(:,:,1);
    compressG=compress(:,:,2);
    compressB=compress(:,:,3);

    %定義extractR存取等等取出的watermark
    extractR = zeros(y,x);
    extractG = zeros(y,x);
    extractB = zeros(y,x);

    for i = 1:y
        for j = 1:x
            %先用compressbitR去存取compressR轉成binary的形式
            compressbitR=dec2bin(compressR(i,j),8);
            compressbitG=dec2bin(compressR(i,j),8);
            compressbitB=dec2bin(compressR(i,j),8);

            %把watermark從channel取出放入extractR
            extractR(i,j)=str2double(compressbitR(channel));
            extractG(i,j)=str2double(compressbitG(channel));
            extractB(i,j)=str2double(compressbitB(channel));        
        end
    end
    
    global extwatermark;
    
    skip=1;
    if skip>1
    extwatermark=imresize(extwatermark,[y,x]);
    end
    skip=skip+1;
    
    extwatermark(:,:,1)= extractR;
    extwatermark(:,:,2)= extractG;
    extwatermark(:,:,3)= extractB;

    %extwatermark=uint8(extwatermark);
    axes(handles.axes4);
    imshow(extwatermark);



    % --- Executes on button press in pushbutton7.
    function pushbutton7_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton7 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global compress;
    global extwatermark;
    global n;
    global swatermark;
    global host;
    global finalwatermark;
    global imghost;

    [y,x,z]=size(imghost);
    extwatermark=imresize(extwatermark,[y,x]);

    psnrnum=[];
    axiscount=1:1:n*n;

    pixelcountx=round(x/n);
    pixelcounty=round(y/n);

    pixelleftx=1;
    pixelrightx=pixelcountx;

    pixelupy=1;
    pixeldowny=pixelcounty;

    bwswatermark=im2bw(swatermark);
    for i=1:n
        for j=1:n
            clear smallwatermark;
            smallwatermark=[];
            smallwatermark=extwatermark(pixelupy:pixeldowny,pixelleftx:pixelrightx,:);
            smallwatermark=im2bw(smallwatermark);
            psnrnum=[psnrnum,psnr(double(smallwatermark),double(bwswatermark))];
            if (pixelrightx<200)
            pixelleftx=pixelrightx+1;
            pixelrightx=pixelrightx+pixelcountx;
            end
        end    
        pixelleftx=1;
        pixelrightx=pixelcountx;
        pixelupy=pixeldowny+1;
        pixeldowny=pixeldowny+pixelcounty;
    end
    axes(handles.axes5);
    plot(axiscount,psnrnum);
    legend('PSNR');
    bar(psnrnum);



    %計算energy
    energy=[];

    pixelleftx=1;
    pixelrightx=pixelcountx;

    pixelupy=1;
    pixeldowny=pixelcounty;

    pixelsum=round(x/n)*round(y/n);

    [m,p,o]=size(finalwatermark);
    imghost=imresize(host,[m,p]);

    b=rgb2gray(imghost);
    [Gmag,Gdir] = imgradient(b,'prewitt');

    for i=1:n
        for j=1:n
            smallgmag=[];
            smallgmag=Gmag(pixelupy:pixeldowny,pixelleftx:pixelrightx,:);

            sum=0;
            for k=1:pixelcounty
                 for l=1:pixelcountx
                     sum=sum+smallgmag(k,l);
                 end 
            end
            energy=[energy,sum/pixelsum];
            sum=0;
            if (pixelrightx<200)
            pixelleftx=pixelrightx+1;
            pixelrightx=pixelrightx+pixelcountx;
            end
        end
        pixelleftx=1;
        pixelrightx=pixelcountx;
        pixelupy=pixeldowny+1;
        pixeldowny=pixeldowny+pixelcounty;
    end

    %normalize psnr 
    psnrmax=-100;
    for i=1:n*n
        if psnrnum(i)>psnrmax
        psnrmax=psnrnum(i);
        end
    end
    for i=1:n*n
        psnrnum(i)=psnrnum(i)./psnrmax;
    end

    %normalize energy
    energymax=-100;
    for i=1:n*n
        if energy(i)>energymax
        energymax=energy(i);
        end
    end
    for i=1:n*n
        energy(i)=energy(i)./energymax;
    end

    %plot psnr and energy
    axes(handles.axes6);
    plot(axiscount,psnrnum,axiscount,energy);
    legend('PSNR','ENERGY');
    
    clear extwatermark;
    clear imghost;
