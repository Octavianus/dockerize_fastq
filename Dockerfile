### Dockerized fastx_toolkit-0.0.14, updated since 5-Jan-2014
# use the dockerfile/ubuntu base image provided by https://index.docker.io/u/dockerfile/ubuntu/
# The environment is ubuntu-14.04
FROM dockerfile/python

MAINTAINER David Weng weng@email.arizona.edu
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

### get the lib that needed for compiling by the fastx.
## Step 1: Install the basic tools to set up the environment.
# Install the wget, gcc, make tools, handling the lib dependency problem.
RUN apt-get install -y wget
RUN apt-get install -y gcc g++
RUN apt-get install -y make
RUN apt-get install -y pkg-config

## Step 2: Get the libgtextutils that needed for executing the fastx.
# Back to the /home/vagrant/ directory
WORKDIR /home/vagrant
RUN wget https://github.com/agordon/libgtextutils/releases/download/0.7/libgtextutils-0.7.tar.gz
RUN tar -zxvf libgtextutils-0.7.tar.gz
WORKDIR libgtextutils-0.7
RUN sudo ./configure
RUN sudo make
RUN sudo make install

## Step 3: Make and install fastq.
WORKDIR /home/vagrant/
RUN wget https://github.com/agordon/fastx_toolkit/releases/download/0.0.14/fastx_toolkit-0.0.14.tar.bz2
RUN tar xvjf fastx_toolkit-0.0.14.tar.bz2
# Change the working directory to the lib
WORKDIR fastx_toolkit-0.0.14
RUN sudo ./configure
RUN sudo make
RUN sudo make install

## Step 4: Add the executable to PATH. TO run the fastx programs, you'll need to tell ubuntu about the new shared library in /usr/local/lib
## Or change the CMD and ENTRYPOINT, we use the former here.
# ENTRYPOINT ["/home/vagrant/fastx_toolkit-0.0.14"]
# CMD ["/home/vagrant/samtools-0.1.19/samtools"]

# run ldconfig to update the shared libraries cache
RUN sudo ldconfig




