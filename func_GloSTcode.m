function G=func_GloSTcode(fs)

% clc;clear all;
if nargin<1
	fs=1;
end


N = 511;
%N = 511 * 10;

G = zeros(1,N);
PT = [1 1 1 1 1 1 1 1 1 ]' ;


for k = 1:N;
    PT_xor = xor(PT(5),PT(9));
    
    P_T_code = PT(7);


    PT = circshift(PT,1);
    PT(1) = PT_xor;

     G(k) = P_T_code ;
end;

for num=1:N
    if G(num)==0
        G(num)=-1;
    end;
 end;
 
 gfs = zeros(1,length(1/fs:1/fs:N));

%upsample to desired rate
if fs~=1
	%fractional upsampling with zero order hold
	index=0;
	for cnt = 1/fs:1/fs:N
		index=index+1;
		if ceil(cnt) > N   %traps a floating point error in index
			gfs(:,index)=G(:,N);
		else
			gfs(:,index)=G(:,ceil(cnt));
		end
	end 
	G=gfs;
end