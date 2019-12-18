%% ԭʼ���ݵ� ��������յ� �Լ�������
clear;
close all;
data1 = xlsread('data1.xlsx');
points = data1(:,2:4);
source = [data1(1,2:4),];
goal = [data1(end,2:4)];
verCorrX = []; % ��ֱ������ ��ɫΪ��ɫ
verCorrY = [];
verCorrZ = [];
horCorrX = []; % ˮƽ������ ��ɫΪ��ɫ
horCorrY = [];
horCorrZ = [];
alpha1 = 25;
alpha2 = 15;
beta1 = 20;
beta2 = 25;
theta = 30;
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
corrPoints = (data1(2:end-1,2:4));
scatter3(source(1,1),source(1,2),source(1,3),100,'r','filled');hold on;
scatter3(goal(1,1),goal(1,2),goal(1,3),100,'r','filled');hold on;

%% �����Ľ�������ʵ�ĵ��ʾ�����������'*'��ʾ ��ֱ������Ϊ��ɫ��ˮƽ������Ϊ��ɫ(��ɫ)
badVerCorr = [];
goodVerCorr = [];
badHorCorr = [];
goodHorCorr = [];
for i = 1:length(verIndex)
    if isBadNode(verIndex(i),data1)
        badVerCorr(end+1,:) = points(verIndex(i),:); 
    else
        goodVerCorr(end+1,:) = points(verIndex(i),:); 
    end
end
for i = 1:length(horIndex)
    if isBadNode(horIndex(i),data1)
        badHorCorr(end+1,:) = points(horIndex(i),:);
        
    else
        goodHorCorr(end+1,:) = points(horIndex(i),:);
    end
end
scatter3(badVerCorr(:,1),badVerCorr(:,2),badVerCorr(:,3),'b','*');hold on;
scatter3(goodVerCorr(:,1),goodVerCorr(:,2),goodVerCorr(:,3),'b','filled');hold on;
scatter3(badHorCorr(:,1),badHorCorr(:,2),badHorCorr(:,3),'g','*');hold on;
scatter3(goodHorCorr(:,1),goodHorCorr(:,2),goodHorCorr(:,3),'g','filled');hold on;

%% �������������
minRoute = distance(source,goal); % �����յ�֮��ľ���
maxP = 100; % ��õĸ���
minZ = minRoute / maxP; % ��õ�����ָ��
% ��ʼ��Ȩֵ
w1 = [0.5];
w2 = [1];
w3 = [3];
% w1 = [0.6992];
% w2 = [1.1992];
% w3 = [3.1992];
miu = 0.001;
counter1 = 0; % �ⲿ��ѭ��
maxCounter1 = 1; % ������ѵ������
counter2 = 0; % �ڲ�ѭ��
maxCounter2 = 20; % ��ǰ·��Ѱ��
Z = []; % ���·��

%% ��ѭ��
while counter1 < maxCounter1 % ������ѵ��ѭ������ѵ��n��
    while counter2 < maxCounter2 % ��ǰȨֵ�����µ�����·�� ��Ѱ20��
        p1 = 0.8; % �ɹ��ĸ���
        p2 = 0.2; % ʧ�ܵĸ���
        openList = [];
        closeList = [1];
        failedAttemps = 0;
        maxFailedAttemps = 100;
        center.verErr = 0;
        center.horErr = 0;
        center.route = 0;
        center.p = 0;
        center.position = points(closeList(end),:);
        pre.verErr = 0;
        pre.horErr = 0;
        pre.route = 0;
        pre.p = 0;
        openListPre = [];
        successFlag = 0;
        disp('��ǰ���Ĵ�ֱ���Ϊ0��ˮƽ���Ϊ0');
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
            if isempty(openList)
                successFlag = 0;
                disp('û���ҵ�������չ�㣬����ʧ�ܣ�');
                break;
            end
            loss = lossFunction2(center,points,openList,data1,w1(end),w2(end),w3(end));
            [disTemp,I] = min(loss,[],2);
            closeList(end+1) = openList(I);
            pre.position = center.position;
            pre.verErr = center.verErr;
            pre.horErr = center.horErr;
            pre.route = center.route;
            pre.p = center.p;
            center.position = points(closeList(end),:);
            if isVertical(closeList(end),verIndex)
                if isBadNode(closeList(end),data1)
                    center.p = 0.2 + pre.p;
                    if rand <= p2
                        center.verErr = min((pre.verErr + distance(center.position,pre.position) * delta),5);
                    else
                        center.verErr = 0;
                    end
                else
                    center.p = 0 + pre.p;
                    center.verErr = 0;
                end
                center.horErr = pre.horErr + distance(center.position,pre.position) * delta;
            else
                if isBadNode(closeList(end),data1)
                    center.p = 0.2 + pre.p;
                    if rand <= 0.2
                        center.horErr = min((pre.horErr + distance(center.position,pre.position)),5);
                    else
                        center.horErr = 0;
                    end
                else
                    center.p = 0 + pre.p;
                    center.horErr = 0;
                end
                center.verErr = pre.verErr + distance(center.position,pre.position) * delta;
            end
            disp(['��ǰ���Ϊ',num2str(closeList(end)),'�ĵ�Ĵ�ֱ���Ϊ',num2str(center.verErr),',ˮƽ���Ϊ',num2str(center.horErr)]);
            if check(center,goal,theta,delta)
                successFlag = 1;
                break;
            end
            center.route = pre.route + distance(center.position,points(closeList(end-1),:));
            openListPre = openList;
            openList = [];
            failedAttemps = failedAttemps + 1;
        end
        a = center.verErr + distance(center.position,goal) * delta;
        b = center.horErr + distance(center.position,goal) * delta;
        disp(['�����յ�ʱ�Ĵ�ֱ���Ϊ��',num2str(a),'��ˮƽ���Ϊ��',num2str(b)]);
        if successFlag
            disp('���гɹ���������');
            record = testForQue3(closeList,points,verIndex,data1,delta,alpha1,alpha2,beta1,beta2,theta,goal);
            disp(['��ǰ�滮·���·���10000�γɹ��Ĵ���Ϊ��',num2str(record(1,1)),'��ʧ�ܵĴ���Ϊ��',num2str(record(1,2)),'���ɹ���Ϊ��',num2str(100 * record(1,3)),'%']);
        end
        %%����·������ �Լ� ��ǰ·���·���1��γɹ��ĸ���
        dis = 0;
        for i = 1:length(closeList)-1
            dis = dis + distance(points(closeList(i),:),points(closeList(i+1),:));
        end
        dis = dis + distance(points(closeList(end),:),points(end,:));
        prob = 100 * record(1,3);
        %���ۺ���
        if successFlag
            z = dis / prob;
            Z(end+1) = z;
        end
        counter2 = counter2 + 1;
    end
    w1(end+1) = w1(end) + 2 * miu * (min(Z) - minZ);
    w2(end+1) = w2(end) + 2 * miu * (min(Z) - minZ);
    w3(end+1) = w3(end) + 2 * miu * (min(Z) - minZ);
    Z = [];
    counter2 = 0;
    counter1 = counter1 + 1;
end
%%
% for i = 1:length(closeList)-1 
%     plot3([points(closeList(i),1),points(closeList(i+1),1)],[points(closeList(i),2),points(closeList(i+1),2)],[points(closeList(i),3),points(closeList(i+1),3)],'r');hold on;
% end
% plot3([points(closeList(end),1),points(end,1)],[points(closeList(end),2),points(end,2)],[points(closeList(end),3),points(end,3)],'r');hold on;
% for i = 2:length(closeList)
%     scatter3(points(closeList(i),1),points(closeList(i),2),points(closeList(i),3),100,'r','*');hold on;
% end
axis equal;

%% ����·��ͼ
plot3([points(1,1),points(432,1)],[points(1,2),points(432,2)],[points(1,3),points(432,3)],'r');hold on;
plot3([points(432,1),points(418,1)],[points(432,2),points(418,2)],[points(432,3),points(418,3)],'r');hold on;
plot3([points(418,1),points(81,1)],[points(418,2),points(81,2)],[points(418,3),points(81,3)],'r');hold on;
plot3([points(81,1),points(238,1)],[points(81,2),points(238,2)],[points(81,3),points(238,3)],'r');hold on;
plot3([points(238,1),points(283,1)],[points(238,2),points(283,2)],[points(238,3),points(283,3)],'r');hold on;
plot3([points(283,1),points(34,1)],[points(283,2),points(34,2)],[points(283,3),points(34,3)],'r');hold on;
plot3([points(34,1),points(562,1)],[points(34,2),points(562,2)],[points(34,3),points(562,3)],'r');hold on;
plot3([points(562,1),points(404,1)],[points(562,2),points(404,2)],[points(562,3),points(404,3)],'r');hold on;
plot3([points(404,1),points(426,1)],[points(404,2),points(426,2)],[points(404,3),points(426,3)],'r');hold on;
plot3([points(426,1),points(502,1)],[points(426,2),points(502,2)],[points(426,3),points(502,3)],'r');hold on;
plot3([points(502,1),points(end,1)],[points(502,2),points(end,2)],[points(502,3),points(end,3)],'r');hold on;








