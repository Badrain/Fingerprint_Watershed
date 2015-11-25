function hog = Calculate_Hog(Grad_Mag,Grad_Angle)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
noOfBins=9;

cell_width=8;
cell_height=8;
[x y]=size(Grad_Mag(:,:,1));

ele=x*y/(cell_width*cell_height);
hog=double(zeros(ele,noOfBins));
xpos=1;
% for i=cell_height:cell_height:y
%     cnt=0;
%     xpos=xpos+1;
%     for j=cell_width:cell_width:x
%        % xpos=i/cell_width;
%         
%         for cell_x=i-cell_width+1:i
%             for cell_y=j-cell_height+1:j
%                 if(cell_x<=x && cell_y<=y)
%                 ang=Grad_Angle(cell_x,cell_y)*180/pi;
%                 end
%                 ang=uint8(ang);
%                 bin=getBin(ang);
%                 if(i<=x && j<=y)
%                     hog(xpos+bin+cnt)=hog(xpos+bin+cnt)+Grad_Mag(i,j);
%                 end
%             end
%         end
%         cnt=cnt+cell_width;
%         
%     end
% end
for i=cell_width:cell_width:x
    for j=cell_height:cell_height:y
        for l=i-cell_width+1:i
            for m=j-cell_height+1:j
                ang=Grad_Angle(l,m)*180/pi;
                bin=getBin(ang);
                bin=bin+1;
                hog(xpos,bin)=hog(xpos,bin)+Grad_Mag(l,m);
            end
        end
        xpos=xpos+1;
    end
end
                
end

