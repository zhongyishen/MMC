%% 原始数据点 包括起点终点 以及矫正点
clear;
close all;
data1 = xlsread('data2.xlsx');
points = data1(:,2:4);
source = [data1(1,2:4),];
goal = [data1(end,2:4)];
verCorrX = []; % 垂直矫正点 颜色为蓝色
verCorrY = [];
verCorrZ = [];
horCorrX = []; % 水平矫正点 颜色为黄色
horCorrY = [];
horCorrZ = [];
alpha1 = 20;
alpha2 = 10;
beta1 = 15;
beta2 = 20;
theta = 20;
delta = 0.001;
verIndex = [];
horIndex = [];
for i = 1:length(data1)
    if data1(i,5) == 1
        verCorrX(end+1) = data1(i,2);
        verCorrY(end+1) = data1(i,3);
        verCorrZ(end+1) = data1(i,4);
        verIndex(end+1) = i;
    elseif data1(i,5) == 0 
        horCorrX(end+1) = data1(i,2);
        horCorrY(end+1) = data1(i,3);
        horCorrZ(end+1) = data1(i,4);
        horIndex(end+1) = i;
    end
end
horCorrPoints = [];
verCorrPoints = [];
horCorrPoints(:,1) = horCorrX;
horCorrPoints(:,2) = horCorrY;
horCorrPoints(:,3) = horCorrZ;
verCorrPoints(:,1) = verCorrX;
verCorrPoints(:,2) = verCorrY;
verCorrPoints(:,3) = verCorrZ;
corrPoints = (data1(2:(end-1),2:4));
scatter3(source(1,1),source(1,2),source(1,3),100,'r','filled');hold on;
scatter3(goal(1,1),goal(1,2),goal(1,3),100,'r','filled');hold on;
scatter3(verCorrX,verCorrY,verCorrZ,'b','filled');hold on;  
scatter3(horCorrX,horCorrY,horCorrZ,'y','filled');hold on;

%% 1
failedAttemps = 0;
maxFailedAttemps = 100;
closeList = [1];
openList = [];
center.verErr = 0;
center.horErr = 0;
center.route = 0;
center.position = points(closeList(end),:);
pre.verErr = 0;
pre.horErr = 0;
pre.route = 0;
openListPre = [];
temp = []; % dsa
while failedAttemps < maxFailedAttemps
    for i = 1:length(points)
        if feasibleNode(center,points(i,:),alpha1,alpha2,beta1,beta2,theta,delta,i,verIndex)
            if ismember(i,closeList)
                continue;
            else
                if ~ismember(i,openListPre)
                    openList(end+1) = i;
                end
            end
        end
    end
    loss = lossFunction(center,points,openList);
    [disTemp,I] = min(loss,[],2);
    closeList(end+1) = openList(I);
    pre.position = center.position;
    pre.verErr = center.verErr;
    pre.horErr = center.horErr;
    pre.route = center.route;
    center.position = points(closeList(end),:);
    if check(center,goal,theta,delta)
        break;
    end
    if isVertical(closeList(end),verIndex)
        center.verErr = 0;
        center.horErr = pre.horErr + distance(center.position,pre.position) * delta;
    else
        center.horErr = 0;
        center.verErr = pre.verErr + distance(center.position,pre.position) * delta;
    end
    center.route = pre.route + distance(center.position,points(closeList(end-1),:));
    openListPre = openList;
    openList = [];
    failedAttemps = failedAttemps + 1;
end
%% 2
for i = 1:length(closeList)-1 
    plot3([points(closeList(i),1),points(closeList(i+1),1)],[points(closeList(i),2),points(closeList(i+1),2)],[points(closeList(i),3),points(closeList(i+1),3)],'r');hold on;
end
plot3([points(closeList(end),1),points(end,1)],[points(closeList(end),2),points(end,2)],[points(closeList(end),3),points(end,3)],'r');hold on;
for i = 2:length(closeList)
    scatter3(points(closeList(i),1),points(closeList(i),2),points(closeList(i),3),100,'r','*');hold on;
end
% axis equal;
%% 3
dis = 0;
for i = 1:length(closeList)-1
    dis = dis + distance(points(closeList(i),:),points(closeList(i+1),:));
end
dis = dis + distance(points(closeList(end),:),points(end,:));



