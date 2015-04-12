quantity = 200;
rands = [rand(quantity,1),2*pi*rand(quantity,1)];
polarands = [rands(:,1),rands(:,1)].*[cos(rands(:,2)),sin(rands(:,2))];
X = [ones(quantity,2)+polarands;2.1*ones(quantity,2)+polarands];
y = [repmat({'A'},quantity,1);repmat({'B'},quantity,1)];

m = fitcsvm(X,y);
sv = m.SupportVectors;
cv = crossval(m);
classloss = kfoldLoss(cv);

figure
whitebg(1,'k')
gscatter(X(:,1),X(:,2),y,[],[],6*[1,1])
hold on
plot(sv(:,1),sv(:,2),'yo','MarkerSize',3)


