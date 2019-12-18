function record = testForQue3(index,points,verIndex,data1,delta,alpha1,alpha2,beta1,beta2,theta,goal)
test = false;
counter = 0;
maxCounter = 1e4;
p = 0.2; % 部分校正点失败概率
% 起始点A点，垂直与水平误差为0，失败概率为0.
current.position = points(index(1),:);
current.verErr = 0;
current.horErr = 0;
% current.p = 0;
record = [0,0,0]; % 记录成功、失败次数，并计算成功率
fail = false;
while counter < maxCounter
    for i = 1:length(index)-1
        previous.position = current.position;
        previous.verErr = current.verErr;
        previous.horErr = current.horErr;
%         previous.p = current.p;
        if isVertical(index(i),verIndex)
            if ~((current.verErr < alpha1) && (current.horErr < alpha2))
                fail = true; 
                break;
            end
        else
            if ~((current.verErr < beta1) && (current.horErr < beta2))
                fail = true;
                break;
            end
        end
        current.position = points(index(i+1),:);
        % cal err
        if isVertical(index(i+1),verIndex)
            if isBadNode(index(i+1),data1)
%                 current.p = p + previous.p;
                if rand <= p
                    current.verErr = min((previous.verErr + distance(previous.position,current.position) * delta),5);
                else
                    current.verErr = 0;
                end
            else
%                 current.p = 0 + previous.p;
                current.verErr = 0;
            end
            current.horErr = previous.horErr + distance(previous.position,current.position) * delta;
        else
            if isBadNode(index(i+1),data1)
%                 current.p = p + previous.p;
                if rand <= p
                    current.horErr = min((previous.horErr + distance(previous.position,current.position) * delta),5);
                else
                    current.horErr = 0;
                end
            else
%                 current.p = 0 + previous.p;
                current.horErr = 0;
            end
            current.verErr = previous.verErr + distance(previous.position,current.position) * delta;
        end
        % 
        if i == length(index)-1
            if ((current.verErr + distance(current.position,goal) * delta) < theta) && ((current.horErr + distance(current.position,goal) * delta) < theta)
                test = true;
            else
                fail = true;
            end
        end
    end % for i = 1:length(index)-1
    if fail
        record(1,2) = record(1,2) + 1; % 失败次数
    else
        record(1,1) = record(1,1) + 1; % 成功次数 fail = false;
    end
    fail = false;
    counter = counter + 1;
    current.position = points(index(1),:);
    current.verErr = 0;
    current.horErr = 0;
end
record(1,3) = (record(1,1))/(record(1,1) + record(1,2)); % 成功率
