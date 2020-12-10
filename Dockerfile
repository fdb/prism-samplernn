FROM tensorflow/tensorflow:latest-gpu

RUN apt-get install -y libsndfile-dev

COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip && \
   pip install --no-cache-dir -r requirements.txt

WORKDIR /app
COPY . /app/

