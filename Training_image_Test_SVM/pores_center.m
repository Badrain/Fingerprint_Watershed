function pores_center= pores_center( input,upthrehold,downthrehold)
bgm=get_bgm(input);
center=line_scan(bgm,upthrehold,downthrehold);
%pores_center=filter_center2(center);
%figure;imshow(center);title('poresCenter before cluster');
[new_coor,pores_center] = coor_cluster(center,7);
[IM,newcoor,coor_image]=red_center(bgm,'binary',upthrehold,downthrehold);
figure;imshow(IM);
%figure;imshow(pores_center);title('poresCenter after cluster');
end

