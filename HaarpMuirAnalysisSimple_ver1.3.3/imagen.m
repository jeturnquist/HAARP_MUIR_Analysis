function h = imagesc(varargin)
%IMAGESC Scale data and display as image.
%   IMAGESC(...) is the same as IMAGE(...) except the data is scaled
%   to use the full colormap.
%   
%   IMAGESC(...,CLIM) where CLIM = [CLOW CHIGH] can specify the
%   scaling.
%
%   See also IMAGE, COLORBAR.

%   Copyright (c) 1984-97 by The MathWorks, Inc.
%   $Revision: 5.5 $  $Date: 1997/04/08 06:46:22 $

clim = [];
if nargin == 0,
  hh = image('CDataMapping','scaled');
elseif nargin == 1,
  hh = image(varargin{1},'CDataMapping','scaled');
elseif nargin > 1,

  % Determine if last input is clim
  if isequal(size(varargin{end}),[1 2])
    for i=length(varargin):-1:1,
      str(i) = isstr(varargin{i});
    end
    str = find(str);
    if isempty(str) | (rem(length(varargin)-min(str),2)==0), 
       clim = varargin{end};
       varargin(end) = []; % Remove last cell
    else
       clim = [];
    end
  else
     clim = [];
  end
  hh = image(varargin{:},'CDataMapping','scaled');
end

if ~isempty(clim),
  set(gca,'CLim',clim)
elseif ~ishold,
  set(gca,'CLimMode','auto')
end

if nargout > 0
    h = hh;
end

set(gca,'yDir','normal')
