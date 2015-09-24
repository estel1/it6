function F = get_sb_matrix_new_diag(N, w1, w2, tau )
F = zeros(N,N,N,N) ;

for k = 1:N
    for n = 1:N
        for m = 1:N
            for p = 1:N
                d = k - n + m - p + tau ;
                F(k,n,m,p) = w2 - w1 ;
                if d ~= 0
                    F(k,n,m,p) = -1j/d*(exp(1i*w2*d) - exp(1i*w1*d)) ;
                end
            end
        end
    end
end
