function extpath = getAllEXTFiles(folder,ext,subfolder)
% Get all files.ext in folder. If subfolder is added the function only
% returns ext files inside subfolder.
%   getAllEXTFiles('/tmp','.png');
%
% ARGUMENTS
%   folder        full path to search ext files
%   subfolder     specific subfolder inside folder to search ext files e.g. sub1/sub2
%   ext           file extension e.g. '.jpg'
%     

% AUTORIGHTS% REQUIEREMENTS
%   Piotr toolbox     -   getPrmDflt
%   Pascal VOC        -   VOCwritexml   (added in my github voc-dpm version)
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

extpath = [];
if exist(folder,'dir')
  if nargin > 2 && exist([folder '/' subfolder],'dir') && ~isempty(subfolder)
    subfolder = ['/' subfolder '/'];
    extpath = dir([folder subfolder '*' ext]);
    extpath = arrayfun(@(x) [folder subfolder x.name],extpath,'UniformOutput',0);
  else
    folder = genpath(folder);
    idx = [0 strfind(folder,':')];
    for i =1:numel(idx)-1
      extpatht = dir([folder(idx(i)+1:idx(i+1)-1) '/*' ext]);
      extpatht = arrayfun(@(x) [folder(idx(i)+1:idx(i+1)-1) '/' x.name],extpatht,'UniformOutput',0);
      extpath = [extpath;extpatht];
    end
  end
end
end