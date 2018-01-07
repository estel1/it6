omega_d = 2*pi ;
omega = 1 ;
Omega = 1 ;

gamma = Omega/tan(pi*omega/omega_d) ;

gamma2 = gamma*gamma ;
A = gamma2 -gamma*sqrt(2) + 1 ;
B = 2 -2*gamma2 ;
C = gamma2 + sqrt(2)*gamma + 1 ;

[Hs,ws] = freqs(1,[1 sqrt(2) 1],100) ;
[Hz,wz] = freqz([1 2 1],[C B A],100) ;

hold off,
plot(ws, ( Hs.*conj(Hs)),'LineWidth', 1.5)
hold on,
plot(wz/pi*omega_d/2,(Hz.*conj(Hz)),'LineWidth', 1.5)
grid on ;
set(gca,'FontSize',14) ;
xlabel('Frequency, rad/s');
ylabel('|H(s)|^2') ;
legend('|H(s)|^2','|H(z)|^2')
