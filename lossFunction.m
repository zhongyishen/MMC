function loss = lossFunction(center,points,openList)
loss = [];
for i = 1:length(openList)
    g = center.route + distance(center.position,points(openList(i),:));
    h = distance(points(openList(i),:),points(end,:));
    loss(end+1) = g + h; 
end
