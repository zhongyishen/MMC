function feasible = feasibleNode(center,point,alpha1,alpha2,beta1,beta2,theta,delta,index,verIndex)
feasible = false;
len = distance(center.position,point);
verErr = center.verErr + len * delta;
horErr = center.horErr + len * delta;
if (verErr < theta) && (horErr < theta)
    if isVertical(index,verIndex)
        if (verErr < alpha1) && (horErr < alpha2)
            feasible = true;
        end
    else
        if (verErr < beta1) && (horErr < beta2)
            feasible = true;
        end
    end
end
