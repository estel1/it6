clc, 

N = 3 ;
idx = 0:N-1 ;
omega = 2*pi/N ;

x = sin(omega*idx(:)+pi/4) + 0 ; % idx(:) - is column vector

F = [...
    1/2 1 0 ; ...
    1/2 cos(omega) sin(omega) ; ...
    1/2 cos(2*omega) sin(2*omega) ; ...
    ] ;

%c = inv(F)*x ;
c = (F'/(N/2)) * x ; % F - is orthogonal, but not orthonormal

a0 = c(1) ; a1 = c(2) ; b1 = c(3) ;

fprintf( '<a0>: %5.3f, <a1:> %5.3f, <b1:> %5.3f\n', ...
    a0, a1, b1 ) ;

