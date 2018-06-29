function [fx,fy]=ClockwiseSortPoints(x,y)
%�㼯��ʱ������
%   Detailed explanation goes here
   num=length(x);
   %��������
   centerx = sum(x)/num;
   centery = sum(y)/num;
   fx=zeros(num);
   fy=zeros(num);
   
    %ð������
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
%����a���ڵ�b,����a�ڵ�b˳ʱ�뷽��,����true,���򷵻�false
  if ax>=0 && bx<0
      bool=true;
      return;
  end
  
  
  %����OA������OB�Ĳ��
  det=(ax-centerx)*(by-centery)-(bx-centerx)*(ay-centery);
  if det<0
      bool=true;
      return;
  end
  if det>0
      bool=false;
      return;
  end

    %����OA������OB���ߣ��Ծ����жϴ�С
    d1 = (ax - centerx) * (ax - centerx) + (ay - centery) * (ay - centery);
    d2 = (bx - centerx) * (bx - centery) + (by - centery) * (by - centery);
    bool=(d1>d2);
end
