function[I, Q, fs_out] = Hilbert_Filter(data1, fs, order)

if nargin<3
    Hlb_order = 66;
else
    Hlb_order = order;
end;
    
hFilt    = designfilt('hilbertfir','FilterOrder',Hlb_order,'TransitionWidth',0.1);
dataOut  = filter(hFilt,data1);
datI  = [  data1( 1 : end - Hlb_order/2)  zeros(1,Hlb_order/2)];
datQ  = [dataOut( Hlb_order/2 +1 : end )  zeros(1,Hlb_order/2)];
%% ===== Decimation ===============
m=1;
% I=datI; Q=datQ;
for k=1:2:length(datI)
    I(m) = (datI(k)+datI(k+1))/2;
    Q(m) = (datQ(k)+datQ(k+1))/2;
    m=m+1;
end
% IQ = I + 1i*Q; 
fs_out=fs /2;
end