%data example
%d1=[196194,177102,171057,161366,148120,141577,136514];
%e1=[161386,161368,161366,161366,161366,161366,161366];
%a1=[180459,172911,171409,161366,156182,147338,138924];
%k1=[173087,169611,167656,161366,159718,161154,159405];
%t1=[163641,164080,160741,161366,161782,168846,169808];

%d2=[674773,671563,666107,660386,656395,653959,647625];
%e2=[660386,660386,660386,660386,660386,660386,660386];
%a2=[702912,685561,674689,660386,651032,641565,631113];
%k2=[683689,674372,667295,660386,655188,649714,637396];
%t2=[627470,639791,654200,660386,666989,676488,685300];

%d3=[578661,499852,464838,460228,454371,450322,437836];
%e3=[460247,460226,460228,460228,460228,460228,460228];
%a3=[605561,491532,476537,460228,447982,436107,421097];
%k3=[484130,479389,465914,460228,452653,447746,439545];
%t3=[478477,451730,455757,460228,468432,472907,476337];
%X=[1,2,3,4,5,6,7];

%avp=[0.4625,0.5459,0.5988];
%cov=[1.8800,1.5500,1.3200];
%ham=[0.2100,0.2880,0.2640];
%oer=[0.7979,0.6915,0.6277];
%rkl=[0.4929,0.4034,0.3449];

avp=[0.5988,0.5459,0.5723,0.5349,0.6172];
cov=[1.3200,1.5500,1.4000,1.6500,1.3400];
ham=[0.2640,0.2880,0.2760,0.2840,0.2400];
oer=[0.6277,0.6915,0.6596,0.6809,0.5638];
rkl=[0.3449,0.4034,0.3688,0.4282,0.3528];
figure(1); 
clf ;
%whitebg(1,'k');
plot(X,d1,X,e1,X,a1,X,k1,X,t1,'--rs','LineWidth',2);
text(X(2),d1(2),'\leftarrow d',...
     'HorizontalAlignment','left');
text(X(2),e1(2),'\leftarrow e',...
     'HorizontalAlignment','left');
text(X(2),a1(2),'\leftarrow 汐',...
     'HorizontalAlignment','left');
text(X(2),k1(2),'\leftarrow 百',...
     'HorizontalAlignment','left');
text(X(2),t1(2),'\leftarrow 而',...
     'HorizontalAlignment','left');
  
 
figure(2); 
clf; 
%whitebg(2,'k');
plot(X,d2,X,e2,X,a2,X,k2,X,t2,'--rs','LineWidth',2);
text(X(2),d2(2),'\leftarrow d',...
     'HorizontalAlignment','left');
text(X(2),e2(2),'\leftarrow e',...
     'HorizontalAlignment','left');
text(X(2),a2(2),'\leftarrow 汐',...
     'HorizontalAlignment','left');
text(X(2),k2(2),'\leftarrow 百',...
     'HorizontalAlignment','left');
text(X(2),t2(2),'\leftarrow 而',...
     'HorizontalAlignment','left');

figure(3); 
clf; 
%whitebg(3,'k');
plot(X,d3,X,e3,X,a3,X,k3,X,t3,'--rs','LineWidth',2);
text(X(2),d3(2),'\leftarrow d',...
     'HorizontalAlignment','left');
text(X(2),e3(2),'\leftarrow e',...
     'HorizontalAlignment','left');
text(X(2),a3(2),'\leftarrow 汐',...
     'HorizontalAlignment','left');
text(X(2),k3(2),'\leftarrow 百',...
     'HorizontalAlignment','left');
text(X(2),t3(2),'\leftarrow 而',...
     'HorizontalAlignment','left');
 
 %saveas(1,'1','bmp');
 %saveas(2,'2','bmp');
 %saveas(3,'3','bmp');
 	
 
 
 
 
 
