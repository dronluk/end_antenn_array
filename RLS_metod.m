function [  e,W,Y,coef_filtr,SKO ] = RLS_metod( D,UINTER )
d=D;            % ��������� ������ �������
Uinter=UINTER;  % ������������ ������� �������
L=length(Uinter);
% lambda=0.87;%�������� �����������
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
      e(m)= d(m)-W'*Uinter(:,m);             % ������ ������ 'e'     
      Pi = P*Uinter(:,m);                            % Parameters for efficiency
            k = (Pi)/(lambda+Uinter(:,m)'*Pi);    % Filter gain vector update
            P = ((P - k*Uinter(:,m)'*P)*laminv);    % Inverse correlation matrix update
           W = W + k*conj(e(m));                 % Filter coefficients adaption
    for k=1:3          %������ � ������ ����������� ��� 3� ������������ �����
    coef_filtr(k,m)=W(k,1);
    end
    SKO(m-4)=std(e);
end       
 Y=W'*Uinter(:,m);
 std(e)%������� ���������� ����������
 figure(13);hold on
plot(real(coef_filtr(1,:)),'r');plot(real(coef_filtr(2,:)),'g');plot(real(coef_filtr(3,:)),'k');%����������� ��� ������ �����������
title('�����������');
end

