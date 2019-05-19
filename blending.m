function []=blenfing(imgs,offset) %這裡讀入已經warping好的照片
height=size(imgs,1);
width=size(imgs,2);
num=size(imgs,4);

top=0;
bottom=0;
top_c=0;
bottom_c=0;
prevOff=[0 0]; %紀錄前幾步照片總共移動了多少，因為每張的offset是相對上一張

photo=zeros(height,width,3,num);

for count=2:num %第一張不動，從2開始
	img1=imgs(:,:,:,count-1);
	img2=imgs(:,:,:,count);

	offset(count-1,2)=width-offset(count-1,2);
	
	if offset(count-1,1)<0  %第一張比第二張下面
		img1=[img1(:,:,:);  %第一張往上補
			  zeros(-offset(count-1,1),width,3)];
		img2=[zeros(-offset(count-1,1),width,3);
			  img2(:,:,:)]; %第二張往下擠

	else
		img1=[zeros(offset(count-1,1),width,3);
			  img1(:,:,:)];
		img2=[img2(:,:,:);
			  zeros(offset(count-1,1),width,3)];
	end
	
	if offset(count-1,2)+prevOff(2)-width>0
		corr=offset(count-1,2)+prevOff(2)-width;
		%中間重疊的部份	
	else
		corr=0;
	end

	
	overlap1=[img1(:,width-offset(count-1,2)+corr+1:width,:)];
	overlap2=[img2(:,1+corr:offset(count-1,2),:)];

	p=linear(overlap1,overlap2); 
	
	if count==2
		para=[img1(:,1:width-offset(count-1,2),:),p];
		top=offset(count-1,1);
		bottom=offset(count-1,1);
		if top>0, top=0; end %top>0下一張相對下移(前-後>0,前比較上)
		if bottom<0, bottom=0; end %bottom<0代表下一張是往上移的
	else
		
		sz=size(para,2); %有幾張照片
		
		concat=[img1(:,prevOff(2)+1: width-offset(count-1,2),:),p];
		c=size(concat);
	
		if prevOff(1)>0 %前張在上
			bottom_c=bottom_c+prevOff(1);
			%bottom_c=bottom_c+offset(count-1,1);
		else  %前張在下
			top_c=top_c+prevOff(1);
			%top_c=top_c+offset(count-1,1);
		end
		if offset(count-1,1)>0
			top_c=top_c+offset(count-1,1);
		else
			bottom_c=bottom_c+offset(count-1,1);
		end
		if top_c<0
			concat=[zeros(abs(top_c),c(2),3);concat];
			%top_c=0;
		else
			top_c=0;
		end
		if bottom_c>0
			concat=[concat;zeros(bottom_c,c(2),3)];
			%bottom_c=0;
		else
			bottom_c=0;
		end
		top=top+offset(count-1,1);
		bottom=bottom+offset(count-1,1);
		
		if top>0
			para=[zeros(top,sz,3);para];
			top=0;
		end
		if bottom<0
			para=[para;zeros(-bottom,sz,3)];
			bottom=0;
		end
		para=[para,concat];
	end
	
	prevOff(1)=offset(count-1,1);
	prevOff(2)=offset(count-1,2);
end

concat=imgs(:,prevOff(2)+1: width,:,num);
c=size(concat);

if prevOff(1)>0
	bottom_c=bottom_c+prevOff(1);
else 
	top_c=top_c+offset(num-1,1);
end
if top_c<0
	concat=[zeros(abs(top_c),c(2),3);concat];
end

if bottom_c>0
	concat=[concat;zeros(bottom_c,c(2),3)];
end

para=[para,concat];


figure
imshow(para);


end