FROM python:3-alpine

LABEL maintainer='Jerry Zhou'
LABEL version='1.0.0'

# 设置 Python 源为清华大学的源
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 设置 Alpine 软件源为国内源
RUN set -eux && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

ADD . /code
WORKDIR /code
RUN \
  apk add --no-cache libc-dev libffi-dev gcc && \
  pip install -r requirements.txt --no-cache-dir && \
  apk del gcc libc-dev libffi-dev && \
  addgroup webssh && \
  adduser -Ss /bin/false -g webssh webssh && \
  chown -R webssh:webssh /code

EXPOSE 9527/tcp
USER webssh
CMD ["python", "run.py"]
