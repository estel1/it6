function f = fun2(y,x,se,m,px,gauss)
s           = 0 ;
for k=1:length(px)
    s       = s + gauss(y,x(k),se) * px(k) ;
end
f = gauss(y,x(m),se)*px(m).*log2(s) ;