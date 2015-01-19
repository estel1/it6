function sendmsg2()
    clc ;
    for n=1:100    
        send_sound_message('101010101010101110101111101011111010111110101111101011111010111110101111101011111010') ;
    end
end

function send_sound_message(msg)
    fd = 8000 ;
    s=get_sound_message(msg) ;
    sound(s,fd) ;
end

function s = get_sound_message(msg)
    fs = 1000 ;
    fd = 8000 ;
    bit_samples = 120 ; % 66.(6) bit/s
    s = zeros(length(msg)*bit_samples,1) ;
    phase = 0 ;
    for n=1:length(s)
        s(n) = cos(phase) ;
        if msg(fix((n-1)/bit_samples)+1)=='1'
            phase = phase + 2*pi*(fs-200)/fd ;
        else
            phase = phase + 2*pi*(fs+200)/fd ;
        end
    end
    %s = [randn(1000,1);s] ;
    %s = randn(10000,1) ;
    %sound(s,fd) ;
end