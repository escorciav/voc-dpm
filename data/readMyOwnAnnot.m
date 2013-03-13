function annot = readMyOwnAnnot(imgpath,dsname)
% Read the annotation file associated with an image and create an strcuture
% with VOC format.
%   annot = readMyOwnAnnot('~/data/1.jpg','CVPRdata');
% ARGUMENTS
% imgpath     -     image full path
% dsname      -     Extra argument to put database name in annotation structure
% ! Developer: Victor Escorcia !
% ! Revision: 1.0.0 !

% This file could be modify any field in the annotation structure
annot=struct('filename',[],'folder',[],'object',[],'segmented',[],'size',[],'source',[]);
annot.source = struct('annotation',dsname,'database',['The ' dsname ' Database'],'image',[dsname ' Dataset']);
annot.segmented = 0;

infoimg = imfinfo(imgpath);
[Ipath fileRoot ext] = fileparts(imgpath);
annot.filename = [fileRoot ext];
annot.size.width = infoimg.Width;
annot.size.height = infoimg.Height;
annot.size.depth = infoimg.NumberOfSamples;

% The following lines are format dependend
idx_backslash = strfind(Ipath,'/');
Dpath = Ipath(1:idx_backslash(end));
[former latter] = strtok(fileRoot,'_');
latter = str2num(latter(2:end));
myannot = load([Dpath 'annotations/' former '.mat']);
for i = 1:numel(myannot.vid.rec)
  annot.object(i,1).name      = myannot.vid.rec(i).class;
  annot.object(i,1).difficult = 0;
  annot.object(i,1).pose      = 'Unspecified';
  annot.object(i,1).occluded  = 0;
  annot.object(i,1).truncated = 0;
  annot.object(i,1).bndbox    = struct('xmin',myannot.vid.rec(i).loc(1,myannot.vid.rec(i).id==latter), ...
                                       'ymin',myannot.vid.rec(i).loc(2,myannot.vid.rec(i).id==latter), ...
                                       'xmax',myannot.vid.rec(i).loc(3,myannot.vid.rec(i).id==latter), ...
                                       'ymax',myannot.vid.rec(i).loc(4,myannot.vid.rec(i).id==latter));
end
end