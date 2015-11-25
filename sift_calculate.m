function template_database = sift_calculate(image)

I=imreadbw(image) ;
S=2 ;
I=I-min(I(:)) ;
I=I/max(I(:)) ;
[frames,descr,gss,dogss] = sift( I, 'Verbosity', 1, 'Threshold', ...
                                     0.06, 'NumLevels', S ) ;
                               
descr=uint8(512*descr) ;
%template_database{1}=frames;
template_database{1}=descr;
%template_database{3}=gss;
%template_database{4}=dogss;


end