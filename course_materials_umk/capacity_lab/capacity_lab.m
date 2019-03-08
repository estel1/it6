% Lab: channel capacity estimation for QAM constellation 
% http://rf-lab.github.io, http://mgupi.ru, KB-3:Modeling and simulation
% 
clc ;
clear ;

[x,y]           = meshgrid([-3 -1 1 3],[-3 -1 1 3]) ;
x               = complex(x(:),y(:)) ;
clear y
figure(1), plot( x,'b+','LineWidth',8 ), grid on, set(gca, 'FontSize', 14 ), title('Tx symbols')

px              = ones(size(x))/length(x) ;

gauss           = @(x,mx,sx) exp( -((x-mx).*conj(x-mx))/(2*sx*sx) )/(sx*sx*2*pi) ;

C = [] ;
snrValues = -10:19 ;
for snrDb = snrValues
    se          = (10^( -snrDb/20 )) * sqrt(var(x)/2) ; %snrDb = 20*log10(std(x)/std(e))
    intLim = 3+4*se ;
    I1          = 0 ;
    I2          = 0 ;
    for m=1:length(x)
        fun1    = @(re_y,im_y) gauss(complex(re_y,im_y),x(m),se)*px(m).*log2(gauss(complex(re_y,im_y),x(m),se)) ;
        fun2p   = @(re_y,im_y) fun2(complex(re_y,im_y),x,se,m,px,gauss) ;
        I1      = I1 + integral2(fun1,  -intLim, intLim, -intLim,intLim ) ;
        I2      = I2 + integral2(fun2p, -intLim, intLim, -intLim,intLim ) ;
    end
    C(end+1) = I1 - I2 ;
end

figure(2), hold off, plot(snrValues,C,'b-','LineWidth',1.5)
hold on,    plot( snrValues, log2(1+10.^(snrValues/10)), 'r-','LineWidth',1.5 ) 
grid on, set(gca,'FontSize',14)
legend('16QAM','log_2(1+SNR)') ;
title('AWGN capacity')
ylabel('bit/s/Hz')
xlabel('SNR, dB')