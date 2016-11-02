function init(im,imgname)

im=im2double(im);
gray=rgb2gray(im);

%bottomhat
se = strel('disk',7);
im2=imbothat(gray,se);

%binarise
thres=mean2(im2)+2.5*std2(im2);
bw=im2>thres;

%erosion
bw=imdilate(bw,strel('disk',3));
bw=imerode(bw,strel('disk',3));
bw=imerode(bw,strel('disk',1));
bw=imdilate(bw,strel('disk',3));

imtool(bw,[]);
imwrite(bw,strcat(imgname,'Bacilli.jpg'));

mkdir(imgname);

%connected component analysis done in python
% [label,n]=bwlabel(bw);
% %filenames=strings(n,1);
% idx=1;
% for i=1:n
%     temp=(label==i);
%     area=sum(temp(:)==1);
%     if(area>200)
%         [node_y, node_x] = find(temp==1);
%         temp=imcrop(min(node_x),min(node_y),max(node_x)-min(node_x),max(node_y)-min(node_y));
%         filename=strcat(imgname,int2str(i));
%         %filenames[idx]=filename;
%         idx=idx+1;
%         imwrite(temp,strcat(strcat('15smear/',filename),'.jpg'));
%     end
% end

end

