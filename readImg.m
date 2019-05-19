function images=readImg(files,path,scale)
total=length(files);
name=[path,'/',files(1).name];
information=imfinfo(name);
height=information.Height;
width=information.Width;

while height>750||width>750
	scale=scale/2;
	height=height/2;
	width=width/2;
end

%height=height*scale;
%width=width*scale;

images=zeros(height,width,3,total,'uint8'); 
for i=1:total
    name=[path,'/',files(i).name];
    P=imread(name);
    images(:,:,:,i)=imresize(P,scale);
end
end
