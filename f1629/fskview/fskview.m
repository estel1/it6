function fskview(varargin)
    if nargin==0        
        fprintf('fskview usage:\n fskview(signal)\n') ;
    elseif nargin==1
        if varargin{1}==123456
            OnLeftClick() ;
        else
            main(varargin{1},2048) ;
        end
    elseif nargin==2
            main(varargin{1},varargin{2}) ;
    else
        fprintf('fskview usage:\n fskview(signal)\n') ;
    end
end

function main(x,wndsize)
    fig = figure(1) ;
    set(fig,'Name','FskView') ;
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
    % input equalization
    eqh = fir2(128,[0 1700/4000 1800/4000 4000/4000],[ 0.5 0.5 3 3]) ;
    obj.data = filter(eqh,1,x) ;
    obj.Fd = 8000 ;
    obj.W = wndsize ;
    obj.cursor = -1 ;
    set(gcf,'UserData',obj) ;
    set(obj.timeplot,'ButtonDownFcn','fskview(123456)') ;
    %set(gcf,'WindowButtonMotionFcn','fskview(123456)') ;
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
    
    xw = obj.data(leftt:rightt-1) ;
    axes(obj.freqplot) ; [status, bits]=demod_fsk(xw) ;
    if status==1
        fprintf('Recv.msg.:%s\n',bits) ;
        set(gcf,'Name',sprintf('FskView: %s',bits)) ;
    else
        set(gcf,'Name','FskView: -no msgs.') ;
    end
    set(gcf,'UserData',obj) ;
end

function [status, bits] = demod_fsk(rxbuf)
    bit_samples = 100 ; % 80 bit/s
    %demodulate FSK signal
    N = length(rxbuf) ;
    r = zeros(N,1) ;
    for k=3:1:N
        r(k) = rxbuf(k)*(0.9420*rxbuf(k-1) + 0.1989*rxbuf(k-2)) ;
    end
    bph = fir2(128,[0 400/4000 500/4000 4000/4000],[ 1 1 0 0]) ;
    r0 = 10*filter(bph,1,r) ;
    %r0(1:64) = 0 ;
    %r0 = r0(64:end) ;
    bit_bounds = zeros(bit_samples,1) ;
    last_check_point = 1 ;
    mesh_count = 0 ;
    data_offset = 0 ;
    for n=1:length(r0)-10
        if r0(n)*r0(n+1)<0 && r0(n)*r0(n+2)<0 && r0(n)*r0(n+3)<0
            bit_bounds(mod(n-1,bit_samples)+1) = bit_bounds(mod(n-1,bit_samples)+1)+1 ;
            mesh_count = mesh_count + 1 ;
            if mesh_count>5
                if (n-last_check_point)<bit_samples
                    fprintf('#%05d: reset bit boundary scan procedure.\n', n) ;
                    bit_bounds = zeros(bit_samples,1) ;
                    data_offset = (fix(n/bit_samples)+1)*bit_samples ;
                end
                mesh_count = 0 ;
                last_check_point = n ;
            end
        end
    end
    if sum(bit_bounds)>5
        bit_bounds = bit_bounds/sum(bit_bounds) ;
        [Pb,bit_shift] = max(bit_bounds) ;
    else
        Pb = 0 ;
        bit_shift = 0 ;
    end
    fprintf('Pb %f\n',Pb) ;
    if Pb>0
        status = 1 ;
        rc = r0 ;
        rc(1:data_offset) = 0 ;
        num_bits = fix((length(r0)-data_offset-bit_shift)/bit_samples) ;
        bits = repmat('x',1,num_bits) ;
        d0 = 5 ;
        for k=1:num_bits
            symbol = mean(r0(data_offset+bit_shift+(k-1)*bit_samples+1+d0:data_offset+bit_shift+k*bit_samples-d0)) ;
            rc(data_offset+bit_shift+(k-1)*bit_samples+1:data_offset+bit_shift+k*bit_samples) = symbol ;
            if symbol>0
                bits(k) = '0' ;
            else
                bits(k) = '1' ;
            end
        end
        hold off, plot(rxbuf,'Color',[0.8 0.8 1]), grid on ;
        hold on, plot(r0), grid on, hold on, plot(rc,'r-') ;
        %xlim([1 length(rxbuf)]) ;
    else
        status = 0 ;
        bits = '' ;
    end
end


