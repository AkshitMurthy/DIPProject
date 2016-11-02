function count=convexHull(im)

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

%getting convex hull
chull=edge(bwconvhull(im),'canny');
%imtool(chull,[]);

%distance transform
distances=bwdist(ed);

%gettin left endpoint
endpt=0;
for j=1:size(chull,2) 
    for i=1:size(chull,1)
        if(chull(i,j)==1)
            endpt=1;
            break;
        end
    end
    if(endpt==1)
        break;
    end
end
xi=i;
yi=j;

%traverse
xinc=[-1 0 1 0 -1 1 1 -1];
yinc=[0 1 0 -1 1 1 -1 -1];

dist=zeros(points,1);

    x=xi;
    y=yi;
    idx=1;
    visited=zeros(size(chull,1),size(chull,2));
    visited(xi,yi)=1;
    flag=1;
    while(idx<=points && flag==1)    
        dist(idx)=distances(x,y);
        idx=idx+1;
        found=0;
        for i=1:8
            xnew=x+xinc(i);
            ynew=y+yinc(i);
            if(isproper(xnew,ynew,size(chull,1),size(chull,2)) && chull(xnew,ynew)==1 && visited(xnew,ynew)==0)
                found=1;
                break;
            end
        end
        if(found==1)
            x=xnew;
            y=ynew;
            visited(x,y)=1;
            if(x==xi && y==yi)
                flag=0;
            end
        else
            break;
        end
    end

%smoothing
%dist(:,1)=smooth(dist(:,1));
filter=ones(11,1);
dist=conv(dist,filter,'same');

%plot(dist);

%disp('Number of bacilli:');
count=(floor(size(findpeaks(dist(:,1)),1)/2));

end

