%load('mfcn.mat');
file=dir('F:\segdata1\result1\re_*.tiff');
sum={};
for i=1:length(file)
    sum{i}=file(i).name;
end
segimg=zeros(1792,2048);
for ind=1:length(mask)
stats=mask_small{ind};
boardset=cell(length(stats));
for i=1:length(stats)
    bounding=bound_small{ind}(i,:);
    g=stats{i};
    size_m=size(g);
    g_pad=zeros(size_m+2);
    edge=zeros(size_m);
    g_pad(2:size_m(1)+1,2:size_m(2)+1)=g;
    nn=0;
    seed_single_sum=[];
    seed_board=[];
    for jk=2:bounding(4)+1
        for jk1=2:bounding(3)+1
            if g_pad(jk,jk1)
                if (g_pad(jk,jk1)-g_pad(jk-1,jk1))>0|(g_pad(jk,jk1)-g_pad(jk+1,jk1)>0)...
                        |(g_pad(jk,jk1)-g_pad(jk,jk1-1)>0)|(g_pad(jk,jk1)-g_pad(jk,jk1+1)>0)
                            bdx=bounding(2)+jk-2;
                            bdy=bounding(1)+jk1-2;
                            if bdx <=0
                                bdx=1;
                            end
                            if bdy<=0
                               bdy=1;
                            end
                            seed_board=[seed_board;[bdx,bdy]];
                            segimg(bdx,bdy)=1;
                    end
             
                end
          end
       end
%     g=stats{i};
      boardset{i}=seed_board;
%     segimg(bounding(2):bounding(2)+bounding(4)-1,bounding(1):bounding(1)+bounding(3)-1)=g;
end
if length(boardset)
    writeImageJRoi('F:\segdata1\result1\',sum{ind}(1:end-5),'Freehand', boardset); 
end
end
%figure,imshow(segimg)