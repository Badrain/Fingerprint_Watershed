function [count,itemp,jtemp,flag,cdtemp_x,cdtemp_y] = eightround(immin,itemp,jtemp,flag,cdtemp_x,cdtemp_y)
                count = 0;%用于确认8邻域内是否存在满足条件的点
                inext = 0;
                jnext = 0;
                [imx,imy]=size(immin);
                if (itemp+1)>imx
                    itemp=itemp-1;
                elseif (itemp-1)<1
                    itemp=itemp+1;
                end
                if (jtemp+1)>imy
                    jtemp=jtemp-1;
                elseif (jtemp-1)<1
                    jtemp=jtemp+1;
                end
                for ir=(itemp-1):(itemp+1)
                    for jr=(jtemp-1):(jtemp+1)
                        if immin(ir,jr)==1 && flag(ir,jr)==0
                            count = count + 1;
                            cdtemp_x = [cdtemp_x,ir];
                            cdtemp_y = [cdtemp_y,jr];
                            flag(ir,jr)=1;
                            inext=ir;
                            jnext=jr;
                        end
                    end
                end
                itemp=inext;
                jtemp=jnext;
