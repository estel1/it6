clc ;
clear all ;
N = 64 ;
argrange = 0:N-1 ;
shift = 0.5 ;
%x = argrange ;
x = cos(2*pi/N*argrange)+0.3*sin(2*pi/N*3*argrange+0.6) ;
X = fft(x) ;
phaserange = [0:N/2,-N/2+1:-1] ;
phasor1 = exp(1j*2*pi/N*(argrange)*shift) ;
phasor2 = exp(1j*2*pi/N*(phaserange)*shift) ;
%hold off, plot(imag(phasor1),'LineWidth',2) ;
%hold on, plot(imag(phasor2),'r-','LineWidth',2) ;
Y = X.*phasor2 ;
%[X.',Y.']
y = ifft(Y) ;
hold off, plot(x,'b-','LineWidth',2) ;
hold on, plot(real(y),'r-','LineWidth',1) ;
grid on ;

