function count=test(im)

%im=imread('bacilli2.jpg');

%im=double(im);

%padding with 0s
im=padarray(im,[size(im,1)+5 size(im,2)+5]);

%edge detetion
ed=edge(im,'canny');
%imtool(ed,[]);

points=0;
for i=1:size(ed,1)
    for j=1:size(ed,2)
        if(ed(i,j)==1)
            points=points+1;
        end
    end
end

%getting  end points
xi=zeros(1,4);
yi=zeros(1,4);

%left end
endpt=0;
for j=1:size(ed,2) 
    for i=1:size(ed,1)
        if(ed(i,j)==1)
            endpt=1;
            break;
        end
    end
    if(endpt==1)
        break;
    end
end
xi(1)=i;
yi(1)=j;

%right end
endpt=0;
for j=size(ed,2):-1:1
    for i=size(ed,1):-1:1
        if(ed(i,j)==1)
            endpt=1;
            break;
        end
    end
    if(endpt==1)
        break;
    end
end
xi(2)=i;
yi(2)=j;

%top end
endpt=0;
for i=1:size(ed,1) 
    for j=1:size(ed,2)
        if(ed(i,j)==1)
            endpt=1;
            break;
        end
    end
    if(endpt==1)
        break;
    end
end
xi(3)=i;
yi(3)=j;

%bottom end
endpt=0;
for i=size(ed,1):-1:1 
    for j=size(ed,2):-1:1
        if(ed(i,j)==1)
            endpt=1;
            break;
        end
    end
    if(endpt==1)
        break;
    end
end
xi(4)=i;
yi(4)=j;

%traverse
xinc=[-1 0 1 0 -1 1 1 -1];
yinc=[0 1 0 -1 1 1 -1 -1];

dist=zeros(points,4);

for border=1:4
    x=xi(border);
    y=yi(border);
    idx=1;
    visited=zeros(size(ed,1),size(ed,2));
    visited(xi(border),yi(border))=1;
    flag=1;
    while(idx<=points && flag==1)    
        dist(idx,border)=double(sqrt( (x-xi(border))^2 + (y-yi(border))^2 ));
        idx=idx+1;
        found=0;
        for i=1:8
            xnew=x+xinc(i);
            ynew=y+yinc(i);
            if(isproper(xnew,ynew,size(ed,1),size(ed,2)) && ed(xnew,ynew)==1 && visited(xnew,ynew)==0)
                found=1;
                %disp('found');
                break;
            end
        end
        if(found==1)
            x=xnew;
            y=ynew;
            visited(x,y)=1;
            if(x==xi(border) && y==yi(border))
                flag=0;
            end
        else
            %disp('Not found');
            %visited(34,69)
            break;
        end
    end
end

%smoothing
for i=1:4
    dist(:,i)=smooth(dist(:,i));
end

% mask=[1;1;1;1;1;1;1];
% for i=1:4
%     dist(:,i)=conv(dist(:,i),mask,'same');
% end    

% %display distances
% dist
% 
%plot
% figure
% 
% subplot(2,2,1)
% plot(dist(:,1))
% title('left end')
% 
% subplot(2,2,2)
% plot(dist(:,2))
% title('right end')
% 
% subplot(2,2,3)
% plot(dist(:,3))
% title('top end')
% 
% subplot(2,2,4)
% plot(dist(:,4))
% title('bottom end')

maximas=zeros(1,4);
for i=1:4
    maximas(i)=size(findpeaks(dist(:,i)),1);
end
%disp('Number of bacilli:')
count=(min(maximas));

end

