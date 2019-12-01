#FROM bitnami/minideb-extras:stretch-buildpack
FROM jrottenberg/ffmpeg:4.2-ubuntu

# fix the following:
# bdist_wheel
# failed building wheel for
# pypandoc
# pytesseract
# pocketsphinx

ENV LC_ALL C.UTF-8
ENV lang C.UTF-8
ENV url http://localhost:32400
ENV token placeholder
ENV default /nobody

# could refine dependencies better most likely

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tzdata \
        software-properties-common \
        apt-utils \
        git \
        swig \
        libpulse-dev \
        libasound2-dev \
        tesseract-ocr \
        python3-pip \
        pandoc \
        python3-setuptools \
        python3-tk && \
        rm -rf /var/lib/apt/lists/*


VOLUME /config
WORKDIR /config

RUN pip3 install        pytest \
                        pytest-cov \
                        pytest-mock \
                        pytest_click \
                        pypandoc codecov \
                        # need to fix opencv
                        opencv-contrib-python-headless \
                        SpeechRecognition \
                        pocketsphinx \
                        pytesseract && \
    git clone --depth=1 https://github.com/Hellowlol/bw_plex.git /config && \
    echo $url && \
    echo $token && \
    echo $default && \
    pip3 install -e .

CMD ["sh", "-c", "bw_plex --url ${url} -t ${token} -df /config watch"]


# To build (Docker image):
# docker build -t bw_plex:latest .
