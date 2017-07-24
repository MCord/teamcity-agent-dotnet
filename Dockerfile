FROM jetbrains/teamcity-agent:2017.1.1
LABEL maintainer="mkordi@gmail.com"

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


# expose environment variables
ENV tool_dotnetcore=1.0.4
ENV tool_mono=4.2         
ENV tool_fake=4.61.3      
ENV tool_node=v6.11.0     
ENV tool_yarn=0.24.6        