"/cygdrive/c/Program Files (x86)/MSBuild/14.0/Bin/MSBuild.exe" "C:\Developer\RepoFormTFS\RepoFormsHelp.sln" /p:DeployOnBuild=true /p:PublishProfile=Deploy /p:Configuration=Release
# sed -i -- "s#localhost#NHOSQLVLSP1#g" /cygdrive/c/Developer/IIS/PlsWebApi/Web.config
sed -i -- "s#//localhost/##g" /cygdrive/c/Developer/IIS/RepoFormsApp/wwwroot/index.html
ncftpput.exe -R -v -u "prant_1\ertran_adm" -p "5aeJi4gc7qFJ@e^" NHOVWEBPLS001 Staging/. /cygdrive/c/Developer/IIS/RepoFormsApp/ 
ncftpput.exe -R -v -u "prant_1\ertran_adm" -p "5aeJi4gc7qFJ@e^" NHOVWEBPLS001 Staging/. /cygdrive/c/Developer/IIS/PlsWebApi/ 
echo "staging" >> /home/ertran/Script/iis.history
