function X = hw1622_double_fourier(x)
N = numel(x) ;
x_odd = x(1:2:end) ;
x_even = x(2:2:end) ;
X_ODD = fft(x_odd) ;
X_EVEN = fft(x_even) ;
W = exp(-1j*2*pi/N*(0:N-1)) ;
X = [X_ODD(:);X_ODD(:)]+[X_EVEN(:);X_EVEN(:)].*W(:) ;