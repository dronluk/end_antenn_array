function [ e2 ] = SMI_Filter( signal,N,k,Antenn )

Inter=signal(:,1:N);
d=Inter(1,:);% ��������� ������ �������
d2=signal(1,:);
U=signal(2:Antenn,:);

U_tap =[];
for i=0:k
    U_tap = [U_tap; circshift(U',i)' ];
end;

Uinter = U_tap(:,1:N); % ������������ ������� �������
W=ones(length(Uinter(:,1)), 1);   %����������
 [e,W,Y]=SMI_metod(d,Uinter);%SMI �����
%[e,W,Y]=LMS_metod(d,Uinter,mu,step);%LMS �����
  Y=W'*Uinter;
  e=d-Y;
 
  Y2=W'*U_tap;
  e2=d2-Y2; 
  std(e2)
end

