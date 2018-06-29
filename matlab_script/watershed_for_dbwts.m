functiondir=cd;
addpath([functiondir '/common']);
addpath([functiondir '/main']);
addpath([functiondir '/process_fun']);
imglen=1;
bound=cell(1,imglen);
center=cell(1,imglen);
mask=cell(1,imglen);
bound_small=cell(1,imglen);%small region that's to be growning
center_small=cell(1,imglen);
mask_small=cell(1,imglen);
rmset=cell(1,imglen);
smallobj=cell(1,imglen);  %smallobjcenter that needed to be complemented
diff_small=cell(1,imglen);%seeds that are needed to be growned importantly
file=dir('F:\segdata1\result1\re_*.tiff');
sum={};
for i=1:length(file)
    sum{i}=file(i).name;
end
for ii=1:length(sum)
    m1= imread(strcat('F:\segdata1\result1\',sum{ii})); 
    m=255-m1;
    bw=m;
    bw2 = ~bwareaopen(~bw,100,8);
    D = -bwdist(~bw2); 
    mask1 = imextendedmin(D,1.5); 
    D2 = imimposemin(D,mask1); 
    Ld2 = watershed(D2);
    bw3 = bw2;
    bw3(Ld2 == 0) = 0;
    [Lbw4,numbw4]=bwlabeln(bw3);
    stats=regionprops(bw3,'all');
    bw4 = ismember(Lbw4, find([stats.Area] >3));
    stats=regionprops(bw4,'all');
    areas=[stats.Area];
    [arearesult,areaindex]=sort(areas,'descend');
    rects=cat(1,stats.BoundingBox);
    zzd=zeros(length(stats),2);
    bound{ii}=zeros(length(stats),4);
    center{ii}=zeros(length(stats),2);
    mask{ii}=cell(1,length(stats));
    for i=1:length(stats)
        bound{ii}(i,:)=ceil(stats(i).BoundingBox);
        zzd(i,:)=stats(i).Centroid;
        center{ii}(i,:)=stats(i).Centroid;
        mask{ii}{i}=stats(i).Image;
    end
    zzdi=zzd;
    n=0;
    small=[];
    smalllocate=[];
    for i=1:length(stats)
        if stats(i).Area<400
            smalllocate=[smalllocate,i];
            if stats(i).Area<10
                n=n+1;
                small=[small,i];
            end
        end
    end
    distance_maxtrix= pdist2(zzd,zzd,'euclidean');
    DIST=distance_maxtrix;
    distance_maxtrix(find(distance_maxtrix==0))=[];
    n=0;
    for iter=1:1
        for i=1:size(zzd,1)-1
            for j=i+1:size(zzd,1)
                if zzd(i,1)&&zzd(j,1)&&norm(zzd(i,:)-zzd(j,:))<max(distance_maxtrix)/mean(distance_maxtrix)*10
                     zzd(j,:)=[0,0];
                end
            end
        end
    end
    rm=find(zzd(:,1)==0);
    small=[small,rm'];
    small=unique(small);
    rmset{ii}=small;
    full=1:length(stats);
    diff=setdiff(full,small);%the complement set
    diff_small{ii}=setdiff(smalllocate,small);  %return values whitch are in smalllocate but not in small(need to be removed)
    zzd(find(zzd(:,1)==0),:)=[];
    smallobj{ii}=center{ii}(diff_small{ii},:);
    bound_small{ii}=bound{ii}(diff,:);
    center_small{ii}=center{ii}(diff,:);
    for ij=1:length(diff)
        mask_small{ii}{ij}=mask{ii}{diff(ij)};     
    end
    stats1=stats(diff);
    segimg=zeros(size(bw));
end
save('mfcn.mat','bound_small','mask_small','center_small','smallobj','center','bound','rmset','mask','smallobj','diff_small');