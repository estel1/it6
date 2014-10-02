function soundchecker()
    clc, clear all ;
    if 0    
        audio_dev = audiorecorder(8000,8,1) ;
        recordblocking(audio_dev, 5) ;
        rxbuf = getaudiodata(audio_dev) ;
    else
        rxbuf = get_sound_message('10101010101011100001010101010101110000') ;
        rxbuf = [randn(1200,1);rxbuf;randn(1000,1);] ;
        %rxbuf = rxbuf+randn(size(rxbuf))*0.4 ;
        load sound3_300 ;
        
        bph = fir2(128,[0 1700/4000 1800/4000 4000/4000],[ 0.5 0.5 3 3]) ;
        rxbuf = filter(bph,1,rxbuf) ;
        %rxbuf = rxbuf(3500:7500) ;
    end
    t = 0 ;
    while t<length(rxbuf)-2500
        [status, bits] = demod_fsk(rxbuf(1+t:t+2500)) ;
        t = t + 2500 ;
        if status==1
            if ~isempty(strfind(bits(:)','10101010'))
                fprintf('Message received!\n') ;
            end
        end
    end
end

function [status, bits] = demod_fsk(rxbuf)
    bit_samples = 100 ; % 80 bit/s
    %demodulate FSK signal
    N = length(rxbuf) ;
    r = zeros(N,1) ;
    for k=3:1:N
        r(k) = rxbuf(k)*(0.9420*rxbuf(k-1) + 0.1989*rxbuf(k-2)) ;
    end
    bph = fir2(128,[0 300/4000 400/4000 4000/4000],[ 1 1 0 0]) ;
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
        %subplot(211), 
        hold off, plot(rxbuf,'Color',[0.8 0.8 1]), grid on ;
        %subplot(212), 
        hold on, plot(r0), grid on, hold on, plot(rc,'r-')
    else
        status = 0 ;
        bits = '' ;
    end
end

function s = get_sound_message(msg)
    fs = 1750 ;
    fd = 8000 ;
    bit_samples = 100 ; % 20 bit/s
    s = zeros(length(msg)*bit_samples,1) ;
    phase = 0 ;
    for n=1:length(s)
        if msg(fix((n-1)/bit_samples)+1)=='1'
            s(n) = cos(phase) ;
            phase = phase + 2*pi*(fs-100)/fd ;
        else
            s(n) = cos(phase) ;
            phase = phase + 2*pi*(fs+100)/fd ;
        end
    end
    %s = [randn(1000,1);s] ;
    %s = randn(10000,1) ;
    %sound(s,fd) ;
end

