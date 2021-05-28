FROM arm32v7/python:3.8

RUN apt-get -y update
RUN apt-get -y upgrade

# Install Firefox and Selenium
RUN apt-get install -y firefox-esr

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-arm7hf.tar.gz
RUN tar -xf geckodriver-v0.23.0-arm7hf.tar.gz
RUN rm geckodriver-v0.23.0-arm7hf.tar.gz
RUN chmod a+x geckodriver
RUN mv geckodriver /usr/local/bin/

RUN apt-get install -y xvfb

RUN python3 -m pip install robotframework
RUN python3 -m pip install robotframework-selenium2library

WORKDIR /robot