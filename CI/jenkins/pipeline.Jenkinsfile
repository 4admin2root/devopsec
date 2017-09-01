node('zbx01') {
    stage ('docker pull image'){
      docker.image('4admin2root/maven:3.5').inside {
        stage ('scm checkout'){
            git url: 'https://github.com/4admin2root/myhomework.git'
        }
        stage ('mvn build'){
	// best way: mount .m2 directory
            sh "JAVA_HOME=/usr/java/jdk1.8.0_71 mvn clean install"
        }
    }
    }
}
