avp=[0.5356,0.5988,0.4444,0.5459,0.5367,0.5723,0.5218,0.5349,0.5463,0.6172];
cov=[1.6500,1.3200,2.0300,1.5500,1.8200,1.4000,1.5600,1.6500,1.6300,1.3400];
ham=[0.2840,0.2640,0.3280,0.2880,0.2720,0.2760,0.3120,0.2840,0.2760,0.2400];
oer=[0.6809,0.6277,0.7979,0.6915,0.6489,0.6596,0.7553,0.6809,0.6596,0.5638];
rkl=[0.4202,0.3449,0.5319,0.4034,0.4672,0.3688,0.4034,0.4282,0.4273,0.3528];
X=[15,20,25,30,35,40,45,50,55,60];


figure(1); 
clf ;
%whitebg(1,'k');
plot(X,avp,X,cov,X,ham,X,oer,X,rkl,'--rs','LineWidth',2);
text(X(2),avp(2),'\leftarrow avp',...
     'HorizontalAlignment','left');
text(X(2),cov(2),'\leftarrow cov',...
     'HorizontalAlignment','left');
text(X(2),ham(2),'\leftarrow ham',...
     'HorizontalAlignment','left');
text(X(2),oer(2),'\leftarrow oer',...
     'HorizontalAlignment','left');
text(X(2),rkl(2),'\leftarrow rkl',...
     'HorizontalAlignment','left');