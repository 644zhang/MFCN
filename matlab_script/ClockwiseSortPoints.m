function [fx,fy]=ClockwiseSortPoints(x,y)
%点集逆时针排序
%   Detailed explanation goes here
   num=length(x);
   %计算重心
   centerx = sum(x)/num;
   centery = sum(y)/num;
   fx=zeros(num);
   fy=zeros(num);
   
    %冒泡排序
    for i=1:num
        for j=1:num-i
            if PointCmp(x(j),y(j),x(j+1),y(j+1),centerx,centery)
                tmpx=x(j);
                tmpy=y(j);
                x(j)=x(j+1);
                y(j)=y(j+1);
                x(j+1)=tmpx;
                y(j+1)=tmpy;
            end
        end
    end
    fx=x;
    fy=y;
end

function bool = PointCmp( ax,ay,bx,by,centerx,centery )
%若点a大于点b,即点a在点b顺时针方向,返回true,否则返回false
  if ax>=0 && bx<0
      bool=true;
      return;
  end
  
  
  %向量OA和向量OB的叉积
  det=(ax-centerx)*(by-centery)-(bx-centerx)*(ay-centery);
  if det<0
      bool=true;
      return;
  end
  if det>0
      bool=false;
      return;
  end

    %向量OA和向量OB共线，以距离判断大小
    d1 = (ax - centerx) * (ax - centerx) + (ay - centery) * (ay - centery);
    d2 = (bx - centerx) * (bx - centery) + (by - centery) * (by - centery);
    bool=(d1>d2);
end
