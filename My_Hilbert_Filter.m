function signal= My_Hilbert_Filter(data,Antenn)
%-------Фильтр Гильберта-----
signal=[];
for i=1:Antenn
d=0.01; w_L=0.1*pi; w_H=0.9*pi; N=27;
h=firpm(N-1,[w_L/pi w_H/pi],[1,1],'hilbert');
 Hlb_order = 26;
 dataOut  = filter(h,1,data(i,:));
datI  = [  data( i ,1 : end - Hlb_order/2)  zeros(1,Hlb_order/2)];
datQ  = [dataOut( Hlb_order/2 +1 : end )  zeros(1,Hlb_order/2)];
%% ===== Decimation ===============
    m=1;
    for k=1:2:length(datI)
        I(m) = (datI(k)+datI(k+1))/2;
        Q(m) = (datQ(k)+datQ(k+1))/2;
        m=m+1;
    end
IQ = I + 1i*Q;

signal=[signal; IQ];
end
end

