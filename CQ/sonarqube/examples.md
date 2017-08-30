# create token
# maven
```
mvn sonar:sonar \
  -Dsonar.host.url=http://10.8.32.31:9000 \
  -Dsonar.login=5893012c9a21624cb34f2442333af0f2a1142f7
```

# msbuild
1. download sonar scanner
```
#view https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+MSBuild
wget https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/3.0.2.656/sonar-scanner-msbuild-3.0.2.656.zip
```
2. download msbuild
```
D:\sonar-scanner\SonarQube.Scanner.MSBuild.exe begin   /k:"wxy"   /d:"sonar.host.url=http://ci-i.xzxpay.com:9000"   /d:"sonar.login=5893012c9a21624cb34f2442333af0f2a1142f7"

"C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\MSBuild" testmvc.sln /t:Rebuild

D:\sonar-scanner\SonarQube.Scanner.MSBuild.exe end  /d:"sonar.login=5893012c9a21624cb34f2442333af0f2a1142f7"

```
