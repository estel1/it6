function coolview(varargin)
    if nargin==0        
        fprintf('coolview usage:\n coolview(signal)\n coolview(signal,wndsize)\n') ;
    elseif nargin==1
        if varargin{1}==123456
            OnLeftClick() ;
        else
            main(varargin{1},256) ;
        end
    elseif nargin==2
            main(varargin{1},varargin{2}) ;
    else
        printf('coolview usage: system_gen()\n') ;
    end
end

function main(x,wndsize)
    fig = figure(1) ;
    set(fig,'Name','CoolView') ;
    set(fig,'NumberTitle','off') ;
    clf ;
    figPos = get(fig,'Position') ;
    figPos(1) = 200 ;
    figPos(2) = 200 ;
    figPos(3) = 1000 ;
    figPos(4) = 600 ;
    set(fig,'Position',figPos) ;    
    
    obj.timeplot = axes() ;
    set(obj.timeplot,'Position',[0.03,0.52,0.93,0.45]) ;
    plot(0:length(x)-1,x,'Color',[0.7 0.7 1],'HitTest','off'); grid on ;
    xlim([0 length(x)-1]) ;
    obj.freqplot = axes() ;
    set(obj.freqplot,'Position',[0.03,0.03,0.93,0.45]) ;
    obj.data = x ;
    obj.Fd = 8000 ;
    obj.W = wndsize ;
    obj.cursor = -1 ;
    set(gcf,'UserData',obj) ;
    set(obj.timeplot,'ButtonDownFcn','coolview(123456)') ;
    set_cursor(obj.W+1) ;
end

function OnLeftClick()
    obj = get(gcf,'UserData') ;
    cp = get(obj.timeplot,'CurrentPoint') ;
    new_pos = round(cp(1,1)) ;
    set_cursor(new_pos) ;
end

function set_cursor(cursor)
    obj = get(gcf,'UserData') ;
    axes(obj.timeplot) ; hold on ; 
    if cursor>10
        if obj.cursor>=0
            line([obj.cursor obj.cursor],[-1 1],'LineStyle','-','Color',[0.1 0.1 0.1],'LineWidth',2,'EraseMode','Xor','HitTest','off') ;
            leftt = max(obj.cursor-obj.W/2,1) ;
            rightt = min(obj.cursor+obj.W/2,length(obj.data)) ;
            rectangle('Position',[leftt,-1,rightt-leftt,2],'FaceColor',[0.9 .5 .5],...
            'EraseMode','Xor','HitTest','off') ;
        end
        obj.cursor = cursor ;
        line([obj.cursor obj.cursor],[-1 1],'LineStyle','-','Color',[0.1 0.1 0.1],'LineWidth',2,'EraseMode','Xor','HitTest','off') ;        
        leftt = max(obj.cursor-obj.W/2,1) ;
        rightt = min(obj.cursor+obj.W/2,length(obj.data)) ;
        rectangle('Position',[leftt,-1,rightt-leftt,2],'FaceColor',[0.9 .5 .5],...
        'EraseMode','Xor','HitTest','off') ;
    end
    
    xw = obj.data(leftt:rightt-1).*hamming(rightt-leftt) ;
    XW = fft(xw) ;
    freqr = (0:rightt-leftt-1)/(rightt-leftt)*obj.Fd ;
    axes(obj.freqplot); plot(freqr,XW.*conj(XW),'LineWidth',2,'Color',[0.8 0 0.3]), grid on ;
    set(gcf,'UserData',obj) ;
end

