function [correct_Img,correctOff]=recognize(imgs,offset,match,outlier)
num=size(imgs,4);
Hight=size(imgs,1);
Width=size(imgs,2);
order=zeros(num); %正確照片的順序
beMatch=zeros(num); %這張照片有沒有已經被找過了
correctOff=zeros(num,2);


order(1)=1; %以第一張input當作input
beMatch(1)=1; %第一張被用過了不用再檢查
fail=0;
for i=2:num
	now=order(i-1);
	best=-1;
	count=-1;
	for j=1:num
		if beMatch(j)==1
			continue;
		end
		a=min([now,j]);
		b=max([now,j]);
		n_i=match(a,b,1);
		n_f=outlier(a,b,1);
		if now>j
			offset(a,b,2)=-offset(a,b,2);
		end
		if offset(a,b,2)<0,continue;end
		if n_i>count&&n_i>5.9+0.22*n_f
			count=n_i;
			best=j;
		end
	end
	if best==-1
		fail=1;
		break;
	end % 沒有合適的，配對失敗
	order(i)=best;  %有找到正確的順序
	beMatch(best)=1;
end


correct_Img=zeros(Hight,Width,3,num,'uint8');

order
if fail==0
for i=1:num
	correct_Img(:,:,:,i)=imgs(:,:,:,order(i));
	if i<num
		a=min([order(i),order(i+1)]);
		b=max([order(i),order(i+1)]);
		correctOff(i,1)=offset(a,b,1);
		correctOff(i,2)=offset(a,b,2);
	end
end
end