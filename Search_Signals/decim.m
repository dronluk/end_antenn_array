
function Y=decim(f0,f,X)

L = ceil(length(X)*f/f0);
Y=zeros(1,L);
m=1;
Ac=f;
for n=1:length(X)
    
    Y(m)=Y(m)+X(n);
    
    Ac=Ac+f;
    
    if(Ac>=f0)
    
        Ac=Ac-f0;
        m=m+1;
        if m>L
            m=L;
        end
        
    end
         
    
end

Y=Y(1:L);
