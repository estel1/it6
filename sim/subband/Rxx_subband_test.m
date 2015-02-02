clc, clear all;

N = 128; % 1 ìñ
K = 50 ;
Fs = 128E3; % Ãö
F = 53E3; % Ãö
%X = sin(2*pi*F/Fs*(0:N-1))' + 0.3*randn(N, 1);
X = sin(2*pi*F/Fs*(0:N-1)).'+sin(2*pi*5E3/Fs*(0:N-1))';

w1 = -pi/6;
w2 = pi/6;

R = zeros(K, 1) ;
R1 = zeros(K, 1) ;
R2 = zeros(K, 1) ;

for i = 0:K-1
    R(i + 1) = Rxx_sb(X, N, w1, w2, i*1/Fs);
    R1(i+1) = X(:).'*circshift(conj(X(:)),i) ;
end

F = zeros(N,N) ;
for tau=1:K
    for n=1:N
        for k=1:N
            kn = k-n ;
            kntau = k-n+(tau-1) ;
            if kntau==0
                F(n,k) = 1 ;
            else
                F(n,k) = -1j/kntau*(exp(1j*w2*kntau)-exp(1j*w1*kntau)) ;
            end
            R2(tau) = R2(tau) + X(n)*conj(X(k))*F(n,k) ;
        end
    end
end

figure(1) ;
hold off, plot(real(R(1:K)),'m-','LineWidth',2) ;
hold on, plot(real(R1(1:K)),'r-','LineWidth',2)
hold on, plot(real(R2(1:K)),'b-.','LineWidth',2)
grid on;

figure(2) ;
plot((F(:,[1,64,128]))) ;
