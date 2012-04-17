clc, clear ;
N = 50000 ;
Kd = 0.7 ;
K0 = 0.6 ;
Ki = 0.9 ;
Kp = 0.15 ;
x = zeros(N,1) ;
y = zeros(N,1) ;
e = zeros(N,1) ;
phi = pi/2 ;
Int_x = 0 ;
Int_e = 0 ;
yn = 0 ;
dt = 0.01 ;
omega0 = 10 ;
for n=1:N
    t = (n-1)*dt ;
    x(n) = Kd*(sin(omega0*t+phi)*yn) ;
    Int_x = Int_x + dt*x(n) ;
    e(n) = Kp*x(n) + Ki*Int_x ;
    Int_e = Int_e + e(n)*dt ;
    yn = cos((omega0)*t+K0*Int_e) ;
    y(n) = yn ;
end
plot(e*K0), grid on ;