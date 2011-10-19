function [ber,r] = bpskmod(snr_db)
%clc, clear ;
%snr_db = 0 ;
N = get_num_iter(snr_db) ;
fs = 2000 ;
fd = 16000 ;
b = randi(2,N,1)-1 ;
c = b*2-1 ;
M = 16 ;
x = zeros(M*N,1) ;
cos1 = cos(2*pi*fs/fd*(0:M-1)) ;
for n=1:N
    if b(n)==0
        x((n-1)*M+1:n*M) = -cos1(:) ;
    else
        x((n-1)*M+1:n*M) = cos1(:) ;
    end        
end
% channel model
signoise = 0.5/10^(snr_db/10) ;
noise = randn(size(x))*sqrt(signoise*M/2) ;
y = x + noise ;
% receiver
r = zeros(size(b)) ;
rb = zeros(size(b)) ;
e1 = exp(-1j*2*pi*fs/fd*(0:M-1)) ;
Eb = real(e1)*real(e1)' ;
for n=1:N
    r(n) = e1*y((n-1)*M+1:n*M)/Eb ;
end
fprintf('SNR=%5.2f, QAM-plane snr=%5.2f\n',10^(snr_db/10),1/var(r-c)) ;
%hold off, plot(r,'b.'), ylim([-1.5 1.5]), axis square,grid on, drawnow ;
rb = r>0 ;
ber = nnz(rb-b)/N ;

function N = get_num_iter(snr_db)
if snr_db<=4
    N = 2000 ;
elseif snr_db<=6
    N = 20000 ;
elseif snr_db<=8
    N = 100000 ;
else
    N = 500000 ;
end

