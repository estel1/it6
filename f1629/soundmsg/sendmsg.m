function sendmsg()
    clc ;
    exit_req = 0 ;
    fprintf('Press Ctrl+C to Quit, other key - to send message.') ;
    while ~exit_req    
        pause ;
        send_sound_message('10101111101011111010111110101111') ;
    end
end

function send_sound_message(msg)
    fs = 1750 ;
    fd = 8000 ;
    bit_samples = 40 ; % 20 bit/s
    s = zeros(length(msg)*bit_samples,1) ;
    for n=1:length(msg)
        if msg(n)=='1'
            s((n-1)*bit_samples+1:n*bit_samples) = cos(2*pi*(fs-100)/fd*(0:bit_samples-1)) ;
        else
            s((n-1)*bit_samples+1:n*bit_samples) = cos(2*pi*(fs+100)/fd*(0:bit_samples-1)) ;
        end
    end
    sound(s,fd) ;
end
