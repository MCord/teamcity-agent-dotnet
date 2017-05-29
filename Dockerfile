FROM jetbrains/teamcity-agent:2017.1.1

# Install dotnet
RUN apt-get update \ 
&&  apt-get install apt-transport-https \
&&  echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list \
&&  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893 \                                                                    
&&  apt-get update \
&&  apt-get install -y dotnet-dev-1.0.3 \
&&  apt-get remove -y apt-transport-https \
&&  rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y wget \
 && wget -q -O NuGet.exe 'https://github.com/NuGet/Home/releases/download/3.2/nuget.exe' \
 && mono NuGet.exe install fake -ExcludeVersion -OutputDirectory /usr/lib -Verbosity quiet \
 && echo "#!/bin/bash" > /usr/local/bin/fake \
 && echo "mono /usr/lib/FAKE/tools/FAKE.exe \"\$@\"" >> /usr/local/bin/fake  \
 && chmod +x /usr/local/bin/fake         \                                                                 \
 && rm NuGet.exe \
 && rm -rf /var/lib/apt/lists/* \

