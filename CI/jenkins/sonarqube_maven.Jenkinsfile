node {
  stage('SCM') {
    git credentialsId: 'e975bb4c-3ed8-4cc5-9c2c-b86bda6f7394', url: 'http://git-i.xzxpay.com/changbin/bracelet.git'
  }
  stage('SonarQube analysis') {
    withSonarQubeEnv('89') {
      // requires SonarQube Scanner for Maven 3.2+
      // sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
      withMaven(jdk: 'jdk1.8.0_71', maven: 'M3', mavenLocalRepo: '', mavenOpts: '', mavenSettingsFilePath: '') {
        sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
        }
    }
  }
}
