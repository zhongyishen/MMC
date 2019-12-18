function pathFound = check(center,goal,theta,delta)
pathFound = false;
len = distance(center.position,goal);
verErr = center.verErr + len * delta;
horErr = center.horErr + len * delta;
if verErr < theta && horErr < theta
    pathFound = true;
end
