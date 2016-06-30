function [  e,W,Y,coef_filtr,SKO ] = RLS_metod( D,UINTER )
d=D;            % Эталонный сигнал выборки
Uinter=UINTER;  % Периферийные антенны выборки
L=length(Uinter);
% lambda=0.87;%параметр взвешивания
N=length(Uinter);
W=zeros(length(Uinter(:,1)),1);
R=ones(length(Uinter(:,1)),1);
P=eye(length(Uinter(:,1)));
lambda  = 0.99999;   
laminv  = 1/lambda;
p       = 5;                       % filter order
e       = d*0;                    % error signal
coef_filtr=[];
coef_filtr(1:3,1:p-1)=0;
SKO=[];
%SKO(1,1:p-1)=0;
for m = p:length(Uinter(1,:))-2
      e(m)= d(m)-W'*Uinter(:,m);             % Сигнал ошибки 'e'     
      Pi = P*Uinter(:,m);                            % Parameters for efficiency
            k = (Pi)/(lambda+Uinter(:,m)'*Pi);    % Filter gain vector update
            P = ((P - k*Uinter(:,m)'*P)*laminv);    % Inverse correlation matrix update
           W = W + k*conj(e(m));                 % Filter coefficients adaption
    for k=1:3          %запись в память коэффиценты для 3х переферийных антен
    coef_filtr(k,m)=W(k,1);
    end
    SKO(m-4)=std(e);
end       
 Y=W'*Uinter(:,m);
 std(e)%Среднее отклонение сходимости
 figure(13);hold on
plot(real(coef_filtr(1,:)),'r');plot(real(coef_filtr(2,:)),'g');plot(real(coef_filtr(3,:)),'k');%Отображение как растут коэффиценты
title('Коэффиценты');
end

