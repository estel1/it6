function [ r ] = Rxx_sb( X, N, w1, w2, tau )

X1 = X;
X2 = conj(X);
E = eye(N);
% r = 0;

for k = 1:N
    for n = 1:N
        d = (k - 1) - (n - 1) + tau;
        e = (w2 - w1);
        if d ~= 0
            e = -1i/d*(exp(1i*w2*d) - exp(1i*w1*d));
        end
        E(k, n) = e;
%         r = r + X1(n)*X2(k)*e;
    end
end

r = X1.'*E*X2 ;

end

