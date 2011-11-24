% function kalman_bucy_model()
clc, clear all ;
Nt = 2000 ;
m = 3 ;
gamma = 2 ;
k = 1 ;
t = 0 ;
h = 0.01 ;
N = 200 ;
M = 0 ;
p11 = zeros(Nt,1) ;
p12 = zeros(Nt,1) ;
p22 = zeros(Nt,1) ;
x1 = zeros(Nt,1) ;
x2 = zeros(Nt,1) ;
u = sin((0:h:h*Nt-h)/4) ;
M = var(u) ;
y = zeros(Nt,1) ;
for n=2:Nt
    x1(n) = x1(n-1) + h*x2(n-1) ;
    x2(n) = x2(n-1) + h*(-k/m*x1(n-1)-gamma/m*x2(n-1)) + u(n-1) ;
    y(n) = x1(n)+randn()*sqrt(N) ;
    
    p11(n) = p11(n-1) + h*(-1/N*p11(n-1)^2+2*p12(n-1)) ;
    p12(n) = p12(n-1) + h*(-k/m*p11(n-1)-gamma/m*p12(n-1)+p22(n-1)-p11(n-1)*p12(n-1)/N) ;
    p22(n) = p22(n-1) + h*(-2*k/m*p12(n-1)-2*gamma/m*p22(n-1)-p12(n-1)^2/N+M/m^2) ;
end
figure(1) ;
hold off ;
plot(0:h:(Nt-1)*h,p11) ;
hold on ;
plot(0:h:(Nt-1)*h,p12,'r-') ;
plot(0:h:(Nt-1)*h,p22,'k-') ;
grid on ;
legend('p_{11}','p_{12}','p_{22}') ;

figure(2)
hold off ;
plot(0:h:(Nt-1)*h,x1,'k-') ; hold on ;
plot(0:h:(Nt-1)*h,x2,'b-') ; grid on ;
plot(0:h:(Nt-1)*h,y,'k-.','Color',[0.6 .6 .6]) ; grid on ;
%plot(x1,x2)
legend('x_1(t)','x_2(t)') ;
