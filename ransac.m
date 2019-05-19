function [offset,match,outlier]=ransac(imgs,pair,pairSize) %pair=(幾張照片,幾個pair,4維match)
num=size(imgs,4);
Width=size(imgs,2);
offset=zeros(num,num,2);
match=zeros(num,num,1);
outlier=zeros(num,num,1);
for count=1:num-1
	for pic=count+1:num
		moveX=0;
		moveY=0;
		for i=1:300
			rnd=int16(rand*(pairSize(count,pic)-1)+1);
			tmpX=pair(count,pic,rnd,2)-pair(count,pic,rnd,4);
			tmpY=pair(count,pic,rnd,1)-pair(count,pic,rnd,3);
		
			tmpMatch=0;
			tmpOutlier=0;
			for j=1:pairSize(count,pic)
				X=pair(count,pic,j,4)+tmpX;
				Y=pair(count,pic,j,3)+tmpY;
				distance=(X-pair(count,pic,j,2))^2+(Y-pair(count,pic,j,1))^2;
				if distance<=100
					tmpMatch=tmpMatch+1;
				end
				if X<Width&&X>tmpX&&distance>100
					tmpOutlier=tmpOutlier+1;
				end
			end
			if match(count,pic,1)<tmpMatch %要找最match的，不然更新
				moveX=tmpX;
				moveY=tmpY;
				match(count,pic,1)=tmpMatch;
				outlier(count,pic,1)=tmpOutlier;
			end
		end
		offset(count,pic,1)=moveY;
		offset(count,pic,2)=moveX;
	end
end
end