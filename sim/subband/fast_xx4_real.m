% Function fast_xx4_real(x)
% evulates xx(k,n,m,p) = x(k)*x(n)*x(m)*x(p)
% for k>=n>=m>=p cases only due to symmetry of 
% above equation for real x values
function xx = fast_xx4_real(x, self_test)
N = length(x) ;
xx = zeros(N,N,N,N) ;
for k = 1:N
    for n = 1:k
        for m = 1:n
            for p = 1:m
                xx(k,n,m,p) = x(k)*x(n)*x(m)*x(p) ;
            end
        end
    end
end
% make the full xx matrix for all k,n,m,p
for k = 1:N
    for n = 1:N
        for m = 1:N
            for p = 1:N          
                s_indices = sort([k,n,m,p],'descend') ;
                xx(k,n,m,p) = xx(s_indices(1),s_indices(2),s_indices(3),s_indices(4)) ;
%                 if (self_test)
%                     if abs(x(k)*x(n)*x(m)*x(p)-xx(k,n,m,p))>1e-12
%                         error('!>fast_xx4_real(x, self_test) self_test failed!') ;
%                     end
%                 end
            end
        end
    end
end

