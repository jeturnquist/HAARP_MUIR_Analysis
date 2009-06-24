function samexaxis_modified(varargin)
%% helper function to clean up subplots that have common x axises
%
% USAGE: samexaxis([optionalarguments])
% 
% Optional arguments:
%   * YAxisLocation (default='left') : choose left,right, alternate or alternate2
%   * XAxisLocation (default='bottom') : choose bottom,top or both
%   * YLabelDistance (default=1.4)  
%   * Box (default='on')
%   * XTick
%   * XLim
%   * XTickLabel
%   * XMinorTick
%   * ABC : add a),b),c), ... to each sub plot
%   * Join: joins the subplots vertically
%   * YTickAntiClash: try to aviod yticklabel clashes (default=false)
%
%
% Example:
%   subplot(3,1,1); plot(randn(100,1),randn(100,1),'x'); ylabel('QF')
%   subplot(3,1,2); plot([-1 0 .5 1],[0 100 100 10],'x-'); ylabel('HT');
%   subplot(3,1,3); plot(randn(100,1),randn(100,1)*33,'x'); ylabel('DV');
%   samexaxis('abc','xmt','on','ytac','join','yld',1)
%
% ---
% (c) Aslak Grinsted 2005
%



Args=struct('YAxisLocation','left','XAxisLocation','bottom','Box','on','XLim',[],'XTick',[],'XTickLabel',[],'XMinorTick',[],'YLabelDistance',1.4,'ABC',false,'Join',false,'YTickAntiClash',false); 
Args=parseArgs(varargin,Args,{'abc' 'join' 'ytickanticlash'});



%--------------- Get all axis handles (that are not legends) ----------------
f=gcf;
ax=get(f,'children');

for ii=length(ax):-1:1
    if (~strcmpi(get(ax(ii),'type'),'axes'))|(strcmpi(get(ax(ii),'tag'),'legend'))
        ax(ii)=[];
    end
end
if numel(ax)<2
    error('samexaxis works on figures with more than one axis')
end

%---------------- apply xtick,xticklabel&xminortick ----------------
if ~isempty(Args.XTick)
    set(ax,'xtick',Args.XTick);
end
if ~isempty(Args.XTickLabel)
    set(ax,'xticklabel',Args.XTickLabel);
end
if ~isempty(Args.XMinorTick)
    set(ax,'xminortick',Args.XMinorTick);
end
if ~isempty(Args.XLim)
    set(ax,'XLim',Args.XLim);
end
set(ax,'box',Args.Box);

%---------------- sort ax by y top pos ------------------
pos=cell2mat(get(ax,'pos'));
num_col = 1;
%%% Seperate out the positions and axis of the subplots in each column
for i = 1:1:num_col
    k = i;
    for j = 1:1:size(ax,1)/num_col
        multi_pos{i}(j,:) = pos(k,:);
        multi_ax{i}(j) = ax(k);
        k = k + num_col;
    end

    ytop=multi_pos{i}(:,2)+multi_pos{i}(:,4);
    [ytop,idx]=sortrows(-ytop);
    multi_ax{i}=multi_ax{i}(idx);
    multi_pos{i}=multi_pos{i}(idx,:);

    if Args.Join
        H=(multi_pos{i}(1,2)+multi_pos{i}(1,4))-multi_pos{i}(end,2); %total height of axes
        Hused=sum(multi_pos{i}(:,4));
        stretch=max(H/Hused,1);
        multi_pos{i}(1,2)=multi_pos{i}(1,2)-multi_pos{i}(1,4)*(stretch-1);
        multi_pos{i}(:,4)=multi_pos{i}(:,4)*stretch;
        set(multi_ax{i},'pos',multi_pos{i}(1,:));
        for ii=2:size(ax,1)/num_col
            multi_pos{i}(ii,2)=multi_pos{i}(ii-1,2)-multi_pos{i}(ii,4);
            set(multi_ax{i}(ii),'pos',multi_pos{i}(ii,:));
        end
    end


%%% Weave seperated data back into the original position and axis varibles
% for i = 1:1:num_col
%     k = i;
%     for j = 1:1:size(ax,1)/num_col
%         pos(k,:) = multi_pos{i}(j,:)
%         ax(k) = multi_ax{i}(j);
%         k = k + num_col;
%     end
% end
%  
% for ii=1:length(ax)
%     set(ax(ii),'pos',pos(ii,:));
% end

if 1
%----------------- Set x&y axis positions ---------------------------
switch lower(Args.YAxisLocation)
    case {'alt' 'alternate' 'alt1' 'alternate1'}
        set(multi_ax{i}(1:2:end),'Yaxislocation','right');
        set(multi_ax{i}(2:2:end),'Yaxislocation','left');        
    case {'alt2' 'alternate2'}
            set(multi_ax{i}(1:2:end),'Yaxislocation','left');
        set(multi_ax{i}(2:2:end),'Yaxislocation','right');
    case {'left' 'right'}
        set(multi_ax{i},'Yaxislocation',Args.YAxisLocation);
    otherwise
        warning('could not recognize YAxisLocation')
end

switch lower(Args.XAxisLocation)
    case 'top'
        set(multi_ax{i}(2:end),'xticklabel',[]);
        set(multi_ax{i}(1),'xaxislocation','top')
    case 'bottom'
        set(multi_ax{i}(1:(end-1)),'xticklabel',[]);
        set(multi_ax{i}(end),'xaxislocation','bottom')
    case 'both'
        set(multi_ax{i}(2:(end-1)),'xticklabel',[]);
        set(multi_ax{i}(end),'xaxislocation','bottom')
        set(multi_ax{i}(1),'xaxislocation','top')
    otherwise
        warning('could not recognize Xaxislocation')
end

%--------------- find common xlim and apply it to all -------------------
xlims=get(multi_ax{i},'xlim');
xlim=[min([xlims{:}]) max([xlims{:}])];
set(multi_ax{i},'xlim',xlim);

%---------make sure that ylabels doesn't jump in and out-----------
ylbl=get(multi_ax{i},'ylabel');
ylbl=[ylbl{:}];
for ii=1:length(ylbl)
    if strcmpi(get(ylbl(ii),'interpreter'),'tex')
        txt=get(ylbl(ii),'string');
        txt=['^{ }' txt '_{ }'];
        set(ylbl(ii),'string',txt);
    end
end
set(ylbl,'units','normalized');
yisleft=strcmpi('left',get(multi_ax{i},'yaxislocation'));


ylblpos=cell2mat(get(ylbl,'pos'));

set(ylbl(yisleft),'pos',[min(ylblpos(yisleft,1))*Args.YLabelDistance 0.5 0],'verticalalignment','bottom');
set(ylbl(~yisleft),'pos',[1+max(ylblpos(~yisleft,1)-1)*Args.YLabelDistance 0.5 0],'verticalalignment','top');

%--------------------- Anti yaxislabel clash: ------------------------------
if (Args.YTickAntiClash)&(length(strmatch(Args.YAxisLocation,{'left' 'right'}))>0)
    for ii=2:length(multi_ax{i})
        if strcmpi(get(multi_ax{i}(ii),'ylimmode'),'auto') %only do it for axes that hasn't manual ylims 
            ytick=get(multi_ax{i}(ii),'ytick');
            ylim=get(multi_ax{i}(ii),'ylim');
            obymax=objbounds(multi_ax{i}(ii));
            obymax=obymax(4);

            dytick=ytick(end)-ytick(end-1);
            if (ylim(end)>(ytick(end)-dytick*.001))
                ylim(end)=ytick(end)-dytick*.00001;
                if ylim(end)<obymax
                    ylim(end)=ytick(end)+dytick*0.49999;
                end
            else
                ylim(end)=ytick(end)+dytick*0.49999;
            end
            set(multi_ax{i}(ii),'ylim',ylim,'xlim',xlim);
        end
    end
end



%---------------- add abc -------------------------
if Args.ABC
    for ii=1:length(multi_ax{i})
        axes(multi_ax{i}(ii))
        text(0,1,[' ' 'a'+ii-1, num2str(num_col - i + 1) ')'],'units','normalized','verticalalignment','top')
    end
end


try
    linkaxes(multi_ax{i},'x');
catch
    warning('linkaxes only works in matlab7+')
end

end %% if 0
end %% for i=1:1:num_col