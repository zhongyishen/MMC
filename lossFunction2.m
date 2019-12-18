function loss = lossFunction2(center,points,openList,data1,w1,w2,w3)
loss = [];
for i = 1:length(openList)
    g = center.route + distance(center.position,points(openList(i),:));
    h = distance(points(openList(i),:),points(end,:));
    f = center.p + isBadNode(openList(i),data1) * 0.2;
    loss(end+1) = w1 * g + w2 * h + w3 * 1e3 *f; 
end
