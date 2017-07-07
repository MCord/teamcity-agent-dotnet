FROM jetbrains/teamcity-agent:2017.1.1

#Known issue:
# tzdata should be installed or nuget fails to download.

# Install dotnet
RUN apt-get update \ 
&&  apt-get install apt-transport-https \
&&  echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list \
&&  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893 \                                                                    
&&  apt-get update \
&&  apt-get install -y dotnet-sdk-2.0.0-preview2-006497 \ 
&&  apt-get install -y mono-devel \
&&  apt-get install -y tzdata

COPY build.bootstrap.csproj .build/bootsrap.csproj

RUN dotnet restore .build/bootsrap.csproj \
&& echo "#!/bin/bash" > /usr/local/bin/fake \
&& echo "mono ~/.nuget/packages/fake/4.61.3/tools/FAKE.exe \"\$@\"" >> /usr/local/bin/fake \
&& chmod +x /usr/local/bin/fake

# Install docker
RUN apt-get update \ 
&&  apt-get install -y apt-transport-https \
&&  apt-get install -y curl \
&&  apt-get install -y software-properties-common \
&&  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
&&  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" \
&&  apt-get install -y docker=1.5-1

# Install nodejs and npm
RUN apt-get update \
&&  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
&&  add-apt-repository "deb https://deb.nodesource.com/node_6.x xenial main" \
&&  apt-get update \
&&  apt-get install -y --allow-unauthenticated nodejs

# Install yarn
RUN apt-get update \
&&  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&&  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
&&  apt-get update \
&&  apt-get install -y yarn \
&&  apt-get clean all