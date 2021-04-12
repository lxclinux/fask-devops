FROM 172.20.31.131/ye/fake-jenkins:0.4.1
MAINTAINER xuye

# 拷贝代码
ADD . /work/
# 安装python依赖
RUN pip install -r /work/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
ENV PYTHONPATH=${PYTHONPATH}:/work
ENV PATH=${PATH}:/work
# 修改mvn库的地址
RUN sed -i "s/110/144/g" /usr/local/mvn/conf/settings.xml
# 启动
CMD ["/work/start_fake_jenkins.sh"]
