function dataset2VOC(dataset,directory,conf)
% Make a copy of dataset with the VOC tree. 
%   dataset2VOC('~/MyDataset','~/MyDataset');
%
% The VOC tree has the following structure
% VOCdevkit
%   VOCXXXX
%     Annotations
%     JPEGImages
%     ImageSets
%       Main
%
% The ImageSets and Main folder are created by this function but not
% filled.
%
% ARGUMENTS
%   dataset       full path with images and annotations to copy e.g. /tmp
%   directory     full path to allocate the copy e.g. /tmp
%   conf          structure with parameters
%     ext         image extension. ['.jpg']
%     action      move (mv) or copy (cp) the images. ['cp']
%     func        handle function to read annotations. [@readMyOwnAnnot]
%     folder      string with folder name inside dataset where are allocated
%                 the images e.g. 'images/1'. If empty find for all images in dataset. []
%     year        replace XXXX. ['2013']
%     dsname      dataset name e.g. 'Coffee and Cigarettes'. []
%     
% REQUIEREMENTS
%   Piotr toolbox     -   getPrmDflt
%   Pascal VOC        -   VOCwritexml   (added in my github voc-dpm version)

% AUTORIGHTS
% -------------------------------------------------------
% Copyright (C) 2013 Victor Escorcia
% 
% This file is part of the voc-dpm code
% https://github.com/escorciav/voc-dpm.git
% and is available under the terms of an MIT-like license
% provided in COPYING. Please retain this notice and
% COPYING if you use this file (or a portion of it) in
% your project.
% -------------------------------------------------------

% format e.g. PAMI2009

dflt = {'action','cp','ext','.jpg','func',@readMyOwnAnnot,'folder',[],'year','2013','dsname',[]};
conf = getPrmDflt(conf,dflt);

createVOCfolder([directory '/VOCdevkit'],conf.year);
imgspath = getAllEXTFiles(dataset,conf.ext,conf.folder);
for i = 1:numel(imgspath)
  [dummy fileRoot dummy] = fileparts(imgspath{i});
  voc.annotation = feval(conf.func,imgspath{i},conf.dsname);
  voc.annotation.folder=['VOC' conf.year];
  VOCwritexml(voc,[directory '/VOCdevkit/VOC' conf.year '/Annotations/' fileRoot '.xml']);
  [rst,stat] = unix([conf.action ' ' imgspath{i} ' ' directory '/VOCdevkit/VOC' conf.year '/JPEGImages/' fileRoot conf.ext]);
end

end

function createVOCfolder(folder,year)
% Create VOC tree and remove if exist
if exist(folder,'dir'),
  [rst,stat] = unix(['rm -rf ' folder]);
end
[rst,stat] = unix(['mkdir ' folder]);
[rst,stat] = unix(['mkdir ' folder '/VOC' year]);
[rst,stat] = unix(['mkdir ' folder '/VOC' year '/Annotations']);
[rst,stat] = unix(['mkdir ' folder '/VOC' year '/JPEGImages']);
[rst,stat] = unix(['mkdir ' folder '/VOC' year '/ImageSets']);
[rst,stat] = unix(['mkdir ' folder '/VOC' year '/ImageSets/Main']);
end