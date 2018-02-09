## 项目描述

发布项目到kubernetes的工具，使用helm方式部署项目。


### 使用方法

1. 该工具读取项目/chart 目录中的配置文件，并执行发布，需要在项目下建立/chart目录，结构如下：

  ```
  .
  ├── chart
  │   ├── Chart.yaml
  │   ├── csmj1-values.yaml
  │   ├── csmj2-values.yaml
  │   └── templates
  │       ├── deployment.yaml
  │       ├── _helpers.tpl
  │       ├── NOTES.txt
  │       └── service.yaml

  ```
  当然，你也可以使用 helm create test 初始化一个目录结构和chart文件
 
2.gitlab-ci 中使用
  ```
  image: dev.flybot.sg:4567/zyh/kubernetes-deploy:1.1.0
  ...
  deploy:
    stage: deploy
    script:
      - command deploy csmj1 values-csmj1.yaml
      - command deploy csmj2 values-csmj2.yaml
      ...
    environment:
      name: csmj
 ```

### 发布工作流程：

1. gitlab-ci ： 检查是否存在Chart项目结构，否则报错并退出发布。
2. gitlab-ci  : 使用helm client 发布项目到k8s。

### 其他

该项目参考gitlab的kubernetes-deploy项目,在此基础上做了修改：
1. 加入多模板发布功能，适合游戏多倍场发布；

### 参考

kubernetes-deploy : https://gitlab.com/gitlab-examples/kubernetes-deploy

helm的文档： https://github.com/kubernetes/helm
