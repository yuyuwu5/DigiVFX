function new_photo=warp(imgs) %轉換xy座標到圓柱座標上
height=size(imgs,1);
width=size(imgs,2);
num=size(imgs,4);
new_photo=zeros(height,width,3,num,'uint8');

for count=1:num
	f=600.0;
	for y=1:height
		for x=1:width
			X=round(y-height ./ 2); %%% different
			Y=round(x-width  ./ 2);
			new_x=round((f*X ./sqrt(Y^2+f^2))+height ./2 );
			new_y=round((f*atan(Y ./ f))+width ./2);
			for c=1:3
				new_photo(new_x,new_y,c,count)=imgs(y,x,c,count);
			end
		end
	end
	%imshow(new_photo(:,:,;,count));
	%imwrite(new_photo(:,:,:,count),['warp/' num2str(count) '.jpg']);
end