function writeImageJRoi1(pathname,filename,varargin)
%WRITEIMAGEJROI(fileName, roiType, x, y)  -- writes ImageJ ROI files given coordinates and ROI type
%    INPUT: e.x. pathname='G:\segdata\abnormal\roi_free'
                 %filename='roi_1'
% roiType  -- type of ROI according to ImageJ specifications
%             + Use roiType = 'PolyLine' for splines
% edge  (cell set contain the edge points' coordinate 
%
% Copyright: Dmytro Lituiev 2014
% BSD Licence
if ~exist(strcat(pathname,'\',filename),'dir') 
    mkdir(strcat(pathname,'\',filename));
end
[roiType, boardset] = varargin{1:2};
for i=1:length(boardset)
    fpath=strcat(pathname,'\',filename,'\roi',int2str(i),'.roi');
    x=boardset{i}(:,2);
    y=boardset{i}(:,1);
    if numel(x)~=numel(y)
       error('writeImageJRoi:dimMismatch', 'dimension mismatch')
    end
        
     % ['nTop', 'nLeft', 'nBottom', 'nRight']
     ROI.vnRectBounds = [ min(y), min(x), max(y), max(x)];
     ROI.x0 = x(:);
     ROI.y0 = y(:);
    
     ROI.nNumCoords = numel(x);  %坐标点的数量
        
     roiTypeStr = { 0, 'Polygon','';  ...
         3,  'Line','';...
         4,  'FreeLine', ''; ...
         5,  'PolyLine','';...
         6,  'NoROI', '';...
         7,  'Freehand', 'Ellipse'; ...
         8,  'Traced','';...
         9,  'Angle', '';
         10, 'Point',''};

     if ~any(strcmpi(roiType, roiTypeStr(:, 2:end)))
          error('writeImageJRoi:unknownroiType', 'unknown roiType')
     end
     sROI.nroiTypeID  = roiTypeStr{any(strcmpi(roiType, roiTypeStr(:, 2:end)), 2), 1};
     sROI.nVersion = 223;
%% writing per se
     fidROI = fopen(fpath, 'w', 'ieee-be');

     fwrite(fidROI, zeros(256,1) , 'uint8');

     frewind(fidROI)

     count = 0;
     count = count + fwrite(fidROI, 'Iout');
     count = count + fwrite(fidROI, sROI.nVersion , 'int16');

% -- Write ROI roiType
    count = count + fwrite(fidROI, sROI.nroiTypeID, 'uint8');
    fwrite(fidROI, 0, 'uint8'); % Skip a byte
    count = count + 1;

% -- Write rectangular bounds
    count = count + fwrite(fidROI, ROI.vnRectBounds, 'int16');
% -- Write number of coordinates
    count = count + fwrite(fidROI, ROI.nNumCoords, 'int16');

% vfLinePoints = zeros(1,4);

% -- Write something (?)
    fseek(fidROI, 63, 'bof');
    count = count + fwrite(fidROI,  6*16^3, 'int16');

% -- Go after header
   fseek(fidROI, 64, 'bof'); count = 64;
   
   tmpx=ROI.x0 - ROI.vnRectBounds(2);
   tmpy=ROI.y0 - ROI.vnRectBounds(1);
   
   [wx,wy]=ClockwiseSortPoints(tmpx,tmpy);
   
   count = count + fwrite(fidROI, wx, 'int16');
   count = count + fwrite(fidROI, wy, 'int16');
   
%       count = count + fwrite(fidROI, tmpx, 'int16');
%    count = count + fwrite(fidROI, tmpy, 'int16');

   status = fclose(fidROI);
end
zip(strcat(pathname,'\',filename,'.zip'),strcat(pathname,'\',filename));
rmdir(strcat(pathname,'\',filename,'\'),'s');
end